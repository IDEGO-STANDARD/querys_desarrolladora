SELECT 

        TabProcesos.codigo_proyecto,
        TabProcesos.codigo_proforma AS codigo_proforma,
        TabProcesos.tipo_unidad_principal,
        TabProcesos.codigo_unidad,
        TabProcesos.total_unidades,
        TabProcesos.nombres_cliente,
        TabProcesos.apellidos_cliente,
        TabProcesos.documento_cliente,
        TabProcesos.moneda,
        TabProcesos.tipo_financiamiento,
        TabProcesos.banco,
        TabProcesos.[ejecutivo],
        TabProcesos.precio_base_proforma,
        TabProcesos.descuento_venta,
        TabProcesos.precio_venta,

        CASE
            WHEN TabProcesos.moneda = 'PEN' THEN (TabProcesos.precio_venta / 3.80)
            ELSE TabProcesos.precio_venta
        END AS precio_venta_$,

        CASE
            WHEN TabProcesos.moneda = 'USD' THEN (TabProcesos.precio_venta * 3.80)
            ELSE TabProcesos.precio_venta
        END AS precio_venta_S,

        CASE
            WHEN TabProcesos.moneda = 'PEN' THEN (TabProcesos.descuento_venta / 3.80)
            ELSE TabProcesos.descuento_venta
        END AS precio_descuento_venta_$,

        CASE
            WHEN TabProcesos.moneda = 'USD' THEN (TabProcesos.descuento_venta * 3.80)
            ELSE TabProcesos.descuento_venta
        END AS precio_descuento_venta_S,


        CASE
            WHEN TabProcesos.moneda = 'PEN' THEN (TabProcesos.precio_base_proforma / 3.80)
            ELSE TabProcesos.precio_base_proforma
        END AS precio_precio_base_proforma_$,

        CASE
            WHEN TabProcesos.moneda = 'USD' THEN (TabProcesos.precio_base_proforma * 3.80)
            ELSE TabProcesos.precio_base_proforma
        END AS precio_precio_base_proforma_S,

        --fecha_fin,
        --estado_proceso,
        --actividad_proceso,
        --total_pagado,
        --TabProcesos.total_pendiente,
        --estado_contrato,


        TabProcesos.total_pagado_$,
        TabProcesos.total_pendiente_$,

        TabProcesos.fecha_reserva, 
        TabProcesos.fecha_aprobacion, 
        TabProcesos.fecha_separacion, 
        TabProcesos.fecha_venta, 
        TabProcesos.fecha_escritura_publica, 
        TabProcesos.fecha_entrega, 
        TabProcesos.fecha_anulacion,
        TabProcesos.nombre_flujo_ultimo_estado,
        TabProcesos.fecha_ultimo_estado,
        TabProcesos.dias_venta,
        TabProcesos.dias_escriturapublica,
        TabProcesos.diferencia_dias_entre_venta_escriturapublica,
        TabProcesos.monto_programado_sumado,
        TabProforma_unidad.nombre_unidad,
        TabProforma_unidad.estado_proforma,
        TabUnidades.area_libre,
        TabUnidades.area_techada,
        TabUnidades.precio_lista,
        TabUnidades.precio_m2,
        TabUnidades.estado_comercial,

        CASE
            WHEN TabUnidades.estado_comercial = 'proceso de separación' OR TabUnidades.estado_comercial = 'proceso de aprobación'
            OR TabUnidades.estado_comercial = 'proceso de venta' THEN 'separado'
            WHEN TabUnidades.estado_comercial = 'separado' THEN 'contrato separación'
            WHEN TabUnidades.estado_comercial = 'proceso de entrega' OR TabUnidades.estado_comercial = 'vendido' THEN 'venta'
            WHEN TabUnidades.estado_comercial = 'entregado'  THEN 'entregado'
           
            ELSE TabUnidades.estado_comercial

        END AS est_venta


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

        TabL.total_pagado_$,
        TabL.total_pendiente_$,




        TabL.fecha_reserva, 
        TabL.fecha_aprobacion, 
        TabL.fecha_separacion, 
        TabL.fecha_venta, 
        TabL.fecha_escritura_publica, 
        TabL.fecha_entrega, 
        TabL.fecha_anulacion,
        TabL.nombre_flujo_ultimo_estado,
        TabL.fecha_ultimo_estado,
        TabL.dias_venta,
        TabL.dias_escriturapublica,
        TabL.diferencia_dias_entre_venta_escriturapublica,
        TabR.monto_programado_sumado

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

    TabPivot.total_pagado_$,
    TabPivot.total_pendiente_$,

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
    END AS nombre_flujo_ultimo_estado,

    CASE
            WHEN Tab2.fecha_ultimo_estado IS NULL THEN Tab3.fecha_ultimo_estado
            ELSE Tab2.fecha_ultimo_estado
    END AS fecha_ultimo_estado

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

    --PivotTable.total_pagado,
    --PivotTable.total_pendiente,

    DATEPART(day, Venta) AS dias_venta,
    DATEPART(day, EscrituraPública) AS dias_escriturapublica,
    CASE
            WHEN ( fecha_venta::date - EscrituraPública::date ) < 0 THEN ( fecha_venta::date - EscrituraPública::date ) * -1
            WHEN  fecha_venta::date IS NULL OR EscrituraPública::date IS NULL THEN 0
            ELSE (fecha_venta::date - EscrituraPública::date)
    END AS diferencia_dias_entre_venta_escriturapublica,

    ultimo_total_pagado.total_pagado_$,
    ultimo_total_pendiente.total_pendiente_$
        
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

        --procesos.total_pagado,
        --procesos.total_pendiente,

        procesos.fecha_fin,
        procesos.fecha_inicio,
        procesos.fecha_anulacion,
        CASE
            WHEN procesos.nombre IN ('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 'EscrituraPública'
            ELSE procesos.nombre
        END AS estado_proceso
    FROM desarrolladora.procesos
    --WHERE procesos.tipo_unidad_principal = 'casa' or procesos.tipo_unidad_principal = 'casa de campo' or procesos.tipo_unidad_principal = 'casa de playa'
    --or procesos.tipo_unidad_principal = 'departamento duplex' or procesos.tipo_unidad_principal = 'departamento flat' or procesos.tipo_unidad_principal = 'depósito'
    --or procesos.tipo_unidad_principal = 'local comercial' or procesos.tipo_unidad_principal = 'oficina' or procesos.tipo_unidad_principal = 'penthouse'

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
            END AS total_pagado_$
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
           END AS total_pendiente_$
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

LEFT JOIN (
    SELECT 
        codigo_proyecto,
        codigo_proforma,
        etiqueta_pago,
        SUM(monto_programado) AS monto_programado_sumado
        
        FROM desarrolladora.depositos
        WHERE etiqueta_pago = 'Cuota Inicial'
        GROUP bY codigo_proyecto,codigo_proforma,etiqueta_pago
        ) as TabR
        ON    TabL.codigo_proyecto = TabR.codigo_proyecto
        AND   TabL.codigo_proforma = TabR.codigo_proforma

) AS TabProcesos

