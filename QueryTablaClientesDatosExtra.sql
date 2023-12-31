SELECT 

        TabProcesos.codigo_proyecto,
        TabProforma_unidad.codigo_proforma AS codigo_proforma_proforma,
        TabProcesos.codigo_unidad,
        TabProcesos.tipo_unidad_principal,
        TabProcesos.[ejecutivo],
        TabProcesos.fecha_reserva, 
        TabProcesos.fecha_aprobacion, 
        TabProcesos.fecha_separacion, 
        TabProcesos.fecha_venta, 
        TabProcesos.fecha_escritura_publica, 
        TabProcesos.fecha_entrega, 
        TabProcesos.fecha_anulacion,
        TabProcesos.fecha_estado_comercial,
        TabClientes.nivel_interes,
        TabClientes.fecha_creacion,
        TabClientes.nombres,
        TabClientes.apellidos,
        TabClientes.tipo_documento,
        TabClientes.documento,
        TabClientes.genero,
        TabClientes.estado_civil,
        TabClientes.email,
        TabClientes.telefono,
        TabClientes.celular,
        TabClientes.agrupacion_medio_captacion,
        TabClientes.medio_captacion,
        TabClientes.canal_entrada,
        TabClientes.fecha_nacimiento,
        TabClientes.nacionalidad,
        TabClientes.pais,
        TabClientes.departamento,
        TabClientes.provincia,
        TabClientes.distrito,
        TabClientes.direccion,
        TabClientes.apto,
        TabClientes.observacion,
        TabClientes.ocupacion,
        TabClientes.documento_conyuge,
        TabClientes.usuario_creador,
        TabClientes.username,
        TabClientes.estado,
        TabClientes.ultimo_proyecto,
        TabClientes.total_unidades_asignadas,
        TabClientes.ultimo_vendedor,
        TabClientes.total_interacciones,
        TabClientes.fecha_ultima_interaccion,
        TabClientes.proyectos_relacionados,
        TabClientes.codigo_externo_cliente,
        TabClientes.rango_edad,
        TabClientes.origen,
        TabClientes.ultimo_tipo_interaccion,
        TabClientes.fecha_actualizacion,
        TabClientes.autorizacion_uso_datos,
        TabClientes.autorizacion_publicidad,
        TabClientes.geo_latitud,
        TabClientes.geo_longitud,
        TabClientes.geolocalizacion,
        TabClientes.cliente_riesgo,
        TabClientes.agrupacion_canal_entrada,
        TabClientes.tipo_persona,
        TabClientes.denominacion,
        TabClientes.tipo_financiamiento,
        TabClientes.anio_ultinteraccion,
        TabClientes.anio_creacion,
        CASE
            WHEN TabProcesos.codigo_proforma IS NOT NULL AND TabProforma_unidad.codigo_proforma IS NOT NULL THEN TabProcesos.estado_comercial
            WHEN TabProforma_unidad.codigo_proforma IS NOT NULL AND TabProcesos.codigo_proforma IS NULL THEN 'Proformado'
            WHEN TabProforma_unidad.codigo_proforma IS NULL THEN 'No proformado'
            ELSE 'No proformado'
        END AS estado_comercial,
        TabProforma_unidad.estado_proforma

