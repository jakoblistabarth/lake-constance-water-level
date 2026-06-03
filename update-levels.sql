INSTALL crawler
FROM
    community;

LOAD crawler;

COPY (
    WITH
        new_data AS (
            SELECT
                strptime (Datum, '%d.%m.%Y %H:%M') AS date,
                CAST(
                    NULLIF(
                        NULLIF(replace (Wasserstand_m_NHN, ',', '.'), '--'),
                        ''
                    ) AS DOUBLE
                ) AS level_m_nhn
            FROM
                read_html (
                    'https://www.hnd.bayern.de/pegel/iller_lech/lindau-20001001/tabelle?methode=seewasserstand&setdiskr=15',
                    'table.tblsort'
                )
        )
    SELECT
        date,
        level_m_nhn AS level_m,
        level_m_nhn,
        NULL AS level_m_mean_nn,
        NULL AS level_m_max_nn,
        NULL AS level_m_min_nn
    FROM
        new_data
    UNION
    BY NAME
    FROM
        'levels.parquet'
    ORDER BY
        date ASC
) TO 'levels.parquet';
