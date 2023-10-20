#!/bin/bash

function mostrarMenu
{
    #AÑADIR CLEAR AQUI
    echo "==============================="
    echo "          CINQUILLO           "
    echo "                    .------.  "
    echo " .------.           |A  ( )|  "
    echo " |A  |  |    .------;  / / |  "
    echo " |  _|_ |-----.__   | //   |  "
    echo " |   |  | __  |   \ |/    A|  "
    echo " |     A|\  / |__ / |------'  "
    echo " '-----+' ||  |    A|         "
    echo "       |  /\ A|-----'         "
    echo "       '------'               "
    echo "==============================="
    echo "C) CONFIGURACION"
    echo "J) JUGAR"
    echo "E) ESTADISTICAS"
    echo "F) CLASIFICACION"
    echo "S) SALIR"
    echo "==============================="
    echo -n "Introduzca una opcion.......... " # -n no hace salto de linea

}

function crearDefault
{
    echo "JUGADORES=2" > config.cfg
    echo "ESTRATEGIA=0" >> config.cfg
    echo LOG=./log/fichero.log >> config.cfg     
    echo "Archivo de configuración creado correctamente, se recomienda modificar sus valores antes de jugar."
}

function configuracion
{
while true; do
    clear
    echo "==============================="
    echo "          CONFIGURACION        "
    echo "==============================="
    echo "1) NUMERO JUGADORES"
    echo "2) SELECCIONAR ESTRATEGIA"
    echo "3) SELECCIONAR LOG"
    echo "4) VOLVER"
    echo "==============================="
    echo -n "Introduzca una opción.......... " # -n no hace salto de linea
    read opcion

    case $opcion in
        1)
            echo "JUGADORES actuales: $(grep '^JUGADORES=' config.cfg)"
            echo -n "Nuevo número de jugadores (2, 3 o 4): "
            read nuevo_jugadores

        #comprueba que el numero de jugadores es 2,3 o 4
        if [ $nuevo_jugadores -eq 2 ] || [ $nuevo_jugadores -eq 3 ] || [ $nuevo_jugadores -eq 4 ]
        then
            #DOCUMENTAR
            sed -i "s/^JUGADORES=.*/JUGADORES=$nuevo_jugadores/" config.cfg 
            echo "JUGADORES actualizado a $nuevo_jugadores"

        else
            echo "Número de jugadores no válido. Debe ser 2, 3 o 4."
        fi
        ;;
        2)
            echo "ESTRATEGIA actual: $(grep '^ESTRATEGIA=' config.cfg)"
            echo -n "Elegir nueva estrategia (0, 1 o 2): "
            read nuevo_estrategia

        
        if [ $nuevo_estrategia -eq 0 ] || [ $nuevo_estrategia -eq 1 ] || [ $nuevo_estrategia -eq 2 ]
        then
            #DOCUMENTAR
            sed -i "s/^ESTRATEGIA=.*/ESTRATEGIA=$nuevo_estrategia/" config.cfg 
            echo "ESTRATEGIA actualizada a $nuevo_estrategia"

        else
            echo "Número de estrategia no válido. Debe ser 0, 1 o 2."
        fi
            ;;
        3)
            echo -n "Seleccione la ruta donde se guardará o se encuentra el registro..."
            read nuevo_directorio
            if [ ! -d "$nuevo_directorio" ] #comprueba que el directorio existe
            then
                echo "ERROR: El directorio no existe o no es correcto."
                sleep 1.5
            else
            #Usar como separador de directorios el caracter # para evitar conflictos con las barras
            sed -i "s#^LOG=.*#LOG=$nuevo_directorio#" config.cfg 
            echo "LOG actualizado a $nuevo_directorio"
            fi
            ;;
        4)
            break
            ;;
        *)
            echo "Seleccione 1, 2, o 3."
            sleep 1.5
            ;;
    esac
done
         
}


function Comprobaciones
{
while [ ! -f "config.cfg" ] || [ ! -s "config.cfg"  ]     #-f comprueba si es un archivo y -s si esta vacio
do                
        echo "El archivo de configuración 'config.cfg' no se ha encontrado en este directorio o esta vacio."
        echo "Por favor, asegúrese de crear el archivo de configuración antes de ejecutar este juego."
        echo -n "Pulse 1 para crear (Predeterminado) o 2 para salir..."
        
        read opcion

        case $opcion in
            1)  
                clear
                crearDefault
                sleep 2          
                ;;
            2) 
                echo "Saliendo del juego..."
                sleep 1
                exit 0
                ;;

            *) echo "Seleccione 1 o 2."
                ;;
        esac
    
done

# El siguiente if comprueba que el fichero mantiene el formato esperado para su lectura posterior
# Si no se cumple, se informa al usuario y crea uno predeterminado

if   ! grep -qE '^JUGADORES=[2-4]$' config.cfg  ||  ! grep -qE '^ESTRATEGIA=[0-2]$' config.cfg  ||  ! grep -qE '^LOG=.*' config.cfg 
        then
            echo "ERROR: El archivo de configuración 'config.cfg' no es correcto, creando uno DEFAULT"
            crearDefault
fi
}

if [ "$1" = "-g" ]
then
    echo "      =========================="
    echo "              DESCRIPCION         "
    echo "      =========================="
    echo
    echo "               AUTORES"
    echo "      ->Jorge Cuadrado Criado"
    echo "      ->David Lavado González"
    echo
    echo "      =========================="
    echo "              ESTRATEGIAS       "
    echo "      =========================="
    echo
    echo "      Estrategia 0 Aleatorio: Los jugadores colocan automaticamente la primera carta que puedan colocar"
    echo "      Estrategia 1 Mayores: Los jugadores colocan la carta de mayor valor que puedan colocar para reducir el numero de puntos restantes al final de la partida"
    echo "      Estrategia 2 ..."
    echo 
    #-p para que no haga salto de linea
    read -p "Pulse una tecla para continuar..."
    exit 0
fi

Comprobaciones #Comprobamos que el archivo de configuracion existe y tiene el formato correcto

while true
do
    mostrarMenu #mostramos el menu
    read opcion

    case $opcion in
        [Cc]) #caso c o C
            echo "ACCEDIENDO A CONFIGURACION..."
            sleep 0.5
            configuracion
            ;;
        [Jj]) #caso j o J
            echo "PREPARATE PARA JUGAR..."
            sleep 0.5

            ;;
        [Ee]) #caso e o E
            echo "ACCEDIENDO A ESTADISTICAS..."
            sleep 0.5
            ;;
        [Ff]) #caso f o F
            echo "ACCEDIENDO A CLASIFICACION..."
            sleep 0.5
            ;;
        [Ss]) #caso s o S
            exit 0
            ;;
        *) echo "Opcion incorrecta"
            sleep 0.5
            ;;
    esac
done


