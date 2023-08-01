SELECT 
        fecha_creacion,
        nombres,
        apellidos,
        tipo_documento,
        documento,
        genero,
        estado_civil,
        email,
        telefono,
        celulares as celular,
        --Estandarizar agrupacion medio captacion
        --agrupacion_medio_captacion,
        CASE
                WHEN LOWER(agrupacion_medio_captacion) LIKE '%facebook%' OR LOWER(agrupacion_medio_captacion) LIKE '%Página%'
                OR LOWER(agrupacion_medio_captacion) = 'Portales Inmobiliarios' OR LOWER(agrupacion_medio_captacion) LIKE '%web%' 
                OR LOWER(agrupacion_medio_captacion) LIKE '%digitales%' THEN 'Leads digitales'
                WHEN agrupacion_medio_captacion = 'Referidos' OR agrupacion_medio_captacion = 'Prensa' 
                OR agrupacion_medio_captacion = 'Ferias' OR agrupacion_medio_captacion = 'Publicidad Exterior' 
                OR agrupacion_medio_captacion = 'Volanteo' OR agrupacion_medio_captacion = 'Activaciones' THEN 'Leads tradicionales'
                ELSE 'Otros'
        END AS agrupacion_medio_captacion,
        --Estandarizar medio captacion
        medio_captacion,
        --Estandarizar canal de entrada
        canal_entrada,

        --Estandarizar nivel de interes
        --nivel_interes,
        CASE
                WHEN LOWER(nivel_interes) LIKE '%de baja%' OR  LOWER(nivel_interes) = 'no contesta' THEN 'De Baja'
                WHEN LOWER(nivel_interes) = 'derivado a ejecutivo' OR LOWER(nivel_interes) = 'en espera' OR LOWER(nivel_interes) = 'evaluando compra'
                OR LOWER(nivel_interes) = 'gestionado' OR LOWER(nivel_interes) = 'volver a contactar' THEN 'Seguimiento'
                WHEN LOWER(nivel_interes) LIKE '%interesado%' OR  LOWER(nivel_interes) = 'por visitar' THEN 'Interesado'
                WHEN LOWER(nivel_interes) LIKE '%potencial%' THEN 'Potencial'
                WHEN LOWER(nivel_interes) LIKE '%separado%' THEN 'Separación'
                WHEN LOWER(nivel_interes) LIKE '%vendido%' THEN 'Vendido'
                ELSE 'NN'
        END AS nivel_interes,

        fecha_nacimiento,
        nacionalidad,
        pais,
        departamento,
        provincia,
        distrito,
        direccion,
        apto,
        observacion,
        ocupacion,
        documento_conyuge,
        usuario_creador,
        username,
        estado,
        ultimo_proyecto,
        total_unidades_asignadas,
        ultimo_vendedor,
        total_interacciones,
        fecha_ultima_interaccion,
        proyectos_relacionados,
        codigo_externo_cliente,
        rango_edad,
        origen,
        ultimo_tipo_interaccion,
        fecha_actualizacion,
        autorizacion_uso_datos,
        autorizacion_publicidad,
        geo_latitud,
        geo_longitud,
        geolocalizacion,
        cliente_riesgo,
        agrupacion_canal_entrada,
        tipo_persona,
        denominacion,
        tipo_financiamiento,
        EXTRACT(YEAR FROM fecha_ultima_interaccion) AS anio_ultinteraccion,
        EXTRACT(YEAR FROM fecha_creacion) AS anio_creacion

FROM desarrolladora.clientes
