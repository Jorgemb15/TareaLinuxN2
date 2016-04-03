#!/bin/bash

	#  archivos de excel y grafica Datos creados..

DATOS=../hojasdatos


SALIDA_DATOS=$DATOS/datos_csv

mkdir $SALIDA_DATOS

#pasando de excel a csv con la herramienta xls2csv, en caso de algun error por favor consultar error1.log

M=0

for archivo in ` find $DATOS -name "*.xls"`
do
	echo "Procesando Archivo $archivo"
	xls2csv	$archivo > $SALIDA_DATOS/datos-$M.csv
	let M=M+1
done 2>error1.log

#Dando formato antes de graficar, en caso de algun error por favor consutar archivo error2.log

M=0

for archivo in ` find $SALIDA_DATOS -name "*.csv"`
do
	echo "Dando formato al archivos de Datos $archivo"
#	cat $archivo | awk -F "/",/"" '{print $1 " " $2 " " $3 " " $4 " " $5}' | sed '1,$ s/"//g' | sed '1 s/date/#date/g' > $SALIDA_DATOS/datos-$M.out
	cat $archivo  | awk -F "\",\"" '{print $1 " " $2 " " $3 " " $4 " "  $5}' | grep -v Sensor | sed '1,$ s/"//g' > $SALIDA_DATOS/datos-$M.out
	let M=M+1
done 2>error2.log

#Eliminando archivo de grafico antiguo si existia, en caso de algun error consutar error3.log

if [ -a $SALIDA_DATOS/grafico.dat ]
then
	rm $SALIDA_DATOS/grafico.dat
	echo "archivo full.dat anterior borrado"
fi 2> error3.log

#Creando el archivo para el grafico, en caso de algun error por favor verificar archivo error4.log

M=0

for archivo in ` find $SALIDA_DATOS -name "*.out"`
do
	sed '1d' $archivo >> $SALIDA_DATOS/grafico.dat
	echo "Procesando Archivo $archivo"
done 2>error4.log

#Definiendo parametros de grafico

FMT_INICIO="20110206 0000"
FMT_FIN="20110206 0200"
FMT_X_SHOW=%H:%M
DATA_DONE=$SALIDA_DATOS/grafico.dat

#Creando funcion para graficar, en caso de algun error por favor verificar archivo error5.log

graficar()
{
	gnuplot << EOF 2> error5.log
		set xdata time
		set timefmt "%Y%m%d%H%M"
#		set xrange ["$FMT_INICIO" : "$FMT_FIN"]
		set format x "$FMT_X_SHOW"
		set terminal png
		set output 'grafico.png'	
		plot "$DATA_DONE" using 1:3 with lines title "sensor 1", "$DATA_DONE" using 1:4 with linespoints title "sensor 2" 
EOF
}

graficar

exit 0
