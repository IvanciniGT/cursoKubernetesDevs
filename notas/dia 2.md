# Contenedor

Entorno aislado donde poder ejecutar procesoS

# Objetos de Kubernetes

## node

Servidor donde tenemos funcionando kubernetes y que pertenece a un cluster
Características:
    nombre
    estado
    labels: Conjunto de claves valor
        Alto Ancho De Banda de Red --> network-bandwidth: high
    taints: Son como etiquetas, pero con un caracter TEMPORAL << Suelen ser gestionadas por el propio kubernetes.

## namespace

Segmentación del cluster de Kubernetes. Espacio de nombres.
Objeto con un determinado nombre (ID) pero montarlo en varios namespaces: 
    - ns: desarrollo
    - ns: pre-produccion
    - ns: produccion

## pod

Conjunto de contenedores, que comparten:
    - Tienen la misma IP
    - Van a instalarse en el mismo nodo
    - Se escalan de la misma forma

Nunca trabajo a nivel de POD: Nunca pongo en un fichero YAML > kind: Pod. Por qué?
Un Pod es UN Pod. Si ese Pod muere... que pasa? Que ya no hay POD: Me he quedado sin servicio: Tengo HA? Nop... ruina !!!!
Un Pod... lo puedo escalar? No. Un Pod es una instancia en ejecución que ya he creado.

SIEMPRE lo que trabajamos es con plantillas de PODs. Desde esas plantillas pediremos a Kubernetes que vaya creando PODs.
Cuantos? Veremos...

# Objetos que permiten definir plantillas de PODs:
 
## PodTemplate: Plantilla de Pod <<< Esto no lo usamos

Este tipo de objeto solo lleva información acerca de la plantilla de POD.
No lleva información acerca de cómo instanciar esa plantilla de POD.

## Deployments:

- Una plantilla de POD
- El número de replicas (PODs) que quiero tener (a priori) de esa plantilla.

Cada replica que se crea del pod, no está identificada... es una más...
Si un pod se cae... se levanta OTRO. 

## StatefulSet

- Una plantilla de POD
- El número de replicas (PODs) que quiero tener (a priori) de esa plantilla.

Cada replica que se crea del pod, SI está identificada... no es una más...
Si un pod se cae... se levanta EL MISMO POD en otro sitio.
El POD tiene su propia personalidad:
- Su propio nombre, que se mantiene a lo largo del tiempo
- Tendrá sus propios valumenes de datos, que están asociados a él.

## DaemonSet

- Una plantilla de POD
Y Kubernetes lo que hará será crear tantas replicas como nodos, una en cada nodo.

## Replicaset

Un objeto dentro de kubernetes que es el responsable de asegurarse que siempre exista el número deseado
de replicas de un pod, según se defina en su deployment


### 

## Ejemplos de pods multicontenedor:

Instalación:
- Websphere - WAS - App   <<< Contenedor
    > Generar logs: - Accesos                   |                       |
                    - Errores                    >  Fluentd, filebeat    >  ElasticSearch
                    - Eventos que se realicen   |                       |

- MariaDB                 <<< Contenedor    

## Podría instalar todo en un único contenedor?

No, porque no van a escalar de la misma forma

## Iría en un único pod o cada contenedor en su propio pod

No, porque no van a escalar de la misma forma

## Me insteresaría ejecutar Fluentd o filebeat en el mismo contenedor que WAS?

A favor.... los logs van a estar en el mismo contenedor.
Un contenedor se genera desde una imagen de contenedor, que es creada por Desarrollador o bien usamos imagenes comerciales.
Los voy a actualizar a la vez? WAS - Filebeat o Fluentd. 
Son independientes.
Quien es el responsable del filebeat? El desarrollador? Filebeat o fluentd? Monitoring

Posiblemente me interesa en 2 contenedores independientes

## Esos 2 contenedores: 1 para WAS y otro para Fluentd, como quiero que escalen?
Cada WAS lleva su fluentd

## Como comparten los ficheros
    - WAS       >>> Escribiendo ficheros
    - FluentD   >>>> Leer los ficheros escritos por WAS
Podrían compartirlos a través de un almacenamiento en RED. Esto sería eficiente? O hay algo más eficiente?
No me interesa hacer esas escrituras/lecturas de ficheros en red.
Alternativas:
    - Si los tuviera en la MISMA MAQUINA podría usar el almacenamiento del host para compartir los datos.
    - Uno de los tipos de volumenes que Kubernetes permite montar en local trabaja sobre RAM
    
