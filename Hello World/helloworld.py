from mpi4py import MPI

N = 20
mensaje = bytearray(b' ' * N)  # Se inicializa el mensaje como un bytearray de tamaño N
root = 0

comm = MPI.COMM_WORLD
my_id = comm.Get_rank()
nproc = comm.Get_size()

if my_id == root:
    mensaje[:len("Hola mundo")] = b"Hola mundo"  # Copiar "Hola mundo" en el bytearray

# Transmitir el mensaje desde el proceso raíz
comm.Bcast(mensaje, root=root)

# Convertir el mensaje a una cadena para imprimir
print(f"Mensaje del proceso {my_id}: {mensaje.decode('utf-8').strip()}")
