SELECT 
        proyecto_codigo,
        codigo AS [codigo_division],
        nombre,
        subdivision_padre,
        CASE
            WHEN subdivision_padre IS NULL THEN codigo
            ELSE subdivision_padre
        END AS codigo_etapa
        
FROM desarrolladora.subdivision

