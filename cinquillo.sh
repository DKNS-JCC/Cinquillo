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
                echo -n "Seleccione la ruta donde se guardará o se encuentra el registro..."
                read N_LOG

                if [ ! -d "N_LOG" ]
                then
                    echo "ERROR: El directorio no existe o no es correcto."
                else
                    LOG=$N_LOG
                    echo JUGADORES=$JUGADORES > config.cfg
                    echo ESTRATEGIA=$ESTRATEGIA >> config.cfg
                    echo LOG=$LOG >> config.cfg
                    clear
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
}

function Comprobaciones
{
    # Comprobar si existe el archivo de configuración
    if [ ! -f "config.cfg" ] || [ ! -s "config.cfg" ]
    then
        echo "El archivo de configuración 'config.cfg' no se ha encontrado en este directorio o esta vacío."
        echo "Por favor, asegúrese de crear el archivo de configuración antes de ejecutar este juego."
        read opcion
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
        exit -1
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

# Función para BARAJAr las CARTASs. 
#Funcionamiento: se recorre el array de CARTAS y se intercambia la CARTA actual con una CARTA aleatoria
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
# Crea dos arrays vacíos para los dos jugadores
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
            JUGADOR1+=("${BARAJA[i + CARTAS_POR_JUGADOR +1]}") # Carta del jugador 1 sobrante
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
    case $JUGADORES in
        2)
            echo "-----------------------------------------------------------------------------------------"
            printf "%-30s %-30s\n" "Tus Cartas:" "Jugador 2:"
            echo
            for ((i=0;i<20;i++)); 
            do
                indice=$((i+1))
                printf "%-30s %-30s\n" "${indice})  ${JUGADOR1[i]}" "${indice})  ${JUGADOR2[i]}"
            done
            ;;
        3)
            echo "-----------------------------------------------------------------------------------------"
            printf "%-30s %-30s %-30s\n" "Tus Cartas:" "Jugador 2:" "Jugador 3:"
            echo
            for ((i=0;i<13;i++)); 
            do
                indice=$((i+1))
                printf "%-30s %-30s %-30s\n" "${indice})  ${JUGADOR1[i]}" "${indice})  ${JUGADOR2[i]}" "${indice})  ${JUGADOR3[i]}"
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
                printf "%-30s %-30s %-30s %-30s\n" "${indice})  ${JUGADOR1[i]}" "${indice})  ${JUGADOR2[i]}" "${indice})  ${JUGADOR3[i]}" "${indice})  ${JUGADOR4[i]}"
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
                unset JUGADOR1[i]
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
                unset JUGADOR2[i]
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
                unset JUGADOR3[i]
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
                unset JUGADOR4[i]
                break
        fi
    done
    clear
    mostrar_tablero
}



function juego {
    clear
    crear_baraja
    barajar
    clear
    repartir_por_jugadores
    mostrar_tablero
    buscar_5oros
    
while [ ${#JUGADOR1[@]} -gt 0 ] || [ ${#JUGADOR2[@]} -gt 0 ] || [ ${#JUGADOR3[@]} -gt 0 ] || [ ${#JUGADOR4[@]} -gt 0 ];
do
    # Si el turno es mayor que el número de jugadores, se reinicia el turno
    if [ $TURNO -gt $JUGADORES ]; then
        TURNO=1
    fi
    case $TURNO in
        1)  
            echo "TURNO DEL JUGADOR $TURNO"
            turno_usuario
            TURNO=2
            ;;
        2)
            echo "TURNO DEL JUGADOR $TURNO"
            echo "ESTRATEGIA 0"
            TURNO=3
            ;;
        3)
            echo "TURNO DEL JUGADOR $TURNO"
            echo "ESTRATEGIA 0"
            TURNO=4
            ;;
        4)
            echo "TURNO DEL JUGADOR $TURNO"
            echo "ESTRATEGIA 0"
            TURNO=1
            ;;
        *)
            echo "ERROR: TURNO NO VÁLIDO"
    esac
