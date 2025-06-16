--1.Total de Ocorrências por Tipo de Ocorrência (Comparando com o mês 1) (João)

SELECT
    toc_corrente.toc_descricao AS tipo_ocorrencia,
    toc_corrente.total_corrente,
    toc_historico.total_historico,
    ABS(toc_corrente.total_corrente - toc_historico.total_historico) AS diferenca
FROM (
    
    SELECT toc.toc_descricao, COUNT(oco.oco_id) AS total_corrente
    FROM OCORRENCIAS oco
    JOIN TIPOS_OCORRENCIA toc ON oco.oco_toc_id = toc.toc_id
    GROUP BY toc.toc_descricao
) toc_corrente
JOIN (
    
    SELECT toc.toc_descricao, COUNT(hoco.hoco_id) AS total_historico
    FROM H_OCORRENCIAS hoco
    JOIN TIPOS_OCORRENCIA toc ON hoco.hoco_toc_id = toc.toc_id
    WHERE hoco.hoco_mes = '1'
    
    GROUP BY toc.toc_descricao
) toc_historico
ON toc_corrente.toc_descricao = toc_historico.toc_descricao
ORDER BY diferenca DESC;


--2. Ocorrências por Estado (Comparando com o mês 1) (João)

SELECT 
    atual.est_uf AS estado,
    atual.total_ocorrencias AS ocorrencias_atuais,
    historico.total_ocorrencias_historico AS ocorrencias_mes1,
    ABS(atual.total_ocorrencias - historico.total_ocorrencias_historico) AS diferenca
FROM (
    
    SELECT 
        est.est_uf,
        COUNT(oco.oco_id) AS total_ocorrencias
    FROM OCORRENCIAS oco
    JOIN MUNICIPIOS mun ON oco.oco_mun_id = mun.mun_id
    JOIN ESTADOS est ON mun.mun_est_id = est.est_id
    GROUP BY est.est_uf
) atual
JOIN (
    
    SELECT 
        est.est_uf,
        COUNT(hoco.hoco_id) AS total_ocorrencias_historico
    FROM H_OCORRENCIAS hoco
    JOIN H_MUNICIPIOS hmun ON hoco.hoco_mun_id = hmun.hmun_id 
    JOIN ESTADOS est ON hmun.hmun_est_id = est.est_id 
    WHERE hoco.hoco_mes = '1'
    GROUP BY est.est_uf
) historico
ON atual.est_uf = historico.est_uf
ORDER BY diferenca DESC;


--3. Comparação entre Ocorrências por Estado Atuais e Passadas (Lucas)

SELECT est.est_uf AS estado,
       atuais.total_atuais AS ocorrencias_atuais,
       historicos.total_hist AS ocorrencias_historicas,
       ABS(atuais.total_atuais - historicos.total_hist) AS diferenca
FROM ESTADOS est
JOIN (
    SELECT mun.mun_est_id AS est_id, COUNT(*) AS total_atuais
    FROM OCORRENCIAS oco
    JOIN MUNICIPIOS mun ON oco.oco_mun_id = mun.mun_id
    GROUP BY mun.mun_est_id
) atuais ON est.est_id = atuais.est_id
JOIN (
    SELECT hmun.hmun_est_id AS est_id, COUNT(*) AS total_hist
    FROM H_OCORRENCIAS hoco
    JOIN H_MUNICIPIOS hmun ON hoco.hoco_mun_id = hmun.hmun_id
    GROUP BY hmun.hmun_est_id
) historicos ON est.est_id = historicos.est_id
ORDER BY ocorrencias_atuais DESC;

--4. Calibres mais utilizados nas Ocorrencias (Lucas)

SELECT calibre, COUNT(*) AS total_ocorrencias
FROM (
    SELECT clb.clb_descricao AS calibre
    FROM OCORRENCIAS oco
    JOIN ARMAS arm ON oco.oco_arm_id = arm.arm_id
    JOIN CALIBRES clb ON arm.arm_clb_id = clb.clb_id

    UNION ALL

    SELECT clb.clb_descricao AS calibre
    FROM H_OCORRENCIAS hoco
    JOIN H_ARMAS harm ON hoco.hoco_arm_id = harm.harm_id
    JOIN CALIBRES clb ON harm.harm_clb_id = clb.clb_id
) 
GROUP BY calibre
ORDER BY total_ocorrencias DESC;


