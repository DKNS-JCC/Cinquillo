#!/bin/bash

function mostrarMenu
{                                                                
    echo "==========================================================================================="
    echo "                                                                                 .------.  "
    echo "    __  ____  ____    ___   __ __  ____  _      _       ___   .------.           |A  ( )|  "
    echo "   /  ]|    ||    \  /   \ |  |  ||    || |    | |     /   \  |A  |  |    .------;  / / |  "
    echo "  /  /  |  | |  _  ||     ||  |  | |  | | |    | |    |     | |  _|_ |-----.__   | //   |  "
    echo " /  /   |  | |  |  ||  Q  ||  |  | |  | | |___ | |___ |  O  | |   |  | __  |   \ |/    A|  "
    echo "/   \_  |  | |  |  ||     ||  :  | |  | |     ||     ||     | |     A|\  / |__ / |------'  "
    echo "\     | |  | |  |  ||     ||     | |  | |     ||     ||     | '-----+' ||  |    A|         "
    echo " \____||____||__|__| \__,_| \__,_||____||_____||_____| \___/        |  /\ A|-----'         "
    echo "                                                                    '------'               "
    echo "=============================== MENU PRINCIPAL ==========================================="
    echo "C) CONFIGURACION"
    echo "J) JUGAR"
    echo "E) ESTADISTICAS"
    echo "F) CLASIFICACION"
    echo "S) SALIR"
    echo "==========================================================================================="
    echo -n "Introduzca una opcion.......... " # -n no hace salto de linea
}

function configuracion
{
    while true; do 

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
                read N_JUGADORES

                if [ $N_JUGADORES == 2 ] || [ $N_JUGADORES == 3 ] || [ $N_JUGADORES == 4 ]
                then
                    JUGADORES=$N_JUGADORES
                    echo JUGADORES=$JUGADORES > config.cfg
                    echo ESTRATEGIA=$ESTRATEGIA >> config.cfg
                    echo LOG=$LOG >> config.cfg
                    clear
                    echo "JUGADORES actualizado a $JUGADORES"
                else
                    echo "Número de jugadores no válido. Debe ser 2, 3 o 4."
                fi
                ;;
            2)
                clear
                echo "ESTRATEGIA actual: $ESTRATEGIA"
                echo -n "Elegir nueva estrategia (0, 1 o 2): "
                read N_ESTRATEGIA

                if [ $N_ESTRATEGIA == 0 ] || [ $N_ESTRATEGIA == 1 ] || [ $N_ESTRATEGIA == 2 ]
                then
                    ESTRATEGIA=$N_ESTRATEGIA
                    echo JUGADORES=$JUGADORES > config.cfg
                    echo ESTRATEGIA=$ESTRATEGIA >> config.cfg
                    echo LOG=$LOG >> config.cfg
                    clear
                    echo "ESTRATEGIA actualizada a $ESTRATEGIA"
                else
                    echo "Número de estrategia no válido. Debe ser 0, 1 o 2."
                fi
                ;;
            3)
                clear
                
                echo "Introduce el nombre del archivo:"
                read ARCHIVO                
                if [[ -f $ARCHIVO ]]; then
                    Comprobaciones_log
                    LOG="$(pwd)/$ARCHIVO"
                    echo JUGADORES=$JUGADORES > config.cfg
                    echo ESTRATEGIA=$ESTRATEGIA >> config.cfg
                    echo LOG=$LOG >> config.cfg
                else
                    echo "El archivo \"$nombre_archivo\" no existe o no es un archivo regular."
                    echo "LOG actualizado a $LOG"
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
    Comprobaciones_cfg
}

function Comprobaciones_cfg
{
    # Comprobar si existe el archivo de configuración
    if [ ! -f "config.cfg" ] || [ ! -s "config.cfg" ]
    then
        echo "El archivo de configuración 'config.cfg' no se ha encontrado en este directorio o esta vacío."
        echo "Por favor, asegúrese de crear el archivo de configuración antes de ejecutar este juego."
        read 
        exit -1
    fi
    # Comprobar si el archivo de configuración tiene permisos de lectura y escritura
    if [ ! -r "config.cfg" ] && [ ! -w "config.cfg" ]; 
    then
        echo "No tienes permisos de lectura y/o escritura en el archivo config.cfg."
        read
        exit -1
    fi
    # Comprobar si el archivo de configuración tiene el formato correcto
    if  ! grep '^JUGADORES=[2-4]$' config.cfg  ||  ! grep '^ESTRATEGIA=[0-2]$' config.cfg  ||  ! grep '^LOG=' config.cfg 
    then
        clear
        echo "ERROR: El archivo de configuración 'config.cfg' no es correcto"
        read
        exit -1
    fi
}

function Comprobaciones_log {
    # Comprobar si existe el archivo de log
    if [ ! -f "$LOG" ]
    then
        echo "El archivo de log '$LOG' no se ha encontrado en este directorio."
        echo "Por favor, asegúrese de configurar el archivo de log antes de jugar."
        read
    else    
        if [ ! -r "$LOG" ] && [ ! -w "$LOG" ]
        then
            echo "No tienes permisos de lectura y/o escritura en el archivo $LOG."
            read
            exit -1
        fi
    fi
}

function crear_baraja {

    PALOS=("bastos" "copas" "espadas" "oros")    
    CARTAS=("1" "2" "3" "4" "5" "6" "7" "10" "11" "12")    
    BARAJA=()

# Llenar la BARAJA con todas las cartas, @ (tamaño) es para que se lean todos los elementos del array
    for PALO in "${PALOS[@]}"; 
    do
        for CARTA in "${CARTAS[@]}"; 
        do
            BARAJA+=("$CARTA de $PALO")
        done
    done
}


