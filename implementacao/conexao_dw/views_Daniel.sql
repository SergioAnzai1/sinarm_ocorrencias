-- Views do Daniel Adriano

-- Criação da View Dinamica
CREATE OR REPLACE VIEW dv_ocorrencias_estados_mensais AS
WITH 
meses_existentes AS (
    SELECT DISTINCT oco_mes AS mes FROM USER_LAB.ocorrencias
    UNION
    SELECT DISTINCT hoco_mes AS mes FROM USER_LAB.h_ocorrencias
),
estados_todos AS (
    SELECT e.est_id, e.est_uf FROM USER_LAB.estados e
    UNION
    SELECT he.hest_id AS est_id, he.hest_uf AS est_uf FROM USER_LAB.h_estados he
),
municipios_todos AS (
    SELECT m.mun_id, m.mun_est_id AS est_id FROM USER_LAB.municipios m
    UNION
    SELECT hm.hmun_id AS mun_id, hm.hmun_est_id AS est_id FROM USER_LAB.h_municipios hm
),
est_meses AS (
    SELECT e.est_id, e.est_uf, me.mes
    FROM estados_todos e
    CROSS JOIN meses_existentes me
),
ocorrencias_com_estado AS (
    SELECT o.oco_mes AS mes, m.mun_est_id AS est_id, o.oco_toc_id AS toc_id
    FROM USER_LAB.ocorrencias o
    JOIN USER_LAB.municipios m ON o.oco_mun_id = m.mun_id
    UNION ALL
    SELECT h.hoco_mes AS mes, hm.hmun_est_id AS est_id, h.hoco_toc_id AS toc_id
    FROM USER_LAB.h_ocorrencias h
    JOIN USER_LAB.h_municipios hm ON h.hoco_mun_id = hm.hmun_id
)
SELECT 
    em.est_uf AS estado,
    toc.toc_descricao AS tipo_ocorrencia,
    CASE 
        WHEN em.mes = 1 THEN 'janeiro'
        WHEN em.mes = 2 THEN 'fevereiro'
        WHEN em.mes = 3 THEN 'março'
        WHEN em.mes = 4 THEN 'abril'
        WHEN em.mes = 5 THEN 'maio'
        WHEN em.mes = 6 THEN 'junho'
        WHEN em.mes = 7 THEN 'julho'
        WHEN em.mes = 8 THEN 'agosto'
        WHEN em.mes = 9 THEN 'setembro'
        WHEN em.mes = 10 THEN 'outubro'
        WHEN em.mes = 11 THEN 'novembro'
        WHEN em.mes = 12 THEN 'dezembro'
        ELSE 'sem mês'
    END AS mes,
    COUNT(oe.est_id) AS total_ocorrencias
FROM est_meses em
CROSS JOIN USER_LAB.tipos_ocorrencia toc
LEFT JOIN ocorrencias_com_estado oe
    ON oe.est_id = em.est_id
   AND oe.toc_id = toc.toc_id
   AND oe.mes = em.mes
GROUP BY em.est_uf, toc.toc_descricao, em.mes;

-- Criação da View Materializada

CREATE MATERIALIZED VIEW mv_ocorrencias_estados_mensais
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
estados_todos AS (
    SELECT e.est_id, e.est_uf FROM USER_LAB.estados e
    UNION
    SELECT he.hest_id AS est_id, he.hest_uf AS est_uf FROM USER_LAB.h_estados he
),
municipios_todos AS (
    SELECT m.mun_id, m.mun_est_id AS est_id FROM USER_LAB.municipios m
    UNION
    SELECT hm.hmun_id AS mun_id, hm.hmun_est_id AS est_id FROM USER_LAB.h_municipios hm
),
est_meses AS (
    SELECT e.est_id, e.est_uf, me.mes
    FROM estados_todos e
    CROSS JOIN meses_existentes me
),
ocorrencias_com_estado AS (
    SELECT o.oco_mes AS mes, m.mun_est_id AS est_id, o.oco_toc_id AS toc_id
    FROM USER_LAB.ocorrencias o
    JOIN USER_LAB.municipios m ON o.oco_mun_id = m.mun_id
    UNION ALL
    SELECT h.hoco_mes AS mes, hm.hmun_est_id AS est_id, h.hoco_toc_id AS toc_id
    FROM USER_LAB.h_ocorrencias h
    JOIN USER_LAB.h_municipios hm ON h.hoco_mun_id = hm.hmun_id
)
SELECT 
    em.est_uf AS estado,
    toc.toc_descricao AS tipo_ocorrencia,
    CASE 
        WHEN em.mes = 1 THEN 'janeiro'
        WHEN em.mes = 2 THEN 'fevereiro'
        WHEN em.mes = 3 THEN 'março'
        WHEN em.mes = 4 THEN 'abril'
        WHEN em.mes = 5 THEN 'maio'
        WHEN em.mes = 6 THEN 'junho'
        WHEN em.mes = 7 THEN 'julho'
        WHEN em.mes = 8 THEN 'agosto'
        WHEN em.mes = 9 THEN 'setembro'
        WHEN em.mes = 10 THEN 'outubro'
        WHEN em.mes = 11 THEN 'novembro'
        WHEN em.mes = 12 THEN 'dezembro'
        ELSE 'sem mês'
    END AS mes,
    COUNT(oe.est_id) AS total_ocorrencias
FROM est_meses em
CROSS JOIN USER_LAB.tipos_ocorrencia toc
LEFT JOIN ocorrencias_com_estado oe
    ON oe.est_id = em.est_id
   AND oe.toc_id = toc.toc_id
   AND oe.mes = em.mes
GROUP BY em.est_uf, toc.toc_descricao, em.mes;
