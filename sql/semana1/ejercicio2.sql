-- Archivo: sql/semana1/ejercicio2.sql

SELECT 
    l.category AS categoria, -- o c.category_name si tienes tabla de categorías
    SUM(l.quantity * l.unit_price) AS gasto_total,
    COUNT(DISTINCT po.supplier_id) AS total_proveedores_distintos,
    ROUND(AVG(l.unit_price), 2) AS precio_unitario_medio,
    COUNT(l.line_id) AS numero_lineas
FROM po_lines l
JOIN purchase_orders po ON l.po_id = po.po_id
GROUP BY l.category
-- Filtrado de grupos consolidado post-agregación
HAVING SUM(l.quantity * l.unit_price) > 100000
   AND COUNT(DISTINCT po.supplier_id) > 5
ORDER BY gasto_total DESC;