FROM (

    SELECT 
        TabL.codigo_proyecto,
        TabL.codigo_proforma,
        TabL.tipo_unidad_principal,
        TabL.codigo_unidad,
        TabL.total_unidades,
        TabL.nombres_cliente,
        TabL.apellidos_cliente,
        TabL.documento_cliente,
        TabL.moneda,
        TabL.tipo_financiamiento,
        TabL.banco,
        TabL.[ejecutivo],
        TabL.precio_base_proforma,
        TabL.descuento_venta,
        TabL.precio_venta,
        TabL.total_pagado,
        TabL.total_pendiente,
        TabL.documento_copropietarios,
        TabL.fecha_reserva, 
        TabL.fecha_aprobacion, 
        TabL.fecha_separacion, 
        TabL.fecha_venta, 
        TabL.fecha_escritura_publica, 
        TabL.fecha_entrega, 
        TabL.fecha_anulacion,
        TabL.estado_comercial,
        TabL.fecha_estado_comercial,
        TabL.dias_venta,
        TabL.dias_escriturapublica,
        TabL.diferencia_dias_entre_venta_escriturapublica
FROM (

SELECT 

    TabPivot.codigo_proyecto,
    TabPivot.codigo_proforma,
    TabPivot.tipo_unidad_principal,
    TabPivot.codigo_unidad,
    TabPivot.total_unidades,
    TabPivot.nombres_cliente,
    TabPivot.apellidos_cliente,
    TabPivot.documento_cliente,
    TabPivot.moneda,
    TabPivot.tipo_financiamiento,
    TabPivot.banco,
    TabPivot.[ejecutivo],
    TabPivot.precio_base_proforma,
    TabPivot.descuento_venta,
    TabPivot.precio_venta,

    TabPivot.total_pagado,
    TabPivot.total_pendiente,

    TabPivot.documento_copropietarios,

    fecha_reserva, 
    fecha_aprobacion, 
    fecha_separacion, 
    fecha_venta, 
    fecha_escritura_publica, 
    fecha_entrega, 
    fecha_anulacion,
    dias_venta,
    dias_escriturapublica,
    diferencia_dias_entre_venta_escriturapublica,

    CASE
            WHEN Tab2.nombre_flujo_ultimo_estado IS NULL THEN Tab3.nombre_flujo_ultimo_estado
            ELSE Tab2.nombre_flujo_ultimo_estado
    END AS estado_comercial,

    CASE
            WHEN Tab2.fecha_ultimo_estado IS NULL THEN Tab3.fecha_ultimo_estado
            ELSE Tab2.fecha_ultimo_estado
    END AS fecha_estado_comercial

FROM (

SELECT 
    PivotTable.codigo_proyecto,
    PivotTable.codigo_proforma,
    PivotTable.tipo_unidad_principal,
    PivotTable.codigo_unidad,
    PivotTable.total_unidades,
    PivotTable.nombres_cliente,
    PivotTable.apellidos_cliente,
    PivotTable.documento_cliente,
    PivotTable.moneda,
    PivotTable.tipo_financiamiento,
    PivotTable.banco,
    PivotTable.[ejecutivo],
    PivotTable.precio_base_proforma,
    PivotTable.descuento_venta,
    PivotTable.precio_venta,
    [Reserva] AS fecha_reserva, 
    [Aprobacion] AS fecha_aprobacion, 
    [Separacion] AS fecha_separacion, 
    [Venta] AS fecha_venta, 
    [EscrituraPública] AS fecha_escritura_publica, 
    [Entrega]  AS fecha_entrega, 
    [Anulacion] AS fecha_anulacion,
    PivotTable.documento_copropietarios,

    DATEPART(day, Venta) AS dias_venta,
    DATEPART(day, EscrituraPública) AS dias_escriturapublica,
    CASE
            WHEN ( fecha_venta::date - EscrituraPública::date ) < 0 THEN ( fecha_venta::date - EscrituraPública::date ) * -1
            WHEN  fecha_venta::date IS NULL OR EscrituraPública::date IS NULL THEN 0
            ELSE (fecha_venta::date - EscrituraPública::date)
    END AS diferencia_dias_entre_venta_escriturapublica,

    ultimo_total_pagado.total_pagado,
    ultimo_total_pendiente.total_pendiente
        
FROM (
    SELECT
        procesos.codigo_proyecto,
        procesos.nombre_proyecto,
        procesos.tipo_unidad_principal,
        procesos.codigo_unidad,
        procesos.total_unidades,
        procesos.nombres_cliente,
        procesos.apellidos_cliente,
        procesos.documento_cliente,
        procesos.codigo_proforma,
        procesos.moneda,
        procesos.tipo_financiamiento,
        procesos.banco,
        procesos.nombres_usuario AS [ejecutivo],
        procesos.precio_base_proforma,
        procesos.descuento_venta,
        procesos.precio_venta,
        procesos.documento_copropietarios,
        procesos.fecha_fin,
        procesos.fecha_inicio,
        procesos.fecha_anulacion,
        CASE
            WHEN procesos.nombre IN ('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 'EscrituraPública'
            ELSE procesos.nombre
        END AS estado_proceso
        
    FROM desarrolladora.procesos
   
) AS tab1
PIVOT 
(
    MAX(
        CASE
            WHEN estado_proceso = 'Separacion' THEN fecha_inicio
            WHEN estado_proceso = 'Anulacion' THEN fecha_anulacion
            ELSE fecha_fin
        END) 

    FOR estado_proceso IN ('Reserva', 'Aprobacion', 'Separacion', 'Venta', 'EscrituraPública', 'Entrega', 'Anulacion')
) AS PivotTable


LEFT JOIN (
    SELECT 
           procesos.codigo_proyecto,
           procesos.codigo_unidad,
           procesos.codigo_proforma,
           --Convertir a dolares por el campo moneda
            CASE
                WHEN procesos.moneda = 'PEN' THEN MAX(total_pagado) / 3.80
                ELSE MAX(total_pagado)
            END AS total_pagado
    FROM desarrolladora.procesos
    GROUP BY procesos.codigo_proyecto, procesos.codigo_unidad, procesos.codigo_proforma,procesos.moneda
) AS ultimo_total_pagado 
ON PivotTable.codigo_proyecto = ultimo_total_pagado.codigo_proyecto
AND PivotTable.codigo_unidad = ultimo_total_pagado.codigo_unidad
AND PivotTable.codigo_proforma = ultimo_total_pagado.codigo_proforma

LEFT JOIN (
    SELECT 
           procesos.codigo_proyecto,
           procesos.codigo_unidad,
           procesos.codigo_proforma,
           CASE
                WHEN procesos.moneda = 'PEN' THEN MAX(total_pendiente) / 3.80
                ELSE MAX(total_pendiente)
           END AS total_pendiente
    FROM desarrolladora.procesos
    GROUP BY procesos.codigo_proyecto, procesos.codigo_unidad, procesos.codigo_proforma,procesos.moneda
) AS ultimo_total_pendiente 

ON PivotTable.codigo_proyecto = ultimo_total_pendiente.codigo_proyecto
AND PivotTable.codigo_unidad = ultimo_total_pendiente.codigo_unidad
AND PivotTable.codigo_proforma = ultimo_total_pendiente.codigo_proforma

) AS TabPivot


LEFT JOIN ( 

    SELECT 
        subconsulta.codigo_proyecto,
        subconsulta.codigo_proforma,
        estado_proceso AS nombre_flujo_ultimo_estado,
        subconsulta.fecha_inicio AS fecha_ultimo_estado
       
FROM (
    SELECT 
        codigo_proyecto,
        nombre_proyecto,
        tipo_unidad_principal,
        codigo_unidad,
        total_unidades,
        codigo_unidades_asignadas,
        nombres_cliente,
        apellidos_cliente,
        documento_cliente,
        codigo_proforma,
        moneda,
        tipo_financiamiento,
        banco,
        ejecutivo,
        precio_base_proforma,
        descuento_venta,
        precio_venta,
        estado_proceso,
        importancia_flujo,
        fecha,
        actividad_proceso,
        total_pagado,
        total_pendiente,
        estado_contrato,
        fecha_inicio,
        fecha_actualizacion,
        ROW_NUMBER() OVER (PARTITION BY codigo_proforma ORDER BY codigo_proyecto, codigo_proforma, fecha_inicio, importancia_flujo) AS numero_flujo
    FROM (
        SELECT
            procesos.codigo_proyecto,
            procesos.nombre_proyecto,
            procesos.tipo_unidad_principal,
            procesos.codigo_unidad,
            procesos.total_unidades,
            procesos.codigo_unidades_asignadas,
            procesos.nombres_cliente,
            procesos.apellidos_cliente,
            procesos.documento_cliente,
            procesos.codigo_proforma,
            procesos.moneda,
            procesos.tipo_financiamiento,
            procesos.banco,
            procesos.nombres_usuario AS ejecutivo,
            procesos.precio_base_proforma,
            procesos.descuento_venta,
            procesos.precio_venta,
            CASE
                WHEN procesos.nombre IN ('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 'Escritura Pública'
                ELSE procesos.nombre
            END AS estado_proceso,
            CASE
                WHEN procesos.nombre = 'Reserva' THEN 1
                WHEN procesos.nombre = 'Separacion' THEN 2
                WHEN procesos.nombre = 'Aprobacion' THEN 3
                WHEN procesos.nombre = 'Venta' THEN 4
                WHEN procesos.nombre in('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 5
                WHEN procesos.nombre = 'Entrega' THEN 6
                WHEN procesos.nombre = 'Anulacion' THEN 7
                ELSE 0
            END AS importancia_flujo,
            procesos.fecha_fin AS fecha,
            procesos.estado AS actividad_proceso,
            procesos.total_pagado,
            procesos.total_pendiente,
            procesos.estado_contrato,
            procesos.fecha_inicio,
            procesos.fecha_actualizacion
    FROM desarrolladora.procesos
    ) as tabprueba2
) AS subconsulta

INNER JOIN (
    SELECT 
        codigo_proyecto,
        codigo_proforma,
        MAX(numero_flujo) as numero_flujo
    FROM (
        SELECT 
        codigo_proyecto,
        codigo_proforma,
        fecha_inicio,
        importancia_flujo,
        ROW_NUMBER() OVER (PARTITION BY codigo_proforma ORDER BY codigo_proyecto, codigo_proforma, fecha_inicio, importancia_flujo) AS numero_flujo

        FROM( SELECT
                    procesos.codigo_proyecto,
                    procesos.nombre_proyecto,
                    procesos.tipo_unidad_principal,
                    procesos.codigo_unidad,
                    procesos.total_unidades,
                    procesos.codigo_unidades_asignadas,
                    procesos.nombres_cliente,
                    procesos.apellidos_cliente,
                    procesos.documento_cliente,
                    procesos.codigo_proforma,
                    procesos.moneda,
                    procesos.tipo_financiamiento,
                    procesos.banco,
                    procesos.nombres_usuario AS ejecutivo,
                    procesos.precio_base_proforma,
                    procesos.descuento_venta,
                    procesos.precio_venta,
                    CASE
                        WHEN procesos.nombre IN ('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 'Escritura Pública'
                        ELSE procesos.nombre
                    END AS estado_proceso,
                    CASE
                        WHEN procesos.nombre = 'Reserva' THEN 1
                        WHEN procesos.nombre = 'Separacion' THEN 2
                        WHEN procesos.nombre = 'Aprobacion' THEN 3
                        WHEN procesos.nombre = 'Venta' THEN 4
                        WHEN procesos.nombre in('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 5
                        WHEN procesos.nombre = 'Entrega' THEN 6
                        WHEN procesos.nombre = 'Anulacion' THEN 7
                        ELSE 0
                    END AS importancia_flujo,
                    procesos.fecha_fin AS fecha,
                    procesos.estado AS actividad_proceso,
                    procesos.total_pagado,
                    procesos.total_pendiente,
                    procesos.estado_contrato,
                    procesos.fecha_inicio,
                    procesos.fecha_actualizacion            
            FROM desarrolladora.procesos
            --WHERE procesos.fecha_fin IS NOT NULL AND procesos.fecha_inicio IS NOT NULL
        ) as tabprueba
    ) AS subconsulta_flujo 
    GROUP BY codigo_proyecto, codigo_proforma
) AS subconsultafinal
ON subconsulta.codigo_proyecto = subconsultafinal.codigo_proyecto
AND subconsulta.codigo_proforma = subconsultafinal.codigo_proforma 
AND subconsulta.numero_flujo = subconsultafinal.numero_flujo

) AS Tab2
ON TabPivot.codigo_proyecto = Tab2.codigo_proyecto
AND TabPivot.codigo_proforma = Tab2.codigo_proforma 

LEFT JOIN (
    
        SELECT 
            subconsulta.codigo_proyecto,
            subconsulta.codigo_proforma,
            estado_proceso AS nombre_flujo_ultimo_estado,
            subconsulta.fecha_inicio AS fecha_ultimo_estado

    FROM (
        SELECT 
            codigo_proyecto,
            nombre_proyecto,
            tipo_unidad_principal,
            codigo_unidad,
            total_unidades,
            codigo_unidades_asignadas,
            nombres_cliente,
            apellidos_cliente,
            documento_cliente,
            codigo_proforma,
            moneda,
            tipo_financiamiento,
            banco,
            ejecutivo,
            precio_base_proforma,
            descuento_venta,
            precio_venta,
            estado_proceso,
            importancia_flujo,
            fecha,
            actividad_proceso,
            total_pagado,
            total_pendiente,
            estado_contrato,
            fecha_inicio,
            fecha_actualizacion,
            ROW_NUMBER() OVER (PARTITION BY codigo_proforma ORDER BY codigo_proyecto, codigo_proforma, fecha_inicio, importancia_flujo) AS numero_flujo
        FROM (
            SELECT
                procesos.codigo_proyecto,
                procesos.nombre_proyecto,
                procesos.tipo_unidad_principal,
                procesos.codigo_unidad,
                procesos.total_unidades,
                procesos.codigo_unidades_asignadas,
                procesos.nombres_cliente,
                procesos.apellidos_cliente,
                procesos.documento_cliente,
                procesos.codigo_proforma,
                procesos.moneda,
                procesos.tipo_financiamiento,
                procesos.banco,
                procesos.nombres_usuario AS ejecutivo,
                procesos.precio_base_proforma,
                procesos.descuento_venta,
                procesos.precio_venta,
                CASE
                    WHEN procesos.nombre IN ('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 'Escritura Pública'
                    ELSE procesos.nombre
                END AS estado_proceso,
                CASE
                    WHEN procesos.nombre = 'Reserva' THEN 1
                    WHEN procesos.nombre = 'Separacion' THEN 2
                    WHEN procesos.nombre = 'Aprobacion' THEN 3
                    WHEN procesos.nombre = 'Venta' THEN 4
                    WHEN procesos.nombre in('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 5
                    WHEN procesos.nombre = 'Entrega' THEN 6
                    WHEN procesos.nombre = 'Anulacion' THEN 7
                    ELSE 0
                END AS importancia_flujo,
                procesos.fecha_fin AS fecha,
                procesos.estado AS actividad_proceso,
                procesos.total_pagado,
                procesos.total_pendiente,
                procesos.estado_contrato,
                procesos.fecha_inicio,
                procesos.fecha_actualizacion
        FROM desarrolladora.procesos
        ) as tabprueba2
    ) AS subconsulta

    INNER JOIN (
        SELECT 
            codigo_proyecto,
            codigo_proforma,
            
            MAX(numero_flujo) as numero_flujo
        FROM (

            SELECT 
            codigo_proyecto,
            codigo_proforma,
            fecha_inicio,
            importancia_flujo,
            ROW_NUMBER() OVER (PARTITION BY codigo_proforma ORDER BY codigo_proyecto, codigo_proforma, fecha_inicio, importancia_flujo) AS numero_flujo

            FROM( SELECT
                        procesos.codigo_proyecto,
                        procesos.nombre_proyecto,
                        procesos.tipo_unidad_principal,
                        procesos.codigo_unidad,
                        procesos.total_unidades,
                        procesos.codigo_unidades_asignadas,
                        procesos.nombres_cliente,
                        procesos.apellidos_cliente,
                        procesos.documento_cliente,
                        procesos.codigo_proforma,
                        procesos.moneda,
                        procesos.tipo_financiamiento,
                        procesos.banco,
                        procesos.nombres_usuario AS ejecutivo,
                        procesos.precio_base_proforma,
                        procesos.descuento_venta,
                        procesos.precio_venta,
                        CASE
                            WHEN procesos.nombre IN ('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 'Escritura Pública'
                            ELSE procesos.nombre
                        END AS estado_proceso,
                        CASE
                            WHEN procesos.nombre = 'Reserva' THEN 1
                            WHEN procesos.nombre = 'Separacion' THEN 2
                            WHEN procesos.nombre = 'Aprobacion' THEN 3
                            WHEN procesos.nombre = 'Venta' THEN 4
                            WHEN procesos.nombre in('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 5
                            WHEN procesos.nombre = 'Entrega' THEN 6
                            WHEN procesos.nombre = 'Anulacion' THEN 7
                            ELSE 0
                        END AS importancia_flujo,
                        procesos.fecha_fin AS fecha,
                        procesos.estado AS actividad_proceso,
                        procesos.total_pagado,
                        procesos.total_pendiente,
                        procesos.estado_contrato,
                        procesos.fecha_inicio,
                        procesos.fecha_actualizacion            
                FROM desarrolladora.procesos
                --WHERE procesos.fecha_fin IS NULL AND procesos.fecha_inicio IS NOT NULL
            ) as tabprueba
        ) AS subconsulta_flujo 
        GROUP BY codigo_proyecto, codigo_proforma
    ) AS subconsultafinal2
    ON subconsulta.codigo_proyecto = subconsultafinal2.codigo_proyecto
    AND subconsulta.codigo_proforma = subconsultafinal2.codigo_proforma 
    AND subconsulta.numero_flujo = subconsultafinal2.numero_flujo

 ) AS Tab3
 
ON TabPivot.codigo_proyecto = Tab3.codigo_proyecto
AND TabPivot.codigo_proforma = Tab3.codigo_proforma 

) AS TabL

) AS TabProcesos


RIGHT JOIN ( 
    SELECT  
            proforma_unidad.codigo_proyecto,
            proforma_unidad.codigo_unidad,
            proforma_unidad.codigo_proforma,
            proforma_unidad.tipo_unidad,
            proforma_unidad.nombre_unidad,
            proforma_unidad.estado as [estado_proforma]
    FROM desarrolladora.proforma_unidad
    --WHERE proforma_unidad.estado = 'en proceso' 
    --or proforma_unidad.estado = 'vigente'
) AS TabProforma_unidad
  ON  TabProcesos.codigo_proyecto = TabProforma_unidad.codigo_proyecto 
  AND TabProcesos.codigo_unidad = TabProforma_unidad.codigo_unidad 
  AND TabProcesos.codigo_proforma = TabProforma_unidad.codigo_proforma
  AND TabProcesos.tipo_unidad_principal = TabProforma_unidad.tipo_unidad

RIGHT JOIN (

    SELECT 
            clientes.fecha_creacion,
            clientes.nombres,
            clientes.apellidos,
            clientes.tipo_documento,
            clientes.documento,
            clientes.genero,
            clientes.estado_civil,
            clientes.email,
            clientes.telefono,
            clientes.celulares as celular,
        
            CASE
                    WHEN LOWER(clientes.agrupacion_medio_captacion) LIKE '%facebook%' OR LOWER(clientes.agrupacion_medio_captacion) LIKE '%Página%'
                    OR LOWER(clientes.agrupacion_medio_captacion) = 'Portales Inmobiliarios' OR LOWER(clientes.agrupacion_medio_captacion) LIKE '%web%' 
                    OR LOWER(clientes.agrupacion_medio_captacion) LIKE '%digitales%' THEN 'Leads digitales'
                    WHEN clientes.agrupacion_medio_captacion = 'Referidos' OR clientes.agrupacion_medio_captacion = 'Prensa' 
                    OR clientes.agrupacion_medio_captacion = 'Ferias' OR clientes.agrupacion_medio_captacion = 'Publicidad Exterior' 
                    OR clientes.agrupacion_medio_captacion = 'Volanteo' OR clientes.agrupacion_medio_captacion = 'Activaciones' THEN 'Leads tradicionales'
                    ELSE 'Otros'
            END AS agrupacion_medio_captacion,
            clientes.medio_captacion,
            clientes.canal_entrada,
            
            CASE
                    WHEN LOWER(clientes.nivel_interes) LIKE '%de baja%' OR  LOWER(clientes.nivel_interes) = 'no contesta' THEN 'De Baja'
                    WHEN LOWER(clientes.nivel_interes) = 'derivado a ejecutivo' OR LOWER(clientes.nivel_interes) = 'en espera' OR LOWER(clientes.nivel_interes) = 'evaluando compra'
                    OR LOWER(clientes.nivel_interes) = 'gestionado' OR LOWER(clientes.nivel_interes) = 'volver a contactar' THEN 'Seguimiento'
                    WHEN LOWER(clientes.nivel_interes) LIKE '%interesado%' OR  LOWER(clientes.nivel_interes) = 'por visitar' THEN 'Interesado'
                    WHEN LOWER(clientes.nivel_interes) LIKE '%potencial%' THEN 'Potencial'
                    WHEN LOWER(clientes.nivel_interes) LIKE '%separado%' THEN 'Separación'
                    WHEN LOWER(clientes.nivel_interes) LIKE '%vendido%' THEN 'Vendido'
                    ELSE 'NN'
            END AS nivel_interes,

            clientes.fecha_nacimiento,
            clientes.nacionalidad,
            clientes.pais,
            clientes.departamento,
            clientes.provincia,
            clientes.distrito,
            clientes.direccion,
            clientes.apto,
            clientes.observacion,
            clientes.ocupacion,
            clientes.documento_conyuge,
            clientes.usuario_creador,
            clientes.username,
            clientes.estado,
            clientes.ultimo_proyecto,
            clientes.total_unidades_asignadas,
            clientes.ultimo_vendedor,
            clientes.total_interacciones,
            clientes.fecha_ultima_interaccion,
            clientes.proyectos_relacionados,
            clientes.codigo_externo_cliente,
            clientes.rango_edad,
            clientes.origen,
            clientes.ultimo_tipo_interaccion,
            clientes.fecha_actualizacion,
            clientes.autorizacion_uso_datos,
            clientes.autorizacion_publicidad,
            clientes.geo_latitud,
            clientes.geo_longitud,
            clientes.geolocalizacion,
            clientes.cliente_riesgo,
            clientes.agrupacion_canal_entrada,
            clientes.tipo_persona,
            clientes.denominacion,
            clientes.tipo_financiamiento,
            EXTRACT(YEAR FROM clientes.fecha_ultima_interaccion) AS anio_ultinteraccion,
            EXTRACT(YEAR FROM clientes.fecha_creacion) AS anio_creacion


FROM desarrolladora.clientes

) AS TabClientes

ON TabProcesos.documento_cliente = TabClientes.documento
AND TabProcesos.codigo_proyecto = TabClientes.proyectos_relacionados

INNER JOIN  (

    Select codigo,nombre,valor,entidad,id,tipo,fecha_actualizacion
    from desarrolladora.datos_extras
    where entidad = 'CLIENTE' and nombre = 'profesion'

) as Tabdatosextra

ON TabProcesos.documento_cliente = TabClientes.documento
AND TabProcesos.codigo_proyecto = TabClientes.proyectos_relacionados