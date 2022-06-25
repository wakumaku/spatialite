SELECT load_extension('mod_spatialite');
SELECT CreateMissingSystemTables(1);
SELECT * FROM knn2
   WHERE f_table_name = 'airports' AND ref_geometry = MakePoint(10, 43) AND radius = 1.0;