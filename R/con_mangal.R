# Cache env
mangal.env <- new.env(parent = emptyenv())

# Base URL
mangal.env$prod <- list()

# Config
mangal.env$base <- "/api/v0"
mangal.env$bearer <- "" # oauth

# Production environment
mangal.env$prod$server <- "http://localhost:3000"
