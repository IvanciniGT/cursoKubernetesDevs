Nodo 1
    Pod: elasticsearch
    Pod: mariadb *
Nodo 2
    Pod: mariadb *
Nodo 3
    Pod: elasticsearch


POD NUEVO
    podAffinity
        NOT elasticsearch
        
Donde determina el scheduler que se puede montar este pod
    Nodo 1
    Nodo 2
    
----------------------------------------------------------------

Nodo 1
    Pod: elasticsearch*
    Pod: mariadb
Nodo 2 <<<<<<<<
    Pod: mariadb
Nodo 3
    Pod: elasticsearch*


POD NUEVO
    podAntiAffinity
        elasticsearch
        topologia NOMBRE NODO
        
Donde determina el scheduler que se puede montar este pod
-Nodo 1
    SI
-Nodo 2
    NO
-Nodo 3
    SI
------------------------------------------------------------------

Busca entre todos los nodos que compartan TOPOLOGY KEY
lo que sea que te esté pidiendo.
En cualquiera de esos nodos me podrías instalar.


Nodo 1 - zona: EUROPA
    elasticsearch
    mariadb
Nodo 2 - zona: ASIA
    mariadb
Nodo 3 - zona: ASIA
    elasticsearch
    mariadb
Nodo 4 - zona: EUROPA
    elasticsearch
Nodo 5 - zona: AFRICA
    mariadb
Nodo 6- zona: AFRICA

POD NUEVO
    podAffinity
        mariadb
        topologia ZONA
        
EUROPA <<<
    Nodo 1
    Nodo 4

ASIA <<< 
    Nodo 2
    Nodo 3

AFRICA <<< 
    Nodo 5
    Nodo 6