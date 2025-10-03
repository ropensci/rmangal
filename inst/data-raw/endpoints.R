rmangal_endpoints <- data.frame(
    name = c(
        "dataset",
        "environment",
        "interaction",
        "network",
        "node",
        "reference",
        "attribute",
        "taxonomy",
        "trait"
    ),
    path = c(
        "dataset",
        "environment",
        "interaction",
        "network",
        "node",
        "reference",
        "attribute",
        "taxonomy",
        "trait"
    )
)

rmangal_endpoints <- save(
    rmangal_endpoints, file = "data/rmangal_endpoints.rda", compress = "xz"
)