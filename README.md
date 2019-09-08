# Business Inteligence Project

Yet another Business Intelligence student project.

## Overview

### Goal

Main goal is to store and visualize historical hourly weather data: [Historical hourly weather data-set](https://www.kaggle.com/selfishgene/historical-hourly-weather-data)

### Realization

For visualization [__Elastic stack__](https://www.elastic.co/products/elastic-stack) is used, which is composed of [Kibana](https://www.elastic.co/products/kibana) and [Elasticsearch](https://www.elastic.co/products/elasticsearch). [Pentaho Data Integration](https://www.hitachivantara.com/en-us/products/big-data-integration-analytics/pentaho-data-integration.html) is used for data transformation.

Simplified workflow is shown bellow:
```
CSV data-set -----------> Data Warehouse -----------> ElasticSearch <====== Kibana
               Pentaho                     Pentaho
               Data                        Data
               Integration                 Integration
```

## Dataset

Dataset contains ~5years worth hourly weather measurements like temperature, pressure for 36 different cities.
Each attribute has it's own file and is organized such that the rows are the time axis (it's the same time axis for all files), and the columns are the different cities (it's the same city ordering for all files as well).
```
         +--------+--------+--------+-------+
         | city_1 | city_2 |   ...  |
+-------------------------------------------+
| time_1 | value  | value  |        |
+-------------------------------------------+
| time_2 | value  | value  |        |
+-------------------------------------------+
| time_3 | value  | value  |        |
+-------------------------------------------+
| ...    |        |        |        |
+        +        +        +        +

```

## Data Warehouse Model

For DW model star schema is used
```
+--------------------------------+                                                          +-------------------------+
|          DATETIME_DIM          |                                                          |         CITY_DIM        |
+--------------------------------+                                                          +-------------------------+
+--------------------------------+                                                          +-------------------------+
| datetime_dim_id        int     +<-----+                                              +--->+ city_dim_id             |
+--------------------------------+      |                                              |    +-------------------------+
| hour                   int     |      |                                              |    | name            varchar |
| minute                 int     |      |                                              |    | country         varchar |
| year                   int     |      |                                              |    | latitude        double  |
| month                  int     |      |                                              |    | longitude       double  |
| day_of_year            int     |      |                                              |    +-------------------------+
| day                    int     |      |                                              |                               
| year_week              int     |      |     +---------------------------------+      |                               
| year_quarter           int     |      |     |          MEASURMENT_FACT        |      |                               
| am_pm                  varchar |      |     +---------------------------------+      |
| astronomical_season    varchar |      |     +---------------------------------+      |
| meterological_season   varchar |      |     | measurment_id            int    |      |
+--------------------------------+      |     +---------------------------------+      |
                                        +-----+ datetime_dim_id          int    |      |
                                              | city_dim_id              int    +------+
                                              | description_dim_id       int    +------+
                                              +---------------------------------+      |
                                              | temperature_kelvin       double |      |    +------------------------------+
                                              | temperature_celsius      double |      |    |     WEATHER_DESCRIPTION_DIM  |
                                              | temperature_fahrenheit   dobule |      |    +------------------------------+
                                              | humanity                 double |      |    +------------------------------+
                                              | pressure                 double |      +--->+ description_dim_id   int     |
                                              | presure_standard_diff    double |           +------------------------------+
                                              | wind_direction           double |           | description          varchar |
                                              | wind_speed               double |           +------------------------------+
                                              +---------------------------------+

```

## Elasticsearch

Index:
```yaml
mappings:
  properties:
    temperature:
      properties:
        kelvin: {type: float}
        celsius: {type: float}
        fahrenheit: {type: float}
    huminity:
      properties:
        percentage: {type: float}
    pressure:
      properties:
        mbars: {type: float}
        standard_difference: {type: float}
    wind:
      properties:
        direction: {type: float}
        speed: {type: float}
    date:
      properties:
        date_time: {type: date, format: "dd.MM.yyyy HH:mm"}
        day_of_year: {type: integer}
        year_week: {type: integer}
        year_quarter: {type: integer}
        am_pm: {type: keyword}
        astronomical_season: {type: keyword}
        meteorological_season: {type: keyword}
    city:
      properties:
        name: {type: keyword}
        country: {type: keyword}
        location: {type: geo_point}
    description: {type: text}
```

## Kibana

![TemperatureTrends][docs/results/kibana/dashbaord_tempTrends.png]

![TemperaturePerSeason][docs/results/kibana/dashboard_tempPerSeason.png]

![TemperaturePerSeason2][docs/results/kibana/dashboard_tempPerSeason2.png]

![Temperature][docs/results/kibana/dashboard_temps.png]