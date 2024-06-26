SELECT
    DUC.CO_SEQ_UNIDADE_CENTRO_CUSTO AS COD_UN,
    DP.CO_TIPO_CENTRO_CUSTO AS CO_TPCC,
    TPC.NO_TIPO_CENTRO_CUSTO AS NM_TPCC,
    DCC.CO_SEQ_CENTRO_CUSTO AS CO_CC,
    DCC.NO_CENTRO_CUSTO AS NM_CC,
    DP.CO_ITEM_PRODUCAO AS CO_IP,
    DIP.NO_ITEM_PRODUCAO AS NM_IP,
    DCR.CO_SEQ_CRITERIO_RATEIO AS CO_CR,
    DCR.NO_CRITERIO_RATEIO AS NM_CR,
    EXTRACT(MONTH FROM DP.DT_PRODUCAO_CENTRO_CUSTO) AS MES_PROD,
    EXTRACT(YEAR FROM DP.DT_PRODUCAO_CENTRO_CUSTO) AS ANO_PROD
FROM {{ source('raw', 'TB_UNIDADE_CENTRO_CUSTO') }} DUC
INNER JOIN {{ source('raw', 'TB_TIPO_UNIDADE') }} DTT ON DUC.CO_TIPO_UNIDADE = DTT.CO_SEQ_TIPO_UNIDADE
INNER JOIN {{ source('raw', 'TB_CENTRO_CUSTO') }} DCC ON DUC.CO_SEQ_UNIDADE_CENTRO_CUSTO = DCC.CO_UNIDADE_CENTRO_CUSTO
LEFT JOIN {{ source('raw', 'TB_PRODUCAO') }} DP ON DCC.CO_SEQ_CENTRO_CUSTO = DP.CO_CENTRO_CUSTO
LEFT JOIN {{ source('raw', 'TB_CRITERIO_RATEIO') }} DCR ON DP.CO_CRITERIO_RATEIO = DCR.CO_SEQ_CRITERIO_RATEIO
LEFT JOIN {{ source('raw', 'TB_MOVIMENTACAO_CUSTO') }} MC ON DP.CO_CENTRO_CUSTO = MC.CO_CENTRO_CUSTO AND DP.DT_PRODUCAO_CENTRO_CUSTO = MC.DT_MOVIMENTACAO_CUSTO
LEFT JOIN {{ source('raw', 'TB_ITEM_PRODUCAO') }} DIP ON DP.CO_ITEM_PRODUCAO = DIP.CO_SEQ_ITEM_PRODUCAO
LEFT JOIN {{ source('raw', 'TB_TIPO_CENTRO_CUSTO') }} TPC ON DP.CO_TIPO_CENTRO_CUSTO = TPC.CO_SEQ_TIPO_CENTRO_CUSTO
WHERE EXTRACT(YEAR FROM DP.DT_PRODUCAO_CENTRO_CUSTO) BETWEEN 2013 AND 2024
