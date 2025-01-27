# Film Database Analysis

## Project Description

This project focuses on analyzing the Sakila film database to extract meaningful insights about films, actors, and genres. By leveraging SQL queries, we aim to answer specific questions such as identifying films with the longest run times per rating, discovering the newest movies in various languages, and finding the top actors in the action and drama categories. This analysis can assist filmmakers, researchers, and movie enthusiasts in understanding trends and patterns within the film industry.

## Queries

### 1. Longest Run Time by Rating
This query retrieves the films with the longest run time for each rating.

```sql
SELECT film_id, length AS runtime, rating, title AS film_title
FROM sakila.film f
WHERE f.length = (
    SELECT MAX(f2.length)
    FROM sakila.film f2
    WHERE f2.rating = f.rating
);
SELECT f.film_id, f.title, f.release_year, l.last_update, l.name
FROM sakila.film f
JOIN sakila.language l ON f.language_id = l.language_id 
WHERE f.release_year = (
    SELECT MAX(f2.release_year)
    FROM sakila.film f2
    WHERE l.language_id = f.language_id
);
SELECT 
    o.first_name, 
    o.last_name,
    COUNT(fa.film_id) AS film_count
FROM 
    sakila.actor o
JOIN
    sakila.film_actor fa ON o.actor_id = fa.actor_id
JOIN
    sakila.film_category fc ON fa.film_id = fc.film_id
JOIN
    sakila.category c ON fc.category_id = c.category_id
WHERE
    c.name IN ('Action', 'Drama') 
GROUP BY
    o.actor_id, o.first_name, o.last_name
ORDER BY
    film_count DESC
LIMIT 5;
SELECT 
    c.name AS genre_name,
    COUNT(fc.film_id) AS film_count
FROM 
    sakila.film_category fc
JOIN 
    sakila.category c ON fc.category_id = c.category_id
GROUP BY 
    c.name
ORDER BY 
    film_count DESC
LIMIT 1;
WITH most_common_genre AS (
    SELECT 
        c.name AS genre_name,
        COUNT(fc.film_id) AS film_count
    FROM 
        sakila.film_category fc
    JOIN 
        sakila.category c ON fc.category_id = c.category_id
    GROUP BY 
        c.name
    ORDER BY 
        film_count DESC
    LIMIT 1
)
SELECT 
    f.title,
    f.rental_rate
FROM 
    sakila.film f
JOIN 
    sakila.film_category fc ON f.film_id = fc.film_id
JOIN 
    sakila.category c ON fc.category_id = c.category_id
JOIN 
    most_common_genre mcg ON c.name = mcg.genre_name
ORDER BY 
    f.rental_rate DESC
LIMIT 3;
Feel free to adjust any section to better suit your needs!
