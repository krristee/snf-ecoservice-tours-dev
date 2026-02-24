# 🚀 snf-ecoservice-debts Project Setup Guide

This document explains how to configure and run the **dbt project template** with Snowflake and GitHub Actions.  

---

## 1. Configure GitHub Actions Variables  

Navigate to:  
**`Settings > Secrets and variables > Actions > Variables`**  

Create the following **variables**:

| Variable | Example Value |
|----------|---------------|
| `SNOWFLAKE_HOST` | `ecoservice-prod.snowflakecomputing.com` |
| `SNOWFLAKE_PORT` | `443` |
| `SNOWFLAKE_ROLE` | `SNF_FRM_DBT` |
| `SNOWFLAKE_USER` | `SVC_DBT` |
| `SNOWFLAKE_WAREHOUSE` | `SERVICE_WH_DBT` |
| `DBT_APP_NAME` | `snf-ecoservice-debts` |
| `SNOWFLAKE_ACCOUNT` | `ecoservice-prod` |
| `SNOWFLAKE_DATABASE_PRE_DEV` | `PRE_DEV` |
| `SNOWFLAKE_DATABASE_DEV` | `DEV` |
| `SNOWFLAKE_DATABASE_UAT` | `UAT` |
| `SNOWFLAKE_DATABASE_PROD` | `PROD` |
| `SNOWFLAKE_PRE_DEV_SCHEMA` | `GOLD_DEBTS` |
| `SNOWFLAKE_DEV_SCHEMA` | `GOLD_DEBTS` |
| `SNOWFLAKE_UAT_SCHEMA` | `GOLD_DEBTS` |
| `SNOWFLAKE_PROD_SCHEMA` | `GOLD_DEBTS` |

Additionally, under:  
**`Settings > Secrets and variables > Actions > Secrets`**  

Create the following **secret**:

| Secret | Description |
|--------|-------------|
| `SNOWFLAKE_PRIVATE_KEY` | The private key used to authenticate the Snowflake user. |

---

## 2. Configure Snowflake Environment  

Ensure the following objects exist in your Snowflake environment:

- **Databases**:
  - `PRE_DEV`  (Optional) 
  - `DEV`
  - `UAT`
  - `PROD`

- **Schemas**:  
  - `GOLD_DEBTS`

- **User**:  
  - `SVC_DBT`  
  - Attach the private key (`SNOWFLAKE_PRIVATE_KEY`) to this user  
  - Assign role: `SNF_FRM_DBT`  
  - Grant access to the database, schemas, and warehouse  

### Example SQL Setup

```sql
-- Create databases
CREATE DATABASE IF NOT EXISTS PRE_DEV;
CREATE DATABASE IF NOT EXISTS DEV;
CREATE DATABASE IF NOT EXISTS UAT;
CREATE DATABASE IF NOT EXISTS PROD;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS PRE_DEV.GOLD_DEBTS;
CREATE SCHEMA IF NOT EXISTS DEV.GOLD_DEBTS;
CREATE SCHEMA IF NOT EXISTS UAT.GOLD_DEBTS;
CREATE SCHEMA IF NOT EXISTS PROD.GOLD_DEBTS;

-- Create role (if needed)
CREATE ROLE IF NOT EXISTS SNF_FRM_DBT;

-- Create user
CREATE USER IF NOT EXISTS SVC_DBT
  LOGIN_NAME = 'SVC_DBT'
  DISPLAY_NAME = 'DBT Service Account'
  DEFAULT_ROLE = SNF_FRM_DBT
  DEFAULT_WAREHOUSE = SERVICE_WH_DBT
  MUST_CHANGE_PASSWORD = FALSE;

-- Grant privileges
GRANT ROLE SNF_FRM_DBT TO USER SVC_GITHUB;
GRANT USAGE ON DATABASE PRE_DEV TO ROLE SNF_FRM_DBT;
GRANT USAGE ON DATABASE DEV TO ROLE SNF_FRM_DBT;
GRANT USAGE ON DATABASE UAT TO ROLE SNF_FRM_DBT;
GRANT USAGE ON DATABASE PROD TO ROLE SNF_FRM_DBT;
GRANT USAGE ON SCHEMA PRE_DEV.GOLD_DEBTS TO ROLE SNF_FRM_DBT;
GRANT USAGE ON SCHEMA DEV.GOLD_DEBTS TO ROLE SNF_FRM_DBT;
GRANT USAGE ON SCHEMA UAT.GOLD_DEBTS TO ROLE SNF_FRM_DBT;
GRANT USAGE ON SCHEMA PROD.GOLD_DEBTS TO ROLE SNF_FRM_DBT;

