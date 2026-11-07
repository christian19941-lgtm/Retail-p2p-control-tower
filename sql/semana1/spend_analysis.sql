-- Archivo: sql/semana1/spend_analysis.sql
-- Objetivo: Análisis de gasto consolidado por proveedor con % sobre el total y filtro de corte

SELECT 
    s.company_name AS proveedor,
    COUNT(DISTINCT po.po_id) AS total_ordenes,
    SUM(l.quantity * l.unit_price) AS gasto_total_proveedor,
    ROUND(
        (SUM(l.quantity * l.unit_price) / SUM(SUM(l.quantity * l.unit_price)) OVER ()) * 100, 
        2
    ) AS pct_sobre_total_empresa
FROM suppliers s
JOIN purchase_orders po ON s.supplier_id = po.supplier_id
JOIN po_lines l ON po.po_id = l.po_id
GROUP BY s.company_name
-- Filtro HAVING para proveedores representativos (ajustable según umbral de gasto)
HAVING SUM(l.quantity * l.unit_price) > 5000
ORDER BY gasto_total_proveedor DESC;