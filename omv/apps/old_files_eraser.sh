#!/bin/bash

DIRECTORIO="/srv/dev-disk-by-uuid-23deda77-cb32-467d-a5ae-4c93b4fe4b56/backup/IMAGES_BACKUP"

# Verifica si el directorio existe
if [ ! -d "$DIRECTORIO" ]; then
    echo "Directory '$DIRECTORIO' does not exist."
    exit 1
fi

echo $0 started !! > /dev/kmsg

# variables

AUX=$(echo $(date +%b-%d-%Y_%HH%MM)"-ART")
DATE=${AUX^^}
IP=$(hostname -f | column -t -s "." | awk '{print $1}')"-"$(ip -4 -br a | grep -i "eth0\|vmbr0" | awk '{print $3}' | column -t -s "/" | awk '{print $1}')

JSON_SUCCESS=$(echo '{ "timestamp": "'"$DATE"'", "source_ip": "'"$IP"'", "country": "FILES ERASE SUCCESSFUL" }')
JSON_FAIL=$(echo '{ "timestamp": "'"$DATE"'", "source_ip": "'"$IP"'", "country": "FILES ERASE FAILED" }')

# Encuentra y elimina archivos modificados hace más de 60 días
cmd='find "$DIRECTORIO" -type f -mtime +90 -print -exec rm -f {} \;'

eval "$cmd"

status=$?

if [[ $status -eq 0 ]];
  then
    echo "Exit code: $status - $0 successfully finished!!" > /dev/kmsg
    curl -sS -X POST -H "Content-Type: application/json" -d "$(echo $JSON_SUCCESS)" "https://x.matanga.com.ar/post"
  else
    echo "Exit code: $status - $0 failed - ERROR: problem erasing old files." > /dev/kmsg
    curl -sS -X POST -H "Content-Type: application/json" -d "$(echo $JSON_FAIL)" "https://x.matanga.com.ar/post"
fi
