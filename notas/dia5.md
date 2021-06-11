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
    
    
    
NGINX PUERTO:80 IP:192.168.1.100
    NginX atiende las peticiones que lleguen a ese puerto por parte de un cliente
    Cuando me llegue ahi una peticion... la mando a otro sitio
    nombre de host:    <<<< VirtualHost
        http://tomcat.caixa.es ----> Tomcat
        http://kibana.caixa.es ----> Kibana
        Paths: 
            /v1    ----> Kibana
            /v2    ----> Kibana2

CLIENTE :       URL:       http://192.168.1.100:80
                                                PUERTO LO UNICO QUE NO VAMOS A CAMBIAR
                            http://192.168.1.100:80/kibana
                            http://192.168.1.100:80/tomcat
                            
                           IP - nombre DNS
                           
                           Muchos nombres DNS que lleven a la misma IP
                           
                           http://tomcat.caixa.es  -----> 192.168.1.100
                           http://kibana.caixa.es  -----> 192.168.1.100
                           http://wordpress.caixa.es  -----> 192.168.1.100
                        
                           SERVIDOR DNS
dashboard.cluster       ----> 52.19.192.177
                           
                           
                           
-----


Charts de Helm     <<<<<     Sevilla    ( Bitnami ) VMWARE


DEV->OPS: Cultura de la automatización

--------

HELM
parametro --dry-run simula la instalacion
comando template, install, uninstall, ______

helm install wordpress-ivan bitnami/wordpress --namespace ivan --create-namespace -f wordpress.conf.yaml