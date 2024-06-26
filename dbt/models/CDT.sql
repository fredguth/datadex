SELECT
    DUC.SG_UF AS UF,
    DES.DT_DESPESA,
    EXTRACT(MONTH FROM DES.DT_DESPESA) AS MES,
    EXTRACT(YEAR FROM DES.DT_DESPESA) AS ANO,
    DES.CO_UNIDADE_CENTRO_CUSTO AS COD_UN,
    GC.CO_SEQ_GRUPO_CUSTO AS COD_GC,
    GC.NO_GRUPO_CUSTO AS NM_GC,
    CASE
            WHEN CC.CO_TIPO_CENTRO_CUSTO = 1 THEN 'Administrativo'
            WHEN CC.CO_TIPO_CENTRO_CUSTO = 2 THEN 'Intermediario'
            WHEN CC.CO_TIPO_CENTRO_CUSTO = 3 THEN 'Externo'
            WHEN CC.CO_TIPO_CENTRO_CUSTO = 4 THEN 'Final'
    END AS COD_TIPO_CC,
    CC.CO_TIPO_CENTRO_CUSTO AS COD_TIPO_CC,
    CC.CO_SEQ_CENTRO_CUSTO AS COD_CC,
    CC.NO_CENTRO_CUSTO AS NM_CC,
    CC.NO_CENTRO_CUSTO_UNIDADE AS NM_CC_UN,
    IC.CO_SEQ_ITEM_CUSTO AS COD_IC,
    IC.NO_ITEM_CUSTO AS NM_IC,
    round_even(SUM(DCC.VL_DESP_CENTRO_CUSTO),2) AS VL_DESP
FROM {{ ref('TB_DESPESA_CENTRO_CUSTO') }} DCC
INNER JOIN {{ ref('TB_DESPESA') }} DES ON DCC.CO_DESPESA = DES.CO_SEQ_DESPESA
INNER JOIN {{ ref('TB_CENTRO_CUSTO') }} CC ON DCC.CO_CENTRO_CUSTO = CC.CO_SEQ_CENTRO_CUSTO
INNER JOIN {{ ref('TB_UNIDADE_CENTRO_CUSTO') }} DUC ON DES.CO_UNIDADE_CENTRO_CUSTO = DUC.CO_SEQ_UNIDADE_CENTRO_CUSTO
INNER JOIN {{ ref('TB_ITEM_CUSTO') }} IC ON DES.CO_ITEM_CUSTO = IC.CO_SEQ_ITEM_CUSTO
INNER JOIN {{ ref('TB_GRUPO_CUSTO') }} GC ON IC.CO_GRUPO_CUSTO = GC.CO_SEQ_GRUPO_CUSTO
WHERE DES.ST_REGISTRO_ATIVO = 'S'
AND CC.ST_REGISTRO_ATIVO = 'S'
AND CC.CO_TIPO_CENTRO_CUSTO IS NOT NULL
AND DES.VL_DESPESA IS NOT NULL 
AND DES.DT_DESPESA BETWEEN '2022-03-01' AND '2024-03-31'
-- remover registros de teste
AND DUC.CO_SEQ_UNIDADE_CENTRO_CUSTO NOT IN (3353, 4473)
GROUP BY 
    DES.DT_DESPESA,
    DUC.SG_UF,
    DES.CO_UNIDADE_CENTRO_CUSTO,
    GC.CO_SEQ_GRUPO_CUSTO,
    GC.NO_GRUPO_CUSTO,
    IC.CO_SEQ_ITEM_CUSTO,
    IC.NO_ITEM_CUSTO,
    CC.CO_SEQ_CENTRO_CUSTO,
    CC.NO_CENTRO_CUSTO,
    CC.NO_CENTRO_CUSTO_UNIDADE,
    CC.CO_TIPO_CENTRO_CUSTO
ORDER BY 
    DES.DT_DESPESA, 
    GC.NO_GRUPO_CUSTO, 
    IC.NO_ITEM_CUSTO
