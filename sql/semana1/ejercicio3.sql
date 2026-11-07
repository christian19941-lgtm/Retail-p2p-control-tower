-- Archivo: sql/semana1/ejercicio3.sql

WITH lineas_con_duplicados AS (
    SELECT 
        *,
        -- Cuenta cuántas veces se repite la combinación po_id + line_no
        COUNT(*) OVER (PARTITION BY po_id, line_no) AS repeticiones
    FROM po_lines
)
SELECT 
    po_id,
    line_no,
    product_sku,
    quantity,
    unit_price,
    CASE 
        WHEN unit_price <= 0 THEN 'Error: Precio menor o igual a 0'
        WHEN quantity IS NULL THEN 'Error: Cantidad nula'
        WHEN repeticiones > 1 THEN 'Error: Linea duplicada (mismo po_id + line_no)'
        ELSE 'Correcto'
    END AS motivo_calidad_dato
FROM lineas_con_duplicados
WHERE unit_price <= 0 
   OR quantity IS NULL 
   OR repeticiones > 1;