RESUMEN: WAS-Fluentd:
    1- Van a escalar de la misma forma: Cada WAS su Fluentd
    2- Me encantaría que estuvieran en la misma máquina (nodo), es más eficiente la compartición de datos entre ellos.
CONCLUSION: Esos contenedores los pongo en un POD.


## Ejemplo entre Deployment vs StatefulSet

MARIADB y lo quiero montar en cluster
- 3 nodos de MariaDB (3 contenedores- 3 pods) que trabajen conjuntamente.
Cada nodo del cluster de mariaDB guarda, almacena los mismos datos?

Que característica me ofrece este tipo de instalación: ALTA DISPONIBILIDAD / Tolerancia a errores
    BBDD Principal   (MAIN)      |
    DDBB Replicacion (WORKER)    | Los 2 nodos guardan los mismos datos? Deberían... pero lo hacen? Que pasa si uno se cae? 
                                 | Si los 2 están funcionando, ambos deberian tener los mismos datos... pero los tienen en mismo momento del tiempo?
                                 | No... con un delay
                                 | Cada una de esa instancias de MariaDB tiene su propo VOLUMEN DE ALMACENAMIENTO
                             
Que característica me ofrece este tipo de instalación: ESCALABILIDAD
MariaDB 1   |
MariaDB 2   |  Cada nodo guarda una parte de los datos.
MariaDB 3   |
MariaDB 4   |

En cualquiera de esos casos:
    Cada nodo tiene sus propios datos, independientes del resto de nodos? SI
    Qué pasa si se cae el MariaDB 2... o si se cae el MariaDB Replica?
        Que quiero levantar de nuevo? Si se cae el MAriaDB2 quiero levantar un MariaDB o el MariaDB2? El MariaDB2
    
    El tipo de objeto que voy a montar en Kubernetes es un : StatefulSet
Otros ejemplos de Statefulse: BBDD, ElasticSearch, Kafka

---

Servidor WEB... que muestra una página WEB (html, css, js)
         ^^ nginx, https                ^^ Unos archivos en un disco duro

Nodo_AB1238649 - servidor web y la página WEB
Nodo_KD83474VB - servidor web y la página WEB
Nodo_ASDHJ1295 - servidor web y la página WEB
Nodo_DNFJ32423 - servidor web y la página WEB
Nodo_234987528 - servidor web y la página WEB

Cada nodo tiene sus propios datos diferentes del resto? Nop... todos trabajan contra la misma web
Si se cae enl nodo3... que tengo que hacer? Levantar OTRO nodo con nginx que muestra la misma WEB

En este escenario montaría un Deployment



------

Nginx <<< Contenedor <<< Pod 
                         ^^
                         Los contenedores del POD se han pinchado en la RED de Kubernetes - Y obtienen una IP
                         
Si yo quiero acceder al nginx, como lo hago? 
Mediante la IP
Si tengo varios PODS (escalado), que IP les doy a mis clientes?
NECESITAMOS UN BALANCEADOR DE CARGA SIEMPRE QUE MONTO UN CLUSTER ACTIVO-ACTIVO.... pero....
Que pasa si un pod se cae?
    - Kubernetes lo levanta en otro sitio... pero con otra IP.
        En este caso, tendría además que cambiar la configuración del BALANCEADOR DE CARGA
        
Incluso el balanceador... vamos a acceder a él a través de una IP? NO
Accedemos através de un nombre de red, resuelto por un DNS.


NECESITAMOS ADICIONALMENTE:
    - BALANCEADOR DE CARGA   |
    - DNS                    |  Que tengo que configurar y mantener esa configuración
    
# Nuevo tipo de objeto de Kubernetes: SERVICE
Balanceador de Carga
Nombre resoluble a través de DNS

# Funcionamiento de los servicios