function barajar {
    for ((i = 0; i < 40 - 1; i++)); 
    do
        j=$((i + RANDOM % (40 - i)))
    # Intercambiar las CARTASs en los índices i y j
        temp="${BARAJA[i]}"
        BARAJA[i]="${BARAJA[j]}"
        BARAJA[j]="$temp"
  done
}
function repartir_por_jugadores {

JUGADOR1=()
JUGADOR2=()
JUGADOR3=()
JUGADOR4=()

# Calcula cuántas cartas se repartirán a cada jugador
TOTAL_CARTAS=${#BARAJA[@]}

case $JUGADORES in
    2)

        CARTAS_POR_JUGADOR=$((TOTAL_CARTAS / 2))
        for ((i=0; i<CARTAS_POR_JUGADOR; i++)); 
        do
        # Añade la carta al jugador 1
        JUGADOR1+=("${BARAJA[i]}")
        # Añade la carta al jugador 2
        JUGADOR2+=("${BARAJA[i + CARTAS_POR_JUGADOR]}")
        done
        NUMERO_CARTAS_JUGADOR1=${#JUGADOR1[@]}
        NUMERO_CARTAS_JUGADOR2=${#JUGADOR2[@]}
    ;;

    3)
        CARTAS_POR_JUGADOR=$((TOTAL_CARTAS / 3))
        for ((i=0; i<CARTAS_POR_JUGADOR; i++)); do
            # Añade la carta al jugador 1
            JUGADOR1+=("${BARAJA[i]}")
            # Añade la carta al jugador 2
            JUGADOR2+=("${BARAJA[i + CARTAS_POR_JUGADOR]}")
            # Añade la carta al jugador 3
            JUGADOR3+=("${BARAJA[i + CARTAS_POR_JUGADOR * 2]}")
        done
            JUGADOR1+=("${BARAJA[39]}") # Carta del jugador 1 sobrante
            NUMERO_CARTAS_JUGADOR1=${#JUGADOR1[@]}
            NUMERO_CARTAS_JUGADOR2=${#JUGADOR2[@]}
            NUMERO_CARTAS_JUGADOR3=${#JUGADOR3[@]}
        ;;

    4)
        CARTAS_POR_JUGADOR=$((TOTAL_CARTAS / 4))
        for ((i=0; i<CARTAS_POR_JUGADOR; i++)); 
        do
            # Añade la carta al jugador 1
            JUGADOR1+=("${BARAJA[i]}")
            # Añade la carta al jugador 2
            JUGADOR2+=("${BARAJA[i + CARTAS_POR_JUGADOR]}")
            # Añade la carta al jugador 3
            JUGADOR3+=("${BARAJA[i + CARTAS_POR_JUGADOR * 2]}")
            # Añade la carta al jugador 4
            JUGADOR4+=("${BARAJA[i + CARTAS_POR_JUGADOR * 3]}")
        done
        NUMERO_CARTAS_JUGADOR1=${#JUGADOR1[@]}
        NUMERO_CARTAS_JUGADOR2=${#JUGADOR2[@]}
        NUMERO_CARTAS_JUGADOR3=${#JUGADOR3[@]}
        NUMERO_CARTAS_JUGADOR4=${#JUGADOR4[@]}
        ;;

    *)
        echo "ERROR: EL NÚMERO DE JUGADORES NO ES CORRECTO"
        exit -1
        ;;
esac

# Declarar arrays de cartas de cada palo llenos
BASTOS=("1 de bastos" "2 de bastos" "3 de bastos" "4 de bastos" "5 de bastos" "6 de bastos" "7 de bastos" "10 de bastos" "11 de bastos" "12 de bastos")
COPAS=("1 de copas" "2 de copas" "3 de copas" "4 de copas" "5 de copas" "6 de copas" "7 de copas" "10 de copas" "11 de copas" "12 de copas")
ESPADAS=("1 de espadas" "2 de espadas" "3 de espadas" "4 de espadas" "5 de espadas" "6 de espadas" "7 de espadas" "10 de espadas" "11 de espadas" "12 de espadas")
OROS=("1 de oros" "2 de oros" "3 de oros" "4 de oros" "5 de oros" "6 de oros" "7 de oros" "10 de oros" "11 de oros" "12 de oros")

}

function mostrar_tablero {
    if [ "$TURNO" == "1" ]; then
        clear
    fi
    case $JUGADORES in
        2)
            echo "-----------------------------------------------------------------------------------------"
            printf "%-30s %-30s\n" "Tus Cartas:" "Jugador 2:"
            echo
            for ((i=0;i<20;i++)); 
            do
                indice=$((i+1))
                printf "%-30s %-30s\n" "${indice}) ${JUGADOR1[i]}" "${indice}) ${JUGADOR2[i]}"
            done
            ;;
        3)
            echo "-----------------------------------------------------------------------------------------"
            printf "%-30s %-30s %-30s\n" "Tus Cartas:" "Jugador 2:" "Jugador 3:"
            echo
            for ((i=0;i<13;i++)); 
            do
                indice=$((i+1))
printf "%-30s %-30s %-30s\n" "${indice}) ${JUGADOR1[i]}" "${indice}) ${JUGADOR2[i]}" "${indice}) ${JUGADOR3[i]}"
            done
                printf "%-30s " "14)  ${JUGADOR1[13]}"
                echo
            ;;
        4)
            echo "-----------------------------------------------------------------------------------------"
            printf "%-30s %-30s %-30s %-30s\n" "Tus Cartas:" "Jugador 2:" "Jugador 3:" "Jugador 4:"
            echo
            for ((i=0;i<10;i++)); 
            do
                indice=$((i+1))
printf "%-30s %-30s %-30s %-30s\n" "${indice}) ${JUGADOR1[i]}" "${indice}) ${JUGADOR2[i]}" "${indice}) ${JUGADOR3[i]}" "${indice})  ${JUGADOR4[i]}"
            done
            ;;
        *)
            echo "ERROR: EL NÚMERO DE JUGADORES NO ES CORRECTO"
            exit -1
            ;;
    esac

    echo "-----------------------------------------------------------------------------------------"
    echo "|                      _____ _____ _____ __    _____ _____ _____                        |"
    echo "|                     |_   _|  _  | __  |  |  |   __| __  |     |                       |"
    echo "|                       | | |     | __ -|  |__|   __|    -|  |  |                       |"
    echo "|                       |_| |__|__|_____|_____|_____|__|__|_____|                       |"
    echo "|                                                                                       |"
    echo "|                     (+) Indica si la carta esta colocada o no                         |"
    echo "-----------------------------------------------------------------------------------------"

    for ((i = 0; i < 10; i++)); do
        PALO_BASTO="${BASTOS[i]}"
        PALO_COPA="${COPAS[i]}"
        PALO_ESPADA="${ESPADAS[i]}"
        PALO_ORO="${OROS[i]}"

        printf "%-20s %-20s %-20s %-20s\n" "$PALO_BASTO" "$PALO_ORO" "$PALO_ESPADA" "$PALO_COPA"
    done
}

function buscar_5oros {
    TURNO=0
    clear
    # Buscar la carta 5 de oros en la mano del jugador 1
    for ((i = 0; i < ${#JUGADOR1[@]}; i++)); 
    do
        if [ "${JUGADOR1[i]}" == "5 de oros" ]; 
        then
            echo "EL JUGADOR 1 TIENE LA CARTA 5 DE OROS"
            # Colocar la carta 5 de oros en el tablero
                OROS[4]="(+) 5 de oros"
                TURNO=2
            # Eliminar la carta 5 de oros de la mano del jugador
                JUGADOR1[i]=""
                break
            
        fi
    done

    # Buscar la carta 5 de oros en la mano del jugador 2
    for ((i = 0; i < ${#JUGADOR2[@]}; i++));
    do
        if [ "${JUGADOR2[i]}" == "5 de oros" ];
        then
            echo
            clear
            echo "EL JUGADOR 2 TIENE LA CARTA 5 DE OROS"
            # Colocar la carta 5 de oros en el tablero
                OROS[4]="(+) 5 de oros"
                TURNO=3
            # Eliminar la carta 5 de oros de la mano del jugador
                JUGADOR2[i]=""
                break
        fi
    done

    # Buscar la carta 5 de oros en la mano del jugador 3
    for ((i = 0; i < ${#JUGADOR3[@]}; i++));
    do
        if [ "${JUGADOR3[i]}" == "5 de oros" ];
        then
            echo
            clear
            echo "EL JUGADOR 3 TIENE LA CARTA 5 DE OROS"
            # Colocar la carta 5 de oros en el tablero
                OROS[4]="(+) 5 de oros"
                TURNO=4
            # Eliminar la carta 5 de oros de la mano del jugador
                JUGADOR3[i]=""
                break
        fi
    done

    # Buscar la carta 5 de oros en la mano del jugador 4
    for ((i = 0; i < ${#JUGADOR4[@]}; i++));
    do
        if [ "${JUGADOR4[i]}" == "5 de oros" ];
        then
            echo
            clear
            echo "EL JUGADOR 4 TIENE LA CARTA 5 DE OROS"
            # Colocar la carta 5 de oros en el tablero
                OROS[4]="(+) 5 de oros"
                TURNO=1
            # Eliminar la carta 5 de oros de la mano del jugador
                JUGADOR4[i]=""
                break
        fi
    done
    clear
    mostrar_tablero
}



function juego {
    HORA_INICIO=$(date +%s)
    clear
    crear_baraja
    barajar
    clear
    repartir_por_jugadores
    mostrar_tablero
    buscar_5oros
    comprobar_vacios

while [ "$VACIO" == "0" ];
do
    comprobar_vacios

    if [ ! "$VACIO" == "0" ]; then
        break
    else
        CONTADOR_TURNOS=$((CONTADOR_TURNOS + 1))
        # Si el turno es mayor que el número de jugadores, se reinicia el turno
        if [ $TURNO -gt $JUGADORES ]; then
            TURNO=1
        fi
        case $TURNO in
            1)  
                echo
                echo "------------> TURNO DEL JUGADOR $TURNO <------------"
                echo
                turno_usuario
                TURNO=2
                comprobar_vacios
                ;;
            2)
                echo
                echo "------------> TURNO DEL JUGADOR $TURNO <------------"
                echo
                NUMERO_CARTAS_TOTAL=$NUMERO_CARTAS_JUGADOR2
                CARTAS_JUGADOR=("${JUGADOR2[@]}")
                TURNO_JUGADOR=$TURNO
                turno_maquina
                comprobar_vacios
                ;;
            3)
                echo
                echo "------------> TURNO DEL JUGADOR $TURNO <------------"
                echo
                NUMERO_CARTAS_TOTAL=$NUMERO_CARTAS_JUGADOR3
                CARTAS_JUGADOR=("${JUGADOR3[@]}")
                TURNO_JUGADOR=$TURNO
                turno_maquina
                comprobar_vacios
                ;;
            4)
                echo
                echo "------------> TURNO DEL JUGADOR $TURNO <------------"
                echo
                NUMERO_CARTAS_TOTAL=$NUMERO_CARTAS_JUGADOR4
                CARTAS_JUGADOR=("${JUGADOR4[@]}")
                TURNO_JUGADOR=$TURNO
                turno_maquina
                comprobar_vacios
                ;;
            *)
                echo "ERROR: TURNO NO VÁLIDO"
        esac
    fi
done


########################################################### FINAL DE PARTIDA #####################################################################

HORA_FIN=$(date +%s)

if [ "$VACIO" == "1" ]; then
    echo
    echo "====== HAS GANADO LA PARTIDA JUGADOR 1 ======"
fi
if [ "$VACIO" == "2" ]; then
    echo
    echo "====== HAS GANADO LA PARTIDA JUGADOR 2 ======"
fi
if [ "$VACIO" == "3" ]; then
    echo
    echo "====== HAS GANADO LA PARTIDA JUGADOR 3 ======"
fi
if [ "$VACIO" == "4" ]; then
    echo
    echo "====== HAS GANADO LA PARTIDA JUGADOR 4 ======"
fi



conteo_puntos
escribir_fichero
echo
echo "                  {}"
echo "                 /__\\"
echo "               /|    |\\"
echo "              (_| J$VACIO |_)"
echo "                 \  /"
echo "                  )("
echo "                _|__|_"
echo "              _|______|_"
echo "             |__________|"
echo

echo "JUGADOR $VACIO HAS CONSEGUIDO $PUNTOS_GANADOR puntos en $CONTADOR_TURNOS turnos y $TIEMPO_PARTIDA segundos!!!"
read
return

}

function turno_maquina {
case $ESTRATEGIA in
    0)
        seleccion_secuencial
    ;;
    1)
    for ((k=0;k<$JUGADORES;k++)); do
        for ((i = 0; i < ${#CARTAS_JUGADOR[@]}; i++)); do
            for ((j = i + 1; j < ${#CARTAS_JUGADOR[@]}; j++)); do
                NUMERO=$(echo "${CARTAS_JUGADOR[i]}" | cut -d " " -f 1)
                NUMERO_SIG=$(echo "${CARTAS_JUGADOR[j]}" | cut -d " " -f 1)

                if [ -n "$NUMERO" ] && [ -n "$NUMERO_SIG" ] && [ "$NUMERO" -lt "$NUMERO_SIG" ]; then ########ERROR AQUI
                  TEMP="${CARTAS_JUGADOR[i]}"
                  CARTAS_JUGADOR[i]="${CARTAS_JUGADOR[j]}"
                  CARTAS_JUGADOR[j]="$TEMP"
                fi
            done
        done
        case $TURNO in
            2)
                JUGADOR2=("${CARTAS_JUGADOR[@]}")
                ;;
            3)
                JUGADOR3=("${CARTAS_JUGADOR[@]}")
                ;;
            4)
                JUGADOR4=("${CARTAS_JUGADOR[@]}")
                ;;
        esac
    done

        seleccion_secuencial
        
    ;;
    2)
    for ((k=0;k<$JUGADORES;k++)); do
        for ((i = 0; i < ${#CARTAS_JUGADOR[@]}; i++)); do
            for ((j = i + 1; j < ${#CARTAS_JUGADOR[@]}; j++)); do
                NUMERO=$(echo "${CARTAS_JUGADOR[i]}" | cut -d " " -f 1)
                NUMERO_SIG=$(echo "${CARTAS_JUGADOR[j]}" | cut -d " " -f 1)

                if [ -n "$NUMERO" ] && [ -n "$NUMERO_SIG" ] && [ "$NUMERO" -gt "$NUMERO_SIG" ]; then ########ERROR AQUI
                  TEMP="${CARTAS_JUGADOR[i]}"
                  CARTAS_JUGADOR[i]="${CARTAS_JUGADOR[j]}"
                  CARTAS_JUGADOR[j]="$TEMP"
                fi
            done
        done
        case $TURNO in
            2)
                JUGADOR2=("${CARTAS_JUGADOR[@]}")
                ;;
            3)
                JUGADOR3=("${CARTAS_JUGADOR[@]}")
                ;;
            4)
                JUGADOR4=("${CARTAS_JUGADOR[@]}")
                ;;
        esac
    done

        seleccion_secuencial
        
    ;;
    *)
        echo "ERROR: ESTRATEGIA NO VÁLIDA"
    ;;
esac
}

function seleccion_secuencial 
{
    for ((i = 0; i < $NUMERO_CARTAS_TOTAL && $TURNO_JUGADOR==$TURNO; i++)); do
        if [ ! -z "${CARTAS_JUGADOR[i]}" ]; then
            CARTA="${CARTAS_JUGADOR[i]}"
            PALO=$(echo "$CARTA" | cut -d " " -f 3)
            NUMERO=$(echo "$CARTA" | cut -d " " -f 1)
            if [ "$NUMERO" == 5 ]; then
                PUSO_CARTA=false

                case $PALO in
                    "bastos")
                        BASTOS[4]="(+) 5 de bastos"
                        echo "JUGADOR $TURNO PONE CARTA: 5 de bastos"
                        CARTAS_JUGADOR[i]=""
                        case $TURNO in
                            2)
                                JUGADOR2[i]=""
                                ;;
                            3)
                                JUGADOR3[i]="" 
                                ;;
                            4)
                                JUGADOR4[i]="" 
                                ;;
                        esac
                        TURNO=$((TURNO + 1))
                        PUSO_CARTA=true
                        #clear
                        mostrar_tablero
                        break
                        ;;
                    "copas")
                        COPAS[4]="(+) 5 de copas"
                        echo "JUGADOR $TURNO PONE CARTA: 5 de copas"
                        case $TURNO in
                            2)
                                JUGADOR2[i]="" 
                                ;;
                            3)
                                JUGADOR3[i]=""
                                ;;
                            4)
                                JUGADOR4[i]="" 
                                ;;
                        esac
                        TURNO=$((TURNO + 1))
                        PUSO_CARTA=true
                        #clear
                        mostrar_tablero
                        break
                        ;;
                    "espadas")
                        ESPADAS[4]="(+) 5 de espadas"
                        echo "JUGADOR $TURNO PONE CARTA: 5 de espadas"
                        case $TURNO in
                            2)
                                JUGADOR2[i]=""   
                                ;;
                            3)
                                JUGADOR3[i]=""     
                                ;;
                            4)
                                JUGADOR4[i]="" 
                                ;;
                        esac
                        TURNO=$((TURNO + 1))
                        PUSO_CARTA=true
                        #clear
                        mostrar_tablero
                        break
                        ;;
                esac
            else
                PUSO_CARTA=false
                case $PALO in
                    "bastos")
                        for ((j = 0; j < 10; j++)); do
                            if [[ "$CARTA" == "${BASTOS[j]}" ]]; then
                            if [[ "$NUMERO" == "10" ]]; then
                                if [[ "${BASTOS[j-1]}" == "(+) 7 de bastos" ]]; then
                                    BASTOS[j]="(+) ${NUMERO} de bastos"
                                    echo "JUGADOR $TURNO PONE CARTA: ${NUMERO} de bastos"
                                    CARTAS_JUGADOR[i]=""
                                    case $TURNO in
                                        2)
                                            JUGADOR2[i]="" 
                                            ;;
                                        3)
                                            JUGADOR3[i]=""   
                                            ;;
                                        4)
                                            JUGADOR4[i]=""   
                                            ;;
                                    esac
                                    TURNO=$((TURNO + 1))
                                    PUSO_CARTA=true
                                    #clear
                                    mostrar_tablero
                                    break
                                fi
