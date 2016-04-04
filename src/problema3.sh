#!/bin/bash

#Este programa recibe un archivo ya ordenado x valores de los cuales nos tocara graficar el valor de KW/m2 maximo y minimo, los cuales deben estar en el siguiente orden field 1= fecha y hora, fienld 6 y 7 KW/m2 maximo y minimo

DATOS=../problema3
ARCHIVO=/Datos
SALIDA_DATOS=$DATOS/datos_out
RUTA_GRAFICOS="./Graficos"

mkdir $SALIDA_DATOS
mkdir $RUTA_GRAFICOS
mkdir ./problema3_logs

#En esta parte del programa extraemos los datos necesarios para generar el grafico, en caso de algun problema por favor verificar archivo error1.log

for archivo in $DATOS$ARCHIVO
do
	echo "procesando archivo $archivo"
#	cat $archivo | cut -d "," --fields=1,6,7 --output-delimiter=' ' | grep 2012 | grep -v TOA5 | sed '1,$ s/"//g' | sed '1,$ s/://g' | sed '1,$ s/-//g' | awk '{print $1$2 " "$3 " " $4}' > $SALIDA_DATOS/Datos.out
	cat $archivo | cut -d "," --fields=1,6,7 --output-delimiter=' ' | grep 2012 | grep -v TOA5 > $SALIDA_DATOS/Datos.out
done 2>./problema3_logs/error1.log

#Definiendo parametros de grafico

DATA_DONE=$SALIDA_DATOS/Datos.out

#Creando funcion para graficar, en caso de algun error por favor verificar archivo error2.log

graficar()
{
        gnuplot << EOF 2>./problema3_logs/error2.log
                set xdata time
                set timefmt '"%Y-%m-%d %H:%M:%S"'
                set format x "%m-%d %H:%M"
                set terminal png
                set output './Graficos/Grafico_Problema3.png'
                plot "$DATA_DONE" using 1:2 with lines title "km/m2 Maximo"
EOF
}

echo "Graficando Archivo"
graficar

echo "Gracias por usar este programa para graficar"

exit 0
