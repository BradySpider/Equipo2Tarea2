/*Importamos datos desde archivos de excel*/
FILENAME REFFILE '/home/u63628016/Tarea2/hdi.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;

FILENAME REFFILE '/home/u63628016/Tarea2/le.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT2;
	GETNAMES=YES;
RUN;

FILENAME REFFILE '/home/u63628016/Tarea2/NG.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT3;
	GETNAMES=YES;
RUN;
/*Unimos tablas para crear una nueva*/
PROC SQL;
   CREATE TABLE work.combined_data AS 
   SELECT * 
   FROM WORK.IMPORT1
   FULL JOIN WORK.IMPORT2
   ON IMPORT1.Country = IMPORT2.Country;
QUIT;
/*Para encontrar el país, hdi_2021 y le_2021 correspondientes al máximo hdi_2021*/
PROC SQL;
SELECT Country, hdi_2021, le_2021
FROM work.combined_data
WHERE hdi_2021 = (SELECT MAX(hdi_2021) FROM work.combined_data);
QUIT;
/*Para encontrar los registros donde hdi_2021 es igual a 0.478, eliminando duplicados*/
PROC SQL;
SELECT DISTINCT Country, hdi_2021, le_2021
FROM work.combined_data
WHERE hdi_2021 = 0.478;
QUIT;
/*Para encontrar los registros donde hdi_2021 es mayor que 0.900*/
PROC SQL;
SELECT DISTINCT Country, hdi_2021, le_2021
FROM work.combined_data
WHERE hdi_2021 > 0.900;
QUIT;
/*Para encontrar los registros donde hdi_2021 es mayor que 0.900 y le_2021 es menor que 80*/
PROC SQL;
SELECT DISTINCT Country, hdi_2021, le_2021
FROM work.combined_data
WHERE hdi_2021 > 0.900 AND le_2021 < 80;
QUIT;
/*vamos a calcular la media*/
PROC MEANS DATA=work.combined_data MEAN;
VAR hdi_2021 le_2021;
RUN;