elif [[ "${BASTOS[j+1]}" == "(+) $((NUMERO + 1)) de bastos" ]] || [[ "${BASTOS[j-1]}" == "(+) $((NUMERO - 1)) de bastos" ]] ; then
                                    BASTOS[j]="(+) ${NUMERO} de bastos"
                                    echo "JUGADOR $TURNO PONE CARTA: ${NUMERO} de bastos"
                                    CARTAS_JUGADOR[i]=""
                                    case $TURNO in
                                        2)
                                            JUGADOR2[i]="" 
                                            ;;
                                        3)
                                            JUGADOR3[i]=""   
                                            ;;
                                        4)
                                            JUGADOR4[i]=""   
                                            ;;
                                    esac
                                    TURNO=$((TURNO + 1))
                                    PUSO_CARTA=true
                                    #clear
                                    mostrar_tablero
                                    break
                                fi
                            fi
                
                    done
                        ;;
                    "copas")
                        for ((j = 0; j < 10; j++)); do
                            if [[ "$CARTA" == "${COPAS[j]}" ]]; then
                            if [[ "$NUMERO" == "10" ]]; then
                                if [[ "${COPAS[j-1]}" == "(+) 7 de copas" ]]; then
                                    COPAS[j]="(+) ${NUMERO} de copas"
                                    echo "JUGADOR $TURNO PONE CARTA: ${NUMERO} de copas"
                                    CARTAS_JUGADOR[i]=""
                                    case $TURNO in
                                        2)
                                            JUGADOR2[i]="" 
                                            ;;
                                        3)
                                            JUGADOR3[i]=""   
                                            ;;
                                        4)
                                            JUGADOR4[i]=""   
                                            ;;
                                    esac
                                    TURNO=$((TURNO + 1))
                                    PUSO_CARTA=true
                                    #clear
                                    mostrar_tablero
                                    break
                                fi
