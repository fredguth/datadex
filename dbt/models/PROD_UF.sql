{{ config(
  enabled = false
) }}
{% for uf_filter in ['DF', 'MG'] %}
    SELECT DISTINCT
        {{ uf_filter }} AS UF,
        COD_UN,
        MES_PROD,
        ANO_PROD,
        COD_CC,
        NM_CC,
        NM_CC_UN,
        TP_CC,
        COD_IP,
        NM_IP,
        QT_IP,
        VL_CD,
        VL_CI,
        VL_CT,
        VL_UNIT
    FROM {{ ref('PROD') }}
    WHERE ANO_PROD IN (2021, 2022, 2023, 2024)
        AND COD_UN NOT IN (4473, 3553)
{% endfor %}