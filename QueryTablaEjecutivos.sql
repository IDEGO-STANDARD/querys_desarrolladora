/* 
   Creado por: Nicolas Figueroa Gómez
   Nombre tabla: NTD_Ejecutivos
   Objetivo: Tener el codigo y nombre de los ejecutivos 
   Campos modificados: 
   -- codigo_nombre:
        --objetivo: Se utliza la funcion SUBSTRING para obtener las 7 primeros caracteres del campo nombres_usuario y asi obtener un codigo unico llamado codigo_nombre.
   -- actividad:
        --objetivo: organizar que ejecutivos estan activos y cuales estan inactivos. 
*/

SELECT DISTINCT
    SUBSTRING(procesos.nombres_usuario, 1, 7) AS codigo_nombre,
    procesos.nombres_usuario as nombre_ejecutivo,
    CASE
        WHEN procesos.nombres_usuario in ('Juan José Velasquez','Ivan Luque','Ricardo  Vasquez','Robinson Villegas','Orlando Poemape',
        'Lucas Prates','Andrea León','Sharon Alberca','Natalia Vinatea') THEN 'Activo'
        ELSE 'Inactivo'
    END AS actividad
FROM desarrolladora.procesos
