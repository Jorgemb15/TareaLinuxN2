#!/bin/bash

# Script para probar el tamaño del disco duro


Espacio=`df | awk '{print $5}' | grep -v Us | sort -n | tail -1 | cut -d "%" -f 1`

case $Espacio in
	[1-6]*)
		MENSAJE="Uso bajo de Almacenamiento"
	;;
	[7-8]+)
		MENSAJE="Hay una particion medio llena. Tamaño = $Espacio%"
	;;
	9[0-5]*)
		MENSAJE="El Sistema Pronto colapsara. Tamaño = $Espacio%"
	;;
	*)
		MENSAJE="No hay sistema de Archivos"
esac

echo $MENSAJE | mail -s "Reporte de Espacio en Disco `date`" jorgemb15@hotmail.es



exit 0
