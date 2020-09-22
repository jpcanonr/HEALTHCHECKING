# HEALTHCHECKING
 Health Check para WMQ, WMB e IIB

# Instrucciones Script WMQ

1. Usar usuario mqm
2. Pasar archivo 'HEALTHCHECKING.tar.gz' a la ruta /admin/IBM/scripts de la máquina
3. Descomprimir con el comando 'tar -xvf HEALTHCHECKING.tar.gz'
4. Se descomprime una carpeta 'HEALTHCHECKING'
   Verificar que el owner y group es mqm
   Si no, asignar permisos a la carpeta y archivos 'chown mqm:mqm ARCHIVO'
5. Verificar permisos de ejecución. Se asignan con 'chmod 750 ARCHIVO'
6. En la carpeta hay 3 archivos:
   hcmq.sh: Ejecutable
   hcmqini.paths: Rutas archivos qm.ini
   hcmqssl.paths: Rutas KeyStores
7. Ejecutar Script './hcmq.sh'
8. El script comienza con el mensaje:
    "Inicio Script Health Checking WMQ"
y finaliza con el mensaje:
    "Reporte generado: /admin/IBM/scripts/HEALTHCHECKING/Nombre del Reporte"
    "Fin Script Health Checking WMQ"
8. Se genera un archivo de texto de salida con fecha y hora en la ruta: /admin/IBM/scripts/HEALTHCHECKING


NOTA: Si el script se demora más de lo usual ejecutarlo como
    bash -x hcmq.sh
Para ejecutar en modo debug y ver el proceso de ejecución.
