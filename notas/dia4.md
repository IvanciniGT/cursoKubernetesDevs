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
             
             
             
---- 
Limiticaciones a la ejecución de PODS
- Memoria
- CPU

Scheduller basa su  trabajo en 2 cosas:
    - Afinidades (Preferencias que tiene un determinado pod a la hora de instalarse en el cluster)
    - Recursos <<<<
        Nodo 1 CPU 80%     <<<<
        Nodo 2 CPU 40%     <<<<
        Nodo 3
        Nodo 4
        Nodo 5
        
    Quiero meter un pod nuevo... donde lo mete el scheduller?
    
Cada vez que un pod solicita instalarse en un cluster, 
    se "calculan" los datos de MEMORIA y CPU que deben garantizarse para el mismo.
    
Nodo: 10 Gbs de RAM
       4 CPUs
      
Cada POD va a tener SIEMPRE unos valores que se le deben garantizar de CPU y de RAM
    Declaración de valores se hace a nivel del POD para cada CONTENEDOR
    Si esto no se hace se toman los valores por defecto designados para el NAMESPACE
    Si no se han asignado valores por defecto para el NAMESPACE se toman los definidos para el cluster.

A nivel de RAM, exige una cantidad de bytes
    5Gi
A nivel de CPU, exige cuanto uso puede hacer de nucleo de cpu cada segundo
    2 <<< Número de cpus integras puedo usar (cada segundo)
        En un segundo me dejase utilizar media cpu de cada cpu durante medio segundo
    0.5 = 500m de uso grantizado de CPU cada segundo
    
    2000ms     100m o 200m
    
Yo debería exigir el mínimo que mi app necesita para funcionar con normalidad
    1º Que aquello funcione
        Por muy pequeña que se la cantidad de CPU.... el sistema siempre funciona... pero irá muy lento
        En cambio si no llego a un mínimo de RAM, el sistema ni arranca
    2º Cúanto me va a dejar usar Kubernetes de RAM y de CPU.
        Cuanto me va a dejar usar Kubernetes de RAM y CPU?
            Al menos cuanto me va a dejar? Lo que me haya garantizado
            Si hay hueco.... puedo usar más.
            
Nodo 1 - POD A - POD C
    10 Gb / Reservados: 4 + 5 = 1 libre
    4 cpus
    USO HACE DE LOS RECURSOS: 
        POD A    6Gbs de RAM en uso  <<<< KATACLASH !
                                            KUB: REBOOT POD A muere... liquidao... Gracefuly
        POD C    5Gbs de RAM en uso
Nodo 2 - Pod B
    10 Gbs
    4 cpus
    
Pod A: 
    Quiero al menos 4Gbs de RAM
    Quiero al menos 2 cpus
Pod B: 
    Quiero al menos 7 Gbs de RAM
    Quiero al menos 1 cpus
Pod C:
    Quiero al menos 5 Gbs de RAM
    Quiero al menos 1 cpus




kill - MANDAR UNA SEÑAL A UN PROCESO
     SIGTERM = 9
    
LO QUE EL DESARROLLADOR PIDE QUE SE GARANTICE
    CPU 2
    RAM 4Gb
     
LIMITE DE USO DE RECURSOS:
    CPU 4
    RAM 8Gb
    
    
Maquina virtual de JAVA con 4Gbs
 ^^^^
 Mi aplicación. Que pasa si mi app quiere tomar mas RAM 5Gbs...
 Mi aplicación EXPLOTA. KATACLASH !!!!!
 
El único riesgo de que me maten es si me paso en RAM... 
Si me paso en CPU no hay problema... Cuando me tenga que limitar, me limitan y punto.
    
JVM      2Gbs - 3Gbs
    WEBLOGIC
        App WEB JAVA 
            Memoria RAM?
                1º Cargar el código del programa en memoria <<< Esto ocupa mucho? No... y además es constante (mas o menos):
                    50Mb - 1Mb-5Mb
                ---------
                2º Buffers
                3º Ir dejando datos temporales de trabajo <<< Creando y destruyendo
                --------- ^^^  No son constantes. De qué dependen? Del uso del aplicativo   ----- Calibrar y Escalar
                4º CACHES <<<<< 95% PROBLEMAS
                    Espacio en RAM donde guardo datos que creo que voy a utilizar en un futuro... y cuando
                    me los pidan me costaría un huevo de tiempo conseguirlos...
                    los dejo aquí por si acaso...   >>>>> RENDIMIENTO
                        HIBERNATE, SPRING
                        
    MINIMO 4Gbs
    LIMITE 4Gbs <<<<
    
    
---- Ejemplos de cuando voy a necesitar dar instrucciones especiales al Scheduller

He montado un programa de DeepLearning  <<<<<  GPU Potente
    Necesito un nodo que tenga GPU

Tengo un cluster que abarca 4 zonas geográficas <<<< Continuidad del servicio 
                                                <<<< Requisitos LEGALES !!!!! 
    Si quiero montar una BBDD
        Donde la quiero montar?     <<<<<<<     Scheduller
            1 en cada zona

Quiero un disco duro rapidito sin persistencia <<< Los datos no los guardo fuera del nodo?
    Datos temporales
    






