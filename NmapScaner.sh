#!/bin/bash

# Función para mostrar el banner
mostrar_banner() {
    echo -e "\e[1;31m"
    echo "************************************"
    echo "*           Nmap Scanner           *"
    echo "************************************"
    echo -e "\e[0m"
}

# Función para el escaneo básico de puertos
escaneo_basico() {
    read -p "Introduce la IP o dominio: " ip
    read -p "Introduce el rango de puertos (ej. 22-80): " puertos
    nmap -p $puertos $ip
}

# Función para escaneo de servicios y versiones
escaneo_servicios_versiones() {
    read -p "Introduce la IP o dominio: " ip
    nmap -sV $ip
}

# Función para escaneo con Nmap Scripting Engine (NSE)
escaneo_vulnerabilidades() {
    read -p "Introduce la IP o dominio: " ip
    nmap --script vuln $ip
}

# Función para el escaneo de red (descubrimiento de hosts)
escaneo_red() {
    read -p "Introduce la IP o rango de IPs (ej. 192.168.1.0/24): " red
    nmap -sn $red
}

# Menú principal de Nmap
mostrar_menu_nmap() {
    while true; do
        clear
        mostrar_banner
        echo -e "\e[1;35mElige el tipo de escaneo que deseas realizar:\e[0m"
        echo "1. Escaneo básico de puertos"
        echo "2. Escaneo de servicios y versiones"
        echo "3. Escaneo de vulnerabilidades (NSE)"
        echo "4. Escaneo de red (descubrimiento de hosts)"
        echo "5. Volver al menú principal"
        echo -e "\e[1;36m---------------------------------\e[0m"
        read -p "Opción: " opcion
        echo -e "\e[1;36m---------------------------------\e[0m"

        case $opcion in
            1)
                escaneo_basico
                ;;
            2)
                escaneo_servicios_versiones
                ;;
            3)
                escaneo_vulnerabilidades
                ;;
            4)
                escaneo_red
                ;;
            5)
                break
                ;;
            *)
                echo "Opción no válida. Por favor, selecciona una opción válida."
                ;;
        esac

        # Preguntar si guardar el resultado en un archivo
        read -p "¿Quieres guardar el resultado en un archivo de texto? (s/n): " guardar
        if [[ $guardar == "s" ]]; then
            read -p "¿Quieres guardar en la carpeta predeterminada o crear una nueva carpeta? (p/n): " carpeta
            if [[ $carpeta == "p" ]]; then
                resultado="resultado_$(date +%F_%T).txt"
                # Redirigir salida del escaneo al archivo
                nmap -p $puertos $ip > $resultado
                echo "Resultado guardado en $resultado"
            else
                read -p "Introduce el nombre de la nueva carpeta: " nueva_carpeta
                mkdir -p $nueva_carpeta
                resultado="$nueva_carpeta/resultado_$(date +%F_%T).txt"
                nmap -p $puertos $ip > $resultado
                echo "Resultado guardado en $resultado"
            fi
        fi
    done
}

# Llamamos al menú de Nmap
mostrar_menu_nmap
