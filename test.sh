#!/bin/env bash
set -e
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPTS_DIR/bin/utils.sh"

info "script started".
elapsed

info "This is an info message."
debug "This is a debug message."
warn "This is a warning message."
error "This is an error message."
trace "This is a trace message."
elapsed "logging" 

sleep 1.234
elapsed "sleeping"

sleep 2.345
elapsed "more sleeping"
 

info "script done."
