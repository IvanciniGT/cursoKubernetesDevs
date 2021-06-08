# Contenedores

## Qué es un contenedor?

Entorno aislado donde vamos a ejecutar procesos (aplicaciones) dentro de un SO Linux.
La gestión de esos contenedores la hacemos a través de un software de Gestión de Contenedores:
    - Docker
    - ContainerD
    - Podman
    ------------------------------------ Permiten la gestión de Contenedores en un Cluster
    - Kubernetes
    - Opernshift < Distribución de Kubernetes - Ultravitaminado

## Qué significa un entorno aislado?

El contenedor tiene:
- Restricción de acceso a CPU
- Restricción de acceso a RAM
- Su propio FileSystem (sistema de archivos)
- Configuración de RED : IP... y otras: DNS, Gateway: El contenedor es pinchado dentro de la red virtual de docker:
- 


## Entorno de Producción de una empresa

- Alta disponibilidad < Intentar garantizar un determinado tiempo de servicio. 99%, 99.9% 99.99% => REDUNDANCIA
    - Compromisos a priori!
        - 99% : 100 dias, 1 puede estar caido el sistema.... 1 año=3,6 dias puede estar el sistema abajo.
        - 99,9% : 1000 dias, 1 puede estar caido.            1 año=8 horas abajo.
        - 99,99% :                                                 30-40 minuto abajo.
        De que depende lo que quiera garantizar! 
            De la pasta que me quiera gastar. Me gastaré pasta cuando la app sea muy crítica.
- Escalabilidad:
    - Capacidad de mi entorno para adaptarse a las necesidades de cada momento: CRECER - DISMINUIR

App 1:                                                      App de gestión de emergencias
    Dia n:          100 usuarios                                10
    Dia n+1:        100000 usuarios    Black friday              5
    Dia n+2         200 usuarios                            1000000 M
    Dia n+3         80000 usuarios     Ciber Monday             10

## Como conseguimos la HA y la Escalabilidad

Montando un cluster(group): grupo
    Activo - Pasivo : 
        Tengo 2 copias del sistema, 1 en funcionamiento. La otra de backup. 
        Cuando la principal falla, se activa la segunda <<< Puede estar automatizado o no.
    Activo - Activo :
        Tengo N copias del sistema, todas funcionando simultaneamente.

# Kubernetes

Gestión de un cluster de nodos (máquinas) donde poner en funcionamiento aplicaciones, servicios,...  mediante contenedores.

---> AUTOMATIZACION del trabajo de despliegue / Operación y mantenimiento de mis sistemas.

# Empaquetado de apps para su distribución:
    - Generar un programa de instalación.
    - Según el lenguaje, en ocasiones existen procedimientos de empaquetado establecidos.
        JAVA: Generamos un ZIP con los Archivos: .jar .war. ear <<< Jakarta EE  : JEE
    
    Para poder trabajar con contenedores (ejecutar mi software dentro de un entornos aislado en LINUX), necesitamos
    distribuir el software mediante: Imagen de Contenedor
    
# Imágen de contenedor:
    ZIP: Con todos los archivos de un programa, YA INSTALADO y CONFIGURADO de antemano
    Lleva adicionalmente unos METADATOS <<<  Configuraciones personalizables 
        COMMAND, que proceso se debe ejecutar al iniciar un contenedor

Docker 2 Kubernetes <<<< Crear imágenes de contenedor
Administración de Kubernetes.


# Docker

docker <OBJETO> <OPERACION> <ARGS>              
docker image pull <ARGS>                >>>>>>>>>>      docker pull <ARGS>
docker image list                       >>>>>>>>>>      docker images

docker container create <ARGS> NOMBRE_IMAGEN

docker image pull >>>>>
    1 Descargado la imagen del contenedor.
    2 Se ha descomprimido esa imagen en una carpeta en el disco.  Ni se donde está ni me interesa


docker container create >>>>
    Se nos ha creado una carpeta en algun sitio del ordenador (que no me interesa tampoco), para guardar los cambios que se realicen
    en el FileSystem del contenedor.
    
docker container inspect NOMBRE_CONTENEDOR
    
docker exec CONTENEDOR PROGRAMA

docker exec -it CONTENEDOR bash
    
## FileSystem de un Contenedor - Sistema de archivos.
El conjunto jerarquizado de todos los archivos / directorios que hay definidos dentro de un entorno (sistema, s.o.)
En linux, cómo comienza el sistema de archivos?
    / RAIZ DEL DISTEMA DE ARCHIVOS
    /home
    /opt
        /tomcat
    /var
        /bin/nginx/  .... /bin/php
        /bin/httpd/
                    httpd <<< Linux no llevan los programas .exe
                        <<< Al arrancarlo a qué da lugar?
                            Un proceso: Un programa que tengo en ejecución dentro e un SO.
                            Qué pasa si el apache le pide al SO raiz: 
                                Dame un listado de todos los archivos que tienes en el RAIZ. Que le daría?
                                    /
                                    /bin/php
                                    /opt
                                    /var
                                    /etc
                                    /home
    /etc
    /bin
-----
/
    bin
    etc
    home
    opt
        /nginx
            /bin/nginx <<< Ejecutable
            /data                       / <<<<<<< Engaña al proceso nginx... y hazle creer que esta carpeta es el / (RAIZ)
                /bin/php
                /tmp
                /var
                /opt
    tmp

ORDENADOR                       CONTENEDOR NGINX
/opt/nginx/data/tmp            /tmp            



El sistema de archivos de un contenedor se contruye a capas.

NGINX: SO, Dame el root del fs: Ahi lo tienes:
NGINX: SO, Dame lo que hay dentro de /var:    prueba.txt
NGINX: Añado 4 lineas en el archivo prueba.txt

                                                        NGINX 
                            VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

