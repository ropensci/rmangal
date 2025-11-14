# rmangal :package: - an R Client for the Mangal database <img src="man/figures/logo.png" width="130" align="right" alt="rmangal logo"/>

[![Status at rOpenSci Software Peer Review](https://badges.ropensci.org/332_status.svg)](https://github.com/ropensci/software-review/issues/332)
[![R CMD Check](https://github.com/ropensci/rmangal/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci/rmangal/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/ropensci/rmangal/graph/badge.svg?token=lGqUVLM2o3)](https://codecov.io/gh/ropensci/rmangal)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![rmangal status badge](https://ropensci.r-universe.dev/rmangal/badges/version)](https://ropensci.r-universe.dev/rmangal)
[![CRAN status](https://www.r-pkg.org:443/badges/version/rmangal)](https://CRAN.R-project.org/package=rmangal)


## Context

[Mangal](https://mangal.io/#/) -- a global ecological interactions database --
serializes ecological interaction matrices into nodes (e.g. taxon, individuals
or population) and interactions (i.e. edges). For each network, Mangal offers
the opportunity to store study context such as the location, sampling
environment, inventory date and information pertaining to the original
publication. For all nodes involved in the ecological networks, Mangal
references unique taxonomic identifiers such as Encyclopedia of Life (EOL),
Catalogue of Life (COL), Global Biodiversity Information Facility (GBIF) etc.
and can extend nodes information to individual traits.

**rmangal** is an R client to the Mangal database and provides various functions
to explore its content through search functions. It offers methods to retrieve
networks structured as `mgNetwork` or `mgNetworksCollection` S3 objects and
methods to convert `mgNetwork` to other class objects in order to analyze and
visualize networks properties: [`igraph`](https://igraph.org/r/),
[`tidygraph`](https://github.com/thomasp85/tidygraph), and
[`ggraph`](https://github.com/thomasp85/ggraph).


## Installation

So far, only the development version is available and can be installed via the [remotes](https://CRAN.R-project.org/package=remotes) :package:

```r
R> remotes::install_github("ropensci/rmangal")
R> library("rmangal")
```


## How to use `rmangal`

There are [seven `search_*()` functions](https://docs.ropensci.org/rmangal/reference/index.html#section-explore-database) to explore the content of Mangal, for instance `search_datasets()`:

```r
R> mgs <- search_datasets("lagoon")
Found 2 datasets.
```

Once this first step is achieved, networks found can be retrieved with the `get_collection()` function.

```r
R> mgn <- get_collection(mgs)
```

`get_collection()` returns an object `mgNetwork` if there is one network
returned, otherwise an object `mgNetworkCollection`, which is a list of
`mgNetwork` objects.


```r
R> class(mgn)
[1] "mgNetworksCollection"
R> mgn
── Network Collection ──

6 networks in collection

── Network #86 
• Dataset: #22
• Description: Dietary matrix of the Huizache–Caimanero lagoon
• Size: 189 edges, 26 nodes
• Taxonomic IDs coverage for nodes:
ITIS: 81%, BOLD: 81%, EOL: 85%, COL: 81%, GBIF: 0%, NCBI: 85%
• Published in reference # DOI: 10.1016/s0272-7714(02)00410-9

── Network #1104 
• Dataset: #53
• Description: Food web of the shallow sublittoral at Cape Ann
• Size: 107 edges, 35 nodes
• Taxonomic IDs coverage for nodes:
ITIS: 77%, BOLD: 71%, EOL: 77%, COL: 74%, GBIF: 3%, NCBI: 71%
• Published in reference # DOI: 10.2307/1948658

── Network #1108 
• Dataset: #53
• Description: Food web of the high salt marsh at Cape Ann
• Size: 44 edges, 19 nodes
• Taxonomic IDs coverage for nodes:
ITIS: 58%, BOLD: 53%, EOL: 58%, COL: 53%, GBIF: 11%, NCBI: 53%
• Published in reference # DOI: 10.2307/1948658

── Network #1105 
• Dataset: #53
• Description: Food web of the rocky shore at Cape Ann
• Size: 124 edges, 29 nodes
• Taxonomic IDs coverage for nodes:
ITIS: 90%, BOLD: 86%, EOL: 90%, COL: 86%, GBIF: 10%, NCBI: 86%
• Published in reference # DOI: 10.2307/1948658

── Network #1107 
• Dataset: #53
• Description: Food web of the low salt marsh at Cape Ann
• Size: 60 edges, 25 nodes
• Taxonomic IDs coverage for nodes:
ITIS: 80%, BOLD: 68%, EOL: 76%, COL: 68%, GBIF: 12%, NCBI: 72%
• Published in reference # DOI: 10.2307/1948658

── Network #1106 
• Dataset: #53
• Description: Food web of the mudflat at Cape Ann
• Size: 175 edges, 37 nodes
• Taxonomic IDs coverage for nodes:
ITIS: 86%, BOLD: 84%, EOL: 86%, COL: 84%, GBIF: 3%, NCBI: 84%
• Published in reference # DOI: 10.2307/1948658

```

[`igraph`](https://igraph.org/r/) and
[`tidygraph`](https://github.com/thomasp85/tidygraph) offer powerful features to
analyze networks and **rmangal** provides functions to convert `mgNetwork` to
`igraph` and `tbl_graph` so that the user can easily benefit from those
packages.



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
rmangal"](https://docs.ropensci.org/rmangal/articles/rmangal.html) will guide
the reader through several examples and provide further details about **rmangal** features.


## Verbosity 

Since `rmangal` version 2.2, the function verbosity is controlled by the option
`rmangal.verbose`. To quiet all rmangal functions, use: 

```R
options(rmangal.verbose = "quiet")
```

and to switch on the verbosity do:

```R
options(rmangal.verbose = "verbose")
```



## How to publish ecological networks

We are working on that part. The networks publication process will be
facilitated with structured objects and tests suite to maintain data integrity
and quality. Comments and suggestions are welcome, feel free to open issues.

## `rmangal` vs `rglobi`

Those interested only in pairwise interactions among taxa may consider using
`rglobi`, an R package that provides an interface to the [GloBi
infrastructure](https://www.globalbioticinteractions.org/about.html). GloBi
provides open access to aggregated interactions from heterogeneous sources. In
contrast, Mangal gives access to the original networks and open the gate to
study ecological networks properties (i.e. connectance, degree etc.) along large
environmental gradients, which wasn't possible using the GloBi infrastructure.


## Older versions 

* See https://github.com/mangal-interactions/rmangal-v1 for the first version of the client.
* Note that due to changes in the RESTful API, there is no backward compatibility.


## Acknowledgment

We are grateful to [Noam Ross](https://github.com/noamross) for acting as an editor during the review process. We also thank [Anna Willoughby](https://github.com/arw36) and [Thomas Lin Petersen](https://github.com/thomasp85) for reviewing the package. Their comments strongly contributed to improving the quality of `rmangal`.


## Code of conduct

Please note that the `rmangal` project is released with a [Contributor Code of Conduct](https://mangal.io/doc/r/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

## Meta

* Get citation information for `rmangal` in R doing `citation(package = 'rmangal')`
* Please [report any issues or bugs](https://github.com/ropensci/rmangal/issues).

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
