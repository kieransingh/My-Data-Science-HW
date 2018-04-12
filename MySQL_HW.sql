use sakila;

-- --- 1a Selecting the first and last name of every actor

select 
	actor_id,
	first_name,
    last_name
from actor
;
-- 1b--  Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT 
	actor_id,
	CONCAT(first_name, ' ', last_name) AS Actor_Name
FROM actor
;
-- 2a You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT 
	actor_id,
    last_name,
    first_name
FROM actor
where first_name LIKE 'Joe'
;
-- It appears there is one actor named Joe Swank (id = 9) 

-- 2b Find all actors whose last name contain the letters GEN:
SELECT 
	actor_id,
    first_name,
    last_name
FROM actor
WHERE last_name LIKE '%Gen%'
;
-- There are 4 actors/actresses 

-- 2c Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT 
    last_name,
    first_name
FROM actor
WHERE last_name LIKE '%Li%'
;
-- There is 10 people 

-- 2d Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT 
	country_id,
    country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')
;

-- 3a Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(45) AFTER first_name;
select * from actor;

-- 3b You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor
MODIFY COLUMN middle_name blob;

-- 3c Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name
;

-- 4a. List the last names of actors, as well as how many actors have that last name.
-- ?? not sure what that last name is referring to.
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
-- dont know what last name its referring too


-- 4c Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET
	first_name = 'HARPO', last_name = 'WILLIAMS'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS'
;

-- 4d if the first name of the actor is currently HARPO, change it to GROUCHO
UPDATE actor
SET
	first_name = 'MUCHO', last_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS'
;



-- 6a Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id = address.address_id
;
-- 6b Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT payment.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) AS total FROM payment
INNER JOIN staff ON staff.staff_id = payment.staff_id
WHERE DATE(payment_date) BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY staff_id
;

-- 6c List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, SUM(film_actor.actor_id) AS total_actors FROM film_actor
INNER JOIN film ON film.film_id = film_actor.film_id
GROUP BY film.title
;

-- 6d  How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(film_id) AS stock_count
FROM inventory
WHERE film_id IN(
SELECT film_id
FROM film
WHERE title = 'Hunchback Impossible'
)
;

-- 6e Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.last_name, SUM(payment.amount) AS customer_total FROM payment
INNER JOIN customer ON customer.customer_id = payment.customer_id
GROUP BY customer.last_name
;
-- 7a Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT 
	title
FROM film
WHERE language_id = 1 AND title LIKE 'K%' OR title LIKE 'Q%'
;

-- 7b Use subqueries to display all actors who appear in the film Alone Trip.
SELECT 
	first_name,
    last_name
FROM  actor
WHERE actor_id IN (
SELECT actor_id
FROM film
WHERE film.title = 'Alone Trip'
)
;

-- 7c You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.
SELECT 
	customer.first_name AS first_name,
    customer.last_name AS last_name,
	customer.email AS email,
    city.city AS city,
    country.country AS country
FROM customer
	JOIN address ON customer.address_id = address.address_id
    JOIN city ON address.city_id = city.city_id
    JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada'
;

-- 7d Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT
title
FROM film
WHERE film_id IN (
SELECT film_id 
FROM film_category
WHERE category_id = 8
)
;
-- 7e Display the most frequently rented movies in descending order.

SELECT 
	film.film_id, COUNT(film.film_id) AS rental_count,
    film.title AS film_title
FROM rental
	JOIN inventory ON inventory.inventory_id = rental.inventory_id
    JOIN film ON inventory.film_id = film.film_id
GROUP BY film_id
ORDER BY rental_count DESC
;

-- 7f Write a query to display how much business, in dollars, each store brought in.
SELECT 
	store.store_id AS store,
    SUM(amount) AS total
FROM payment
	JOIN customer ON customer.customer_id = payment.customer_id
    JOIN store ON store.store_id = customer.store_id
GROUP BY store
;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT 
	store.store_id AS store,
    city.city AS city,
    country.country AS country
FROM store
	JOIN address ON address.address_id = store.address_id
    JOIN city ON city.city_id = address.city_id
    JOIN country ON country.country_id = city.country_id
;

-- 7h. List the top five genres in gross revenue in descending order.

SELECT 
    SUM(payment.amount) AS total,
    category.name AS category
FROM rental
	JOIN payment ON rental.rental_id = payment.rental_id
	JOIN inventory ON inventory.inventory_id = rental.inventory_id
    JOIN film_category ON film_category.film_id = inventory.film_id
    JOIN category ON film_category.category_id = category.category_id
GROUP BY category
;












