#!/bin/bash

# Primer ejemplo de Case, Determina si el script puede correr 
# en una arquitectura determinada, Ademas ignora los tamaños 
# de las letras. Asi Ubuntu ubuntu UBUNTU van a comprobar al valor deseado

shopt -s nocasematch

distro=$1

case "$distro" in
	Ubuntu)
		echo "Sistema soportado en 32 bits"
	;;
	Fedora)
		echo "Sistema soportado 64 bits"
	;;
	Debian)
		echo "Sistema para ARM"
	;;
	*)
		echo "Sistema no soportado"
esac

exit 0
