ElasticSearch
    Siempre funciona en cluster
    Cada nodo de un cluster tiene su propia misión
        Maestros -> 3   
        Datos ->    2
        Ingesta ->  Preparar datos para su carga en ES (data) -> 2
        Coordinadores -> Son los que dan la cara con respecto a los clientes (CONSUMIR) -> 2
Kibana

A la hora de formar un cluster de ES

Master1 (Master1 > Master2 > Master3)
  v^
Master2 (Master1 > Master2 > Master3)
  v^
Master3 (Master1 > Master2 > Master3)

Quien va a empezar siendo el maestro: LISTA ORDEN PROIRIDADES
Master1 > Master2 > Master3


Data 1 ----> Cualquier maestro (Servicio - Load Balancing)

Servicio << elastic-maestros >>>> Maestro1 Maestro2 Maestro3
Master <<<< Statefulset
    Pods:
        Maestro1: Contacta por orden con el master1, master2, master3
        Maestro2
        Maestro3
        
Maestro 1 >  nombre(IP)  > Maestro2 
              ^^^^
             Service < elastic-maestro-1,elastic-maestro-2,elastic-maestro-3
             
             maestro1.servicio-statefulset
             maestro2.servicio-statefulset
             maestro3.servicio-statefulset