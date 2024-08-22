--1.1 Data base creation
CREATE DATABASE AirQualityDB
WITH 
OWNER = postgres
ENCODING = 'UTF8'
CONNECTION LIMIT = -1;

--schema creation using setting the connection to AirQualityDB
CREATE SCHEMA AirqualitySC;

--table creation 
CREATE TABLE AirqualitySC.AirQuality (
    Date DATE,
    Time TIME,
    CO_GT FLOAT,
    PT08_S1_CO INTEGER,
    NMHC_GT INTEGER,
    C6H6_GT FLOAT,
    PT08_S2_NMHC INTEGER,
    NOx_GT INTEGER,
    PT08_S3_NOx INTEGER,
    NO2_GT INTEGER,
    PT08_S4_NO2 INTEGER,
    PT08_S5_O3 INTEGER,
    T FLOAT,
    RH FLOAT,
    AH FLOAT
);


--1.2 Inset data from a CSV local file Air Quality Data Set.
COPY AirqualitySC.AirQuality
FROM 'C:\data_test\AirQualityUCI.csv'
DELIMITER ','
CSV HEADER;


--1.3 Query to Identify the Worst Air Quality
--worst record was get at 2004-11-23 at 18 hours getting CO_GT=11.9, C6H6_GT=50.6 and NO2_GT=220

select * 
from AirqualitySC.AirQuality
order by CO_GT desc, C6H6_GT desc, NO2_GT desc
limit 1;

--1.4 Query for Average and Variability NO2(GT)
-- for NO2(GT) rounded average is 58.15 and population standard deviation is 126.93

select 
	round(avg(NO2_GT),2)  as NO2_GT_AVG,
	round(STDDEV_POP(NO2_GT),2)  as NO2_GT_SD
from AirqualitySC.AirQuality;

--1.5 Query with Specific Conditions CO_GT > 2.0 AND T < 15.0
--- getting rows 1416
select 
	*
from AirqualitySC.AirQuality
WHERE CO_GT > 2.0 AND T < 15.0;

--1.6 Python script that connects to the AirQualityDB

--The following lines are the python script used to connect to the DB:
-- from sqlalchemy import create_engine
-- import pandas as pd

-- # Crear la cadena de conexión usando SQLAlchemy
-- engine = create_engine('postgresql+psycopg2://postgres:Test*123@localhost:5432/airqualitydb')

-- # Definir la consulta SQL
-- query = "SELECT * FROM AirqualitySC.AirQuality;"

-- # Leer la consulta en un DataFrame de pandas usando la conexión de SQLAlchemy
-- airquality_df = pd.read_sql_query(query, engine)

-- # Mostrar las primeras filas del DataFrame
-- print(airquality_df.head())
