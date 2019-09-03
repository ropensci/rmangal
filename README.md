<img src="man/figures/rmangal.png" width="130" align="right"/>

# rmangal :package: - an R Client for the Mangal database

[![Travis-CI Build Status](https://travis-ci.org/mangal-wg/rmangal.svg?branch=master)](https://travis-ci.org/mangal-wg/rmangal)
[![Build status](https://ci.appveyor.com/api/projects/status/mibs2ni969xiqgrd?svg=true)](https://ci.appveyor.com/project/KevCaz/rmangal)
[![codecov](https://codecov.io/gh/mangal-wg/rmangal/branch/master/graph/badge.svg)](https://codecov.io/gh/mangal-wg/rmangal)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![CRAN status](https://www.r-pkg.org/badges/version/rmangal)](http://www.r-pkg.org/badges/version/rmangal)


## Context

Interactions among species is at the heart of ecology. Despite their importance,
studying ecological interactions remains difficult due to the lack of standard
information and the disparity of formats in which ecological interactions are
stored. Historically, ecologists have used matrices to store interactions, which
tend to easily decontextualize interactions from fieldwork when metadata is
missing. To overcome these limitations, [Mangal](https://mangal.io/#/) -- a
global ecological interactions database -- serializes ecological interaction
matrices into nodes (e.g. taxon, individuals or population) and edges. Hence the
base unit in Mangal is a published ecological network and thus distinct from
other initiatives such as [Globi](https://www.globalbioticinteractions.org/)
(see [rglobi](https://github.com/ropensci/rglobi) for an R Client to) that store
pairwise interactions.

For every network, Mangal store a vast array of metadata: from the details
of the orginal publication to taxonomic information. Regarding the latter, Mangal store unique taxonomic identifiers such as Encyclopedia
of Life (EOL), Catalogue of Life (COL), Global Biodiversity Information Facility
(GBIF) and Integrated Taxonomic Information System (ITIS)

**rmangal** is an R client to the Mangal database. As such, it provides various functions to query the data base and retrieve networks that are stored as
`mgNetwork` or `mgNetworksCollection`. It also provides methods to convert `mgNetwork` to other object in order to use powerful package to work with networks: [`igraph`](https://igraph.org/r/), [`tidygraph`](https://github.com/thomasp85/tidygraph), and [`ggraph`](https://github.com/thomasp85/ggraph).




## Installation

So far, only the development version is available and can be installed via the [remotes](https://CRAN.R-project.org/package=remotes) :package:

```r
R> devtools::install_github("mangal-wg/rmangal")
R> library("rmangal")
```


## How to use rmangal

In order to query the data base, there are [five `search_*()` functions](), for instance `search_datasets()`:

```r
R> mgs <- search_datasets("lagoon")
Found 2 datasets
```

Once this first step achieved networks found can be retrieved with the `get_collection()` function:

```r
R> mgn <- get_collection(mgs)
```

which returns an object `mgNetwork` if there is one network returned, otherwise
an object `mgNetworkCollection` is returned, which basically is a list of
`mgNetwork` objects:


```r
R> class(mgn)
[1] "mgNetworksCollection"
R> mgn
A collection of 3 networks

* Network # from data set #
* Description: Dietary matrix of the Huizache–Caimanero lagoon
* Includes 189 edges and 26 nodes
* Current taxonomic IDs coverage for nodes of this network:
  --> ITIS: 81%, BOLD: 81%, EOL: 85%, COL: 81%, GBIF: 0%, NCBI: 85%
* Published in ref # DOI:10.1016/s0272-7714(02)00410-9

* Network # from data set #
* Description: Food web of the Brackish lagoon
* Includes 27 edges and 11 nodes
* Current taxonomic IDs coverage for nodes of this network:
  --> ITIS: 45%, BOLD: 45%, EOL: 45%, COL: 45%, GBIF: 18%, NCBI: 45%
* Published in ref # DOI:NA

* Network # from data set #
* Description: Food web of the Costal lagoon
* Includes 34 edges and 13 nodes
* Current taxonomic IDs coverage for nodes of this network:
  --> ITIS: 54%, BOLD: 54%, EOL: 54%, COL: 54%, GBIF: 15%, NCBI: 54%
* Published in ref # DOI:NA
```

[`igraph`](https://igraph.org/r/) and
[`tidygraph`](https://github.com/thomasp85/tidygraph) offer powerful features to
analyse networks and **rmangal** provides functions to convert `mgNetwork` to
`igraph` and `tbl_graph` so that the user can easily benefit from those
features.

```r
R> ig <- as.igraph(mgn[[1]])
R> class(ig)
[1] "igraph"
R> library(tidygraph)
R> tg <- as_tbl_graph(mgn[[1]])
R> class(tg)
[1] "tbl_graph" "igraph"
```

:book: Note that the vignette ["Get started with
rmangal"](https://mangal-wg.github.io/rmangal/articles/rmangal.html) will guide
the reader through several examples and provide further details about **rmangal** features.



## Code of conduct

Please note that the 'rmangal' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
