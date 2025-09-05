London Bike Share: Data Warehouse and Database Comparison

Author: Akash Nikam (DBS – MSc Data Analytics)
Tools: SQL Server (DB & DW), SSIS (ETL), SSRS (reports), Tableau (dashboard), Neo4j (graph DB)

Project Overview

Design and compare data storage solutions for the London Bike Share dataset. The project delivers:

A normalized relational database for raw journeys, stations, and bikes.

A star-schema data warehouse for analytics and reporting.

An SSIS ETL pipeline to populate dimensions and facts.

SSRS reports and a Tableau dashboard for business insights.

A Neo4j graph model with Cypher queries to evaluate network analysis vs. SQL.

Business goal: support operators and planners with insights on usage patterns, peak hours, station performance, and network connectivity to improve rebalancing and availability.

Tech & Platforms

Microsoft SQL Server (Database, Data Warehouse)

SQL Server Integration Services (SSIS)

SQL Server Reporting Services (SSRS)

Tableau Desktop

Neo4j Community/Enterprise

Optional: Azure Data Studio / SSMS

Install or access the above tools before reproducing.

Dataset

Source: London Bike Share Usage (Kaggle).

Core fields: timestamps, start/end stations, bike id/model, journey duration.

Recommendation: download data locally and keep large files out of the repo; store only small samples for demonstration.

Data Models

Relational schema (operational):

Stations(StationID, StationName, Location)

Bikes(BikeID, BikeModel in {CLASSIC, PBSC_EBIKE}, Status)

Journeys(JourneyID, StartDateTime, EndDateTime, StartStationID, EndStationID, BikeID, TotalDurationMS)
Integrity via foreign keys, CHECK constraints, and indexes on StartDateTime and BikeID.

Data warehouse (analytics – star schema):

DateDim(DateKey, FullDate, Year, Month, Day, DayOfWeek, Hour, IsWeekend)

StationDim(StationKey, StationID, StationName, Location)

BikeDim(BikeKey, BikeID, BikeModel)

JourneyFacts(JourneyFactID, StartDateKey, EndDateKey, StartStationKey, EndStationKey, BikeKey, JourneyCount, TotalDurationMS)

Design supports time-based aggregations, station performance, and duration metrics.

ETL (SSIS)

Control flow loads dimensions first, then JourneyFacts.

Generate StartDateKey/EndDateKey as yyyyMMddHH.

Lookup transformations map natural keys to surrogate keys in StationDim and BikeDim.

Use DISTINCT to avoid duplicates on dim loads.

Screenshots in results/ illustrate the control flow and data flows.

Reports and Visualizations

SSRS (4 reports):

Average Journey Duration by Bike Type

Journey Counts by Bike Type

Top 10 Start/End Stations

Weekend vs Weekday Usage

Tableau (4 visuals + dashboard):

Average Duration by Bike Model

Journey Counts by Hour

Journey Counts by Station

Weekend vs Weekday Usage

Combined interactive dashboard

Graph Database (Neo4j)

Graph model:

Nodes: Station, Bike

Relationships: TRAVELLED_FROM_TO (Station→Station, with TotalDurationMS, timestamps), USED_IN (Bike→Station)

Included Cypher queries cover: total journeys per station, average duration by model, popular routes, bikes with most journeys, stations with no journeys, longest journeys, and two-hop connectivity.

Relational vs Graph: Key Findings

SQL Server excels at tabular aggregations and reporting (SSRS).

Neo4j is more concise and often faster for relationship/path queries (e.g., two-hop station connectivity).

A hybrid approach is practical: relational DW for BI; graph DB for network analysis.

How to Reproduce

A. Database and Data Warehouse (SQL Server)

Create two databases (e.g., LondonBikeJourney and LondonBikeJourneyDW).

Run sql/database_and_warehouse_schema.sql to create tables in both.

Load raw CSVs into Stations, Bikes, Journeys (via BULK INSERT or SSIS).

Pre-populate DateDim for the required date/hour range.

B. ETL (SSIS)

Open your SSIS solution; configure connections to both databases.

Run the flows in order: DFT_Load_StationDim, DFT_Load_BikeDim, DFT_Load_JourneyFacts.

Validate row counts and keys.

C. Reporting (SSRS)

Point report datasets to the DW.

Deploy or run locally and verify the four reports.

D. Tableau

Open tableau/BikeSharingDashboard.twbx.

Update data source connections to your DW.

Refresh extracts.

E. Neo4j

Export CSVs for stations, bikes, journeys (or reuse the raw ones).

Ensure datetime fields are YYYY-MM-DD HH:mm:ss.

Load CSVs into Neo4j and execute neo4j/cypher_queries.cql.

Future Work

Add external dimensions (weather, events) to the DW.

Real-time or scheduled ELT using ADF or Airflow.

Predictive modeling on top of DW; route optimization with graph algorithms.

Publish a lightweight web dashboard (Power BI/Streamlit) for stakeholders.

Academic Artefacts

Full report and presentation included in reports/.

Contact

Akash Nikam — MSc Data Analytics, Dublin Business School
Email: aakashn3118@gmail.com
