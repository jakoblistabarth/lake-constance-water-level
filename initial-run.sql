INSTALL crawler
FROM
    community;

LOAD crawler;

COPY (
    WITH
        h AS (
            SELECT
                strptime (Datum, '%d.%m.%Y') AS date,
                NULLIF(
                    NULLIF(replace ("Mittelwert_[m_ü._NN]", ',', '.'), '--'),
                    ''
                ) AS mittelwert_txt,
                NULLIF(
                    NULLIF(replace ("Maximum_[m_ü._NN]", ',', '.'), '--'),
                    ''
                ) AS maximum_txt,
                NULLIF(
                    NULLIF(replace ("Minimum_[m_ü._NN]", ',', '.'), '--'),
                    ''
                ) AS minimum_txt
            FROM
                read_html (
                    'https://www.gkd.bayern.de/de/seen/wasserstand/bayern/lindau-20001001/gesamtzeitraum/tabelle?addhr=hr_s_hist',
                    'table.tblsort'
                )
        ),
        l AS (
            SELECT
                strptime (Datum, '%d.%m.%Y %H:%M') AS date,
                NULLIF(
                    NULLIF(replace (Wasserstand_m_NHN, ',', '.'), '--'),
                    ''
                ) AS wasser_txt
            FROM
                read_html (
                    'https://www.hnd.bayern.de/pegel/iller_lech/lindau-20001001/tabelle?methode=seewasserstand&setdiskr=15days=365',
                    'table.tblsort'
                )
        )
    SELECT
        COALESCE(l.date, h.date) AS date,
        COALESCE(
            CAST(l.wasser_txt AS DOUBLE),
            CAST(h.mittelwert_txt AS DOUBLE)
        ) AS level_m,
        CAST(l.wasser_txt AS DOUBLE) AS level_m_nhn,
        CAST(h.mittelwert_txt AS DOUBLE) AS level_m_mean_nn,
        CAST(h.maximum_txt AS DOUBLE) AS level_m_max_nn,
        CAST(h.minimum_txt AS DOUBLE) AS level_m_min_nn
    FROM
        h
        FULL OUTER JOIN l ON h.date = l.date
    ORDER BY
        date ASC
) TO 'levels.parquet';