elif [[ "${COPAS[j+1]}" == "(+) $((NUMERO + 1)) de copas" ]] || [[ "${COPAS[j-1]}" == "(+) $((NUMERO - 1)) de copas" ]] ; then
                                    COPAS[j]="(+) ${NUMERO} de copas"
                                    echo "JUGADOR $TURNO PONE CARTA: ${NUMERO} de copas"
                                    CARTAS_JUGADOR[i]=""
                                    case $TURNO in
                                    2)
                                        JUGADOR2[i]="" 
                                        ;;
                                    3)
                                        JUGADOR3[i]="" 
                                        ;;
                                    4)
                                        JUGADOR4[i]=""
                                        ;;
                                    esac
                                    TURNO=$((TURNO + 1))
                                    PUSO_CARTA=true
                                    #clear
                                    mostrar_tablero
                                    break
                                fi
                           
                        fi
                    done
                        ;;
                    "espadas")
                        for ((j = 0; j < 10; j++)); do
                            if [[ "$CARTA" == "${ESPADAS[j]}" ]]; then
                            if [[ "$NUMERO" == "10" ]]; then
                                if [[ "${ESPADAS[j-1]}" == "(+) 7 de espadas" ]]; then
                                    ESPADAS[j]="(+) ${NUMERO} de espadas"
                                    echo "JUGADOR $TURNO PONE CARTA: ${NUMERO} de espadas"
                                    CARTAS_JUGADOR[i]=""
                                    case $TURNO in
                                        2)
                                            JUGADOR2[i]="" 
                                            ;;
                                        3)
                                            JUGADOR3[i]=""   
                                            ;;
                                        4)
                                            JUGADOR4[i]=""   
                                            ;;
                                    esac
                                    TURNO=$((TURNO + 1))
                                    PUSO_CARTA=true
                                    #clear
                                    mostrar_tablero
                                    break
                                fi
