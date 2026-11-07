-- 1. Limpieza de tablas previas si existen
DROP VIEW IF EXISTS v_po_lines CASCADE;
DROP TABLE IF EXISTS po_lines CASCADE;
DROP TABLE IF EXISTS purchase_orders CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;

-- 2. Tabla de Proveedores (Suppliers)
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    contact_email VARCHAR(100)
);

-- 3. Tabla de Cabecera de Órdenes de Compra (Purchase Orders)
CREATE TABLE purchase_orders (
    po_id SERIAL PRIMARY KEY,
    po_number VARCHAR(20) UNIQUE NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Draft',
    supplier_id INT REFERENCES suppliers(supplier_id)
);

-- 4. Tabla de Líneas de Detalle (PO Lines con line_no y category)
CREATE TABLE po_lines (
    line_id SERIAL PRIMARY KEY,
    po_id INT REFERENCES purchase_orders(po_id) ON DELETE CASCADE,
    line_no INT NOT NULL,
    category VARCHAR(50) NOT NULL,
    product_sku VARCHAR(50) NOT NULL,
    description TEXT,
    quantity INT,            -- Permite NULL para probar casos del Ejercicio 3
    unit_price NUMERIC(10, 2) -- Permite negativos/cero para probar el Ejercicio 3
);

-- 5. Vista v_po_lines actualizada
CREATE OR REPLACE VIEW v_po_lines AS
SELECT 
    po.po_number,
    po.order_date,
    po.status,
    s.company_name AS supplier_name,
    l.line_id,
    l.line_no,
    l.category,
    l.product_sku,
    l.description,
    l.quantity,
    l.unit_price,
    (l.quantity * l.unit_price) AS total_line_amount
FROM purchase_orders po
JOIN suppliers s ON po.supplier_id = s.supplier_id
JOIN po_lines l ON po.po_id = l.po_id;

-- =====================================================
-- 6. CARGA DE DATOS REALISTAS PARA LOS 3 EJERCICIOS
-- =====================================================

-- 12 Proveedores
INSERT INTO suppliers (supplier_id, company_name, country, contact_email) VALUES
(1, 'Global Tech Logistics', 'España', 'info@globaltech.es'),
(2, 'Roma Hardware SpA', 'Italia', 'ordini@romahardware.it'),
(3, 'Berlin Components GmbH', 'Alemania', 'sales@berlincomp.de'),
(4, 'Nordic Industrial Supplies', 'Suecia', 'orders@nordicsupply.se'),
(5, 'Milano Cables & Wire', 'Italia', 'commerciale@milanocables.it'),
(6, 'Iberia Raw Materials', 'España', 'compras@iberiamat.es'),
(7, 'Alps Machinery Solutions', 'Suiza', 'sales@alpsmachinery.ch'),
(8, 'Euro packaging Ltd', 'Reino Unido', 'orders@europack.co.uk'),
(9, 'Lazio Network Services', 'Italia', 'contact@lazionet.it'),
(10, 'Vanguard Security Systems', 'Francia', 'contact@vanguardsec.fr'),
(11, 'Prime Office Solutions', 'Portugal', 'geral@primeoffice.pt'),
(12, 'Baltic Electronics', 'Polonia', 'sales@balticel.pl');

SELECT setval('suppliers_supplier_id_seq', 12);

-- Órdenes de compra del año 2025 (para Ejercicio 1)
INSERT INTO purchase_orders (po_id, po_number, order_date, status, supplier_id) VALUES
(1,  'PO-2025-001', '2025-01-15', 'Approved', 1),
(2,  'PO-2025-002', '2025-02-10', 'Completed', 2),
(3,  'PO-2025-003', '2025-02-28', 'Approved', 3),
(4,  'PO-2025-004', '2025-03-12', 'Completed', 4),
(5,  'PO-2025-005', '2025-04-05', 'Completed', 5),
(6,  'PO-2025-006', '2025-04-20', 'Approved', 6),
(7,  'PO-2025-007', '2025-05-18', 'Completed', 7),
(8,  'PO-2025-008', '2025-06-01', 'Completed', 8),
(9,  'PO-2025-009', '2025-07-14', 'Approved', 9),
(10, 'PO-2025-010', '2025-08-22', 'Completed', 10),
(11, 'PO-2025-011', '2025-09-05', 'Completed', 11),
(12, 'PO-2025-012', '2025-10-11', 'Approved', 12),
(13, 'PO-2025-013', '2025-11-03', 'Completed', 1),
(14, 'PO-2025-014', '2025-11-20', 'Completed', 2),
(15, 'PO-2025-015', '2025-12-05', 'Approved', 3);

