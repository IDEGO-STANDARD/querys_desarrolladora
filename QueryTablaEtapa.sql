/* Nombre tabla: NTD_Etapa
   Objetivo: Tener el codigo de etapa por prouecto, asi como su estado.
   
   Campos modificados: 
   -- estado_etapa:
        --objetivo: organizar las etapas de los proyectos si estan activos o inactivos. 
   -- codigo_etapa:
        --objetivo: Este campo determinara el codigo de la etapa. Para ello, se realizo un INNER JOIN con la tabla subdivison.
                    En dicha tabla, para la creacion del campo codigo_etapa se siguio la siguiente logica. Si en la tabla sub-
                    division el proyecto no tiene subdivision padre utilizara como valor el codigo, caso contrario si tiene
                    utilizara como valor subdivision padre.
                    
   Creado por: Nicolas Figueroa Gómez
*/

SELECT 
        codigo AS [codigo_proyecto],
        Nombre AS [nombre_proyecto],
        Tabsubdiv.codigo_etapa,

        CASE
                WHEN codigo_etapa = 'MAR-A' OR codigo_etapa = 'DOR-A' THEN 'activo'
                ELSE 'inactivo'
        END AS estado_etapa

FROM desarrolladora.proyectos

INNER JOIN (

    SELECT DISTINCT
        proyecto_codigo,
        CASE
            WHEN subdivision_padre IS NULL THEN codigo
            ELSE subdivision_padre
        END AS codigo_etapa

FROM desarrolladora.subdivision

) AS Tabsubdiv

ON codigo = Tabsubdiv.proyecto_codigo


