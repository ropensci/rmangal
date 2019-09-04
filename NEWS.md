# rmangal 1.9.1.9000

* Revisions see https://github.com/ropensci/software-review/issues/332;
* add summary method [#87];
* `mg_to_igraph` is now `as.igraph()`;
* `search_references()` has been rewritten [#85];
* vignette now includes examples to use `tigygraph` and `ggraph`;
* pkgdown website is now deployed by Travis CI [#86];
* `geom` column has been removed from `mgSearchInteractions` objects;
* `sf` features are only used in `search_networks_sf()` and when argument `as_sf` is set to `TRUE` [#89];
* query with spatial (`sf`) objects are handle in `query_networks_sf()` that is now exported.

# rmangal 1.9.1

* Version submitted to ROpenSci for review;
* Added a `NEWS.md` file to track changes to the package.
