SELECT 
        TabProforma_unidad.fecha_proforma,
        TabProforma_unidad.codigo_proyecto, --Si
        TabProforma_unidad.nombre_proyecto, -- SI
        --TabProcesos.codigo_proforma AS codigo_proforma_procesos, --Si
        TabProforma_unidad.codigo_proforma,
        TabProforma_unidad.tipo_unidad AS tipo_unidad_principal, --Si
        TabProforma_unidad.codigo_unidad, --Si
        
        TabProcesos.total_unidades, --No
        --codigo_unidades_asignadas,
        
        CASE
            WHEN TabProcesos.nombres_cliente IS NULL THEN TabClientes.nombres
            ELSE TabProcesos.nombres_cliente
        END AS nombre_cliente,
        

        CASE
            WHEN TabProcesos.apellidos_cliente IS NULL THEN TabClientes.apellidos
            ELSE TabProcesos.apellidos_cliente
        END AS apellidos_cliente,
        
        TabProforma_unidad.documento_cliente, --Si
        TabProforma_unidad.moneda, --Si
        TabProforma_unidad.tipo_financiamiento, --SI
        TabProforma_unidad.banco, --Si
        TabProforma_unidad.ejecutivo_proforma, --Si

        TabProcesos.precio_base_proforma, --No
        TabProcesos.descuento_venta, --No

        TabProforma_unidad.precio_venta, --Si

        CASE
            WHEN TabProforma_unidad.moneda = 'PEN' THEN (TabProforma_unidad.precio_venta / 3.80)
            ELSE TabProforma_unidad.precio_venta
        END AS precio_venta_$,

        CASE
            WHEN TabProforma_unidad.moneda = 'USD' THEN (TabProforma_unidad.precio_venta * 3.80)
            ELSE TabProforma_unidad.precio_venta
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
        TabProcesos.fecha_reserva, --No
        TabProcesos.fecha_aprobacion, --No
        TabProcesos.fecha_separacion,  --No
        TabProcesos.fecha_venta,  --No
        TabProcesos.fecha_escritura_publica, --No 
        TabProcesos.fecha_entrega,  --No
        TabProcesos.fecha_anulacion, --No
        TabProcesos.nombre_flujo_ultimo_estado, --No
        TabProcesos.fecha_ultimo_estado, --No
        TabProcesos.dias_venta, --No
        TabProcesos.dias_escriturapublica, --No
        TabProcesos.diferencia_dias_entre_venta_escriturapublica, --No
        TabProcesos.motivo_anulacion, --No
        TabProcesos.monto_programado_sumado, --No

        TabProforma_unidad.nombre_unidad, --Si
        TabProforma_unidad.estado_proforma, --Si

        TabUnidades.area_libre, --No
        TabUnidades.area_techada, --No
        TabUnidades.precio_lista, --No
        TabUnidades.precio_m2, --No

        --Campo para ver si son vencidas son anuladas y cuales no, y las vigentes dejarlas tal como esta.

        CASE
            WHEN TabProforma_unidad.estado_proforma = 'vencido' AND TabProcesos.codigo_proforma IS NULL THEN 'Anuladas_sin_proceso'
            WHEN TabProforma_unidad.estado_proforma = 'vencido' AND TabProcesos.codigo_proforma IS NOT NULL THEN 'Anuladas_con_proceso'
            ELSE 'vigente'
        END AS tipos_proformas


