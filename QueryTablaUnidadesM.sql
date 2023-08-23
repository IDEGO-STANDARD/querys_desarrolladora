SELECT

    unidades.codigo AS codigo_unidad,
    unidades.codigo_proyecto,
    --unidades.codigo_proforma,
    unidades.tipo_unidad,
    --unidades.estado_construccion,
    unidades.nombre_tipologia,
    unidades.area_libre,
    unidades.area_techada,
    unidades.area_total,
    --unidades.estado_comercial,
    --unidades.precio_lista,
    --unidades.precio_base_proforma,
    --unidades.descuento_venta,
    --unidades.precio_venta,
    --unidades.precio_m2,
    unidades.fecha_precio_actualizado,
    unidades.moneda_precio_lista,
    unidades.moneda_venta,
    unidades.fecha_separacion,
    unidades.total_habitaciones as dormitorios,
    unidades.total_banos as baños,
    unidades.piso

    --Falta campos:
    -- unidades.vista
    -- unidades.columnas
    /*
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

    */

FROM desarrolladora.unidades 