elif [[ "${ESPADAS[j+1]}" == "(+) $((NUMERO + 1)) de espadas" ]] || [[ "${ESPADAS[j-1]}" == "(+) $((NUMERO - 1)) de espadas" ]] ; then
                                    ESPADAS[j]="(+) ${NUMERO} de espadas"
                                    echo "JUGADOR $TURNO PONE CARTA: ${NUMERO} de espadas"
                                    CARTAS_JUGADOR[i]=""
                                case $TURNO in
                                    2)
                                        JUGADOR2[i]="" 
                                        ;;
                                    3)
                                        JUGADOR3[i]="" 
                                        ;;
                                    4)
                                        JUGADOR4[i]="" 
                                        ;;
                                esac
                                    TURNO=$((TURNO + 1))
                                    PUSO_CARTA=true
                                    #clear
                                    mostrar_tablero
                                    break
                                fi
                            fi
                    done
                        ;;
                    "oros")
                        for ((j = 0; j < 10; j++)); do
                            if [[ "$CARTA" == "${OROS[j]}" ]]; then
                            if [[ "$NUMERO" == "10" ]]; then
                                if [[ "${OROS[j-1]}" == "(+) 7 de oros" ]]; then
                                    OROS[j]="(+) ${NUMERO} de oros"
                                    echo "JUGADOR $TURNO PONE CARTA: ${NUMERO} de oros"
                                    CARTAS_JUGADOR[i]=""
                                    case $TURNO in
                                        2)
                                            JUGADOR2[i]="" 
                                            ;;
                                        3)
                                            JUGADOR3[i]=""   
                                            ;;
                                        4)
                                            JUGADOR4[i]=""   
                                            ;;
                                    esac
                                    TURNO=$((TURNO + 1))
                                    PUSO_CARTA=true
                                    #clear
                                    mostrar_tablero
                                    break
                                fi
elif [[ "${OROS[j+1]}" == "(+) $((NUMERO + 1)) de oros" ]] || [[ "${OROS[j-1]}" == "(+) $((NUMERO - 1)) de oros" ]] ; then
                                OROS[j]="(+) ${NUMERO} de oros"
                                    echo "JUGADOR $TURNO PONE CARTA: ${NUMERO} de oros"
                                    CARTAS_JUGADOR[i]=""
                                    case $TURNO in
                                    2)
                                        JUGADOR2[i]="" 
                                        ;;
                                    3)
                                        JUGADOR3[i]="" 
                                        ;;
                                    4)
                                        JUGADOR4[i]="" 
                                        ;;
                                    esac
                                    TURNO=$((TURNO + 1))
                                    PUSO_CARTA=true
                                    #clear
                                    mostrar_tablero
                                    break
                                fi
                            fi
                    done
                    ;;
                esac
            fi
        fi
done
if [ "$PUSO_CARTA" == false ]; then
    echo "JUGADOR $TURNO PASA TURNO :("
    TURNO=$((TURNO + 1))
fi
}

function turno_usuario {

    puede=false
    for ((i = 0; i < $NUMERO_CARTAS_JUGADOR1; i++)); do
        CARTA="${JUGADOR1[i]}"
            if [ -n "$CARTA" ]; then
                PALO=$(echo "$CARTA" | cut -d " " -f 3)
                NUMERO=$(echo "$CARTA" | cut -d " " -f 1)

                if [ "$NUMERO" -eq 5 ]; then
                    puede=true
                    break
                else
                    case $PALO in
                        "bastos")
                            for ((j = 0; j < 10; j++)); do
                                if [[ "$CARTA" == "${BASTOS[j]}" ]]; then
                                    if [[ "$NUMERO" == "10" ]]; then
                                        if  [[ "${BASTOS[j-1]}" == "(+) 7 de bastos" ]]; then
                                            puede=true
                                            break
                                        fi
elif [[ "${BASTOS[j+1]}" == "(+) $((NUMERO + 1)) de bastos" ]] || [[ "${BASTOS[j-1]}" == "(+) $((NUMERO - 1)) de bastos" ]] ; then
                                        puede=true
                                        break
                                    fi
                                fi
                            done
                            ;;
                        "copas")
                            for ((j = 0; j < 10; j++)); do
                                if [[ "$CARTA" == "${COPAS[j]}" ]]; then
                                    if [[ "$NUMERO" == "10" ]]; then
                                        if [[ "${COPAS[j-1]}" == "(+) 7 de copas" ]]; then
                                            puede=true
                                            break
                                        fi
elif [[ "${COPAS[j+1]}" == "(+) $((NUMERO + 1)) de copas" ]] || [[ "${COPAS[j-1]}" == "(+) $((NUMERO - 1)) de copas" ]] ; then
                                        puede=true
                                        break
                                    fi
                                fi
                            done
                            ;;
                        "espadas")
                            for ((j = 0; j < 10; j++)); do
                                if [[ "$CARTA" == "${ESPADAS[j]}" ]]; then
                                    if  [[ "$NUMERO" == "10" ]]; then
                                        if [[ "${ESPADAS[j-1]}" == "(+) 7 de espadas" ]]; then
                                            puede=true
                                            break
                                        fi
elif [[ "${ESPADAS[j+1]}" == "(+) $((NUMERO + 1)) de espadas" ]] || [[ "${ESPADAS[j-1]}" == "(+) $((NUMERO - 1)) de espadas" ]] ; then
                                        puede=true
                                        break
                                    fi
                                fi
                            done
                            ;;
                        "oros")
                            for ((j = 0; j < 10; j++)); do
                                if [[ "$CARTA" == "${OROS[j]}" ]]; then
                                    if [[ "$NUMERO" == "10" ]]; then
                                        if [[ "${OROS[j-1]}" == "(+) 7 de oros" ]]; then
                                            puede=true
                                            break
                                        fi
elif [[ "${OROS[j+1]}" == "(+) $((NUMERO + 1)) de oros" ]] || [[ "${OROS[j-1]}" == "(+) $((NUMERO - 1)) de oros" ]] ; then
                                        puede=true
                                        break
                                    fi
                                fi
                            done
                            ;;
                    esac
                fi
            fi
    done

if [ "$puede" = false ]; then
    echo "JUGADOR 1 PASA TURNO :("
    TURNO=2
    return
else
    while true; do
    colocada=false
        read -p "Selecciona una carta para colocar (índice): " INDICE
        if [[ "$INDICE" =~ ^[0-9]+$ ]]; then
            if [ "$INDICE" -ge 1 ] && [ "$INDICE" -le ${NUMERO_CARTAS_JUGADOR1} ]; then
                break
            else
                echo "Índice no válido. Debes seleccionar una carta entre 1 y ${NUMERO_CARTAS_JUGADOR1}"
            fi
        else
            echo "Índice no válido. Debes seleccionar una carta válida (número positivo)"
        fi
    done
