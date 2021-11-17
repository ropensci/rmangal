## Submission of rmangal v2.1.0

Dear CRAN, 

rmangal was archived on 2020-11-02 for policy violation on internet access. 
This minor release addresses this concern: tests now use `vcr` and the vignette has been precomputed. Minor bugs have been squashed along the way. 

## CRAN comment 


### Comment

Missing Rd-tags:
     avail_type.Rd: \value
     clear_cache_rmangal.Rd: \value


### Answer

1. `avail_type` is no longer exported, instead type of interactions are detailed in the documentation of `search_interactions()`. 

2. \value tag has been added for `clear_cache_rmangal`



## Test environments

  * GitHub Actions, Ubuntu 20.04: R-release,
  * GitHub Actions, Ubuntu 20.04: R-devel,
  * GitHub Actions, macOS 11.6: R-release,
  * win-builder (R-oldrelease, R-release and R-devel),
  * local Debian 11 (Kernel: 5.14.0-2-amd64 x86_64), R-4.1.1.


## R CMD check results

0 ERRORs | 0 WARNINGs | 0 NOTES.


## Downstream dependencies

There are currently no downstream dependencies for this package.
