/* 
   Creado por: Nicolas Figueroa Gómez
   Nombre tabla: NTD_UnidadesC
   Objetivo: Obtener datos de las unidades como son los precios, numero de proformas, entre otros.
   Campos modificados: 

   -- precio_lista_S:
        --objetivo: 
   -- precio_lista_$:
        --objetivo: 
   -- precio_venta_S:
        --objetivo: 
   -- precio_venta_$:
        --objetivo: 
   -- descuento_venta_S
        --objetivo: 
   -- descuento_venta_$
        --objetivo: 
   -- precio_m2_S
        --objetivo: 
   -- precio_m2_$
        --objetivo: 
   -- precio_base_proforma_S
        --objetivo: 
   -- precio_base_proforma_$
        --objetivo: 
   -- nro_proformas
        --objetivo: 
*/


SELECT

    Tab1.codigo_unidad,
    Tab1.codigo_proyecto,
    Tab1.codigo_proforma,
    Tab1.tipo_unidad,
    Tab1.nombre_tipologia,
    Tab1.area_libre,
    Tab1.area_techada,
    Tab1.area_total,
    Tab1.estado_comercial,
    Tab1.fecha_precio_actualizado,
    Tab1.moneda_precio_lista,
    Tab1.moneda_venta,
    Tab1.fecha_separacion,
    Tab1.fecha_reserva,
    Tab1.fecha_venta,
    Tab1.fecha_entrega,
    Tab1.fecha_inicio_independizacion,
    Tab1.fecha_fin_independizacion,
    Tab1.modalidad_contrato,
    Tab1.precio_lista_S,
    Tab1.precio_lista_$,
    Tab1.precio_venta_S,
    Tab1.precio_venta_$,
    Tab1.descuento_venta_S,
    Tab1.descuento_venta_$,
    Tab1.precio_m2_S,
    Tab1.precio_m2_$,
    Tab1.precio_base_proforma_S,
    Tab1.precio_base_proforma_$,

    Tab2.nro_proformas

    FROM (
        SELECT

                unidades.codigo AS codigo_unidad,
                unidades.codigo_proyecto,
                unidades.codigo_proforma,
                unidades.tipo_unidad,
                unidades.nombre_tipologia,
                unidades.area_libre,
                unidades.area_techada,
                unidades.area_total,
                unidades.estado_comercial,
                unidades.fecha_precio_actualizado,
                unidades.moneda_precio_lista,
                unidades.moneda_venta,
                unidades.fecha_separacion,

                unidades.fecha_reserva,
                unidades.fecha_venta,
                unidades.fecha_entrega,
                unidades.fecha_inicio_independizacion,
                unidades.fecha_fin_independizacion,
                unidades.modalidad_contrato,

                CASE
                    WHEN unidades.moneda_precio_lista = 'USD' THEN precio_lista*3.80
                    ELSE precio_lista
                END AS [precio_lista_S],
                CASE
                    WHEN unidades.moneda_precio_lista = 'PEN' THEN precio_lista/3.80
                    ELSE precio_lista
                END AS precio_lista_$,

                CASE
                    WHEN unidades.moneda_venta = 'USD' THEN precio_venta*3.80
                    ELSE precio_venta
                END AS precio_venta_S,
                CASE
                    WHEN unidades.moneda_venta = 'PEN' THEN precio_venta/3.80
                    ELSE precio_venta
                END AS precio_venta_$,

                CASE
                    WHEN unidades.moneda_venta = 'USD' THEN descuento_venta*3.80
                    ELSE descuento_venta
                END AS descuento_venta_S,
                CASE
                    WHEN unidades.moneda_venta = 'PEN' THEN descuento_venta/3.80
                    ELSE descuento_venta
                END AS descuento_venta_$,

                CASE
                    WHEN unidades.moneda_venta = 'USD' THEN precio_m2*3.80
                    ELSE precio_m2
                END AS precio_m2_S,
                CASE
                    WHEN unidades.moneda_venta = 'PEN' THEN precio_m2/3.80
                    ELSE precio_m2
                END AS precio_m2_$,

                CASE
                    WHEN unidades.moneda_venta = 'USD' THEN precio_base_proforma*3.80
                    ELSE precio_base_proforma
                END AS precio_base_proforma_S,
                CASE
                    WHEN unidades.moneda_venta = 'PEN' THEN precio_base_proforma/3.80
                    ELSE precio_base_proforma
                END AS precio_base_proforma_$

                FROM desarrolladora.unidades

    ) AS Tab1

INNER JOIN (

    SELECT  
            proforma_unidad.codigo_unidad,
            COUNT(proforma_unidad.codigo_proforma) AS nro_proformas

    FROM desarrolladora.proforma_unidad
    GROUP BY codigo_unidad

) AS Tab2

ON Tab1.codigo_unidad = Tab2.codigo_unidad