FROM (

    SELECT 
        TabL.codigo_proyecto,
        TabL.nombre_proyecto,
        TabL.codigo_proforma,
        TabL.tipo_unidad_principal,
        TabL.codigo_unidad,
        TabL.total_unidades,
        --codigo_unidades_asignadas,
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
        --fecha_fin,
        --estado_proceso,
        --actividad_proceso,
        --total_pagado,
        --TabL.total_pendiente,
        --estado_contrato,
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
        TabL.motivo_anulacion,
        TabR.monto_programado_sumado

FROM (

SELECT 

    TabPivot.codigo_proyecto,
    TabPivot.nombre_proyecto,
    TabPivot.codigo_proforma,
    TabPivot.tipo_unidad_principal,
    TabPivot.codigo_unidad,
    TabPivot.total_unidades,
    --codigo_unidades_asignadas,
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
    --fecha_fin,
    --estado_proceso,
    --actividad_proceso,
    --total_pagado,
    --TabPivot.total_pendiente,
    --estado_contrato,
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
    TabPivot.motivo_anulacion,
    Tab2.nombre_flujo_ultimo_estado,
    Tab2.fecha_ultimo_estado
FROM (

SELECT 
    PivotTable.codigo_proyecto,
    PivotTable.codigo_proforma,
    PivotTable.nombre_proyecto,
    PivotTable.tipo_unidad_principal,
    PivotTable.codigo_unidad,
    PivotTable.total_unidades,
    --codigo_unidades_asignadas,
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
    --fecha_fin,
    --estado_proceso,
    --actividad_proceso,
    --total_pagado,
    --PivotTable.total_pendiente,
    --estado_contrato,
    [Reserva] AS fecha_reserva, 
    [Aprobacion] AS fecha_aprobacion, 
    [Separacion] AS fecha_separacion, 
    [Venta] AS fecha_venta, 
    [EscrituraPública] AS fecha_escritura_publica, 
    [Entrega]  AS fecha_entrega, 
    [Anulacion] AS fecha_anulacion,

    DATEPART(day, Venta) AS dias_venta,
    DATEPART(day, EscrituraPública) AS dias_escriturapublica,
    CASE
            WHEN ( fecha_venta::date - EscrituraPública::date ) < 0 THEN ( fecha_venta::date - EscrituraPública::date ) * -1
            WHEN  fecha_venta::date IS NULL OR EscrituraPública::date IS NULL THEN 0
            ELSE (fecha_venta::date - EscrituraPública::date)
    END AS diferencia_dias_entre_venta_escriturapublica,
    PivotTable.motivo_anulacion
    
    --(fecha_venta::date - EscrituraPública::date) as DiferenciaFechaPrueba

    
FROM (
    SELECT
        procesos.codigo_proyecto,
        procesos.nombre_proyecto,
        procesos.tipo_unidad_principal,
        procesos.codigo_unidad,
        procesos.total_unidades,
        --procesos.codigo_unidades_asignadas,
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
        procesos.fecha_fin,
        procesos.fecha_inicio,
        procesos.fecha_anulacion,
        procesos.nombre_flujo AS [motivo_anulacion],
        CASE
            WHEN procesos.nombre IN ('Escritura Pública', 'Escritura Pública V2', 'Escritura Pública V3') THEN 'EscrituraPública'
            ELSE procesos.nombre
        END AS estado_proceso
        --procesos.estado AS [actividad_proceso],
        --procesos.total_pagado,
        --procesos.total_pendiente
        --procesos.estado_contrato
    FROM desarrolladora.procesos
    WHERE procesos.tipo_unidad_principal = 'casa' or procesos.tipo_unidad_principal = 'casa de campo' or procesos.tipo_unidad_principal = 'casa de playa'
    or procesos.tipo_unidad_principal = 'departamento duplex' or procesos.tipo_unidad_principal = 'departamento flat' or procesos.tipo_unidad_principal = 'depósito'
    or procesos.tipo_unidad_principal = 'local comercial' or procesos.tipo_unidad_principal = 'oficina' or procesos.tipo_unidad_principal = 'penthouse'

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

) AS TabPivot

INNER JOIN ( 


    SELECT 
        subconsulta.codigo_proyecto,
        --nombre_proyecto,
        --tipo_unidad_principal,
        --codigo_unidad,
        --total_unidades,
        --codigo_unidades_asignadas,
        --nombres_cliente,
        --apellidos_cliente,
        --documento_cliente,
        subconsulta.codigo_proforma,
        --moneda,
        --tipo_financiamiento,
        --banco,
        --ejecutivo,
        --precio_base_proforma,
        --descuento_venta,
        --precio_venta,
        estado_proceso AS nombre_flujo_ultimo_estado,
        --importancia_flujo,
        --fecha,
        --actividad_proceso,
        --total_pagado,
        --total_pendiente,
        --estado_contrato,
        subconsulta.fecha_inicio AS fecha_ultimo_estado
        --fecha_actualizacion,
        --subconsulta.numero_flujo

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
        ) as tabprueba
        --GROUP BY codigo_proyecto, codigo_proforma, fecha_inicio, importancia_flujo
        --ORDER BY codigo_proyecto, codigo_proforma, fecha_inicio, importancia_flujo
    ) AS subconsulta_flujo 
    GROUP BY codigo_proyecto, codigo_proforma
) AS subconsultafinal
ON subconsulta.codigo_proyecto = subconsultafinal.codigo_proyecto
AND subconsulta.codigo_proforma = subconsultafinal.codigo_proforma 
--AND subconsulta.fecha_inicio = subconsultafinal.fecha_inicio
AND subconsulta.numero_flujo = subconsultafinal.numero_flujo

) AS Tab2
ON TabPivot.codigo_proyecto = Tab2.codigo_proyecto
AND TabPivot.codigo_proforma = Tab2.codigo_proforma 
) AS TabL
LEFT JOIN (
    SELECT 
        --fecha_creacion,
        codigo_proyecto,
        --nombre_proyecto,
        --nombres_cliente,
        --apellidos_cliente,
        codigo_proforma,
        --numero_contrato,
        --modalidad_contrato,
        --tipo_cronograma,
        --nombre_pago,
        etiqueta_pago,
        SUM(monto_programado) AS monto_programado_sumado
        --fecha_vcto_pago,
        --fecha_deposito,
        --fecha_aplicacion,
        --tipo_abono,
        --moneda_venta,
        --monto_abono,
        --tipo_cambio,
        --saldo_antes_abono,
        --total_descuento,
        --capital_abono,
        --nombres_usuario,
        --username,
        --numero_operacion,
        --banco,
        --numero_cuenta,
        --observacion,
        --fecha_nif,
        --estado_nif,
        --tipo,
        --porte,
        --comision,
        --codigo_externo,
        --origen,
        --forma_pago,
        --abono_aplicado,
        --abono_real,
        --moneda_abono_real,
        --tipo_cambio_abono_real,
        --observacion_s10,
        --codigo_cuenta,
        --fecha_actualizacion,
        --tipo_deposito,
        --CASE
        --        WHEN moneda_venta = 'PEN'  THEN  ROUND(((monto_abono)/3.81), 2)
        --        ELSE monto_abono
        --END AS monto_abono_$
        
        FROM desarrolladora.depositos
        WHERE etiqueta_pago = 'Cuota Inicial'
        GROUP bY codigo_proyecto,codigo_proforma,etiqueta_pago
        ) as TabR
        ON    TabL.codigo_proyecto = TabR.codigo_proyecto
        AND   TabL.codigo_proforma = TabR.codigo_proforma

) AS TabProcesos

