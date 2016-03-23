#!/bin/bash

# Este script extrae archivos de excel y grafica Datos.

DATOS=../hojasdatos


SALIDA_DATOS=$DATOS/datos_csv

mkdir $SALIDA_DATOS

M=0

for archivo in ` find $DATOS -name "*.xls"`
do
	echo "Procesando Archivo $archivo"
	xls2csv	$archivo > $SALIDA_DATOS/datos-$M.scv
	let M=M+1
done 2>error1.log

M=0

for archivo in ` find $SALIDA_DATOS -name "*.csv"`
do
	echo "Dando formato al archivos de Datos $archivo"
	cat $archivo | awk -F "\",\"" '{print $1 " " $2 " " $3 " " $4 " " $5}' | grep -v Sensor | sed '1,$ s/"//g' > $SALIDA_DATOS/datos-$M.out
	let M=M+1
done 2>error2.log


