# suggests 0.1.0 (2023-07-14)

First official CRAN release!

* `need()` (and `is_installed()`) can check for a minimum version of a package by appending `>=[version]`, e.g. `need("pkg>=0.1.2")`

* `need()` also gains a couple of new arguments:
  - Use `msg` to provide a custom informative message, to be displayed to users if one or more packages will need to be installed
  - Use `install_cmd` to provide a custom installation command, which will be used in the installation prompt



# suggests 0.0.2 (2023-01-16)

`need()` now doesn't load packages by default: instead it checks whether a package has a valid installation location. This is much faster, but slightly less of a guarantee that the package is actually usable. You can switch back to the package-loading method with `load = TRUE`.




# suggests 0.0.1 (2022-07-30)

First package release.
