<img src="man/figures/rmangal.svg" width="130" height="150" align="right"/>

[![Travis-CI Build Status](https://travis-ci.org/mangal-wg/rmangal.svg?branch=master)](https://travis-ci.org/mangal-wg/rmangal)
[![Build status](https://ci.appveyor.com/api/projects/status/mibs2ni969xiqgrd?svg=true)](https://ci.appveyor.com/project/KevCaz/rmangal)
[![codecov](https://codecov.io/gh/mangal-wg/rmangal/branch/master/graph/badge.svg)](https://codecov.io/gh/mangal-wg/rmangal)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#WIP)
[![CRAN status](https://www.r-pkg.org/badges/version/rmangal)](http://www.r-pkg.org/badges/version/rmangal)



# rmangal

A package to retrieve and explore data from the ecological interactions database MANGAL.

- API documentation: https://mangal-wg.github.io/mangal-api/
- Data explorer: http://poisotlab.biol.umontreal.ca/#/
- Package documentation: https://mangal-wg.github.io/rmangal/


## Installation

### Development

So far, the development version can be installed via the devtools package:

```r
devtools::install_github("mangal-wg/rmangal")
library("rmangal")
```

## Incoming developments

### Roadmap v2.2

- Develop functions to retrieve traits and environmnent attached to nodes (v2.1)
- Facilitate user publication of new ecological networks with template (v2.2)
    - Create publication S3 object
    - Generate the publication object based on template
    - Used suite of tests (`testthat`) to assist user on data integrity assessment