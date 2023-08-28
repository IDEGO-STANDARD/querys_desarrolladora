/* 
   Creado por: Nicolas Figueroa Gómez
   Nombre tabla: NTD_Unidades
   Objetivo: Obtener los datos generales de las unidades.
   Campos modificados: 
   -- precio_lista_S:
        --objetivo: De acuerdo de codigo de proyecto, se agrupo por estado activo e inactivo.
   -- precio_lista_$:
        --objetivo: Se establece una fecha de acuerdo a la antiguedad del proyecto. Esto con
                    el fin de organizarlo en un grafico en power bi por orden de cronológico.
   -- precio_venta_S:
        --objetivo: tasa de cambio del proyecto.
   -- precio_venta_$:
        --objetivo: factor de descuento por proyecto.
   -- descuento_venta_S
        --objetivo: tipo vivienda del proyecto. Este se clasifica en ...
   -- descuento_venta_$
        --objetivo: tipo de proyecto. Este se clasifica en ...
   -- precio_m2_S
        --objetivo: cantidad de unidades con tipo unidad igual a casa, departamento, local
                    comercial, oficina, penthouse, restaurante.
   -- precio_m2_$
        --objetivo: cantidad de unidades con tipo unidad igual a deposito, closet y
                    estacionamiento.
   -- precio_base_proforma_S
        --objetivo: precio base del proyecto dado en la proforma en soles.
   -- precio_base_proforma_$
        --objetivo: precio base de la unidad dado en la proforma en dolares, utilizando 3.80 como valor de cambio.
*/

SELECT

    unidades.codigo AS codigo_unidad,
    unidades.codigo_proyecto,
    unidades.codigo_proforma,
    unidades.tipo_unidad,
    unidades.estado_construccion,
    unidades.nombre_tipologia,
    unidades.area_libre,
    unidades.area_techada,
    unidades.area_total,
    unidades.estado_comercial,
    unidades.fecha_precio_actualizado,
    unidades.moneda_precio_lista,
    unidades.moneda_venta,
    unidades.fecha_separacion,

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