RIGHT JOIN ( 
    --Obtengo de la tabla proforma_unidad las proformas con el estado vencido y vigente.
    SELECT  
            proforma_unidad.fecha_creacion AS [fecha_proforma] ,
            proforma_unidad.codigo_proyecto,
            proforma_unidad.nombre_proyecto,
            proforma_unidad.codigo_proforma,
            proforma_unidad.tipo_unidad,
            proforma_unidad.codigo_unidad,
            proforma_unidad.nombre_unidad,
            proforma_unidad.estado AS [estado_proforma],
            proforma_unidad.documento_cliente,
            proforma_unidad.moneda,
            proforma_unidad.tipo_financiamiento,
            proforma_unidad.banco,
            proforma_unidad.usuario_creador AS [ejecutivo_proforma],
            proforma_unidad.precio_venta

    FROM desarrolladora.proforma_unidad
    WHERE proforma_unidad.estado = 'vencido' OR proforma_unidad.estado = 'vigente'
) AS TabProforma_unidad
  ON  TabProcesos.codigo_proyecto = TabProforma_unidad.codigo_proyecto 
  AND TabProcesos.codigo_unidad = TabProforma_unidad.codigo_unidad 
  AND TabProcesos.codigo_proforma = TabProforma_unidad.codigo_proforma
  AND TabProcesos.tipo_unidad_principal = TabProforma_unidad.tipo_unidad

LEFT JOIN (
    --Obtengo de la tabla unidades los campos de la tabla unidades.
    SELECT 
            unidades.codigo_proyecto,
            unidades.codigo,
            unidades.codigo_proforma,
            unidades.tipo_unidad,
            unidades.area_libre,
            unidades.area_techada,
            unidades.area_total,
            unidades.precio_lista,
            unidades.precio_m2

FROM desarrolladora.unidades

) AS TabUnidades

ON TabProforma_unidad.codigo_proyecto = TabUnidades.codigo_proyecto
AND TabProforma_unidad.codigo_unidad = TabUnidades.codigo
AND TabProforma_unidad.codigo_proforma = TabUnidades.codigo_proforma
AND TabProforma_unidad.tipo_unidad = TabUnidades.tipo_unidad

LEFT JOIN (
    --Obtengo de la tabla clientes los campos nombres y apellidos faltantes para la nueva tabla proforma beta.
    SELECT 
            nombres,
            apellidos,
            documento

FROM desarrolladora.clientes

) AS TabClientes

ON TabProforma_unidad.documento_cliente = TabClientes.documento