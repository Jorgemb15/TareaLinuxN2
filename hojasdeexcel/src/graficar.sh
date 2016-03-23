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
	let M=$M+1
done 2>error1.log


