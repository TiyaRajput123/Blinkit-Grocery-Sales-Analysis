CREATE TABLE BLINKIT (
    "Item Fat Content" VARCHAR(80),
    "Item Identifier" VARCHAR(20),
    "Item Type" VARCHAR(50),
    "Outlet Establishment Year" INT,
    "Outlet Identifier" VARCHAR(20),
    "Outlet Location Type" VARCHAR(20),
    "Outlet Size" VARCHAR(20),
    "Outlet Type" VARCHAR(30),
    "Item Visibility" DECIMAL(10,9),
    "Item Weight" DECIMAL(10,5),
    "Total Sales" DECIMAL(10,5),
    "Rating" DECIMAL(5,4)
);
SELECT * FROM BLINKIT

UPDATE BLINKIT
SET "Item Fat Content"=
CASE
WHEN "Item Fat Content" IN ('LF','low fat') THEN 'Low Fat'
WHEN "Item Fat Content" = 'reg' THEN 'Regular'
ELSE "Item Fat Content"
END

SELECT COUNT(*) FROM BLINKIT

SELECT * FROM BLINKIT

SELECT DISTINCT("Item Fat Content") FROM BLINKIT

/* =====================================================
   PART 1 : BUSINESS REQUIREMENT - KPI's
===================================================== */

/* 1. TOTAL SALES */

SELECT SUM("Total Sales") AS "TOTAL_SALES"
FROM BLINKIT;

SELECT CAST(SUM("Total Sales")/1000000 AS DECIMAL(10,2)) AS "TOTAL SALES MILLIONS"
FROM BLINKIT;

/* 2. AVERAGE SALES */

SELECT AVG("Total Sales") AS "AVERAGE SALES"
FROM BLINKIT;

SELECT CAST(AVG("Total Sales") AS DECIMAL(10,0)) AS "AVERAGE SALES"
FROM BLINKIT;

/* 3. NUMBER OF ITEMS */

SELECT
    COUNT(*) AS "NUMBER OF ITEMS"
FROM BLINKIT;

/* 4. AVERAGE RATING */

SELECT AVG("Rating") AS "AVERAGE RATING"
FROM BLINKIT;

SELECT CAST(AVG("Rating") AS DECIMAL(10,2)) AS "AVERAGE RATING"
FROM BLINKIT;


/* =====================================================
   PART 2 : BUSINESS REQUIREMENT - ANALYSIS
===================================================== */

/* Total Sales by Fat Content */

SELECT
    "Item Fat Content",
    CAST(SUM("Total Sales") AS DECIMAL(10,2)) AS "TOTAL SALES"
FROM BLINKIT
GROUP BY "Item Fat Content";


/* Total Sales by Item Type */

SELECT
    "Item Type",
    CAST(SUM("Total Sales") AS DECIMAL(10,2)) AS "TOTAL SALES"
FROM BLINKIT
GROUP BY "Item Type"
ORDER BY "TOTAL SALES" DESC;


/* Fat Content by Outlet Location */

SELECT
    "Outlet Location Type",
    "Item Fat Content",
    ROUND(SUM("Total Sales"),2) AS "TOTAL SALES"
FROM BLINKIT
GROUP BY
    "Outlet Location Type",
    "Item Fat Content"
ORDER BY "Outlet Location Type";


/* Low Fat vs Regular */

SELECT
    "Outlet Location Type",

    COALESCE(
        SUM("Total Sales")
        FILTER (WHERE "Item Fat Content"='Low Fat'),
        0
    ) AS "Low Fat",

    COALESCE(
        SUM("Total Sales")
        FILTER (WHERE "Item Fat Content"='Regular'),
        0
    ) AS "Regular"

FROM BLINKIT

GROUP BY "Outlet Location Type"

ORDER BY "Outlet Location Type";


/* Total Sales by Outlet Establishment Year */

SELECT
    "Outlet Establishment Year",
    ROUND(SUM("Total Sales"),2) AS "TOTAL SALES"
FROM BLINKIT
GROUP BY "Outlet Establishment Year"
ORDER BY "Outlet Establishment Year";


/* =====================================================
   PART 3 : CHART REQUIREMENTS
===================================================== */

SELECT
    "Outlet Size",
    ROUND(SUM("Total Sales"),2) AS "TOTAL SALES",
    ROUND(
        SUM("Total Sales")*100.0/
        SUM(SUM("Total Sales")) OVER(),
        2
    ) AS "SALES PERCENTAGE"
FROM BLINKIT
GROUP BY "Outlet Size"
ORDER BY "TOTAL SALES" DESC;


/* Sales by Outlet Location */

SELECT
  "Outlet Location Type",
    ROUND(SUM("Total Sales"),2) AS "TOTAL SALES"
FROM BLINKIT
GROUP BY "Outlet Location Type"
ORDER BY "TOTAL SALES" DESC;


/* All Metrics by Outlet Type */

SELECT
    "Outlet Type",
  ROUND(SUM("Total Sales"),2) AS "TOTAL SALES",

    ROUND(
        SUM("Total Sales")*100.0/
        SUM(SUM("Total Sales")) OVER(),
        2
    ) AS "SALES PERCENTAGE",

    ROUND(AVG("Total Sales"),2) AS "AVERAGE SALES",

    COUNT(*) AS "NUMBER OF ITEMS",

    ROUND(AVG("Rating"),2) AS "AVERAGE RATING"

FROM BLINKIT
GROUP BY "Outlet Type"
ORDER BY "TOTAL SALES" DESC;