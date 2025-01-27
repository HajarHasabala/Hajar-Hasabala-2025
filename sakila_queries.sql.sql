-- Which films had the longest run time in each rating ?
SELECT film_id, length AS runtime, rating,title AS film_title
FROM sakila.film f
where f.length=
(select max(f2.length)
from sakila.film f2
where f2.rating = f.rating);
--
-- What is the newest movie across each language?
select f.film_id,f.title,f.release_year,l.last_update,l.name
from sakila.film f
join sakila.language l on f.language_id = l.language_id 
WHERE f.release_year = (
SELECT MAX(f2.release_year)
FROM sakila.film f2
WHERE l.language_id = f.language_id
);
-- Who are the top 5 recurring actors in action and drama films?
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
    o.first_name, 
    o.last_name,
    c.name AS category_name,
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
    o.actor_id, o.first_name, o.last_name, c.name
ORDER BY
    film_count DESC
LIMIT 5;
--
-- Which genre is the most recurring?  
UNLOCK TABLES;
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
-- what are the top 3 movies in this genre by rental rate ?
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




        

