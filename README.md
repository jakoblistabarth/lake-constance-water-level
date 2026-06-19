# Lake Constance water level

The data are scraped using [duckdb](https://duckdb.org/) from [Hochwassernachrichtendienst Bayern/ Gewässerkundlicher Dienst Bayern](https://www.hnd.bayern.de/pegel/iller_lech/lindau-20001001).

They are provided under the Creative Commons Attribution 4.0 International License.

# TODO

- [ ] Remove duplicate entries

## Duplicate entries

Currently, there are duplicate entries in the data. Perhaps this is because of the `UNION BY NAME` in the SQL update query?

| date       | level_m | level_m_nhn | level_mean_nn | level_m_max_nn | level_m_min_nn |
| ---------- | ------- | ----------- | ------------- | -------------- | -------------- |
| 2026-06-03 | 395.06  | 395.06      | 395.08        | 395.1          | 395.04         |
| 2026-06-03 | 395.06  | 395.06      | null          | null           | null           |