--5. Especie da arma com maior número de ocorrencias (Daniel)

SELECT especie.arm_especie, COUNT(*) AS total_ocorrencias
FROM (
    SELECT arm.arm_especie
    FROM ocorrencias oco
    JOIN armas arm ON oco.oco_arm_id = arm.arm_id
    UNION ALL
    SELECT harm.harm_especie
    FROM h_ocorrencias hoco
    JOIN h_armas harm ON hoco.hoco_arm_id = harm.harm_id
    AND hoco.hoco_data = harm.harm_data
) especie
GROUP BY especie.arm_especie
ORDER BY total_ocorrencias DESC
FETCH FIRST 1 ROW ONLY;

--6. Estados com maior diversidade de tipos de ocorrência (Daniel)


SELECT estado.est_uf AS Estado, COUNT(DISTINCT ocorrencias_com_tipos.toc_id) AS "Tipos de Ocorrencias Diferentes"
FROM (
    SELECT oco.oco_toc_id AS toc_id, mun.mun_est_id AS est_id
    FROM ocorrencias oco
    JOIN municipios mun ON oco.oco_mun_id = mun.mun_id
    UNION ALL
    SELECT hoco.hoco_toc_id AS toc_id, hmun.hmun_est_id AS est_id
    FROM h_ocorrencias hoco
    JOIN h_municipios hmun ON hoco.hoco_mun_id = hmun.hmun_id
    AND hoco.hoco_data = hmun.hmun_data
) ocorrencias_com_tipos
JOIN estados estado ON ocorrencias_com_tipos.est_id = estado.est_id
GROUP BY estado.est_uf
ORDER BY "Tipos de Ocorrencias Diferentes" DESC;


--7. Tipos de Ocorrência por Município (Sergio)

WITH 
meses_existentes AS (
    SELECT DISTINCT oco_mes AS mes FROM ocorrencias
    UNION
    SELECT DISTINCT hoco_mes AS mes FROM h_ocorrencias
),
municipios_todos AS (
    SELECT mun_id, mun_nome FROM municipios
    UNION
    SELECT hmun_id AS mun_id, hmun_nome AS mun_nome FROM h_municipios
),
mun_meses AS (
    SELECT m.mun_id, m.mun_nome, me.mes
    FROM municipios_todos m
    CROSS JOIN meses_existentes me
),
ocorrencias_todas AS (
    SELECT oco_mun_id AS mun_id, oco_toc_id AS toc_id, oco_mes AS mes
    FROM ocorrencias
    UNION ALL
    SELECT hoco_mun_id AS mun_id, hoco_toc_id AS toc_id, hoco_mes AS mes
    FROM h_ocorrencias
)
SELECT 
    mm.mun_nome AS "Municipios",
    toc.toc_descricao AS "Tipos de ocorrencia",
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
    END AS "Mes",
    COUNT(ot.mun_id) AS "Total de ocorrencias"
FROM mun_meses mm
CROSS JOIN tipos_ocorrencia toc
LEFT JOIN ocorrencias_todas ot
    ON ot.mun_id = mm.mun_id
   AND ot.toc_id = toc.toc_id
   AND ot.mes = mm.mes
GROUP BY mm.mun_nome, toc.toc_descricao, mm.mes
ORDER BY mm.mun_nome, mm.mes, toc.toc_descricao;


--8.Armas por Marca (Sergio)

SELECT 
    mar.mar_nome AS nome_marca,
    COUNT(DISTINCT arm.arm_id) + COUNT(DISTINCT harm.harm_id) AS total_armas
FROM marcas mar

LEFT JOIN armas arm ON mar.mar_id = arm.arm_mar_id
LEFT JOIN ocorrencias oco ON arm.arm_id = oco.oco_arm_id
LEFT JOIN h_armas harm ON mar.mar_id = harm.harm_mar_id
LEFT JOIN h_ocorrencias hoco ON harm.harm_id = hoco.hoco_arm_id
GROUP BY mar.mar_nome
ORDER BY total_armas DESC;
