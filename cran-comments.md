On 2024-03-01, rmangal was archived because packages that rely on internet resources must fail gracefully with an informative message if a resource is unavailable or has changed, rather than producing check warnings or errors. We addressed this issue and made several major improvements to strengthen the package. The package now uses httr2, all core API-calling functions fail gracefully, and additional tests have been added to ensure this behaviour.


## Test environments

* GitHub Actions, Ubuntu 24.04.5: R-oldrel,
* GitHub Actions, Ubuntu 24.04.5: R-release,
* GitHub Actions, Ubuntu 24.04.5: R-devel,
* GitHub Actions, macOS 15.7.1: R-release,
* GitHub Actions, Microsoft Windows Server 2025 (10.0.26100): R-release,
* win-builder (R-old-release, R-release and R-devel),
* local Ubuntu 25.10 (Kernel: 5.19.0-35-generic x86_64), R-4.5.2


## R CMD check results.

Locally:
0 ERRORs | 0 WARNINGs | 0 NOTES.


win-builder:
0 ERRORs | 0 WARNINGs | 1 NOTES.

Found the following (possibly) invalid URLs:
  URL: https://gbif.org
    From: man/search_taxonomy.Rd
    Status: 403
    Message: Forbidden
  URL: itis.gov
    From: man/search_taxonomy.Rd
    Status: 404
    Message: Not Found

Found the following (possibly) invalid DOIs:
  DOI: https://doi.org/10.59350/51nby-5v347
    From: inst/CITATION
    Status: 404
    Message: Not Found


I checked the URL: 

R> urlchecker::url_check()
✔ All URLs are correct!



## Downstream dependencies

There are currently no downstream dependencies for this package.
