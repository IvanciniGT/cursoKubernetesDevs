Tipos de software:
    - Aplicacion    : Programa que se ejecuta primer plano, de forma indefinida en el tiempo,
                      pensado para interactuar con un usuario (persona física).
-----------------------------     VVVVV   ------------------------------------------
    - Servicio      : Programa que se ejecuta segundo plano, de forma indefinida en el tiempo,
                      pensado para interactuar con otro programas.
                      
        >>>> Pods > Contenedor > Servicio > Proceso que corre INDEFINIDAMENTE EN EL TIEMPO 
                    PUERTO DE COMUNICACIONES ABIERTO
                        Weblogic
            
    - Demonio       : Programa que se ejecuta segundo plano, de forma indefinida en el tiempo,
                      pensado para no interactuar con nadie.
                    NO TIENEN PUERTO
                        FileBeat | FluentD
        
        >>>> Pods > Contenedor > Demonio > Proceso que corre INDEFINIDAMENTE EN EL TIEMPO         
                      
    - Scripts       : Programa que se ejecuta primer plano o segundo plano, de forma 
                      limitada en el tiempo, para hacer una secuencia de tareas. (quizas configurables)
    
        >>>> Pods > InitContainers > Script > Proceso que corre DE FORMA FINITA EN EL TIEMPO       
        >>>> Jobs  > Script > Proceso que corre DE FORMA FINITA EN EL TIEMPO       

IMPORTANTISIMO: En kubernetes, los contenedores se PRESUPONE que tienen que estar ejecutandose
                de forma INDEFINIDA !!!!!

    
    
    
    --
    - SO
    - Drivers
    - Librerias
    
    
    
----
Si tengo un POD y lo borro, que tengo: NADA
Si tengo un DEPLOYMENT: Un generador de PODS (desde una plantilla):
    Si borro un POD, que ocurre, el deployment (a través del replicaSet) crea de nuevo el POD.


----
Filebeat/FluentD vs Webslogic/WAS

WAS-> Configuraria dos archivos de log con rotacion... De 50Kb

Cual es el tamaño que ocupo de RAM: 100Kbs

----

Gib - Gi - Gibibytes: Lo que antes era un Gb
Mib - Mi     --
Kib - Ki        Base 2

1Gb: 1024 x 1024 x 1024 bytes > ESTO YA NO ES ASI
HOY EN DIA: 
    1Gb: 1000 x 1000 x 1000 bytes <<<< ESTO ES HOY EN DIA
    
-----
Para configurar los pods
# ConfigMaps
# Secrets       <<<< Almacenarán información sensible
                     Dentro de kubernetes se almacenan encriptados