fi

if [ "$INDICE" -ge 1 ] && [ "$INDICE" -le "${NUMERO_CARTAS_JUGADOR1}" ]; then
    CARTA="${JUGADOR1[INDICE - 1]}"
    INDICE_REAL=$((INDICE - 1))
    if [ -n "$CARTA" ]; then
        PALO=$(echo "$CARTA" | cut -d " " -f 3)
        NUMERO=$(echo "$CARTA" | cut -d " " -f 1)
        if [ "$NUMERO" == "5" ]; then 
            case $PALO in
                "bastos")
                    BASTOS[4]="(+) 5 de bastos"
                    echo "JUGADOR $TURNO PONE CARTA: 5 de bastos"
                    JUGADOR1[INDICE_REAL]="" 
                    ;;
                "copas")
                    COPAS[4]="(+) 5 de copas"
                    echo "JUGADOR $TURNO PONE CARTA: 5 de copas"
                    JUGADOR1[INDICE_REAL]=""
                    ;;
                "espadas")
                    ESPADAS[4]="(+) 5 de espadas"
                    echo "JUGADOR $TURNO PONE CARTA: 5 de espadas"
                    JUGADOR1[INDICE_REAL]=""
                    ;;
            esac
            #clear
            mostrar_tablero

        elif [[ "$NUMERO" == "10" ]]; then
            case $PALO in
                "bastos")
                    for ((j = 0; j < 10; j++)); do
                        if [[ "${BASTOS[j-1]}" == "(+) 7 de bastos" ]]; then
                            BASTOS[j]="(+) $NUMERO de bastos"
                            colocada=true
                            echo "JUGADOR $TURNO PONE CARTA: $NUMERO de bastos"
                            JUGADOR1[INDICE_REAL]=""
                            break                           
                        fi                       
                    done
                    if [ "$colocada" == false ]; then
                        echo "No puedes colocar esa carta"
                        turno_usuario
                    fi
                ;;
                "copas")
                    for ((j = 0; j < 10; j++)); do
                        if [[ "${COPAS[j-1]}" == "(+) 7 de copas" ]]; then
                            COPAS[j]="(+) $NUMERO de copas"
                            colocada=true
                            echo "JUGADOR $TURNO PONE CARTA: $NUMERO de copas"
                            JUGADOR1[INDICE_REAL]=""
                            break                        
                        fi
                    done
                    if [ "$colocada" == false ]; then
                        echo "No puedes colocar esa carta"
                        turno_usuario
                    fi
                ;;
                "espadas")
                    for ((j = 0; j < 10; j++)); do
                        if [[ "${ESPADAS[j-1]}" == "(+) 7 de espadas" ]]; then
                            ESPADAS[j]="(+) $NUMERO de espadas"
                            colocada=true
                            echo "JUGADOR $TURNO PONE CARTA: $NUMERO de espadas"
                            JUGADOR1[INDICE_REAL]=""
                            break                        
                        fi
                    done
                    if [ "$colocada" == false ]; then
                        echo "No puedes colocar esa carta"
                        turno_usuario
                    fi
                ;;
                "oros")
                    for ((j = 0; j < 10; j++)); do
                        if [[ "${OROS[j-1]}" == "(+) 7 de oros" ]]; then
                            OROS[j]="(+) $NUMERO de oros"
                            colocada=true
                            echo "JUGADOR $TURNO PONE CARTA: $NUMERO de oros"
                            JUGADOR1[INDICE_REAL]=""
                            break
                        fi
                    done
                    if [ "$colocada" == false ]; then
                        echo "No puedes colocar esa carta"
                        turno_usuario
                    fi
                    ;;
            esac
            #clear
            mostrar_tablero

        elif [[ ! "$NUMERO" == "5" && ! "$NUMERO" == "10" ]]; then #############################
            case $PALO in
            "bastos")
                for ((j = 0; j < 10; j++)); do
if [[ "${BASTOS[j+1]}" == "(+) $((NUMERO+1)) de bastos" || "${BASTOS[j-1]}" == "(+) $((NUMERO-1)) de bastos" ]]; then
                        BASTOS[j]="(+) $NUMERO de bastos"
                        colocada=true
                        echo "JUGADOR $TURNO PONE CARTA: $NUMERO de bastos"
                        JUGADOR1[INDICE_REAL]=""
                        break
                    fi
                done
                if [ "$colocada" == false ]; then
                    echo "No puedes colocar esa carta"
                    turno_usuario
                fi
            ;;
            "copas")
                for ((j = 0; j < 10; j++)); do
if [[ "${COPAS[j+1]}" == "(+) $((NUMERO+1)) de copas" || "${COPAS[j-1]}" == "(+) $((NUMERO-1)) de copas" ]]; then
                        COPAS[j]="(+) $NUMERO de copas"
                        colocada=true
                        echo "JUGADOR $TURNO PONE CARTA: $NUMERO de copas"
                        JUGADOR1[INDICE_REAL]=""
                        break
                    fi
                done
                if [ "$colocada" == false ]; then
                    echo "No puedes colocar esa carta"
                    turno_usuario
                fi
            ;;
            "espadas")
                for ((j = 0; j < 10; j++)); do
if [[ "${ESPADAS[j+1]}" == "(+) $((NUMERO+1)) de espadas" || "${ESPADAS[j-1]}" == "(+) $((NUMERO-1)) de espadas" ]]; then
                        ESPADAS[j]="(+) $NUMERO de espadas"
                        colocada=true
                        echo "JUGADOR $TURNO PONE CARTA: $NUMERO de espadas"
                        JUGADOR1[INDICE_REAL]=""
                        break
                    fi                   
                done
                if [ "$colocada" == false ]; then
                    echo "No puedes colocar esa carta"
                    turno_usuario
                fi
            ;;
            "oros")
                for ((j = 0; j < 10; j++)); do
if [[ "${OROS[j+1]}" == "(+) $((NUMERO+1)) de oros" || "${OROS[j-1]}" == "(+) $((NUMERO-1)) de oros" ]]; then
                        OROS[j]="(+) $NUMERO de oros"
                        colocada=true
                        echo "JUGADOR $TURNO PONE CARTA: $NUMERO de oros"
                        JUGADOR1[INDICE_REAL]=""
                        break
                    fi
                done
                if [ "$colocada" == false ]; then
                    echo "No puedes colocar esa carta"
                    turno_usuario
                fi
                ;;
        esac
        #clear
        mostrar_tablero
    fi
else
    echo "Ya has colocado esa carta"
    turno_usuario
fi
fi

}

