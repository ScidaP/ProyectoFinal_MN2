#!/bin/bash

# Archivos donde se guardarán las salidas
SALIDAS_MPI="tiempos_c.txt"
SALIDAS_PYTHON="tiempos_python.txt"

# Limpia los archivos de salidas previos si existen
> $SALIDAS_MPI
> $SALIDAS_PYTHON

# Lista de números de procesadores
PROCESADORES=(2 4 6 8)

# Ejecuta el programa MPI en C
for NUM_PROC in "${PROCESADORES[@]}"; do
    echo -n "${NUM_PROC}_Proc_C = [" >> $SALIDAS_MPI
    for i in {1..100}; do 
        if [[ $NUM_PROC -eq 8 || $NUM_PROC -eq 6 ]]; then
            mpirun --oversubscribe -np $NUM_PROC ./producto_escalar >> $SALIDAS_MPI
        else
            mpirun -np $NUM_PROC ./producto_escalar >> $SALIDAS_MPI
        fi
    done
    echo -n "]" >> $SALIDAS_MPI
    echo "" >> $SALIDAS_MPI
done

echo "Resultados del programa MPI (C) guardados en $SALIDAS_MPI."

# Ejecuta el programa MPI en Python
for NUM_PROC in "${PROCESADORES[@]}"; do
    echo -n "${NUM_PROC}_Proc_Py = [" >> $SALIDAS_PYTHON
    for i in {1..100}; do
        if [[ $NUM_PROC -eq 8 || $NUM_PROC -eq 6 ]]; then
            mpiexec --oversubscribe -np $NUM_PROC python3 producto_escalar.py >> $SALIDAS_PYTHON
        else
            mpiexec -np $NUM_PROC python3 producto_escalar.py >> $SALIDAS_PYTHON
        fi
    done
    echo -n "]" >> $SALIDAS_PYTHON
    echo "" >> $SALIDAS_PYTHON
done

echo "Resultados del programa MPI (Python) guardados en $SALIDAS_PYTHON."