Cluster Kubernetes:                     
    Nodo 1                                  X.X.X.1  ----| Red Kubernetes
        Pod MariaDB                         X.X.X.10 ----|
        NetFilter. Reglas:                               |
            Cuando te llamen a la IP XXX                 | 
                                    ^la del servicio     |
            El el puerto 96                              |
                         ^Puerto del servicio            |
            Reenvialo al puerto 80 de los pods           |
                que ofrezcan ese servicio                |
            Abre el puerto 32000 en el Nodo y reenvia    |
                las peticiones al la IP interna          |
                del servicio                             |
                                                         |
    Nodo 2                                  X.X.X.2  ----|
        Pod MariaDB                         X.X.X.11 ----|
        Pod WAS                             X.X.X.12 ----|
        NetFilter. Reglas:                               |
            Cuando te llamen a la IP XXX                 | 
                                    ^la del servicio     |
            El el puerto 96                              |
                         ^Puerto del servicio            |
            Reenvialo al puerto 80 de los pods           |
                que ofrezcan ese servicio                |
            Abre el puerto 32000 en el Nodo y reenvia    |
                las peticiones al la IP interna          |
                del servicio                             |
                                                         :
                                                         |
Servicio mariab                             X.X.X.20 ----|  
    Nombre y un balanceo de carga
    Se implemente en el cluster mediante REGLAS "NETFILTER" <<< Una librería que existe en el Kernel de Linux
                                                                Es la que gestiona todo el tráfico de RED
                                                IPTABLES    <<< Crear reglar de firewall 
                                                                >>>> Suministrar reglas a NETFILTER
    Quién da de alta esas reglas? Kubeproxy
    Quiero que sea de tipo NODEPORT: 32000

## Tipos de servicios en Kubernetes:

### ClusterIP

Es el tipo por defecto. Sirve para crear nombres DNS internos al cluster, para servcios que SOLO queremos que sean accesibles desde el cluster
Serán habituales?
En el 99,9% van a ser estos.

### NodePort 

Es una extensión del tipo ClusterIP, pero que ADEMÁS tiene:
    - En cada nodo del cluster va a abrir un puerto (en su red pública), puerto que está entre el 30000 y el 32XXX
    - De tal forma que si llamo al host en su red publica a ese puerto (3XXXX), esa peticion se reenvia a la IP privada del servicio

Que dirección le doy a mis clientes finales?
IP + Puerto
NECESITO MONTAR UN BALANCEADOR EXTERNO EN ESTE CASO QUE MANDE LAS PETICIONES A:
La externa de cualquier nodo del HOST  +  32000

Load Balancer   | Nodo 1: 32000   |
                | Nodo 2: 32000   |    Se reenvian a la IP Del servicio Cluster IP de Kubernetes
                | ...             |
                | Nodo 50: 32000  |
Esto no es muy práctico.... Al final hay cosas sin automatizar aquí.
Los servicios de Tipo NodePort, están bien para jugar, para exponer algo localmente, en una minired (entorno de desarrollo), probar... NO VALEN PARA PRODUCCION
a no ser que monte un LOAD BALANCER EXTERNO... y eso va a ser mucho curro.... Paso !


### LoadBalancer

Es un paso más sobre los servicios NodePort, Donde además de los que se monta en el Node Port, vamos a tener un BALANCEADOR DE CARGA AUTOMATICO
PERO.... Ohhhh. Esto no es algo que ofrezca Kubernetes.

Los servicios Load Balancer SOLO (hay truquitos....) los podemos utilizar en clusters de Kubernetes gestionados por un proveedor de Cloud.
Si yo le pido a Kubernetes que quiero un servicio LoadBalancer, y mi cluster de kubernetes está siendo gestionado por AWS, AZURE, GCL,
estos proveedores de cloud me dan ese servicio de LOAD BALANCER gratis + IP publica accesible desde internet, que yo puedo luego dar de alta en un DNS mio.

Si trabajo con un cluster OnPremisses (BAREMETAL) hay un programa integrado con Kubernetes que se llama METALLB.

# Que tipo de servicio os he dicho que vamos a utilizar "siempre"? ClusterIP

En kubernetes hay un tipo de objeto llamado INGRESS <<< nginx   POD <<<<< Tendrá un servicio asociado. Os imaginais el tipo? LOAD_BALANCER
Configurare redirecciones en nginx. Cuando te llamen por este nombre o a este conexto o en este puerto... reenvia a un servicio INTERNO del cluster.


En nuestro cluster vamos a necesitar un INGRESS-CONTROLLER > Este es un objeto en kubernetes que crea un Pod con NGINX y un servicio LOAD-BALANCER

A partir de ahí, nosotros para nuestra s aplicaciones que queramos que sean accesibles publicamente, definiremos objetos de tipo: INGRESS

Que es un objeto de TIPO INGRESS: Un conjunto de reglas (configuración) con la que alimentar a ese POD de NGINX

