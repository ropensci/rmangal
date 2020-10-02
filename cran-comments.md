## Submission of rmangal v2.0.2

This patch fixes the broken function `search_datasets()`.
Some datasets didn't have networks and this wasn't handled by the function porperly.


## Test environments

* local Ubuntu testing (4.18.0-2-amd64), R-3.6.2
* local Debian bullseye/sid (5.8.0-2-amd64), R-4.0.2
* Ubuntu 16.04 (on Travis-CI): R-oldrel
* Ubuntu 18.04 (on Travis-CI): R-release
* Ubuntu 20.04 (on Travis-CI): R-devel
* MacOSX 10.13 (on Travis-CI), R-release
* Windows (x86_64-w64-mingw32/x64, Windows Server 2012 om AppVeyor) R-release
* Windows win-builder (R-release and R-devel)


## R CMD check results

0 ERRORs | 0 WARNINGs | 0 NOTES.


## Downstream dependencies

There are currently no downstream dependencies for this package.
