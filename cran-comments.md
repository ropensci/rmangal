On 2024-03-01, rmangal was archived because packages that rely on internet resources must fail gracefully with an informative message if a resource is unavailable or has changed, rather than producing check warnings or errors. We addressed this issue and made several major improvements to strengthen the package. The package now uses httr2, all core API-calling functions fail gracefully, and additional tests have been added to ensure this behaviour.

Tests are now skipped if vcr is missing.


## Test environments

* GitHub Actions, Ubuntu 24.04.5: R-oldrel,
* GitHub Actions, Ubuntu 24.04.5: R-release,
* GitHub Actions, Ubuntu 24.04.5: R-devel,
* GitHub Actions, macOS 15.7.1: R-release,
* GitHub Actions, Microsoft Windows Server 2025 (10.0.26100): R-release,
* win-builder (R-old-release, R-release and R-devel),
* local Ubuntu 25.10 (Kernel: 6.17.0-5-generic arch: x86_64), R-4.5.2


## R CMD check results.

Locally:
0 ERRORs | 0 WARNINGs | 0 NOTES.


win-builder:
Maintainer: 'Kevin Cazelles <kevin.cazelles@insileco.io>'

New submission

Package was archived on CRAN



## Downstream dependencies

There are currently no downstream dependencies for this package.
