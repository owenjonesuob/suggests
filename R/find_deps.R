#' List places where dependencies are used
#'
#' A quick-and-dirty diagnostic tool to find top-level expressions (e.g.
#' declared functions) in R scripts within a development package.
#'
#' This might be useful for package developers hoping to use `suggests::need()`
#' in their package, and looking for good candidates for dependencies which
#' could be moved from `Imports` to `Suggests` in the `DESCRIPTION` file.
#'
#' @param path Path to the base directory of a package.
#' @param threshold Only report on dependencies used in fewer than this many
#'   top-level expressions.
#'
#' @return A data frame, with one row per distinct file and top-level expression
#'   where a package is used. Packages used in the fewest places are listed
#'   first.
#'
#' @details
#'  Dependencies are searched for in two ways:
#'
#'  * `import()` and `importFrom()` statements in the package's `NAMESPACE`
#'    file, such as those created by `@import` and `@importFrom` tags if
#'    creating package documentation with roxygen2
#'  * Functions called by using `::` or `:::` to access a dependency's namespace
#'    directly
#'
#'  This approach isn't perfect, but it should capture most dependency uses.
#'
#' @examples
#'   find_deps(system.file("demopkg", package = "suggests"))
#'
#' @export

find_deps <- function(path = ".", threshold = NULL) {

  path <- find_package_root(path)

  # Start with dependencies declared with importFrom(pkg, fn) statements...
  ns_fns <- ns_importfrom(path)

  # ... then add to these (overriding if present already) with dependencies
  # declared with import(pkg) statements
  ns_fns_import <- ns_import(path)
  ns_fns[names(ns_fns_import)] <- ns_fns_import


  # Retrieve a list of all R files in the package
  files <- list.files(path, pattern = "\\.[Rr]$", recursive = TRUE)
  names(files) <- files


  pkgs_per_expr_per_file <- lapply(files, function(f) {

    # Get parsing information for each expression in file
    exprs <- lapply(
      as.list(parse(file.path(path, f), keep.source = FALSE)),
      function(x) utils::getParseData(parse(text = deparse(x), keep.source = TRUE))
    )

    # Ignore any expressions which aren't assigned to something
    exprs <- Filter(function(x) any(grepl("ASSIGN", x$token)), exprs)

    # Use the text before the assignment operator as the name
    names(exprs) <- lapply(exprs, function(x) paste0(x$text[seq_len(utils::head(grep("ASSIGN|\\{", x$token), 1) - 1)], collapse = ""))


    # Packages used via :: and ::: are easy to spot in the parsed data!
    src_pkgs_used <- lapply(exprs, function(x) unique(x$text[x$token == "SYMBOL_PACKAGE"]))


    # Additionally, find all function calls within an expression, and see which
    # packages (if any) they match with in the NAMESPACE imports found earlier
    ns_pkgs_used <- lapply(
      exprs,
      function(x) Filter(function(pkg) any(ns_fns[[pkg]] %in% x$text[x$token == "SYMBOL_FUNCTION_CALL"]), names(ns_fns))
    )

    # Now merge these two sets of results...
    pkgs_used <- lapply(names(exprs), function(nm) unique(c(src_pkgs_used[[nm]], ns_pkgs_used[[nm]])))
    names(pkgs_used) <- names(exprs)

    # ... and only return non-empty entries, i.e. a list with an entry for each
    # expression which used any functions from dependencies
    pkgs_used[lengths(pkgs_used) > 0]
  })


  # Again, we're only interested in non-empty entries, i.e. files which had at least one expression
  pkgs_per_expr_per_file <- pkgs_per_expr_per_file[lengths(pkgs_per_expr_per_file) > 0]


  # Rectangularise the nested list into a data frame
  out <- do.call(rbind, lapply(
    names(pkgs_per_expr_per_file), function(f) do.call(rbind, lapply(
      names(pkgs_per_expr_per_file[[f]]), function(x) data.frame(
        "package_used" = pkgs_per_expr_per_file[[f]][[x]],
        "in_file" = f,
        "in_expr" = x
      )
    ))
  ))


  # Sort by frequency (least common first)
  out <- merge(out, table(out$package_used), by.x = "package_used", by.y = "Var1")

  if (!is.null(threshold))
    out <- out[out$Freq <= threshold, ]

  out <- out[order(out$Freq, out$package_used, out$in_file, out$in_expr), ]
  out$Freq <- NULL
  rownames(out) <- NULL


  out
}




ns_importfrom <- function(path) {

  ns <- readLines(file.path(path, "NAMESPACE"))
  pkgs <- unique(sub(".*importFrom\\(([^,]*),.*", "\\1", ns[grepl("importFrom\\(", ns)]))
  fns <- lapply(pkgs, function(pkg) {
    ns <- ns[grepl(paste0("importFrom\\(", pkg, ","), ns)]
    unique(sub(".*,\\s*([^)]*)\\).*", "\\1", ns))
  })
  names(fns) <- pkgs

  fns
}



ns_import <- function(path) {

  ns <- readLines(file.path(path, "NAMESPACE"))
  pkgs <- unique(sub(".*import\\(([^)]*)\\).*", "\\1", ns[grepl("import\\(", ns)]))
  fns <- lapply(pkgs, getNamespaceExports)
  names(fns) <- pkgs

  fns
}



find_package_root <- function(path) {

  path <- normalizePath(path, winslash = "/", mustWork = FALSE)

  while (TRUE) {

    if (length(setdiff(c("DESCRIPTION", "NAMESPACE"), list.files(path))) == 0)
      return(path)

    # If we've hit the root directory
    if (path == dirname(path))
      stop("It looks like the path you provided is not within an R package.")

    path <- dirname(path)
  }

}
