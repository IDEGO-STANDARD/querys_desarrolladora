--Actualizado con el ultimo campo de traer el numero de clientes que han proformado por proyecto.
SELECT 
    --id AS [id_registro],
    codigo AS [codigo_proyecto],
    Nombre AS [nombre_proyecto],
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
    valor_venta_usd,
    tabdispproyec.vv_proyectada_usd,
    tabventas.precio_venta_totales,
    unidades_1_venta,
    unidades_1_disp,
    unidades_2_venta,
    unidades_2_disp,
    m2_vendidos,
    m2_disponible,
    CASE
        WHEN unidades_1_velocidad_venta * 1.0 / (EXTRACT(MONTH FROM GETDATE()) - 1) - FLOOR(unidades_1_velocidad_venta * 1.0 / (EXTRACT(MONTH FROM GETDATE()) - 1)) >= 0.5 THEN CEILING(unidades_1_velocidad_venta * 1.0 / (EXTRACT(MONTH FROM GETDATE()) - 1))
        WHEN unidades_1_velocidad_venta IS NULL THEN 0
        ELSE FLOOR(unidades_1_velocidad_venta * 1.0 / (EXTRACT(MONTH FROM GETDATE()) - 1))
    END AS velocidad_venta,
    tabnumprof.numero_clientes_proformados

FROM desarrolladora.proyectos

LEFT JOIN (
    --Query para sacar la cantidad de unidades primarias --Número de unidades primarias (Departamento o Casas)
    SELECT
        tab0.codigo_proyecto,
        SUM(tab0.precio_venta) AS valor_venta_usd
        --SUM(tab0.precio_lista_descontado) AS vv_proyectada_usd
    FROM (

        SELECT
            unidades.codigo_proyecto,
            CASE
                WHEN unidades.moneda_venta = 'PEN' THEN (unidades.precio_venta / 3.81)
                ELSE unidades.precio_venta
            END AS precio_venta
            
        FROM desarrolladora.unidades
    ) AS tab0    
    GROUP BY tab0.codigo_proyecto
) AS tabun1
ON codigo = tabun1.codigo_proyecto


LEFT JOIN (
    SELECT
        unidades.codigo_proyecto,
        COUNT(unidades.codigo) AS unidades_1_venta
        --unidades.fecha_venta
        --(COUNT(unidades.codigo) / (MONTH(GETDATE()) - 1)) AS velocidad_venta
    FROM desarrolladora.unidades 
    --RECUENTO DEL CODIGO_UNIDAD PARA LOS ESTADOS <> DISPONIBLE, NO DISPONIBLE, PRE ASIGNADO DEL PROYECTO EN TABLA UNIDADES
    WHERE (unidades.estado_comercial not like '%disponible%' AND  unidades.estado_comercial not like '%pre-asignado%' 
    AND  unidades.estado_comercial not like '%no disponible%')
    AND (unidades.tipo_unidad like '%casa%' OR  unidades.tipo_unidad like '%departamento%' OR  unidades.tipo_unidad like '%local comercial%' OR
    unidades.tipo_unidad like '%oficina%' OR  unidades.tipo_unidad like '%penthouse%' OR  unidades.tipo_unidad like '%restaurante%')
    GROUP BY unidades.codigo_proyecto
) AS tabventa
ON codigo = tabventa.codigo_proyecto

LEFT JOIN (
    SELECT
        unidades.codigo_proyecto,
        CASE
                WHEN COUNT(unidades.codigo) IS NULL THEN 0
                ELSE COUNT(unidades.codigo)
        END AS unidades_1_velocidad_venta
        --COUNT(unidades.codigo) AS unidades_1_velocidad_venta
        --unidades.fecha_venta
        --(COUNT(unidades.codigo) / (MONTH(GETDATE()) - 1)) AS velocidad_venta
    FROM desarrolladora.unidades 
    --RECUENTO DEL CODIGO_UNIDAD PARA LOS ESTADOS <> DISPONIBLE, NO DISPONIBLE, PRE ASIGNADO DEL PROYECTO EN TABLA UNIDADES
    WHERE (unidades.estado_comercial not like '%disponible%' AND  unidades.estado_comercial not like '%pre-asignado%' 
    AND  unidades.estado_comercial not like '%no disponible%')
    AND (unidades.tipo_unidad like '%casa%' OR  unidades.tipo_unidad like '%departamento%' OR  unidades.tipo_unidad like '%local comercial%' OR
    unidades.tipo_unidad like '%oficina%' OR  unidades.tipo_unidad like '%penthouse%' OR  unidades.tipo_unidad like '%restaurante%')
    AND (fecha_separacion >= '01-01-2023')
    GROUP BY unidades.codigo_proyecto
) AS tabventavelocidad
ON codigo = tabventavelocidad.codigo_proyecto

