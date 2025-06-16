-- VIEW MATERIALIZADA
CREATE MATERIALIZED VIEW mv_analise_armas_ocorrencias
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
WITH armas_todas AS (
    SELECT 
        arm_id AS id,
        arm_especie AS especie,
        arm_mar_id AS mar_id,
        arm_clb_id AS clb_id
    FROM USER_LAB.armas
    UNION ALL
    SELECT 
        harm_id AS id,
        harm_especie AS especie,
        harm_mar_id AS mar_id,
        harm_clb_id AS clb_id
    FROM USER_LAB.h_armas
),
ocorrencias_todas AS (
    SELECT 
        oco_id AS id,
        oco_mes AS mes,
        oco_arm_id AS arm_id,
        oco_toc_id AS toc_id,
        oco_mun_id AS mun_id
    FROM USER_LAB.ocorrencias
    UNION ALL
    SELECT 
        hoco_id AS id,
        hoco_mes AS mes,
        hoco_arm_id AS arm_id,
        hoco_toc_id AS toc_id,
        hoco_mun_id AS mun_id
    FROM USER_LAB.h_ocorrencias
),
municipios_todos AS (
    SELECT mun_id AS id, mun_nome AS nome FROM USER_LAB.municipios
    UNION ALL
    SELECT hmun_id AS id, hmun_nome AS nome FROM USER_LAB.h_municipios
),
tipos_todos AS (
    SELECT toc_id AS id, toc_descricao AS descricao FROM USER_LAB.tipos_ocorrencia
    UNION ALL
    SELECT htoc_id AS id, htoc_descricao AS descricao FROM USER_LAB.h_tipos_ocorrencia
),
dados_completos AS (
    SELECT 
        o.mes,
        m.nome AS municipio,
        t.descricao AS tipo_ocorrencia,
        a.especie AS especie_arma
    FROM ocorrencias_todas o
    LEFT JOIN armas_todas a ON a.id = o.arm_id
    LEFT JOIN municipios_todos m ON m.id = o.mun_id
    LEFT JOIN tipos_todos t ON t.id = o.toc_id
)
SELECT 
    mes,
    municipio,
    tipo_ocorrencia,
    especie_arma,
    COUNT(*) AS total_ocorrencias
FROM dados_completos
GROUP BY mes, municipio, tipo_ocorrencia, especie_arma;

-- VIEW DINÂMICA
CREATE OR REPLACE VIEW v_analise_armas_ocorrencias AS
WITH armas_todas AS (
    SELECT 
        arm_id AS id,
        arm_especie AS especie,
        arm_mar_id AS mar_id,
        arm_clb_id AS clb_id
    FROM USER_LAB.armas
    UNION ALL
    SELECT 
        harm_id AS id,
        harm_especie AS especie,
        harm_mar_id AS mar_id,
        harm_clb_id AS clb_id
    FROM USER_LAB.h_armas
),
ocorrencias_todas AS (
    SELECT 
        oco_id AS id,
        oco_mes AS mes,
        oco_arm_id AS arm_id,
        oco_toc_id AS toc_id,
        oco_mun_id AS mun_id
    FROM USER_LAB.ocorrencias
    UNION ALL
    SELECT 
        hoco_id AS id,
        hoco_mes AS mes,
        hoco_arm_id AS arm_id,
        hoco_toc_id AS toc_id,
        hoco_mun_id AS mun_id
    FROM USER_LAB.h_ocorrencias
),
municipios_todos AS (
    SELECT mun_id AS id, mun_nome AS nome FROM USER_LAB.municipios
    UNION ALL
    SELECT hmun_id AS id, hmun_nome AS nome FROM USER_LAB.h_municipios
),
tipos_todos AS (
    SELECT toc_id AS id, toc_descricao AS descricao FROM USER_LAB.tipos_ocorrencia
    UNION ALL
    SELECT htoc_id AS id, htoc_descricao AS descricao FROM USER_LAB.h_tipos_ocorrencia
),
dados_completos AS (
    SELECT 
        o.mes,
        m.nome AS municipio,
        t.descricao AS tipo_ocorrencia,
        a.especie AS especie_arma
    FROM ocorrencias_todas o
    LEFT JOIN armas_todas a ON a.id = o.arm_id
    LEFT JOIN municipios_todos m ON m.id = o.mun_id
    LEFT JOIN tipos_todos t ON t.id = o.toc_id
)
SELECT 
    mes,
    municipio,
    tipo_ocorrencia,
    especie_arma,
    COUNT(*) AS total_ocorrencias
FROM dados_completos
GROUP BY mes, municipio, tipo_ocorrencia, especie_arma;

