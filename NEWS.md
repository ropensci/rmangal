# rmangal 2.1.2

* Fixtures are now written in JSON.

# rmangal 2.1.1

* `inherits()` is now used to test classes.
* `purrr` is no longer listed as an imported package.
* Add lintr workflow to automatically check stylistic errors.
* Summary method for `mgNetwork` objects now reports nodes and properly (see nodes #108).

# rmangal 2.1.0

* All examples are within the `\donttest` tag (see #100).
* `get_collection()` methods always return an object of class `mgNetworksCollection` (see #100).
* `get_network_by_id()` gains an argument `force_collection` to force the class collection (see #100).
* Vignette now precomputed (see #100).
* Tests now use `vcr` (see #100).
* Travis and Appveyor removed, use GitHub Actions (see #100).
* `avail_type()` is no longer exported.

# rmangal 2.0.2

* Fix a minor bug `search_datasets()` related to absent networks attached on a dataset (see #97 and #98);
* Update Travis CI environment test (`travis.yml`).

# rmangal 2.0.1

* Fix a minor bug in the print method for `mgNetwork` objects see #94;
* Fix broken URIs in README;
* Remove mapview from vignette (CRAN issue with missing PhantomJS).

# rmangal 2.0.0

* Revisions see https://github.com/ropensci/software-review/issues/332;
* add summary method [#87];
* `mg_to_igraph` is now `as.igraph()`;
* `search_references()` has been rewritten [#85];
* vignette now includes examples to use `tigygraph` and `ggraph`;
* pkgdown website is now deployed by Travis CI [#86];
* `geom` column has been removed from `mgSearchInteractions` objects;
* `sf` features are only used in `search_networks_sf()` and when argument `as_sf` is set to `TRUE` [#89];
* query with spatial (`sf`) objects are handle in `query_networks_sf()` that is now exported.

# rmangal 1.9.0.9000

* Version submitted to ROpenSci for review;
* Added a `NEWS.md` file to track changes to the package.
