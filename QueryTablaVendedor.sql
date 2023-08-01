SELECT DISTINCT
    SUBSTRING(procesos.nombres_usuario, 1, 7) AS codigo_nombre,
    procesos.nombres_usuario as nombre_ejecutivo,
    CASE
        WHEN procesos.nombres_usuario in ('Juan José Velasquez','Ivan Luque','Ricardo  Vasquez','Robinson Villegas','Orlando Poemape',
        'Lucas Prates','Andrea León','Sharon Alberca','Natalia Vinatea') THEN 'Activo'
        ELSE 'Inactivo'
    END AS actividad
FROM desarrolladora.procesos

