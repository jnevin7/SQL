CREATE TABLE vacuum_test (
    integer_column integer
);

-- Listing 17-2: Determining the size of vacuum_test

SELECT pg_size_pretty(
           pg_total_relation_size('vacuum_test')
       );

-- optional: Determine database size   
SELECT pg_size_pretty(
           pg_database_size('analysis')
       );

-- Listing 17-3: Inserting 500,000 rows into vacuum_test

INSERT INTO vacuum_test
SELECT * FROM generate_series(1,500000);

-- Test its size again
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Listing 17-4: Updating all rows in vacuum_test

UPDATE vacuum_test
SET integer_column = integer_column + 1;

-- Test its size again (35 MB)
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Listing 17-5: Viewing autovacuum statistics for vacuum_test

SELECT relname,
       last_vacuum,
       last_autovacuum,
       vacuum_count,
       autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- To see all columns available
SELECT *
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- Listing 17-6: Running VACUUM manually

VACUUM vacuum_test;

VACUUM; -- vacuums the whole database

VACUUM VERBOSE; -- provides messages

-- Listing 17-7: Using VACUUM FULL to reclaim disk space

VACUUM FULL vacuum_test;

-- Test its size again
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Listing 17-8: Showing the location of postgresql.conf

SHOW config_file;

-- Listing 17-10: Show the location of the data directory

SHOW data_directory;