SELECT setval('purchase_orders_po_id_seq', 15);

-- Líneas de orden de compra
-- Distribuidas en categorías como 'Hardware' e 'Industrial' para superar los 100.000 € y 5 proveedores (Ejercicio 2)
INSERT INTO po_lines (po_id, line_no, category, product_sku, description, quantity, unit_price) VALUES
-- Cargas en 'Hardware' (Proveedores: 1, 2, 3, 5, 9, 12 -> 6 proveedores distintos, > 100k €)
(1,  1, 'Hardware', 'SRV-RACK-01', 'Servidor Rack Enterprise', 10, 4500.00),
(1,  2, 'Hardware', 'SW-48P-POE',  'Switch Core 48 Puertos',   15, 1200.00),
(2,  1, 'Hardware', 'SSD-NVME-4TB', 'Módulos Almacenamiento NVMe', 50, 600.00),
(3,  1, 'Hardware', 'CPU-XEON-24', 'Procesadores para Servidores', 20, 1850.00),
(5,  1, 'Hardware', 'CAB-FIBER-10G','Cableado estructurado fibra', 100, 350.00),
(9,  1, 'Hardware', 'ROUTER-BGP',   'Enrutador perimetral', 4, 6200.00),
(12, 1, 'Hardware', 'CONT-MEM-32',  'Módulos RAM industriales', 60, 400.00),

-- Cargas en 'Industrial' (Proveedores: 4, 6, 7, 8 -> 4 proveedores)
(4,  1, 'Industrial', 'ENG-PUMP-200', 'Bomba hidráulica industrial', 5, 12500.00),
(6,  1, 'Industrial', 'STEEL-BEAM-X', 'Vigas estructurales', 30, 1100.00),
(7,  1, 'Industrial', 'VALVE-AUTO-01', 'Válvula automatizada', 40, 850.00),
(8,  1, 'Industrial', 'PACK-HEAVY-BOX', 'Embalaje pesado', 200, 150.00),

-- Más compras del año 2025
(10, 1, 'Seguridad',  'CAM-4K-IP',    'Cámaras domo IP exterior', 25, 420.00),
(11, 1, 'Mobiliario', 'DESK-ERG-01',  'Puestos de trabajo ergonómicos', 30, 520.00),
(13, 1, 'Hardware',   'FIREWALL-500', 'Dispositivo UTM Firewall', 2, 8500.00),
(14, 1, 'Hardware',   'SAN-ARRAY-01', 'Cabina de almacenamiento SAN', 1, 32000.00),
(15, 1, 'Hardware',   'UPS-10KVA',    'Sistema de respaldo eléctrico', 3, 4100.00),

-- =========================================================================
-- DATOS ANÓMALOS INTENCIONALES PARA AUDITORÍA (Cumpliendo el Ejercicio 3)
-- =========================================================================
(2, 2, 'Hardware', 'ERR-SKU-01', 'Producto con precio negativo', 5, -25.00),
(3, 2, 'Hardware', 'ERR-SKU-02', 'Producto con precio cero', 10, 0.00),
(4, 2, 'Industrial', 'ERR-SKU-03', 'Producto con cantidad nula', NULL, 150.00),
(1, 1, 'Hardware', 'SRV-RACK-01', 'Registro DUPLICADO (mismo po_id 1 y line_no 1)', 10, 4500.00);