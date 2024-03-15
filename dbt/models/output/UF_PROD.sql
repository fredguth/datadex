{{ config(
  materialized = 'external',
  format = 'csv',
  delimiter = ';',
  location = '../data/output/',
  options={
    "partition_by": "UF",
    "overwrite_or_ignore": 1,
    "filename_pattern": "'PROD_{i}'"
    })
 }}
 select * from {{ref('PROD')}}