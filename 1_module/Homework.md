1. 24.3.1
2. db:5433
3. 104,838; 199,013; 109,645; 27,688; 35,202

a)

``` sql
SELECT COUNT(*) FROM public.trips
WHERE trips.lpep_pickup_datetime >= '2019-10-01 00:00:00' AND trips.lpep_dropoff_datetime < '2019-11-02 00:00:00'
AND trip_distance <=1.00
```

b) 199004

``` sql
SELECT COUNT(*) FROM public.trips
WHERE trips.lpep_pickup_datetime >= '2019-10-01 00:00:00' AND trips.lpep_dropoff_datetime < '2019-11-02 00:00:00'
AND trip_distance > 1.00 AND trip_distance <= 3.00
```



c) 109644

```sql
SELECT COUNT(*) FROM public.trips
WHERE trips.lpep_pickup_datetime >= '2019-10-01 00:00:00' AND trips.lpep_dropoff_datetime < '2019-11-02 00:00:00'
AND trip_distance > 3.00 AND trip_distance <= 7.00
```


d) 27686

```sql
SELECT COUNT(*) FROM public.trips
WHERE trips.lpep_pickup_datetime >= '2019-10-01 00:00:00' AND trips.lpep_dropoff_datetime < '2019-11-02 00:00:00'
AND trip_distance > 7.00 AND trip_distance <= 10.00
```


e) 35202

```sql
SELECT COUNT(*) FROM public.trips
WHERE trips.lpep_pickup_datetime >= '2019-10-01 00:00:00' AND trips.lpep_dropoff_datetime < '2019-11-02 00:00:00'
AND trip_distance > 10.00
```


4. 2019-10-31

```sql
SELECT 
    DATE(trips.lpep_pickup_datetime) AS day,  -- Extract the date from the timestamp
    MAX(trip_distance) AS total_distance
FROM 
    public.trips
GROUP BY 
    DATE(trips.lpep_pickup_datetime)
ORDER BY 
    total_distance DESC;
```



5. East Harlem North, East Harlem South, Morningside Heights

```sql
SELECT 
    SUM(total_amount) AS fare, 
    trips."PULocationID", 
    zones."Zone"
FROM 
    public.trips
LEFT JOIN 
    public.zones 
ON 
    trips."PULocationID" = zones."LocationID"
WHERE 
    DATE(trips.lpep_pickup_datetime) = '2019-10-18'  
GROUP BY 
    trips."PULocationID", 
    zones."Zone"
HAVING
	SUM(total_amount) > 13000
ORDER BY 
    fare DESC;
```


6. JFK Airport

```sql
WITH tips_zone AS (SELECT "DOLocationID", tip_amount FROM public.trips
LEFT JOIN public.zones 
ON trips."PULocationID" = zones."LocationID"
WHERE DATE_PART('year', lpep_pickup_datetime) = 2019
  AND DATE_PART('month', lpep_pickup_datetime) = 10
  AND zones."Zone" = 'East Harlem North')

SELECT MAX(tips_zone.tip_amount) AS max_tip, zones."Zone"
FROM tips_zone
LEFT JOIN public.zones 
ON tips_zone."DOLocationID" = zones."LocationID"
GROUP BY 
    zones."Zone"
ORDER BY 
    max_tip DESC
LIMIT 1;
```


7. terraform init, terraform apply -auto-approve, terraform destroy