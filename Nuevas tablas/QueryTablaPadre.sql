/* 
   Creado por: Nicolas Figueroa Gómez
   Nombre tabla: NTD_Precios
   Objetivo: ...
   Campos modificados: ...
   -- 
*/


SELECT 
    
    --area azul
    Tabu.codigo_unidad,      
    dpto,
    area_techada,
    area_libre,
    area_total,
    area_ajustada,
    --area verde claro
    dorm,
    vista,
    columna,
    tipo,
    piso,
    particular,
    --area verde oscuro
    dormh,
    vistah,
    columnah,
    tipoh,
    pisoh,
    particularh,

    precio_base_proforma_$ * (dormh + tipoh + pisoh) AS p_unit_ajustado_techada,

    (precio_base_proforma * (dormh + tipoh + pisoh) ) * 0.5 AS p_unit_ajustado_libre,


    CASE 
        WHEN area_ajustada = 0  THEN 0
        ELSE (CEIL(((area_techada * (precio_base_proforma * (dormh + tipoh + pisoh))) + (area_ajustada * (precio_base_proforma * (dormh + tipoh + pisoh)))) / 5) * 5) / area_ajustada
    END AS p_unit_total,

    precio_lista_$,
    separados,
    m2_separado,
    total_proyectado,

    lista,
    
    _status,
    Tabu.fecha_separacion,
    precio_venta_$,
    precio_lista_registrado,
    CASE
        WHEN Tabu.precio_lista_$ = precio_lista_registrado THEN 1
        ELSE 0
    END AS control_carga_precio,
    CASE
        WHEN _status = 'SEPARACION' THEN 'S'
        WHEN _status = 'DISPONIBLE' THEN 'D'
        WHEN _status = 'RESERVADO' THEN 'R'
        ELSE 'V'
    END AS inicial_status,

    Tabpro.cantidad_proformas,

    (precio_lista_$ * 0.95) AS descuento_maximo_ejecutivo,
    
    --(CEIL(((area_techada * (precio_base_proforma * (dormh + tipoh + pisoh))) + (area_ajustada * (precio_base_proforma * (dormh + tipoh + pisoh)))) / 5) * 5) / area_ajustada AS p_unit_total
    --(area_techada * (precio_base_proforma * (dormh + tipoh + pisoh)))
    --(area_ajustada * (precio_base_proforma * (dormh + tipoh + pisoh)))

    CASE 
        WHEN  area_ajustada = 0 OR total_proyectado = 0 THEN 0
        ELSE (total_proyectado / area_ajustada)
    END AS precio_m2_proyectado

FROM (
    SELECT
            unidades.codigo AS codigo_unidad,
            unidades.nombre AS dpto,
            unidades.area_techada,
            unidades.area_libre,
            unidades.area_total,
            unidades.area_techada + (unidades.area_libre * 0.5) AS area_ajustada,

            unidades.total_habitaciones AS dorm,
            
            (NULL) AS vista,

            (NULL) AS columna,

            unidades.tipo_unidad AS tipo,
            unidades.piso,
                        
            (NULL) AS particular,


            CASE
                WHEN unidades.total_habitaciones = 1 THEN 1.06
                WHEN unidades.total_habitaciones = 2 THEN 1.03
                WHEN unidades.total_habitaciones = 3 THEN 1.02
                WHEN unidades.total_habitaciones = 4 THEN 1
                ELSE 0
            END AS dormh,

            (NULL) AS vistah,
            (NULL) AS columnah,
      
            CASE
                WHEN unidades.tipo_unidad like '%duplex%' THEN 1
                WHEN unidades.tipo_unidad like '%flat%' THEN 1
                ELSE 0
            END AS tipoh,
            CASE
                WHEN unidades.piso in (1,2,16) THEN 1.050
                WHEN unidades.piso in (3,15) THEN 1.055
                WHEN unidades.piso in (4,14) THEN 1.060
                WHEN unidades.piso in (5,13) THEN 1.065
                WHEN unidades.piso in (6,12) THEN 1.070
                WHEN unidades.piso in (7,11) THEN 1.075
                WHEN unidades.piso in (8,10) THEN 1.080
                WHEN unidades.piso in (9) THEN 1.090
                WHEN unidades.piso = 17 THEN 1.045
                WHEN unidades.piso = 18 THEN 1.040
                WHEN unidades.piso = 19 THEN 1.035
                WHEN unidades.piso = 20 THEN 1.030
                WHEN unidades.piso = 21 THEN 1.025
                WHEN unidades.piso = 22 THEN 1.020
                WHEN unidades.piso = 23 THEN 1.020
                ELSE 0
            END AS pisoh,
            
            (NULL) AS particularh,

            unidades.precio_base_proforma,
            unidades.codigo_proyecto,
            unidades.tipo_unidad,
            unidades.nombre_tipologia,
            unidades.fecha_precio_actualizado,
            unidades.moneda_precio_lista,
            unidades.moneda_venta,
            unidades.fecha_separacion,
            unidades.total_banos as baños,
        

            CEIL(((area_techada * (precio_base_proforma * (dormh + tipoh + pisoh))) + (area_ajustada * (precio_base_proforma * (dormh + tipoh + pisoh)))) / 5) * 5 AS precio_perfil,


            CASE
                WHEN unidades.moneda_precio_lista = 'PEN' THEN unidades.precio_lista/3.80
                ELSE unidades.precio_lista
            END AS precio_lista_$,


            CASE
                WHEN unidades.moneda_venta = 'PEN' THEN precio_base_proforma/3.80
                ELSE precio_base_proforma
            END AS precio_base_proforma_$

            CASE
                WHEN unidades.estado_comercial = 'disponible' THEN 0
                ELSE unidades.precio_venta
            END AS separados,

            CASE
                WHEN unidades.estado_comercial = 'libre' THEN 0
                ELSE area_ajustada
            END AS m2_separado,


            CASE
                WHEN unidades.estado_comercial = 'disponible' OR unidades.estado_comercial = 'reservado' OR unidades.estado_comercial = 'bloqueado'  THEN precio_perfil
                ELSE unidades.precio_venta
            END AS total_proyectado,

            (NULL) lista,

            CASE
                WHEN unidades.estado_comercial = 'disponible' THEN 'DISPONIBLE'
                ELSE 'MINUTA'
            END AS _status,

            CASE
                WHEN unidades.moneda_venta = 'PEN' THEN unidades.precio_venta/3.80
                ELSE unidades.precio_venta
            END AS precio_venta_$,

            
            (NULL) AS precio_lista_registrado

            
FROM desarrolladora.unidades

) AS Tabu

INNER JOIN (

    SELECT 
        COUNT(proforma_unidad.codigo_proforma) AS cantidad_proformas,
        proforma_unidad.codigo_unidad

FROM desarrolladora.proforma_unidad
GROUP BY proforma_unidad.codigo_unidad

) AS Tabpro

ON Tabu.codigo_unidad = Tabpro.codigo_unidad



 