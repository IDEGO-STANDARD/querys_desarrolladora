/* 
   Creado por: Nicolas Figueroa Gómez
   Nombre tabla: NTD_UnidadesM
   Objetivo: Obtener 
   Campos modificados:
   -- No se modificaron ningun campo, todos son traidos de sperant.
*/


SELECT

    unidades.codigo AS codigo_unidad,
    unidades.codigo_proyecto,
    unidades.tipo_unidad,
    unidades.nombre_tipologia,
    unidades.area_libre,
    unidades.area_techada,
    unidades.area_total,
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
    
FROM desarrolladora.unidades 