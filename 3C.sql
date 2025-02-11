SELECT DISTINCT app_store_name,app_store_primary_genre,
((app_store_total+play_store_total)-app_store_upkeep_cost)::money-(app_store_purchase_price::money+play_store_purchase_price) AS total_profit
FROM (SELECT *,
app_store_longevity*1000 AS app_store_upkeep_cost,
play_store_longevity*1000 AS play_store_upkeep_cost,
app_store_longevity*5000 AS app_store_total,
play_store_longevity*5000 AS play_store_total
FROM (SELECT *,
CASE WHEN app_store_price = 0.00 THEN 2.50*10000 ELSE app_store_price*10000 END AS app_store_purchase_price,
CASE WHEN play_store_price::money = 0.00::money THEN 2.50::money*10000 ELSE play_store_price::money*10000 END AS play_store_purchase_price,
ROUND((ROUND(app_store_rating*4)/4)/.25 * 6)+12 AS app_store_longevity,
ROUND((ROUND(play_store_rating*4)/4)/.25 * 6)+12 AS play_store_longevity
FROM (SELECT name AS app_store_name,
size_bytes AS app_store_size_bytes,
currency AS app_store_currency,
price AS app_store_price,
review_count AS app_store_review_count,
rating AS app_store_rating,
content_rating AS app_store_content_rating,
primary_genre AS app_store_primary_genre
FROM app_store_apps) AS cleaned_app_store
INNER JOIN (SELECT
name AS play_store_name,
rating AS play_store_rating,
review_count AS play_store_review_count,
size AS play_store_size,
install_count AS play_store_install_count,
type AS play_store_type,
price AS play_store_price,
content_rating AS play_store_content_rating,
genres AS play_store_genres
FROM play_store_apps) AS cleaned_play_store 
ON cleaned_app_store.app_store_name = cleaned_play_store.play_store_name) AS both_store_metadata) AS store_totals
WHERE app_store_name = 'Egg, Inc.'
OR app_store_name ILIKE 'Domino%s Pizza USA'
OR app_store_name = 'Microsoft Excel'
OR app_store_name = 'DoorDash - Food Delivery'
ORDER BY total_profit DESC
LIMIT 4;
