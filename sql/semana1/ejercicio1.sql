-- Archivo: sql/semana1/ejercicio1.sql

WITH spend_2025 AS (
    SELECT 
        s.supplier_id,
        s.company_name AS proveedor,
        COUNT(DISTINCT po.po_id) AS num_ordenes_compra,
        SUM(l.quantity * l.unit_price) AS gasto_proveedor
    FROM suppliers s
    JOIN purchase_orders po ON s.supplier_id = po.supplier_id
    JOIN po_lines l ON po.po_id = l.po_id
    -- Filtro de fecha para el año 2025
    WHERE po.order_date >= '2025-01-01' AND po.order_date <= '2025-12-31'
    GROUP BY s.supplier_id, s.company_name
)
SELECT 
    proveedor,
    num_ordenes_compra,
    gasto_proveedor,
    -- % del total respecto al gasto global de TODO el año 2025
    ROUND(
        (gasto_proveedor / SUM(gasto_proveedor) OVER ()) * 100, 
        2
    ) AS pct_sobre_total
FROM spend_2025
ORDER BY gasto_proveedor DESC
LIMIT 10;