suppressMessages(library(R6,           warn.conflicts = FALSE))
suppressMessages(library(hash,         warn.conflicts = FALSE))
suppressMessages(library(stringr,      warn.conflicts = FALSE))
suppressMessages(library(tibble,       warn.conflicts = FALSE))
suppressMessages(library(dplyr,        warn.conflicts = FALSE))
suppressMessages(library(lubridate,    warn.conflicts = FALSE))
# Shiny
suppressMessages(library(shiny,        warn.conflicts = FALSE))
suppressMessages(library(htmltools,    warn.conflicts = FALSE))
suppressMessages(library(shinyjs,      warn.conflicts = FALSE))
suppressMessages(library(shinyWidgets, warn.conflicts = FALSE))
suppressMessages(library(reactable,    warn.conflicts = FALSE))
# suppressMessages(library(bslib,     warn.conflicts = FALSE))

suppressMessages(library(RMariaDB,     warn.conflicts = FALSE))

# Load sources from subdirectories
files = list.files(path="R", pattern="\\.R$", recursive=TRUE, full.names=T, ignore.case=F)
sapply(files,source)

WEB = JGGWEBROOT$new("test")