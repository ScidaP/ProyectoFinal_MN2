from mpi4py import MPI
from decimal import Decimal

N = 20
mensaje = bytearray(b' ' * N)  # Se inicializa el mensaje como un bytearray de tamaño N
root = 0

start_time = MPI.Wtime()
comm = MPI.COMM_WORLD
my_id = comm.Get_rank()
nproc = comm.Get_size()

if my_id == root:
    mensaje[:len("Hola mundo")] = b"Hola mundo"  # Copiar "Hola mundo" en el bytearray

# Transmitir el mensaje desde el proceso raíz
comm.Bcast(mensaje, root=root)

# Convertir el mensaje a una cadena para imprimir
print(f"Mensaje del proceso {my_id}: {mensaje.decode('utf-8').strip()}")

end_time = MPI.Wtime()
execution_time = end_time - start_time
total_execution_time = comm.reduce(execution_time, op=MPI.MAX, root=0)

# El proceso raíz (0) imprime el tiempo total de ejecución
if my_id == 0:
    print(f"Tiempo total de ejecución: {total_execution_time} segundos")