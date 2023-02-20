> Dataset to be used:

`bigquery-public-data.samples.github_nested`

-- DDL:
-- Create Bigquery dataset 
CREATE SCHEMA
  samples;

-- Query nested table structure
SELECT
  repository.organization,
  actor_attributes.company,
  actor_attributes.location,
  repository.open_issues,
  repository.watchers,
  repository.has_downloads,
  SUBSTRING(repository.pushed_at, 0, 10) as date_push
FROM
  `bigquery-public-data.samples.github_nested`;


-- Create unnested table
CREATE OR REPLACE TABLE
  `samples.github_nested` AS
SELECT
  repository.organization,
  actor_attributes.company,
  actor_attributes.location,
  repository.open_issues,
  repository.watchers,
  repository.has_downloads,
  SUBSTRING(repository.pushed_at, 0, 10) as date_push
FROM
  `bigquery-public-data.samples.github_nested`;

-- Create unnested partitioned table
CREATE TABLE
  `samples.github_nested_partitioned`
PARTITION BY
  date_push
CLUSTER BY location
 AS
SELECT
  repository.organization,
  actor_attributes.company,
  actor_attributes.location,
  repository.open_issues,
  repository.watchers,
  repository.has_downloads,
  cast(PARSE_DATE("%Y/%m/%d",SUBSTRING(repository.pushed_at, 0, 10)) as date) as date_push
FROM
  `bigquery-public-data.samples.github_nested`;

-- DML
-- Query nested table
SELECT 
organization,
company,			
location,			
open_issues,			
watchers,			
date_push,
  RANK() OVER (PARTITION BY COUNT(has_downloads)
  ORDER BY 
    COUNT(open_issues), COUNT(watchers), COUNT(has_downloads) desc) 
 FROM `YOUR_GCP_PROJECT_ID.samples.github_nested`
 group by 
 organization,
company,			
location,			
open_issues,			
watchers,			
date_push

-- Query partitioned table
SELECT 
organization,
company,			
location,			
open_issues,			
watchers,			
date_push,
  RANK() OVER (PARTITION BY COUNT(has_downloads)
  ORDER BY 
    COUNT(open_issues), COUNT(watchers), COUNT(has_downloads) desc) 
 FROM `YOUR_GCP_PROJECT_ID.samples.github_nested_partitioned`
 group by 
 organization,
company,			
location,			
open_issues,			
watchers,			
date_push
