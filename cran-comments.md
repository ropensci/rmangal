## Submission of rmangal v2.0.2

From the CRAN team:
====

Found the following (possibly) invalid URLs:
    URL: http://www.r-pkg.org/badges/version/rmangal (moved to https://www.r-pkg.org:443/badges/version/rmangal)
      From: README.md
      Status: 200
      Message: OK
    URL: https://docs.ropensci.org/rmangal (moved to https://docs.ropensci.org/rmangal/)
      From: DESCRIPTION
            man/rmangal.Rd
      Status: 200
      Message: OK
    URL: https://eol.org/
      From: man/search_taxonomy.Rd
      Status: Error
      Message: libcurl error code 28:
            Connection timed out after 60000 milliseconds
    URL: https://github.com/PoisotLab/Mangal.jl (moved to https://github.com/EcoJulia/Mangal.jl)
      From: inst/doc/rmangal.html
      Status: 200
      Message: OK
    URL: https://mangal.io/doc/api (moved to https://mangal.io/doc/api/)
      From: DESCRIPTION
      Status: 200
      Message: OK


Please change http --> https, add trailing slashes, or follow moved content as appropriate.


    URL: https://ropensci.github.io/rmangal/
      From: inst/CITATION
      Status: 404
      Message: Not Found 

Response from the authors:
====

We have updated the URL documented within the package to comply with the requests.
We added the trailing slash when needed. We ensured that all URLs are now secured and used the HTTPS protocol. We followed the guidelines provided at this address: https://cran.r-project.org/web/packages/URL_checks.html. We performed the following test: `curl -I -L https://eol.org/` and we think that the time out is related to a server side issue, because the test performed well on our side.


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
