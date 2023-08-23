/* Nombre tabla: NTD_Proyectos
   Objetivo: Obtener los datos generales de los proyectos.
   Campos modificados: 
   -- estado:
        --objetivo: De acuerdo de codigo de proyecto, se agrupo por estado activo e inactivo.
   -- id_orden_cronologico:
        --objetivo: Se establece una fecha de acuerdo a la antiguedad del proyecto. Esto con
                    el fin de organizarlo en un grafico en power bi por orden de cronológico.
   
   Creado por: Nicolas Figueroa Gómez
*/

SELECT 
id AS [id_registro],
codigo AS [codigo_proyecto],
Nombre AS [nombre_proyecto],
CASE
        WHEN codigo = 'ANG' OR  codigo = 'ELESCOLA' OR codigo = 'DOR' OR codigo = 'PVIEJO5' OR codigo = 'SAL' OR codigo = 'CSA' OR codigo = 'PVIEJO4' THEN 'activo'
        WHEN codigo = 'ROSARIO' THEN 'Proyecto'
        ELSE 'cerrado'
END AS estado,

CASE
        WHEN codigo = 'ELESCOLA' THEN DATE '2023-03-01'
        WHEN codigo = 'DOR' THEN DATE '2023-04-01'
        WHEN codigo = 'PVIEJO5' THEN DATE '2023-08-01'
        WHEN codigo = 'PVIEJO2' THEN DATE '2023-06-01'
        WHEN codigo = 'PVIEJO3' THEN DATE '2023-05-01'
        WHEN codigo = 'SAL' THEN DATE '2023-07-01'
        WHEN codigo = 'CSA' THEN DATE '2023-02-01'
        WHEN codigo = 'PVIEJO4' THEN DATE '2023-01-01'
        ELSE DATE '2000-01-01'
END AS id_orden_cronologico,

direccion AS [direccion],
fecha_estimacion,
fecha_real,
latitud,
longitud,
pais,
departamento,
provincia,
distrito,
tipo_proyecto,
estado_construccion,
total_unidades,
unidades_vendidas,
moneda AS [codigo_moneda],
tasa_interes_mensual,
banco_promotor,
fecha_inicio_venta,
fecha_actualizacion
FROM desarrolladora.proyectos
ORDER BY id_orden_cronologico

