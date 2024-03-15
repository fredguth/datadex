WITH BASE AS 
(
    SELECT 
        DISTINCT *
        EXCLUDE ("DATA CADASTRO", "DATA ÚLTIMA ALIM", "ALIM DEZ", "ALIM 12 MESES", "N. LEITOS", "SITUAÇÃO")  
    FROM {{ source('raw', 'PL_ALIM') }}
),
IBGE AS (
    SELECT 
        COD_MUN,
        SUBSTRING(CAST(COD_MUN AS VARCHAR), 1, 6) AS COD_IBGE_SHORT, 
        Nome_Municipio AS MUNICIPIO,
        Sigla_Reg
    FROM read_csv('../data/raw/IBGE.csv')
),
UNIDADES AS (
    SELECT 
        CASE
            WHEN IBGE.Sigla_Reg = 'S' THEN 'Sul'
            WHEN IBGE.Sigla_Reg = 'N' THEN 'Norte'
            WHEN IBGE.Sigla_Reg = 'SE' THEN 'Sudeste'
            WHEN IBGE.Sigla_Reg = 'NE' THEN 'Nordeste'
            WHEN IBGE.Sigla_Reg = 'CO' THEN 'Centro-Oeste'
        END AS REGIAO,
        IBGE.MUNICIPIO,
        ESTAB.*
    FROM {{ ref('ESTAB') }} AS ESTAB
    LEFT JOIN IBGE ON CAST(ESTAB.COD_MUN AS VARCHAR) = IBGE.COD_IBGE_SHORT
),
UNIDADES_BASE AS (
from UNIDADES as a left join BASE as b on a.COD_UN=b."COD UN"::BIGINT 
    select 
        a.REGIAO,
        a.UF,
        b."UF NOME" AS ESTADO, 
        a.MUNICIPIO,
        b.GESTORA,
        b.UNIVERSIDADE,
        a.TIPO_UN,
        b.CNES,
        b.MANTENEDOR,
        b.APOIADOR,
        a.COD_UN,
        a.CNPJ_UN,
        a.NM_P_UN,
        a.NU_LEITO_ATENDE AS NU_LEITOS,
        CAST(a.DATA AS DATE) as DT_CADASTRO
)

select a.*, u.DT_DESPESA AS DT_ULT_ALIM from UNIDADES_BASE as a left join {{ref('ULT_ALIM')}} as u on COD_UN=CO_UNIDADE_CENTRO_CUSTO order by APOIADOR, UF
