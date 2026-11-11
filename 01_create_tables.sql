-- Query: Create all tables for BESS Performance Tracker
-- Description: Creates site_info, tariff_zones and battery_cycles tables
-- Database: energy_project.db
-- Author: Abhishekkumar Panchal

CREATE TABLE site_info (
    site_id      INTEGER PRIMARY KEY,
    site_name    TEXT,
    location     TEXT,
    capacity_kwh REAL,
    max_power_kw REAL
);

CREATE TABLE tariff_zones (
    hour         INTEGER PRIMARY KEY,
    zone         TEXT,
    rate_eur_kwh REAL
);

CREATE TABLE battery_cycles (
    cycle_id        INTEGER PRIMARY KEY,
    site_id         INTEGER,
    cycle_date      TEXT,
    charge_start    TEXT,
    charge_end      TEXT,
    discharge_start TEXT,
    discharge_end   TEXT,
    energy_in_kwh   REAL,
    energy_out_kwh  REAL,
    soc_start       REAL,
    soc_end         REAL
);