LEFT JOIN (
    SELECT
        unidades.codigo_proyecto,
        COUNT(unidades.codigo) AS unidades_1_disp
        
    
    FROM desarrolladora.unidades 
    --RECUENTO DEL CODIGO_UNIDAD PARA LOS ESTADOS = DISPONIBLE, NO DISPONIBLE, PRE ASIGNADO DEL PROYECTO EN TABLA UNIDADES
    WHERE ( unidades.estado_comercial like '%disponible%' OR  unidades.estado_comercial like '%pre-asignado%' OR  unidades.estado_comercial like '%no disponible%')    
    AND (unidades.tipo_unidad like '%casa%' OR  unidades.tipo_unidad like '%departamento%' OR  unidades.tipo_unidad like '%local comercial%' OR
    unidades.tipo_unidad like '%oficina%' OR  unidades.tipo_unidad like '%penthouse%' OR  unidades.tipo_unidad like '%restaurante%')
    
    GROUP BY unidades.codigo_proyecto
) AS tabdisp
ON codigo = tabdisp.codigo_proyecto

LEFT JOIN (
    SELECT
        sub.codigo_proyecto,
        SUM(sub.precio_lista_convertido) AS vv_proyectada_usd
    FROM (

        SELECT
            unidades.codigo_proyecto,  
            CASE
                WHEN unidades.moneda_precio_lista = 'PEN' THEN (unidades.precio_lista / 3.80)
                ELSE unidades.precio_lista
            END AS precio_lista_convertido
        FROM desarrolladora.unidades
        --RECUENTO DEL CODIGO_UNIDAD PARA LOS ESTADOS = DISPONIBLE, NO DISPONIBLE, PRE ASIGNADO DEL PROYECTO EN TABLA UNIDADES
        WHERE ( unidades.estado_comercial like '%disponible%' OR  unidades.estado_comercial like '%pre-asignado%' OR  unidades.estado_comercial like '%no disponible%')
    ) AS sub
    GROUP BY sub.codigo_proyecto
) AS tabdispproyec
ON codigo = tabdispproyec.codigo_proyecto

LEFT JOIN (
    SELECT
        sub.codigo_proyecto,
        SUM(sub.precio_venta_convertido) AS precio_venta_totales
    FROM 
        (SELECT
            unidades.codigo_proyecto,
            CASE
                WHEN unidades.moneda_venta = 'PEN' THEN (unidades.precio_venta / 3.80)
                ELSE unidades.precio_venta
            END AS precio_venta_convertido
        FROM desarrolladora.unidades 
        WHERE (unidades.estado_comercial NOT LIKE '%disponible%' AND unidades.estado_comercial NOT LIKE '%pre-asignado%' 
        AND unidades.estado_comercial NOT LIKE '%no disponible%')) as sub
    GROUP BY sub.codigo_proyecto
) AS tabventas
ON codigo = tabventas.codigo_proyecto

LEFT JOIN (
    SELECT
        unidades.codigo_proyecto,
        COUNT(unidades.codigo) AS unidades_2_venta
    
    FROM desarrolladora.unidades 
    --RECUENTO DEL CODIGO_UNIDAD PARA LOS ESTADOS <> DISPONIBLE, NO DISPONIBLE, PRE ASIGNADO DEL PROYECTO EN TABLA UNIDADES
    WHERE (unidades.estado_comercial not like '%disponible%' AND  unidades.estado_comercial not like '%pre-asignado%' 
    AND unidades.estado_comercial not like '%no disponible%')
    AND (unidades.tipo_unidad like '%depósito%' OR  unidades.tipo_unidad like '%closet%' OR unidades.tipo_unidad like '%estacionamiento%')
    GROUP BY unidades.codigo_proyecto
) AS tabventa2
ON codigo = tabventa2.codigo_proyecto

