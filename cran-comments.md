## Submission of rmangal v2.1.1

Dear CRAN,

This patch addresses a mistake pertaining to the network details printed in
one of the summary methods. We took this opportunity to remove one dependency
(`purrr`, base R is used instead instead).


## Test environments

  * GitHub Actions, Ubuntu 20.04: R-release,
  * GitHub Actions, Ubuntu 20.04: R-devel,
  * GitHub Actions, macOS 11.6.5: R-release,
  * GitHub Actions, Microsoft Windows Server Microsoft Windows Server 2022 (10.0.20348): R-release,
  * win-builder (R-oldrelease, R-release and R-devel),
  * local Debian Testing (Kernel: 5.17.0-1-amd64 x86_64), R-4.2.0.


## R CMD check results

0 ERRORs | 0 WARNINGs | 0 NOTES.


## Downstream dependencies

There are currently no downstream dependencies for this package.
