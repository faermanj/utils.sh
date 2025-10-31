# elapsed.sh - Prints elapsed time since script start and since last call, tracks laps
# Usage: source this file, then call elapsed <lap_name>

SCRIPT_START_TIME=${SCRIPT_START_TIME:-$(date +%s.%N)}
ELAPSED_LAST_CALL=${ELAPSED_LAST_CALL:-$SCRIPT_START_TIME}
declare -A ELAPSED_LAPS
ELAPSED_LAP_ORDER=()

elapsed() {
       local lap_name="$1"
       local now_sec now_nsec start_sec start_nsec last_sec last_nsec
       local since_start since_last

       # Split seconds and nanoseconds
       IFS='.' read -r now_sec now_nsec <<< "$(date +%s.%N)"
       IFS='.' read -r start_sec start_nsec <<< "$SCRIPT_START_TIME"
       IFS='.' read -r last_sec last_nsec <<< "$ELAPSED_LAST_CALL"



       # Calculate elapsed times in nanoseconds
       now_nsec=${now_nsec:0:9}
       start_nsec=${start_nsec:0:9}
       last_nsec=${last_nsec:0:9}

       since_start_ns=$(( (10#$now_sec - 10#$start_sec)*1000000000 + (10#$now_nsec - 10#$start_nsec) ))
       since_last_ns=$(( (10#$now_sec - 10#$last_sec)*1000000000 + (10#$now_nsec - 10#$last_nsec) ))

       # Convert nanoseconds to seconds with 3 decimals using Bash only
       since_start_sec=$(( since_start_ns / 1000000000 ))
       since_start_frac=$(( (since_start_ns % 1000000000) / 1000000 ))
       since_last_sec=$(( since_last_ns / 1000000000 ))
       since_last_frac=$(( (since_last_ns % 1000000000) / 1000000 ))

       since_start=$(printf "%d.%03d" "$since_start_sec" "$since_start_frac")
       since_last=$(printf "%d.%03d" "$since_last_sec" "$since_last_frac")

       if [[ -n "$lap_name" ]]; then
              ELAPSED_LAPS["$lap_name"]="$since_last"
              # Add lap name to order array if not already present
              local found=0
              for l in "${ELAPSED_LAP_ORDER[@]}"; do
                     if [[ "$l" == "$lap_name" ]]; then
                            found=1
                            break
                     fi
              done
              if [[ $found -eq 0 ]]; then
                     ELAPSED_LAP_ORDER+=("$lap_name")
              fi
       fi


       local msg="elapsed[${since_start}] lap[${since_last}]"
       for lap in "${ELAPSED_LAP_ORDER[@]}"; do
              msg+=" ${lap}[${ELAPSED_LAPS[$lap]}]"
       done
       perf "$msg"

       ELAPSED_LAST_CALL="$(date +%s.%N)"
}
