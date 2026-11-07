# Bitácora de Aprendizaje - Semana 1

## Log de 3 Errores Identificados
1. **Error al filtrar agregaciones con WHERE en lugar de HAVING:**
   - Intentar usar `WHERE SUM(...) > 100000` falla porque el motor SQL evalúa `WHERE` antes de consolidar los grupos. Se debe usar `HAVING`.
2. **Confusión en funciones de ventana (OVER vs GROUP BY):**
   - Usar `GROUP BY` colapsa las filas perdiendo el identificador único de la línea. Se resolvió usando `COUNT(*) OVER (PARTITION BY po_id, line_no)` dentro de una CTE para auditar duplicados.
3. **División entera en cálculo de porcentajes:**
   - Si no se trabaja con tipos numéricos/decimales, la división de totales puede redondear a cero. Se aseguró el uso de `NUMERIC` y `ROUND(..., 2)`.

## Respuestas de la Micro-evaluación
- **¿Resolviste cada ejercicio en ≤ 30 min?** Sí.
- **¿Los porcentajes suman 100?** Sí, al calcularse mediante `SUM(...) OVER ()` sobre el universo anual evaluado.
- **¿Orden lógico de ejecución de una consulta?**
  1. FROM / JOIN
  2. WHERE
  3. GROUP BY
  4. HAVING
  5. SELECT
  6. DISTINCT
  7. ORDER BY
  8. LIMIT / OFFSET