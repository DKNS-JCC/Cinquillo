#!/bin/bash

function mostrarMenu
{
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

function configuracion
{
    while true; do
        #-d es el delimitador y -f es el campo
        JUGADORES=$(grep '^JUGADORES=' config.cfg | cut -d '=' -f 2)
        ESTRATEGIA=$(grep '^ESTRATEGIA=' config.cfg | cut -d '=' -f 2)
        LOG=$(grep '^LOG=' config.cfg | cut -d '=' -f 2) 

        echo "==============================="
        echo "          CONFIGURACION        "
        echo "==============================="
        echo "1) NUMERO JUGADORES (ACTUAL: $JUGADORES)"
        echo
        echo "2) SELECCIONAR ESTRATEGIA (ACTUAL: $ESTRATEGIA)"
        echo
        echo "3) SELECCIONAR LOG (ACTUAL: $LOG)"
        echo
        echo "4) VOLVER AL MENU PRINCIPAL"
        echo "==============================="
        echo -n "Introduzca una opción...        "
        read opcion

        case $opcion in
            1)
                clear
                echo "JUGADORES actuales: $JUGADORES"
                echo -n "Nuevo número de jugadores (2, 3 o 4): "
                read nuevo_jugadores

                if [ $nuevo_jugadores == 2 ] || [ $nuevo_jugadores == 3 ] || [ $nuevo_jugadores == 4 ]
                then
                    echo JUGADORES=$nuevo_jugadores > config.cfg
                    echo ESTRATEGIA=$ESTRATEGIA >> config.cfg
                    echo LOG=$LOG >> config.cfg
                    clear
                    echo "JUGADORES actualizado a $nuevo_jugadores"
                else
                    echo "Número de jugadores no válido. Debe ser 2, 3 o 4."
                fi
                ;;
            2)
                clear
                echo "ESTRATEGIA actual: $ESTRATEGIA"
                echo -n "Elegir nueva estrategia (0, 1 o 2): "
                read nuevo_estrategia

                if [ $nuevo_estrategia == 0 ] || [ $nuevo_estrategia == 1 ] || [ $nuevo_estrategia == 2 ]
                then
                    echo JUGADORES=$JUGADORES > config.cfg
                    echo ESTRATEGIA=$nuevo_estrategia >> config.cfg
                    echo LOG=$LOG >> config.cfg
                    clear
                    echo "ESTRATEGIA actualizada a $nuevo_estrategia"
                else
                    echo "Número de estrategia no válido. Debe ser 0, 1 o 2."
                fi
                ;;
            3)
                clear
                echo -n "Seleccione la ruta donde se guardará o se encuentra el registro..."
                read nuevo_directorio

                if [ ! -d "$nuevo_directorio" ]
                then
                    echo "ERROR: El directorio no existe o no es correcto."
                else
                    echo $JUGADORES > config.cfg
                    echo $ESTRATEGIA >> config.cfg
                    echo $nuevo_directorio >> config.cfg
                    clear
                    echo "LOG actualizado a $nuevo_directorio"
                fi
                ;;
            4)
                clear
                break
                ;;
            *)
                clear
                echo "Seleccione 1, 2, 3, 4 o 5"
                ;;
        esac
    done
}

function Comprobaciones
{
    if [ ! -f "config.cfg" ] || [ ! -s "config.cfg" ]
    then
        echo "El archivo de configuración 'config.cfg' no se ha encontrado en este directorio o esta vacío."
        echo "Por favor, asegúrese de crear el archivo de configuración antes de ejecutar este juego."
        read opcion
        exit 0
    fi

    if ! grep '^JUGADORES=[2-4]$' config.cfg || ! grep '^ESTRATEGIA=[0-2]$' config.cfg || ! grep '^LOG=*' config.cfg
    then
        clear
        echo "ERROR: El archivo de configuración 'config.cfg' no es correcto"
        exit 0
    fi
}

if [ "$1" = "-g" ]
then
    echo "      =========================="
    echo "              DESCRIPCION       "
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
    echo "      Estrategia 0 Aleatorio: Los jugadores colocan automáticamente la primera carta que puedan colocar"
    echo "      Estrategia 1 Mayores: Los jugadores colocan la carta de mayor valor que puedan colocar para reducir el número de puntos restantes al final de la partida"
    echo "      Estrategia 2 ..."
    echo

    read -p "Pulse una tecla para continuar..."
    exit 0
fi

Comprobaciones

while true
do
    mostrarMenu
    read opcion

    case $opcion in
        [Cc])
            clear
            configuracion
            ;;
        [Jj])
            echo "PREPARATE PARA JUGAR..."
            ;;
        [Ee])
            echo "ACCEDIENDO A ESTADISTICAS..."
            ;;
        [Ff])
            echo "ACCEDIENDO A CLASIFICACION..."
            ;;
        [Ss])
            exit 0
            ;;
        *)
            echo "Opcion incorrecta"
            ;;
    esac
done
