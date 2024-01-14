suppressMessages(library(R6,                 warn.conflicts = FALSE))
suppressMessages(library(hash,               warn.conflicts = FALSE))
suppressMessages(library(stringr,            warn.conflicts = FALSE))
suppressMessages(library(tibble,             warn.conflicts = FALSE))
suppressMessages(library(dplyr,              warn.conflicts = FALSE))
suppressMessages(library(tidyr,              warn.conflicts = FALSE))
suppressMessages(library(lubridate,          warn.conflicts = FALSE))
suppressMessages(library(openxlsx,           warn.conflicts = FALSE))
suppressMessages(library(reactable,          warn.conflicts = FALSE))
suppressMessages(library(plotly,             warn.conflicts = FALSE))
suppressMessages(library(jsonlite,           warn.conflicts = FALSE))

suppressMessages(library(RMariaDB,     warn.conflicts = FALSE))

# Forzar a recargar
unloadNamespace("JGGShiny")
suppressMessages(library(JGGShiny2,          warn.conflicts = FALSE))

# Load sources from subdirectories
files = list.files(path="R", pattern="\\.R$", recursive=TRUE, full.names=T, ignore.case=F)
sapply(files,source)

WEB = WEBROOT$new()
