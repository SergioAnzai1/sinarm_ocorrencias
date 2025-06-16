-- Criação da View Dinâmica
CREATE OR REPLACE VIEW dv_ocorrencias_armas_completas AS
WITH 
meses_existentes AS (
    SELECT DISTINCT oco_mes AS mes FROM USER_LAB.ocorrencias
    UNION
    SELECT DISTINCT hoco_mes AS mes FROM USER_LAB.h_ocorrencias
),
armas_todas AS (
    SELECT arm_id, arm_especie, arm_mar_id, arm_clb_id FROM USER_LAB.armas
    UNION ALL
    SELECT harm_id AS arm_id, harm_especie, harm_mar_id, harm_clb_id FROM USER_LAB.h_armas
),
ocorrencias_todas AS (
    SELECT oco_arm_id AS arm_id, oco_mes AS mes FROM USER_LAB.ocorrencias
    UNION ALL
    SELECT hoco_arm_id AS arm_id, hoco_mes AS mes FROM USER_LAB.h_ocorrencias
),
armas_meses AS (
    SELECT a.arm_id, a.arm_especie, a.arm_mar_id, a.arm_clb_id, me.mes
    FROM armas_todas a
    CROSS JOIN meses_existentes me
)
SELECT 
    am.arm_especie,
    m.mar_nome,
    c.clb_descricao,
    CASE 
        WHEN am.mes = 1 THEN 'janeiro'
        WHEN am.mes = 2 THEN 'fevereiro'
        WHEN am.mes = 3 THEN 'março'
        WHEN am.mes = 4 THEN 'abril'
        WHEN am.mes = 5 THEN 'maio'
        WHEN am.mes = 6 THEN 'junho'
        WHEN am.mes = 7 THEN 'julho'
        WHEN am.mes = 8 THEN 'agosto'
        WHEN am.mes = 9 THEN 'setembro'
        WHEN am.mes = 10 THEN 'outubro'
        WHEN am.mes = 11 THEN 'novembro'
        WHEN am.mes = 12 THEN 'dezembro'
        ELSE 'sem mês'
    END AS mes,
    COUNT(ot.arm_id) AS total_ocorrencias
FROM armas_meses am
LEFT JOIN ocorrencias_todas ot
    ON ot.arm_id = am.arm_id
   AND ot.mes = am.mes
LEFT JOIN USER_LAB.marcas m ON am.arm_mar_id = m.mar_id
LEFT JOIN USER_LAB.calibres c ON am.arm_clb_id = c.clb_id
GROUP BY am.arm_especie, m.mar_nome, c.clb_descricao, am.mes
ORDER BY am.arm_especie, m.mar_nome, c.clb_descricao, am.mes;
/

-- Criação da View Materializada
CREATE MATERIALIZED VIEW mv_ocorrencias_armas_completas
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
WITH ROWID
AS
WITH 
meses_existentes AS (
    SELECT DISTINCT oco_mes AS mes FROM USER_LAB.ocorrencias
    UNION
    SELECT DISTINCT hoco_mes AS mes FROM USER_LAB.h_ocorrencias
),
armas_todas AS (
    SELECT arm_id, arm_especie, arm_mar_id, arm_clb_id FROM USER_LAB.armas
    UNION ALL
    SELECT harm_id AS arm_id, harm_especie, harm_mar_id, harm_clb_id FROM USER_LAB.h_armas
),
ocorrencias_todas AS (
    SELECT oco_arm_id AS arm_id, oco_mes AS mes FROM USER_LAB.ocorrencias
    UNION ALL
    SELECT hoco_arm_id AS arm_id, hoco_mes AS mes FROM USER_LAB.h_ocorrencias
),
armas_meses AS (
    SELECT a.arm_id, a.arm_especie, a.arm_mar_id, a.arm_clb_id, me.mes
    FROM armas_todas a
    CROSS JOIN meses_existentes me
)
SELECT 
    am.arm_especie,
    m.mar_nome,
    c.clb_descricao,
    CASE 
        WHEN am.mes = 1 THEN 'janeiro'
        WHEN am.mes = 2 THEN 'fevereiro'
        WHEN am.mes = 3 THEN 'março'
        WHEN am.mes = 4 THEN 'abril'
        WHEN am.mes = 5 THEN 'maio'
        WHEN am.mes = 6 THEN 'junho'
        WHEN am.mes = 7 THEN 'julho'
        WHEN am.mes = 8 THEN 'agosto'
        WHEN am.mes = 9 THEN 'setembro'
        WHEN am.mes = 10 THEN 'outubro'
        WHEN am.mes = 11 THEN 'novembro'
        WHEN am.mes = 12 THEN 'dezembro'
        ELSE 'sem mês'
    END AS mes,
    COUNT(ot.arm_id) AS total_ocorrencias
FROM armas_meses am
LEFT JOIN ocorrencias_todas ot
    ON ot.arm_id = am.arm_id
   AND ot.mes = am.mes
LEFT JOIN USER_LAB.marcas m ON am.arm_mar_id = m.mar_id
LEFT JOIN USER_LAB.calibres c ON am.arm_clb_id = c.clb_id
GROUP BY am.arm_especie, m.mar_nome, c.clb_descricao, am.mes
ORDER BY am.arm_especie, m.mar_nome, c.clb_descricao, am.mes;
