#!/bin/bash
function generar-yaml-volumen (){
    echo "---"
    echo "kind: PersistentVolume"
    echo "apiVersion: v1"
    echo 
    echo "metadata:"
    echo "    name: $1"
    echo 
    echo "spec:"
    echo "    capacity:"
    echo "        storage: 200Gi"
    echo "    storageClassName: redundante"
    echo "    accessModes:"
    echo "        - ReadWriteOnce "
    echo "    hostPath:"
    echo "          path: /home/ubuntu/environment/datos/$1"
    echo "          type: DirectoryOrCreate"
}

volumenes="volumen1 volumen2 volumen3 volumen4 volumen5 volumen6 volumen7 volumen8 volumen9 volumen10"
for vol_name in $volumenes;
do
    echo "$(generar-yaml-volumen $vol_name)"  | kubectl apply -f -
done;