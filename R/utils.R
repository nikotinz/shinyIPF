# Load and cache IPF data
load_ipf_data <- function() {
    if (!exists("ipf_data_cache", envir = .GlobalEnv)) {
        message("Loading IPF data...")
        .GlobalEnv$ipf_data_cache <- read_feather("data/ipf_data.feather")

        # Convert weight_class to ordered factor
        levels <- sort(unique(as.numeric(as.character(
            .GlobalEnv$ipf_data_cache$weight_class
        ))))
        .GlobalEnv$ipf_data_cache$weight_class <- factor(
            .GlobalEnv$ipf_data_cache$weight_class,
            levels = as.character(levels),
            ordered = TRUE
        )
    }
    return(.GlobalEnv$ipf_data_cache)
}

# Get factor levels for UI elements
get_factor_levels <- function(var_name) {
    if (!exists("factor_levels_cache", envir = .GlobalEnv)) {
        .GlobalEnv$factor_levels_cache <- readRDS("data/factor_levels.rds")
    }
    return(.GlobalEnv$factor_levels_cache[[var_name]])
}

# Format weight class labels
format_weight_class <- function(x) {
    paste0(x, " kg")
}
