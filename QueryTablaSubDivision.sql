/* 
   Creado por: Nicolas Figueroa Gómez
   Nombre tabla: NTD_Subdivision
   Objetivo: tener un mapeo de la relacion entre el codigo proyecto, codigo subdivision y codigo etapa.
   Campos modificados: 
   -- codigo_etapa:
        --objetivo: establecer un codigo etapa. Para ello, se sigue la siguiente lógica, cuando el valor de campo subdivision padre
                    es null se tomara el valor del campo codigo, caso contrario se tomara el valor del campo subdivision padre.
*/


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

