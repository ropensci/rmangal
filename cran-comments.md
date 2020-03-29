## Submission of rmangal v2.0.1

This patch fix the following issue raises by the CRAN:
> PhantomJS not found. You can install it with webshot::install_phantomjs(). If
> it is installed, please make sure the phantomjs executable can be found via the
> PATH variable. Quitting from lines 251-258 (rmangal.Rmd) 

We removed mapview from the vignette and replace the interactive graph by static png.

## Test environments

* local Ubuntu testing (4.18.0-2-amd64), R-3.6.2
* Ubuntu 16.04 (on Travis-CI): R-oldrel
* Ubuntu 14.04 (on Travis-CI): R-release
* Ubuntu 16.04 (on Travis-CI): R-devel
* MacOSX 10.13 (on Travis-CI), R-release
* Windows (x86_64-w64-mingw32/x64, Windows Server 2012 om AppVeyor) R-release
* Windows win-builder (R-release and R-devel)


## R CMD check results

0 ERRORs | 0 WARNINGs | 0 NOTES.


## Downstream dependencies

There are currently no downstream dependencies for this package.
