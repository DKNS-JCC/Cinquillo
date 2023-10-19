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
#!/bin/bash

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
            clear
            echo "==============================="
            echo "          JUGADORES            "
            echo "==============================="
            echo "2) 2 JUGADORES"
            echo "3) 3 JUGADORES"
            echo "4) 4 JUGADORES"
            echo "==============================="
            echo -n "Introduzca una opción.......... " # -n no hace salto de linea
            read opcion_jugadores

            case $opcion_jugadores in
                2)
                    clear
                    echo "JUGADORES=2" > config.cfg
                    ;;
                3)
                    clear
                    echo "JUGADORES=3" > config.cfg
                    ;;
                4)
                    clear
                    echo "JUGADORES=4" > config.cfg
                    ;;
                *)
                    echo "Seleccione 2, 3 o 4."
                    sleep 1.5
                    ;;
            esac
            ;;
        2)
            clear
            echo "==============================="
            echo "          ESTRATEGIA           "
            echo "==============================="
            echo "0) ESTRATEGIA 0"
            echo "1) ESTRATEGIA 1"
            echo "2) ESTRATEGIA 2"
            echo "==============================="
            echo -n "Introduzca una opción.......... " # -n no hace salto de linea
            read opcion_estrategia

            case $opcion_estrategia in
                0)
                    echo "ESTRATEGIA=0" >> config.cfg
                    ;;
                1)
                    echo "ESTRATEGIA=1" >> config.cfg
                    ;;
                2)
                    echo "ESTRATEGIA=2" >> config.cfg
                    ;;
                *)
                    echo "Seleccione 0, 1 o 2."
                    sleep 1.5
                    ;;
            esac
            ;;
        3)
            echo "Seleccione el directorio donde se guardará o se encuentra el registro"
            read directorio
            echo "LOG=$directorio" >> config.cfg
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
# Si no se cumple, se informa al usuario

if   ! grep -qE '^JUGADORES=[2-4]$' config.cfg  ||  ! grep -qE '^ESTRATEGIA=[0-2]$' config.cfg  ||  ! grep -qE '^LOG=.*' config.cfg 
        then
            echo "ERROR: El archivo de configuración 'config.cfg' no es correcto, creando uno DEFAULT"
            crearDefault
fi
}


Comprobaciones
while true
do
    mostrarMenu
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