- VOLUMENES:
   Oye docker... cuando te pidan que guarde algo en la carpeta del contenedor :         
    Realmente guardalo en la carpeta fisica del host /datos/mariadb                    /var
                                                                                        prueba.txt (con las 4 lineas adicionales... aparte de lo que hubiera)
- Carpeta para el contenedor                                                           /var
    Aqui se guardará solamente los cambios que se realicen sobre el FS original de la imagen del contenedor
- Imagen del contenedor:          /bin              /etc               /opt            /var    
                                                                                        prueba.txt

### Interfaz de RED: El montaje que se hace de una o varias NICs para su utilización dentro del SO.
3 interfaces de RED:
    - Uno asociado a la ethernet (Cable, RJ45)
        172.31.6.211
    - Otro asociado a la WIFI
    - Loopback (localhost): Red física? NO, Una red virtual que vide dentro de mi computadora. Para que sirve esa red?
        Para que procesos que yo estoy ejecutando dentro de mi computadora y que quiera que hablen entre SI, 
            tengan una forma de hacerlo: 127.0.0.1
    - Docker monta ina interfaz de red virtual y provada dentro de la maquina (HOST): 172.17.0.1

### Dispositivo: HARDWRE      NIC: Network Interface Card


Mi contenedor de nginx: 172.17.0.2



-------------------------------------------------------------------------------- Red amazon
  | IP: 172.31.6.211          Redirección de Puertos (NAT)            | IP: 172.31.6.212
 HOST UBUNTU                                                        OTRO ORDENADOR
  | IP: 172.17.0.1
------------------------------ Red de docker
  | IP: 172.17.0.2          | IP: 172.17.0.3
 Cnginx                     Apache
 
 
 Ordenador UBUNTU, Atención !!!!
    EXPONER UN SERVICIO:
    Cuando te llamen a tu IP: 172.17.6.211, en un determinado puerto que yo voy a elegir... pj: 87
        Reenvia esa petición a la IP: 172.17.0.3, en el puerto 80
        
Imaginad que creo un contenedor, desde una imagen que lleve instalado MariaDB.
    Todos los datos que escribiese, irían a la carpeta del contenedor...

Esos datos tienen persistencia? SI
    Define persistencia:
        Si apago el ordenador y lo vuelvo a poner en marcha... Los datos de MariaDB siguen ahí? SI TOTALMENTE. AHI SIGUEN !!!!!

Si arranco / paro, reinicio un contenedor, sus datos propios (sus cambios) no se pierden.

Que pasa si borro el contenedor?
    Docker en automatico borra la carpeta propia del contenedor..... En este caso PIERDO LOS DATOS. 
Esta es una operación habitutal: BORRAR UN CONTENEDOR <<<<
    - Vamos a estar borrando contenedores por minutos.
    
CLUSTER, KUBERNETES, OPENSHIFT:
    Maquina fisica 1                                                |       VOLUMENES EXTERNOS:
        Contenedor MariaDB   <<<< Lo migro a la maquina 2           |
            ID: 127                                                 |       Servidor NFS
                                                                    |       Cabina de Almacenamiento EMC2
    Maquina fisica 2                                                |       AWS
        Contenedor MariaDB                                          |       AZURE
            ID: 94856382748489274                                   |
    
Tengo mariaDB en una maquina 1

Maquina1:
    MariaDB v 11.2.1    <<< Upgrade v: 11.2.2
        VVV DATOS               ^^^^
            /datos/mariaDB del host
            
            
----------
KUBERNETES: 


Maquina 1                                                                                              -| Red Virtual que 
    Demonio Docker                                                                                      | monta KUBERNETES
    Demonio Kubernetes   -   kubelet                                                                    |   Flannel < Sencillo
    Contenedores de kubernetes: - Plano de control de Kubernetes: Control-plane                         |   Calico  < Alto rendimiento
        scheduler             Determina el nodo                                                     ----|
        api server                                                                                  ----|
        etcd                                                                                        ----|
        coredns                                                                                     ----|
        kubeproxy                                                                                   ----|
        controller manager                                                                          ----|
                                                                                                        |
                                                                                                        |
Maquina 2                                                                                               |
    Demonio Docker                                                                                      |
    Demonio Kubernetes   -   kubelet                                                                    |

Cliente kubernetes:   kubectl  <<< En la maquina que quiera comunicar con el cluster... + en la máquina principal del cluster
Ncesitamos otro programa que se llama "kubeadm"  < Permite: 
    - 1 Crear un nuevo cluster de Kubernetes
    - 2 Añadir nuevos nodos a un cluster de kubernetes
    
    
    # KUBECTL Cliente de Kubernetes
    
                    Sobre que quiero realizar la operación indicada
    kubectl <VERBO> <TIPO_DE_OBJETO> <ARGS>
            OPERACION QUE QUIERO REALIZAR
            
            
# Objetos de Kubernetes

node - Requesenta una máquina "física" dentro del cluster de Kubernetes
pod  - Algo tiene que ver con contenedores <<<
namespace - División que hacemos en el cluster de kubernetes, para separar nuestros objetos del cluster.

-----
# POD:  Minima unidad de trabajo en Kubernetes. 
Conjunto de contenedores (puede ser 1 solo), que cumplen:
    - 1º Kubernetes me asegura que van a instalarse en la misma máquina (nodo)
    - 2º Comparten Dirección IP: Entre ellos la comunicación se realiza mediante: localhost
    - 3º Escalan de la misma forma

----
Cualquier objeto que quiera crear dentro de Kubernetes lo haré desde un fichero .YAML