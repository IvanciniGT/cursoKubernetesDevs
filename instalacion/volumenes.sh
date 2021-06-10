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

volumenes="es01 es02 es03 es04 es05 es06 es07 es08 es09 es10 es11 es12 es13 es14"
for vol_name in $volumenes;
do
    echo "$(generar-yaml-volumen $vol_name)"  | kubectl apply -f -
done;