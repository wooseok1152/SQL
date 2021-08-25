SELECT CASE WHEN DL_Q_RANGE_SUM = 0 THEN TO_NUMBER(DL_DT) ELSE -1 * TO_NUMBER(DL_DT) END AS INT_DT
FROM (
    SELECT DL_DT,
           HNGL_SHRT_NM,
           DL_TYP,
           DL_Q,
           FIRST_DL_FLAG,
           DL_Q_RANGE_SUM,
           RANGE_SUM_ZERO_FLAG,
           CASE WHEN LAG(RANGE_SUM_ZERO_FLAG) OVER(ORDER BY DL_DT) IS NOT NULL THEN DL_DT ELSE NULL END AS DL_RESTART_FLAG
    FROM (
        SELECT DL_DT,
               HNGL_SHRT_NM,
               DL_TYP,
               DL_Q,
               FIRST_DL_FLAG,
               DL_Q_RANGE_SUM,
               CASE WHEN DL_Q_RANGE_SUM = 0 THEN DL_DT ELSE NULL END AS RANGE_SUM_ZERO_FLAG
        FROM (
            SELECT DL_DT,
                   HNGL_SHRT_NM,
                   DL_TYP,
                   CASE WHEN DL_TYP = '01' THEN DL_Q ELSE -1 * DL_Q END AS DL_Q,
                   CASE WHEN LAG(DL_Q) OVER(ORDER BY DL_DT) IS NULL THEN '1' ELSE '0' END AS FIRST_DL_FLAG,
                   SUM(CASE WHEN DL_TYP = '01' THEN DL_Q ELSE -1 * DL_Q END) OVER(ORDER BY DL_DT RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS DL_Q_RANGE_SUM
            FROM (
                SELECT '20210701' AS DL_DT, '»ï¼ºÀüÀÚ' AS HNGL_SHRT_NM, '01' AS DL_TYP, 20 AS DL_Q FROM DUAL
                UNION ALL
                SELECT '20210705' AS DL_DT, '»ï¼ºÀüÀÚ' AS HNGL_SHRT_NM, '02' AS DL_TYP, 5 AS DL_Q FROM DUAL
                UNION ALL
                SELECT '20210708' AS DL_DT, '»ï¼ºÀüÀÚ' AS HNGL_SHRT_NM, '02' AS DL_TYP, 15 AS DL_Q FROM DUAL
                UNION ALL
                SELECT '20210711' AS DL_DT, '»ï¼ºÀüÀÚ' AS HNGL_SHRT_NM, '01' AS DL_TYP, 10 AS DL_Q FROM DUAL
                UNION ALL
                SELECT '20210715' AS DL_DT, '»ï¼ºÀüÀÚ' AS HNGL_SHRT_NM, '02' AS DL_TYP, 3 AS DL_Q FROM DUAL
                UNION ALL
                SELECT '20210716' AS DL_DT, '»ï¼ºÀüÀÚ' AS HNGL_SHRT_NM, '01' AS DL_TYP, 2 AS DL_Q FROM DUAL
                UNION ALL
                SELECT '20210731' AS DL_DT, '»ï¼ºÀüÀÚ' AS HNGL_SHRT_NM, '02' AS DL_TYP, 9 AS DL_Q FROM DUAL
            )
        )
    )
)
WHERE FIRST_DL_FLAG = 1 OR RANGE_SUM_ZERO_FLAG IS NOT NULL OR DL_RESTART_FLAG IS NOT NULL;