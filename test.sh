apk add curl p7zip
curl -o airports.7z https://www.gaia-gis.it/gaia-sins/knn/airports.7z
7za x airports.7z

sqlite3 airports.sqlite < /test.sql