INNER JOIN ( 
    SELECT  
            proforma_unidad.codigo_proyecto,
            proforma_unidad.codigo_unidad,
            proforma_unidad.codigo_proforma,
            proforma_unidad.tipo_unidad,
            proforma_unidad.nombre_unidad,
            proforma_unidad.estado as [estado_proforma]
    FROM desarrolladora.proforma_unidad
    --WHERE proforma_unidad.estado = 'en proceso' or proforma_unidad.estado = 'vigente'
) AS TabProforma_unidad
  ON  TabProcesos.codigo_proyecto = TabProforma_unidad.codigo_proyecto 
  AND TabProcesos.codigo_unidad = TabProforma_unidad.codigo_unidad 
  AND TabProcesos.codigo_proforma = TabProforma_unidad.codigo_proforma
  AND TabProcesos.tipo_unidad_principal = TabProforma_unidad.tipo_unidad
  
  
LEFT JOIN (

    SELECT 
            unidades.codigo_proyecto,
            unidades.codigo,
            unidades.codigo_proforma,
            unidades.tipo_unidad,
            unidades.area_libre,
            unidades.area_techada,
            unidades.area_total,
            unidades.precio_lista,
            unidades.precio_m2,
            unidades.estado_comercial

FROM desarrolladora.unidades

) AS TabUnidades

ON TabProcesos.codigo_proyecto = TabUnidades.codigo_proyecto
AND TabProcesos.codigo_unidad = TabUnidades.codigo
AND TabProcesos.codigo_proforma = TabUnidades.codigo_proforma
AND TabProcesos.tipo_unidad_principal = TabUnidades.tipo_unidad

WHERE TabProcesos.nombre_flujo_ultimo_estado NOT IN ('Anulacion', 'Reserva')
