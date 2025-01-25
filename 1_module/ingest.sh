docker run --network '1_module_default' -it taxi_ingest:v02 --user='root' --password='root' --host='pgdatabase' --port='5432' --db='ny_taxi' --table_name_1='trips'  --table_name_2='zones'
