--Consulta: Top 3 estados com mais apreensões no ano mais recente (Daniel)

WITH ano_recente AS (
    SELECT MAX(ano) AS ano_atual FROM dv_armas_estado_ano
)
SELECT 
    estado,
    total_armas
FROM dv_armas_estado_ano
WHERE ano = (SELECT ano_atual FROM ano_recente)
ORDER BY total_armas DESC
FETCH FIRST 3 ROWS ONLY;

--Total de armas apreendidas por ano (Daniel)

SELECT 
    ano,
    SUM(total_armas) AS total_armas
FROM dv_armas_estado_ano
GROUP BY ano
ORDER BY ano;



--Top 5 Armas mais utilizadas, em cada mês (Lucas)
SELECT
    mes,
    arm_especie,
    mar_nome AS marca,
    clb_descricao AS calibre,
    total_ocorrencias
FROM (
    SELECT 
        mes,
        arm_especie,
        mar_nome,
        clb_descricao,
        total_ocorrencias,
        RANK() OVER (PARTITION BY mes ORDER BY total_ocorrencias DESC) AS posicao
    FROM mv_ocorrencias_armas_completas
)
WHERE posicao <= 5
ORDER BY mes, posicao;

--Top 3 Marcas mais utilizadas, em cada mês (Lucas)
SELECT
    mes,
    marca,
    total_ocorrencias
FROM (
    SELECT
        mes,
        mar_nome AS marca,
        SUM(total_ocorrencias) AS total_ocorrencias,
        RANK() OVER (PARTITION BY mes ORDER BY SUM(total_ocorrencias) DESC) AS posicao
    FROM mv_ocorrencias_armas_completas
    WHERE mar_nome IS NOT NULL
    GROUP BY mes, mar_nome
)
WHERE posicao <= 3
ORDER BY mes, posicao;


--Top 3 Calibres mais utilizados, em cada mês (Lucas)
SELECT
    mes,
    calibre,
    total_ocorrencias
FROM (
    SELECT
        mes,
        clb_descricao AS calibre,
        SUM(total_ocorrencias) AS total_ocorrencias,
        RANK() OVER (PARTITION BY mes ORDER BY SUM(total_ocorrencias) DESC) AS posicao
    FROM mv_ocorrencias_armas_completas
    WHERE clb_descricao IS NOT NULL
    GROUP BY mes, clb_descricao
)
WHERE posicao <= 3
ORDER BY mes, posicao;



--Ocorrências por espécie de arma e tipo de ocorrência (João)
SELECT 
    especie_arma,
    tipo_ocorrencia,
    SUM(total_ocorrencias) AS total
FROM mv_analise_armas_ocorrencias
GROUP BY especie_arma, tipo_ocorrencia
ORDER BY total DESC;

--Top 10 municípios com mais ocorrências envolvendo “Pistola” (João)

SELECT 
    municipio,
    SUM(total_ocorrencias) AS total
FROM mv_analise_armas_ocorrencias
WHERE especie_arma = 'Pistola'
GROUP BY municipio
ORDER BY total DESC
FETCH FIRST 10 ROWS ONLY;

--Evolução mensal de ocorrências com “Espingarda” (João)

SELECT 
    mes,
    SUM(total_ocorrencias) AS total
FROM mv_analise_armas_ocorrencias
WHERE especie_arma = 'Espingarda'
GROUP BY mes
ORDER BY 
    TO_NUMBER(mes);



--Total de ocorrências por município (todos os meses e tipos) (Sérgio)
SELECT municipios, SUM(total_ocorrencias) AS total_ocorrencias
FROM mv_ocorrencias_mensais
GROUP BY municipios
ORDER BY total_ocorrencias DESC;

--Total de ocorrências por tipo (todos os municípios e meses) (Sérgio)
SELECT tipos_ocorrencia, SUM(total_ocorrencias) AS total_ocorrencias
FROM mv_ocorrencias_mensais
GROUP BY tipos_ocorrencia
ORDER BY total_ocorrencias DESC;

--Total de ocorrências por mês (todos os municípios e tipos) (Sérgio)
SELECT mes, SUM(total_ocorrencias) AS total_ocorrencias
FROM mv_ocorrencias_mensais
GROUP BY mes
ORDER BY 
  CASE mes
    WHEN 'janeiro' THEN 1
    WHEN 'fevereiro' THEN 2
    WHEN 'março' THEN 3
    WHEN 'abril' THEN 4
    WHEN 'maio' THEN 5
    WHEN 'junho' THEN 6
    WHEN 'julho' THEN 7
    WHEN 'agosto' THEN 8
    WHEN 'setembro' THEN 9
    WHEN 'outubro' THEN 10
    WHEN 'novembro' THEN 11
    WHEN 'dezembro' THEN 12
    ELSE 13
  END;

--Ocorrências mensais detalhadas para um município específico (Sérgio)
SELECT mes, tipos_ocorrencia, total_ocorrencias
FROM mv_ocorrencias_mensais
WHERE municipios = 'ABELARDO LUZ' -- Fazer uma opção para mudar o municipio no power bi
ORDER BY 
  CASE mes
    WHEN 'janeiro' THEN 1
    WHEN 'fevereiro' THEN 2
    WHEN 'março' THEN 3
    WHEN 'abril' THEN 4
    WHEN 'maio' THEN 5
    WHEN 'junho' THEN 6
    WHEN 'julho' THEN 7
    WHEN 'agosto' THEN 8
    WHEN 'setembro' THEN 9
    WHEN 'outubro' THEN 10
    WHEN 'novembro' THEN 11
    WHEN 'dezembro' THEN 12
    ELSE 13
  END,
  tipos_ocorrencia;

--Top 5 municípios com mais ocorrências de um tipo específico (Sérgio)
SELECT municipios, SUM(total_ocorrencias) AS total_ocorrencias
FROM mv_ocorrencias_mensais
WHERE tipos_ocorrencia = 'Apreensão de Arma de Fogo'  -- Fazer uma opção para mudar o tipo de ocorrencia no power bi
GROUP BY municipios
ORDER BY total_ocorrencias DESC
FETCH FIRST 5 ROWS ONLY;