function conteo_puntos {

    PUNTOS_GANADOR=0

    for ((i = 0; i < $NUMERO_CARTAS_JUGADOR1; i++)); do
        CARTA="${JUGADOR1[i]}"
        NUMERO=$(echo "$CARTA" | cut -d " " -f 1)
        PUNTOS_GANADOR=$((PUNTOS_GANADOR + NUMERO))
    done

    for ((i = 0; i < $NUMERO_CARTAS_JUGADOR2; i++)); do
        CARTA="${JUGADOR2[i]}"
        NUMERO=$(echo "$CARTA" | cut -d " " -f 1)
        PUNTOS_GANADOR=$((PUNTOS_GANADOR + NUMERO))
    done
    if [ "$JUGADORES" -ge 3 ]; then
        for ((i = 0; i < $NUMERO_CARTAS_JUGADOR3; i++)); do
            CARTA="${JUGADOR3[i]}"
            NUMERO=$(echo "$CARTA" | cut -d " " -f 1)
            PUNTOS_GANADOR=$((PUNTOS_GANADOR + NUMERO))
        done
    fi
    if [ "$JUGADORES" -eq 4 ]; then
        for ((i = 0; i < $NUMERO_CARTAS_JUGADOR4; i++)); do
            CARTA="${JUGADOR4[i]}"
            NUMERO=$(echo "$CARTA" | cut -d " " -f 1)
            PUNTOS_GANADOR=$((PUNTOS_GANADOR + NUMERO))
        done
    fi
}

function comprobar_vacios {
    VACIO=0

    # Comprueba el mazo del jugador 1
    for ((k=0; k < $NUMERO_CARTAS_JUGADOR1; k++)); do
        if [ -n "${JUGADOR1[k]}" ]; then
            VACIO=0
            break
        else
            VACIO=1
        fi
    done
    if [ "$VACIO" == "1" ]; then
        return
    fi

    # Comprueba el mazo del jugador 2
    for ((k=0; k < $NUMERO_CARTAS_JUGADOR2; k++)); do
        if [ -n "${JUGADOR2[k]}" ]; then
            VACIO=0
            break
        else
            VACIO=2
        fi
    done
    if [ "$VACIO" == "2" ]; then
        return
    fi

    # Comprueba el mazo del jugador 3 si hay al menos 3 jugadores
    if [ "$JUGADORES" -ge 3 ]; then
        for ((k=0; k < $NUMERO_CARTAS_JUGADOR3; k++)); do
            if [ -n "${JUGADOR3[k]}" ]; then
                VACIO=0
                break
            else
                VACIO=3

            fi
        done
    fi
    if [ "$VACIO" == "3" ]; then
        return
    fi

    # Comprueba el mazo del jugador 4 si hay 4 jugadores
    if [ "$JUGADORES" -eq 4 ]; then
        for ((k=0; k < $NUMERO_CARTAS_JUGADOR4; k++)); do
            if [ -n "${JUGADOR4[k]}" ]; then
                VACIO=0
                break
            else
                VACIO=4

            fi
        done
    fi
    if [ "$VACIO" == "4" ]; then
        return
    fi

}