LEFT JOIN (
    SELECT
        unidades.codigo_proyecto,
        COUNT(unidades.codigo) AS unidades_2_disp
    
    FROM desarrolladora.unidades 
    --RECUENTO DEL CODIGO_UNIDAD PARA LOS ESTADOS = DISPONIBLE, NO DISPONIBLE, PRE ASIGNADO DEL PROYECTO EN TABLA UNIDADES
    WHERE (unidades.estado_comercial like '%disponible%' OR  unidades.estado_comercial like '%pre-asignado%' OR  unidades.estado_comercial like '%no disponible%' )   
    AND (unidades.tipo_unidad like '%depósito%' OR  unidades.tipo_unidad like '%closet%' OR unidades.tipo_unidad like '%estacionamiento%')
    GROUP BY unidades.codigo_proyecto
) AS tabdisp2
ON codigo = tabdisp2.codigo_proyecto

--Filtro de unidades 1, unidades primarias
LEFT JOIN (
    SELECT
        unidades.codigo_proyecto,
        SUM(unidades.area_total) AS m2_vendidos_1
    
    FROM desarrolladora.unidades 
    --RECUENTO DEL CODIGO_UNIDAD PARA LOS ESTADOS <> DISPONIBLE, NO DISPONIBLE, PRE ASIGNADO DEL PROYECTO EN TABLA UNIDADES
    WHERE( unidades.estado_comercial not like '%disponible%' AND  unidades.estado_comercial not like '%pre-asignado%' 
    AND  unidades.estado_comercial not like '%no disponible%') 
    AND (unidades.tipo_unidad like '%casa%' OR  unidades.tipo_unidad like '%departamento%' OR  unidades.tipo_unidad like '%local comercial%' OR
    unidades.tipo_unidad like '%oficina%' OR  unidades.tipo_unidad like '%penthouse%' OR  unidades.tipo_unidad like '%restaurante%')

    GROUP BY unidades.codigo_proyecto
) AS tabm2vendidos_1
ON codigo = tabm2vendidos_1.codigo_proyecto


LEFT JOIN (
    SELECT
        unidades.codigo_proyecto,
        SUM(unidades.area_total) AS m2_vendidos
    
    FROM desarrolladora.unidades 
    --RECUENTO DEL CODIGO_UNIDAD PARA LOS ESTADOS <> DISPONIBLE, NO DISPONIBLE, PRE ASIGNADO DEL PROYECTO EN TABLA UNIDADES
    WHERE( unidades.estado_comercial not like '%disponible%' AND  unidades.estado_comercial not like '%pre-asignado%' 
    AND  unidades.estado_comercial not like '%no disponible%')
    GROUP BY unidades.codigo_proyecto
) AS tabm2vendidos
ON codigo = tabm2vendidos.codigo_proyecto


LEFT JOIN (
    SELECT
        unidades.codigo_proyecto,
        SUM(unidades.area_total) AS m2_disponible
    
    FROM desarrolladora.unidades 
    --RECUENTO DEL CODIGO_UNIDAD PARA LOS ESTADOS = DISPONIBLE, NO DISPONIBLE, PRE ASIGNADO DEL PROYECTO EN TABLA UNIDADES
    WHERE unidades.estado_comercial like '%disponible%' OR  unidades.estado_comercial like '%pre-asignado%' OR  unidades.estado_comercial like '%no disponible%'    
    GROUP BY unidades.codigo_proyecto
) AS tabm2disponible
ON codigo = tabm2disponible.codigo_proyecto


LEFT JOIN (
    --Obtengo la cantidad de clientes proformados por proyecto
    SELECT 
            subtab.codigo_proyecto,
            --subtab.codigo_proforma,
            --subtab.documento_cliente,
            COUNT(subtab.documento_cliente) AS numero_clientes_proformados

    FROM (

        SELECT
            proforma_unidad.codigo_proyecto,
            --proforma_unidad.codigo_unidad,
            --proforma_unidad.codigo_proforma,
            proforma_unidad.documento_cliente
            --COUNT(proforma_unidad.documento_cliente) AS numero_proformas
    FROM desarrolladora.proforma_unidad
    GROUP BY proforma_unidad.codigo_proyecto, proforma_unidad.documento_cliente
    ) AS subtab
    GROUP BY subtab.codigo_proyecto
) AS tabnumprof

ON codigo = tabnumprof.codigo_proyecto

ORDER BY id_orden_cronologico
