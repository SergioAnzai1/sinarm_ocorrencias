-- Views do Sérgio Anzai

-- Criação da View Dinamica
CREATE OR REPLACE VIEW dv_ocorrencias_mensais AS
WITH 
meses_existentes AS (
    SELECT DISTINCT oco_mes AS mes FROM USER_LAB.ocorrencias
    UNION
    SELECT DISTINCT hoco_mes AS mes FROM USER_LAB.h_ocorrencias
),
municipios_todos AS (
    SELECT mun_id, mun_nome FROM USER_LAB.municipios
    UNION
    SELECT hmun_id AS mun_id, hmun_nome AS mun_nome FROM USER_LAB.h_municipios
),
mun_meses AS (
    SELECT m.mun_id, m.mun_nome, me.mes
    FROM municipios_todos m
    CROSS JOIN meses_existentes me
),
ocorrencias_todas AS (
    SELECT oco_mun_id AS mun_id, oco_toc_id AS toc_id, oco_mes AS mes
    FROM USER_LAB.ocorrencias
    UNION ALL
    SELECT hoco_mun_id AS mun_id, hoco_toc_id AS toc_id, hoco_mes AS mes
    FROM USER_LAB.h_ocorrencias
)
SELECT 
    mm.mun_nome AS municipios,
    toc.toc_descricao AS tipos_ocorrencia,
    CASE 
        WHEN mm.mes = 1 THEN 'janeiro'
        WHEN mm.mes = 2 THEN 'fevereiro'
        WHEN mm.mes = 3 THEN 'março'
        WHEN mm.mes = 4 THEN 'abril'
        WHEN mm.mes = 5 THEN 'maio'
        WHEN mm.mes = 6 THEN 'junho'
        WHEN mm.mes = 7 THEN 'julho'
        WHEN mm.mes = 8 THEN 'agosto'
        WHEN mm.mes = 9 THEN 'setembro'
        WHEN mm.mes = 10 THEN 'outubro'
        WHEN mm.mes = 11 THEN 'novembro'
        WHEN mm.mes = 12 THEN 'dezembro'
        ELSE 'sem mês'
    END AS mes,
    COUNT(ot.mun_id) AS total_ocorrencias
FROM mun_meses mm
CROSS JOIN USER_LAB.tipos_ocorrencia toc
LEFT JOIN ocorrencias_todas ot
    ON ot.mun_id = mm.mun_id
   AND ot.toc_id = toc.toc_id
   AND ot.mes = mm.mes
GROUP BY mm.mun_nome, toc.toc_descricao, mm.mes
ORDER BY mm.mun_nome, mm.mes, toc.toc_descricao;
/

-- Criação da View Materializada
CREATE MATERIALIZED VIEW mv_ocorrencias_mensais
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
municipios_todos AS (
    SELECT mun_id, mun_nome FROM USER_LAB.municipios
    UNION
    SELECT hmun_id AS mun_id, hmun_nome AS mun_nome FROM USER_LAB.h_municipios
),
mun_meses AS (
    SELECT m.mun_id, m.mun_nome, me.mes
    FROM municipios_todos m
    CROSS JOIN meses_existentes me
),
ocorrencias_todas AS (
    SELECT oco_mun_id AS mun_id, oco_toc_id AS toc_id, oco_mes AS mes
    FROM USER_LAB.ocorrencias
    UNION ALL
    SELECT hoco_mun_id AS mun_id, hoco_toc_id AS toc_id, hoco_mes AS mes
    FROM USER_LAB.h_ocorrencias
)
SELECT 
    mm.mun_nome AS municipios,
    toc.toc_descricao AS tipos_ocorrencia,
    CASE 
        WHEN mm.mes = 1 THEN 'janeiro'
        WHEN mm.mes = 2 THEN 'fevereiro'
        WHEN mm.mes = 3 THEN 'março'
        WHEN mm.mes = 4 THEN 'abril'
        WHEN mm.mes = 5 THEN 'maio'
        WHEN mm.mes = 6 THEN 'junho'
        WHEN mm.mes = 7 THEN 'julho'
        WHEN mm.mes = 8 THEN 'agosto'
        WHEN mm.mes = 9 THEN 'setembro'
        WHEN mm.mes = 10 THEN 'outubro'
        WHEN mm.mes = 11 THEN 'novembro'
        WHEN mm.mes = 12 THEN 'dezembro'
        ELSE 'sem mês'
    END AS mes,
    COUNT(ot.mun_id) AS total_ocorrencias
FROM mun_meses mm
CROSS JOIN USER_LAB.tipos_ocorrencia toc
LEFT JOIN ocorrencias_todas ot
    ON ot.mun_id = mm.mun_id
   AND ot.toc_id = toc.toc_id
   AND ot.mes = mm.mes
GROUP BY mm.mun_nome, toc.toc_descricao, mm.mes
ORDER BY mm.mun_nome, mm.mes, toc.toc_descricao;
/
