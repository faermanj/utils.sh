#!/bin/bash
# Utility functions for bash scripts
# Source:
#   https://github.com/faermanj/utils.sh
# Update command:
#   curl -s https://api.github.com/repos/faermanj/utils.sh/releases/latest | jq -r '.assets[] | select(.name=="utils.sh" or .name=="bin/utils.sh") | .browser_download_url' | xargs -n 1 curl -sL -o utils.sh

DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" >/dev/null 2>&1 && pwd)"

# Define colors
readonly RED="\033[0;31m"
readonly GREEN="\033[0;32m"
readonly YELLOW="\033[0;33m"
readonly BLUE="\033[0;34m"
readonly NO_COLOR="\033[0m"
readonly MAGENTA="\033[0;35m"

# Generic log function
LOG_FORMAT="{color}{timestamp} [{level}] {message}{nocolor}"

log() {
    local level="$1"; shift
    local message="$1"; shift
    local color="$NO_COLOR"
    local timestamp
    timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

    # Trim spaces from log level
    levelmatch="$(echo "$level" | xargs)"

    # Determine color based on log level
    case "$levelmatch" in
        INFO) color="$GREEN" ;;
        DEBUG) color="$BLUE" ;;
        WARN) color="$YELLOW" ;;
        ERROR) color="$RED" ;;
        TRACE) color="$MAGENTA" ;;
    esac

        # Use user-definable format
        local formatted="$LOG_FORMAT"
            formatted="${formatted//\{timestamp\}/$timestamp}"
            formatted="${formatted//\{color\}/$color}"
            formatted="${formatted//\{level\}/$level}"
            formatted="${formatted//\{nocolor\}/$NO_COLOR}"
            formatted="${formatted//\{message\}/$message}"
        echo -e "$formatted" >&2
}

# Specific log level functions
info() {
    log 'INFO ' "$@"
}

debug() {
    log "DEBUG" "$@"
}

warn() {
    log 'WARN ' "$@"
}

error() {
    log "ERROR" "$@"
}

trace() {
    log "TRACE" "$@"
}