done
}
function turno_usuario {
    while true; do
        read -p "Selecciona una carta para colocar (índice): " INDICE
    if [[ "$INDICE" =~ ^[0-9]+$ ]]; then
        break  
    else
        echo "Índice no válido. Debes seleccionar una carta entre 1 y $CARTAS_POR_JUGADOR."
    fi
        
    done
        if [ "$INDICE" -ge 1 ] && [ "$INDICE" -le "$CARTAS_POR_JUGADOR" ]; then
            CARTA="${JUGADOR1[INDICE - 1]}"
            INDICE_REAL=$((INDICE - 1))

            if [ -n "$CARTA" ]; then
                PALO=$(echo "$CARTA" | cut -d " " -f 3)
                NUMERO=$(echo "$CARTA" | cut -d " " -f 1)

                if [ "$NUMERO" -eq 5 ]; then
                    case $PALO in
                        "bastos")
                            BASTOS[4]="(+) 5 de bastos"
                            unset JUGADOR1[INDICE_REAL]
                            ;;
                        "copas")
                            COPAS[4]="(+) 5 de copas"
                            unset JUGADOR1[INDICE_REAL]
                            ;;
                        "espadas")
                            ESPADAS[4]="(+) 5 de espadas"
                            unset JUGADOR1[INDICE_REAL]
                            ;;
                    esac
                    clear
                    mostrar_tablero
                else
    case $PALO in
    "bastos")
                    for ((i = 0; i < 10; i++)); do
                    if [[ "$CARTA" == "${BASTOS[i]}" ]]; then
                    if [[ "${BASTOS[i+1]}" == "(+) $((NUMERO + 1)) de bastos" ]] || [[ "${BASTOS[i-1]}" == "(+) $((NUMERO - 1)) de bastos" ]]; then

                    BASTOS[i]="(+) ${NUMERO} de bastos"
                    unset JUGADOR1[INDICE_REAL]
                    break
                else
                    echo "No puedes colocar esa carta."
                    turno_usuario
                fi
            fi
        done
        ;;
    "copas")
        for ((i = 0; i < 10; i++)); do
            if [[ "$CARTA" == "${COPAS[i]}" ]]; then
                if [[ "${COPAS[i+1]}" == "(+) $((NUMERO + 1)) de copas" ]] || [[ "${COPAS[i-1]}" == "(+) $((NUMERO - 1)) de copas" ]]; then

                    COPAS[i]="(+) ${NUMERO} de copas"
                    unset JUGADOR1[INDICE_REAL]
                    break
                else
                    echo "No puedes colocar esa carta."
                    turno_usuario
                fi
            fi
        done
        ;;
    "espadas")
        for ((i = 0; i < 10; i++)); do
            if [[ "$CARTA" == "${ESPADAS[i]}" ]]; then
                if [[ "${ESPADAS[i+1]}" == "(+) $((NUMERO + 1)) de espadas" ]] || [[ "${ESPADAS[i-1]}" == "(+) $((NUMERO - 1)) de espadas" ]]; then

                    ESPADAS[i]="(+) ${NUMERO} de espadas"
                    unset JUGADOR1[INDICE_REAL]
                    break
                else
                    echo "No puedes colocar esa carta."
                    turno_usuario
                fi
            fi
        done
        ;;
    "oros")
        for ((i = 0; i < 10; i++)); do
            if [[ "$CARTA" == "${OROS[i]}" ]]; then
                if [[ "${OROS[i+1]}" == "(+) $((NUMERO + 1)) de oros" ]] || [[ "${OROS[i-1]}" == "(+) $((NUMERO - 1)) de oros" ]]; then

                    OROS[i]="(+) ${NUMERO} de oros"
                    unset JUGADOR1[INDICE_REAL]
                    break
                else
                    echo "No puedes colocar esa carta."
                    turno_usuario
                fi
            fi
        done
        ;;
    esac

            fi
            else
                echo "La carta en el índice $INDICE ya se ha jugado. Selecciona una carta válida."
                turno_usuario
            fi
            else
                echo "Índice no válido. Debes seleccionar una carta entre 1 y $CARTAS_POR_JUGADOR."
                turno_usuario
        fi
        TURNO+=1
        clear
        mostrar_tablero
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
    echo "      Estrategia 2 ..."
    echo

    read -p "Pulse una tecla para continuar..."
    exit 0
fi

Comprobaciones

        #-d es el delimitador y -f es el campo
        JUGADORES=$(grep '^JUGADORES=' config.cfg | cut -d '=' -f 2)
        ESTRATEGIA=$(grep '^ESTRATEGIA=' config.cfg | cut -d '=' -f 2)
        LOG=$(grep '^LOG=' config.cfg | cut -d '=' -f 2)

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