function contar_cartas {
    NUMERO_CARTAS_JUGADOR1=0
    NUMERO_CARTAS_JUGADOR2=0
    NUMERO_CARTAS_JUGADOR3=0
    NUMERO_CARTAS_JUGADOR4=0

    for ((i = 0; i < ${#JUGADOR1[@]}; i++)); do
        if [ -n "${JUGADOR1[i]}" ]; then
            NUMERO_CARTAS_JUGADOR1=$((NUMERO_CARTAS_JUGADOR1 + 1))
        fi
    done

    for ((i = 0; i < ${#JUGADOR2[@]}; i++)); do
        if [ -n "${JUGADOR2[i]}" ]; then
            NUMERO_CARTAS_JUGADOR2=$((NUMERO_CARTAS_JUGADOR2 + 1))
        fi
    done

    if [ "$JUGADORES" -ge 3 ]; then
        for ((i = 0; i < ${#JUGADOR3[@]}; i++)); do
            if [ -n "${JUGADOR3[i]}" ]; then
                NUMERO_CARTAS_JUGADOR3=$((NUMERO_CARTAS_JUGADOR3 + 1))
            fi
        done
    else
        NUMERO_CARTAS_JUGADOR3=*
    fi

    if [ "$JUGADORES" -eq 4 ]; then
        for ((i = 0; i < ${#JUGADOR4[@]}; i++)); do
            if [ -n "${JUGADOR4[i]}" ]; then
                NUMERO_CARTAS_JUGADOR4=$((NUMERO_CARTAS_JUGADOR4 + 1))
            fi
        done
    else 
        NUMERO_CARTAS_JUGADOR4=*
    fi
}

function escribir_fichero {
    FECHA=$(date +%d%m%Y)
    HORA=$(date +%H:%M:%S)
    TIEMPO_PARTIDA=$((HORA_FIN - HORA_INICIO))
    RONDAS=$((CONTADOR_TURNOS / JUGADORES))
    GANADOR="$VACIO"
    PUNTOS="$PUNTOS_GANADOR"
    contar_cartas
    echo "$FECHA|$HORA|$JUGADORES|$TIEMPO_PARTIDA|$RONDAS|$GANADOR|$PUNTOS|$NUMERO_CARTAS_JUGADOR1-$NUMERO_CARTAS_JUGADOR2-$NUMERO_CARTAS_JUGADOR3-$NUMERO_CARTAS_JUGADOR4" >> "$LOG"   
}

function estadisticas {
if [ -f "$LOG" ]; then
    if [ ! -s "$LOG" ]; then
        echo "El archivo de registro '$LOG' esta vacio juega una partida para ver las estadisticas"
        return
    fi
    # Número total de partidas jugadas según líneas
    # grep -c . cuenta las líneas del archivo
    TOTAL_PARTIDAS=$(grep -c . "$LOG")

    # Media de los tiempos de todas las partidas jugadas
    TOTAL_TIEMPO=0
    MEDIA_TIEMPO=0
    for ((i = 1; i <= $TOTAL_PARTIDAS; i++)); do
        #sed -n no imprime lo procesado y {i}p imprime la línea i
        TIEMPO_PARTIDA=$(sed -n "${i}p" "$LOG" | cut -d "|" -f 4)
        TOTAL_TIEMPO=$((TOTAL_TIEMPO + TIEMPO_PARTIDA))
    done
    MEDIA_TIEMPO=$(($TOTAL_TIEMPO / $TOTAL_PARTIDAS))

    # Tiempo total invertido en todas las partidas
    TIEMPO_TOTAL=$TOTAL_TIEMPO

    # Media de los puntos obtenidos por el ganador en todas las partidas
    TOTAL_PUNTOS=0
    MEDIA_PUNTOS_GANADOR=0
    for ((i = 1; i <= $TOTAL_PARTIDAS; i++)); do
        PUNTOS_GANADOR_E=$(sed -n "${i}p" "$LOG" | cut -d "|" -f 7)
        TOTAL_PUNTOS=$((TOTAL_PUNTOS + PUNTOS_GANADOR_E))
    done
    MEDIA_PUNTOS_GANADOR=$(($TOTAL_PUNTOS / $TOTAL_PARTIDAS))

    # Porcentaje de partidas ganadas por cada jugador
    VICTORIAS_JUGADOR_1=0
    VICTORIAS_JUGADOR_2=0
    VICTORIAS_JUGADOR_3=0
    VICTORIAS_JUGADOR_4=0
    
    PARTIDAS_JUGADOR_1=0
    PARTIDAS_JUGADOR_2=0
    PARTIDAS_JUGADOR_3=0
    PARTIDAS_JUGADOR_4=0
    
    # Contabiliza las victorias de cada jugador y las partidas jugadas
    for ((i = 1; i <= $TOTAL_PARTIDAS; i++)); do
        GANADOR=$(sed -n "${i}p" "$LOG" | cut -d "|" -f 6)
        case $GANADOR in
            1)
                VICTORIAS_JUGADOR_1=$((VICTORIAS_JUGADOR_1 + 1))
                ;;
            2)
                VICTORIAS_JUGADOR_2=$((VICTORIAS_JUGADOR_2 + 1))
                ;;
            3)
                VICTORIAS_JUGADOR_3=$((VICTORIAS_JUGADOR_3 + 1))
                ;;
            4)
                VICTORIAS_JUGADOR_4=$((VICTORIAS_JUGADOR_4 + 1))
                ;;
        esac
        PARTIDAS_JUGADOR_1=$((PARTIDAS_JUGADOR_1 + 1))
    done
        PORCENTAJE_GANADAS_1=$((VICTORIAS_JUGADOR_1 * 100 / PARTIDAS_JUGADOR_1))
        PORCENTAJE_GANADAS_2=$((VICTORIAS_JUGADOR_2 * 100 / PARTIDAS_JUGADOR_1))
        PORCENTAJE_GANADAS_3=$((VICTORIAS_JUGADOR_3 * 100 / PARTIDAS_JUGADOR_1))
        PORCENTAJE_GANADAS_4=$((VICTORIAS_JUGADOR_4 * 100 / PARTIDAS_JUGADOR_1))

    clear
    echo
    echo "      =========================="
    echo "              ESTADISTICAS      "
    echo "      =========================="
    echo

    echo "Número total de partidas jugadas: $TOTAL_PARTIDAS"
    echo "Media de los tiempos de todas las partidas jugadas: $MEDIA_TIEMPO segundos"
    echo "Tiempo total invertido en todas las partidas: $TIEMPO_TOTAL segundos"
    echo "Media de los puntos obtenidos por el ganador en todas las partidas: $MEDIA_PUNTOS_GANADOR puntos"
    echo "Porcentaje de partidas ganadas del jugador 1: $PORCENTAJE_GANADAS_1%"
    echo "Porcentaje de partidas ganadas del jugador 2: $PORCENTAJE_GANADAS_2%"
    echo "Porcentaje de partidas ganadas del jugador 3: $PORCENTAJE_GANADAS_3%"
    echo "Porcentaje de partidas ganadas del jugador 4: $PORCENTAJE_GANADAS_4%"
else
    echo "El archivo de registro '$LOG' no existe o esta vacio"
fi
    echo
    read -p "Pulse una tecla para continuar..."

}

function clasificacion {
if [ -f "$LOG" ]; then
    if [ ! -s "$LOG" ]; then
        echo "El archivo de registro '$LOG' esta vacio juega una partida para ver las estadisticas"
        return
    fi
    PARTIDA_MAS_CORTA=""
    PARTIDA_MAS_LARGA=""
    PARTIDA_MAS_RONDAS=""
    PARTIDA_MENOS_RONDAS=""
    PARTIDA_MAS_PUNTOS=""
    PARTIDA_MAS_CARTAS=""

    # Partida más corta
    # Ordena el archivo por el campo 4 (tiempo total) y coge la primera línea (la más corta) y la guarda en la variable
    PARTIDA_MAS_CORTA=$(sort -t "|" -k 4 -n "$LOG" | head -n 1)

    # Partida más larga
    # Ordena el archivo por el campo 4 (tiempo total) y coge la última línea (la más larga) y la guarda en la variable
    PARTIDA_MAS_LARGA=$(sort -t "|" -k 4 -n "$LOG" | tail -n 1)

    # Partida con más rondas
    # Ordena el archivo por el campo 5 (rondas) y coge la última línea (la que más rondas tiene) y la guarda en la variable
    PARTIDA_MAS_RONDAS=$(sort -t "|" -k 5 -n "$LOG" | tail -n 1)

    # Partida con menos rondas
    # Ordena el archivo por el campo 5 (rondas) y coge la primera línea (la que menos rondas tiene) y la guarda en la variable
    PARTIDA_MENOS_RONDAS=$(sort -t "|" -k 5 -n "$LOG" | head -n 1)

    # Partida con más puntos
    # Ordena el archivo por el campo 7 (puntos) y coge la última línea (la que más puntos tiene) y la guarda en la variable
    PARTIDA_MAS_PUNTOS=$(sort -t "|" -k 7 -n "$LOG" | tail -n 1)

    # Partida con más cartas
    PARTIDA_MAS_CARTAS=$(awk -F '|' '{split($8, a, "-"); max = a[1]; for (i = 2; i <= 4; i++) if (a[i] > max) max = a[i]} max > maxval {maxval = max; maxline = $0} END {print maxline}' fichero.log)



    clear
    echo
    echo "      =========================="
    echo "              CLASIFICACION     "
    echo "      =========================="
    echo
    echo "                                  Fecha|Hora|Jugadores|TiempoTotal|Rondas|Ganador|Puntos|CartasJugadores"
    echo "DATOS partida más corta:          $PARTIDA_MAS_CORTA "
    echo "DATOS partida más larga:          $PARTIDA_MAS_LARGA "
    echo "DATOS partida con más rondas:     $PARTIDA_MAS_RONDAS "
    echo "DATOS partida con menos rondas:   $PARTIDA_MENOS_RONDAS "
    echo "DATOS partida con más puntos:     $PARTIDA_MAS_PUNTOS "
    echo "DATOS partida con más cartas:     $PARTIDA_MAS_CARTAS "


    echo
    read -p "Pulse una tecla para continuar..."
fi
}


#####################################################################
####################### PROGRAMA PRINCIPAL ##########################	
#####################################################################



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
    echo "      Estrategia 2 Menores: Los jugadores colocan la carta de menor valor que puedan colocar"
    echo

    read -p "Pulse una tecla para continuar..."
    exit 0
fi

Comprobaciones_cfg
        #-d es el delimitador y -f es el campo
        JUGADORES=$(grep '^JUGADORES=' config.cfg | cut -d '=' -f 2)
        ESTRATEGIA=$(grep '^ESTRATEGIA=' config.cfg | cut -d '=' -f 2)
        LOG=$(grep '^LOG=' config.cfg | cut -d '=' -f 2)

Comprobaciones_log

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
            clear
            juego
            ;;
        [Ee])
            clear
            estadisticas
            ;;
        [Ff])
            clear
            clasificacion
            ;;
        [Ss])
            exit 0
            ;;
        *)
            echo "Opcion incorrecta"
            ;;
    esac
done
