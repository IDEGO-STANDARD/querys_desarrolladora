/* 
   Creado por: Nicolas Figueroa Gómez
   Nombre tabla: NTD_ProyectosM
   Objetivo: Obtener los datos generales de los proyectos y otros datos como la tasa de cambio del proyecto, factor de descuento del proyecto, tipo de proyecto,
   entre otros.
   Campos modificados: 
   -- estado:
        --objetivo: De acuerdo de codigo de proyecto, se agrupo por estado activo e inactivo.
   -- id_orden_cronologico:
        --objetivo: Se establece una fecha de acuerdo a la antiguedad del proyecto. Esto con
                    el fin de organizarlo en un grafico en power bi por orden de cronológico.
   -- tc_usd:
        --objetivo: tasa de cambio del proyecto.
   -- fac_desc_proyecc:
        --objetivo: factor de descuento por proyecto.
   -- tipo_vivienda
        --objetivo: tipo vivienda del proyecto. Este se clasifica en ...
   -- tipo_proyecto
        --objetivo: tipo de proyecto. Este se clasifica en ...
   -- unidades_1
        --objetivo: cantidad de unidades con tipo unidad igual a casa, departamento, local
                    comercial, oficina, penthouse, restaurante.
   -- unidades_2
        --objetivo: cantidad de unidades con tipo unidad igual a deposito, closet y
                    estacionamiento.
*/

SELECT 
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

CASE
        WHEN codigo = 'ANG' OR  codigo = 'ELESCOLA' OR codigo = 'DOR' OR codigo = 'PVIEJO5' OR codigo = 'SAL' OR codigo = 'CSA' OR codigo = 'PVIEJO4' THEN 3.80
        --WHEN codigo = 'ROSARIO' THEN 'Proyecto'
        ELSE 0
END AS tc_usd,

CASE
        WHEN codigo = 'ANG' OR  codigo = 'ELESCOLA' OR codigo = 'DOR' OR codigo = 'PVIEJO5' OR codigo = 'SAL' OR codigo = 'CSA' OR codigo = 'PVIEJO4' THEN 0.10
        --WHEN codigo = 'ROSARIO' THEN 'Proyecto'
        ELSE 0
END AS fac_desc_proyecc,

CASE
        WHEN codigo = 'ANG' OR  codigo = 'ELESCOLA' OR codigo = 'DOR' OR codigo = 'PVIEJO5' OR codigo = 'SAL' OR codigo = 'CSA' OR codigo = 'PVIEJO4' THEN 'falta clasificar1'
        WHEN codigo = 'ROSARIO' THEN 'falta clasificar2'
        ELSE 'falta clasificar3'
END AS tipo_vivienda,

CASE
        WHEN codigo = 'ANG' OR  codigo = 'DOR' OR codigo = 'ELESCOLA' OR codigo = 'SAL' THEN 'Primera vivienda'
        WHEN codigo = 'PVIEJO4' OR codigo = 'CSA' OR codigo = 'PVIEJO2' OR codigo = 'PVIEJO5' OR codigo = 'PVIEJO3' or codigo = 'PVIEJO' THEN 'Segunda vivienda'
        ELSE 'falta clasificar3'

END AS tipo_proyecto,
direccion AS [direccion],
fecha_estimacion,
fecha_real,
latitud,
longitud,
pais,
departamento,
provincia,
distrito,
estado_construccion,
total_unidades,
unidades_vendidas,
unidades_1,
unidades_2,
moneda AS [codigo_moneda],
tasa_interes_mensual,
banco_promotor,
fecha_inicio_venta,
fecha_actualizacion
FROM desarrolladora.proyectos

LEFT JOIN (
    SELECT
        unidades.codigo_proyecto,
        COUNT(unidades.codigo) AS unidades_1
    
    FROM desarrolladora.unidades 
    WHERE unidades.tipo_unidad like '%casa%' OR  unidades.tipo_unidad like '%departamento%' OR  unidades.tipo_unidad like '%local comercial%' OR
    unidades.tipo_unidad like '%oficina%' OR  unidades.tipo_unidad like '%penthouse%' OR  unidades.tipo_unidad like '%restaurante%'
    GROUP BY unidades.codigo_proyecto
) AS tabun1
ON codigo = tabun1.codigo_proyecto

LEFT JOIN (
    SELECT
        unidades.codigo_proyecto,
        COUNT(unidades.codigo) AS unidades_2
    
    FROM desarrolladora.unidades 
    WHERE unidades.tipo_unidad like '%depósito%' OR  unidades.tipo_unidad like '%closet%' OR unidades.tipo_unidad like '%estacionamiento%'
    GROUP BY unidades.codigo_proyecto

) AS tabun2

ON codigo = tabun2.codigo_proyecto
ORDER BY id_orden_cronologico
