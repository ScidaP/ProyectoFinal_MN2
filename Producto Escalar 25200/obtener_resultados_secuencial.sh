#!/bin/bash

# Archivo donde se guardarán los resultados
output_file="tiempos_secuencial_python.txt"

# Limpiar el archivo si ya existe
> "$output_file"

# Ejecutar el programa 100 veces
for i in {1..100}; do
    python3 producto_escalar_secuencial.py >> "$output_file"
done

echo "Las 100 ejecuciones se han completado. Los resultados están en $output_file."
