#!/bin/sh
apk add --update --no-cache curl curl-dev p7zip
curl -o airports.7z https://www.gaia-gis.it/gaia-sins/knn/airports.7z
7z x airports.7z

sqlite3 airports.sqlite < /test.sql > output.txt
cat output.txt 
echo
echo "diff..."
diff output.txt test_expected_output.txt
