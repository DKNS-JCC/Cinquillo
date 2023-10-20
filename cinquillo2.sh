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
function es_carta_valida() {
	#DOCUMENTAR
     carta="$1"
     ultima_carta_sobre_la_mesa="$2"

    # Extraer el palo de la última carta sobre la mesa
    palo_ultima_carta_sobre_la_mesa="${ultima_carta_sobre_la_mesa##*de }"

    # Extraer el número de la última carta sobre la mesa
    numero_ultima_carta_sobre_la_mesa="${ultima_carta_sobre_la_mesa%% de*}"

    # Extraer el palo de la carta actual
    palo_carta="${carta##*de }"

    # Extraer el número de la carta actual
    numero_carta="${carta%% de*}"

    # Verificar si el número de la carta actual es 5 o si el número es mayor o menor en 1 en comparación con la última carta
    if [ "$numero_carta" -eq 5 ] || [ "$numero_carta" -eq $((numero_ultima_carta_sobre_la_mesa - 1)) ] || [ "$numero_carta" -eq          	$((numero_ultima_carta_sobre_la_mesa + 1)) ]
     then
        # Verificar si el palo de la carta actual es el mismo que el de la última carta o si es un "5" de cualquier palo
        if [ "$palo_carta" == "$palo_ultima_carta_sobre_la_mesa" ] || [ "$numero_carta" -eq 5 ]
        then
            return 0  # La carta es válida
        fi
    fi

    return 1  # La carta no es válida
}
function Jugar{
	# definir las cartas de la baraja española
	baraja=("1 de Espadas" "2 de Espadas" "3 de Espadas" "4 de Espadas" "5 de Espadas"
        	"6 de Espadas" "7 de Espadas" "10 de Espadas" "11 de Espadas" "12 de Espadas"
        	"1 de Copas" "2 de Copas" "3 de Copas" "4 de Copas" "5 de Copas"
        	"6 de Copas" "7 de Copas" "10 de Copas" "11 de Copas" "12 de Copas"
        	"1 de Oros" "2 de Oros" "3 de Oros" "4 de Oros" "5 de Oros"
        	"6 de Oros" "7 de Oros" "10 de Oros" "11 de Oros" "12 de Oros"
        	"1 de Bastos" "2 de Bastos" "3 de Bastos" "4 de Bastos" "5 de Bastos"
        	"6 de Bastos" "7 de Bastos" "10 de Bastos" "11 de Bastos" "12 de Bastos")
	#caso en el que sean 2 jugadores
	if [ '^JUGADORES' -eq 2 ] 
	then
	#DOCUMENTAR
	# Repartir las cartas a 4 jugadores
	cartas_por_jugador= 20
	indice=0
	# Inicializar matrices para almacenar las cartas de cada jugador
	for ((i = 1; i <= '^JUGADORES'; i++));
	do
    	declare -a jugador$i=()
	done

	for ((i = 1; i <= '^JUGADORES'; i++));
	do
    	for ((j = 0; j < $cartas_por_jugador; j++));
    	do
        	carta="${barajadar[$indice]}"
        	eval "jugador$i+=('$carta')"  # Almacena la carta en el jugador$i
       	 ((indice++))
    	done
	done

	# Mostrar las cartas de cada jugador
	for ((i = 1; i <= '^JUGADORES'; i++))
	do
    	echo "Jugador $i:"
    	for carta in "${!jugador$i[@]}"
    	do
        	echo "Carta: ${jugador$i[$carta]}"
    	done
    	echo
	done
	
	turno=1
	ultima_carta_sobre_la_mesa="5 de Oros"

	# Juego
	while true
	 do
    	jugador_actual="jugador$turno"
    
    	echo "Turno de Jugador $turno"
    	echo "Última carta sobre la mesa: $ultima_carta_sobre_la_mesa"
    
    	carta_valida=0
    	while [ $carta_valida -eq 0 ] 
    	do
        	echo "Cartas del jugador $turno:"
        	for carta in "${!jugador_actual[@]}" 
        	do
            	echo "Carta: ${jugador$turno[$carta]}"
       	 done
        
       	read -p "Selecciona una carta para jugar: " carta_seleccionada
       	 carta_seleccionada="${jugador$turno[$carta_seleccionada]}"
        
      	  es_carta_valida "$carta_seleccionada" "$ultima_carta_sobre_la_mesa"
        
        	if [ $? -eq 0 ]
        	then
            	ultima_carta_sobre_la_mesa="$carta_seleccionada"
           	unset "jugador$turno[$carta_seleccionada]"
          	 carta_valida=1
       	 else
           	 echo "Carta no válida. Inténtalo de nuevo."
       	 fi
  	  done
    
   	 ((turno++))
 	  if [ $turno -gt '^JUGADORES' ]
 	  then
   	     turno=1
  	  fi
	done
	
	
	#caso en el que sean 3 jugadores
	elif [ '^JUGADORES' -eq 3 ] 
	then
	#DOCUMENTAR
	
	#caso en el que sean 4 jugadores
	elif [ '^JUGADORES' -eq 4 ] 
	then
	#DOCUMENTAR
	# Barajar las cartas
	barajar=($(shuf -e "${baraja[@]}"))
	# Repartir las cartas a 4 jugadores
	cartas_por_jugador= 10
	indice=0
	# Inicializar matrices para almacenar las cartas de cada jugador
	for ((i = 1; i <= '^JUGADORES'; i++));
	do
    	declare -a jugador$i=()
	done

	for ((i = 1; i <= '^JUGADORES'; i++));
	do
    	for ((j = 0; j < $cartas_por_jugador; j++));
    	do
        	carta="${barajadar[$indice]}"
        	eval "jugador$i+=('$carta')"  # Almacena la carta en el jugador$i
       	 ((indice++))
    	done
	done

	# Mostrar las cartas de cada jugador
	for ((i = 1; i <= '^JUGADORES'; i++))
	do
    	echo "Jugador $i:"
    	for carta in "${!jugador$i[@]}"
    	do
        	echo "Carta: ${jugador$i[$carta]}"
    	done
    	echo
	done
	
	turno=1
	ultima_carta_sobre_la_mesa="5 de Oros"

	# Juego
	while true
	 do
    	jugador_actual="jugador$turno"
    
    	echo "Turno de Jugador $turno"
    	echo "Última carta sobre la mesa: $ultima_carta_sobre_la_mesa"
    
    	carta_valida=0
    	while [ $carta_valida -eq 0 ] 
    	do
        	echo "Cartas del jugador $turno:"
        	for carta in "${!jugador_actual[@]}" 
        	do
            	echo "Carta: ${jugador$turno[$carta]}"
       	 done
        
       	read -p "Selecciona una carta para jugar: " carta_seleccionada
       	 carta_seleccionada="${jugador$turno[$carta_seleccionada]}"
        
      	  es_carta_valida "$carta_seleccionada" "$ultima_carta_sobre_la_mesa"
        
        	if [ $? -eq 0 ]
        	then
            	ultima_carta_sobre_la_mesa="$carta_seleccionada"
           	unset "jugador$turno[$carta_seleccionada]"
          	 carta_valida=1
       	 else
           	 echo "Carta no válida. Inténtalo de nuevo."
       	 fi
  	  done
    
   	 ((turno++))
 	  if [ $turno -gt '^JUGADORES' ]
 	  then
   	     turno=1
  	  fi
	done

	else
		echo "Vuelva a configuración y elija un número válido de jugadores."
	fi
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

