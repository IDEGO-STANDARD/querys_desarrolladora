SELECT 

            --Datos del cliente
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
            TabClientes.nivel_interes,
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
            TabClientes.fecha_actualizacion_clientes,
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
            --Datos extra
            Tabdatosextra.codigo,
            Tabdatosextra.nombre,
            Tabdatosextra.valor,
            Tabdatosextra.entidad,
            Tabdatosextra.id,
            Tabdatosextra.tipo,
            Tabdatosextra.fecha_actualizacion as fecha_actualizacion_datos_extra

FROM (

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
            clientes.fecha_actualizacion as fecha_actualizacion_clientes,
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

INNER JOIN (

    Select 
            codigo,
            nombre,
            valor,
            entidad,
            id,
            tipo,
            fecha_actualizacion

    from desarrolladora.datos_extras
    where entidad = 'CLIENTE' and nombre = 'profesion'

) AS Tabdatosextra

ON Tabdatosextra.codigo = TabClientes.documento

