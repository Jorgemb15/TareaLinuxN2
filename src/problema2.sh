#!/bin/bash

#Este programa tiene dos partes, la primera creara un grafico el cual nos dara la variacion de los montos en los primeros 3 meses del ano 2012, y la segunda nos dara todo lo que se consumio de agua durante los primeros 6 meses

#Definicion de Variables

DATOS="../problema2"
SALIDA_DATOS="$DATOS/Datos_csv"
RUTA_GRAFICOS="./Graficos"
MES=0
MONTO_MENSUAL=0


mkdir $SALIDA_DATOS
mkdir $RUTA_GRAFICOS

mkdir ./problema2_logs

#En esta area del programa pasaremos el excel a archivo csv, en caso de error verificar archivo ./problema2_logs/error1.log

for archivo in ` find $DATOS -name "*.xls"`
do
	MES="`echo "$archivo" | cut -d "0" -f2 | cut -d "_" -f1`"
	#if [ "`echo "$archivo" | cut -d "0" -f2 | cut -d "_" -f1`" -lt 4 ]
	#then
		echo "Procesando el archivo del Mes $MES"
		xls2csv $archivo > $SALIDA_DATOS/datos-$MES.csv
	#fi
	
done 2>./problema2_logs/error1.log

#En esta parte del programa borramos archivos viejos para que no quede basura, en caso de error verificar archivo ./problema2_logs/error2.log

if [ -a $SALIDA_DATOS/datos_luz.dat ]
then
        rm $SALIDA_DATOS/datos_luz.dat
        echo "Archivo datos_luz.dat anterior borrado"
	rm $SALIDA_DATOS/datos_agua.dat
	echo "Archivo datos_agua.dat anterior borrado"
fi 2>./problema2_logs/error2.log


#En esta parte del programa damos formato a los archivos csv para poder graficar, en caso de error verificar archivo ./problema2_logs/error3.log

for archivo in ` find $SALIDA_DATOS -name "*.csv" | sort`
do
	echo "Convirtiendo Informacion para Graficar"
	MES="`echo "$archivo" | cut -d "-" -f2 | cut -d "." -f1`"
	echo "20120$MES `cat $archivo | grep Agua | cut -d "," -f2 | sed '1,$ s/"//g'`" >> $SALIDA_DATOS/datos_agua.dat
	if [ $MES -lt 4 ]
	then
		echo "20120$MES `cat $archivo | grep Luz | cut -d "," -f2 | sed '1,$ s/"//g'`" >> $SALIDA_DATOS/datos_luz.dat
	fi
done 2>./problema2_logs/error3.log


#En esta parte del programa graficamos, en caso de error verificar archivo ./problema2_logs/error4.log

DATOS_GRAFICO="$SALIDA_DATOS/datos_luz.dat"

graficarLuz()
{
        gnuplot << EOF 2> ./problema2_logs/error4.log

		set terminal png
		set output './Graficos/Grafico_Luz.png'
		
		set xdata time
		set xtics nomirror rotate 2592000
		set timefmt "%Y%m"
		set format x "%m"
		set xlabel "Meses"
		set ylabel "Monto"
		
		plot "$DATOS_GRAFICO" using 1:2 with linespoints title "Luz" 
EOF
}


graficarAgua()
{
        gnuplot << EOF 2> ./problema2_logs/error5.log
		set terminal png
		set xdata time
		set ylabel "Monto"
		set xtics nomirror rotate 2592000
		set style fill solid 1.0
		set timefmt "%Y%m"
		set format x "%m"
		set xlabel "Meses"
 
		set output './Graficos/Grafico_Agua.png'
		plot "$DATOS_GRAFICO" using 1:2 with boxes title "Agua" 
EOF
}


DATOS_GRAFICO="$SALIDA_DATOS/datos_luz.dat"
graficarLuz

DATOS_GRAFICO="$SALIDA_DATOS/datos_agua.dat"
graficarAgua

echo "El programa para graficar ha finalizado por favor verifique los resultados del mismo en la carpeta problema2_logs"

exit 0
