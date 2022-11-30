# spatialite
SQLite + SpatiaLite

Version = SQLite Version - Spatialite last commit date

 3.40.0-2022-09-09

```shell
$ docker run --rm -it wakumaku/spatialite:latest sh

# apk add curl p7zip

# curl -o airports.7z https://www.gaia-gis.it/gaia-sins/knn/airports.7z

# 7za x airports.7z

# sqlite3 airports.sqlite

sqlite> SELECT load_extension('mod_spatialite');
sqlite> SELECT CreateMissingSystemTables(1);
sqlite> SELECT * FROM knn2
   ...> WHERE f_table_name = 'airports' AND ref_geometry = MakePoint(10, 43) AND radius = 1.0;
MAIN|airports|geom||1.0|3|0|1|6299623|0.338817343121628|33043.3195204468
MAIN|airports|geom||1.0|3|0|2|6299392|0.683116233521059|65226.5731488238
MAIN|airports|geom||1.0|3|0|3|6299628|0.788669213865991|82387.0140281855

```

ref: https://www.gaia-gis.it/fossil/libspatialite/wiki?name=KNN2