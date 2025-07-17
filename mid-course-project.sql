-- Question 1:

-- Level: Simple

-- Topic: DISTINCT

-- Task: Create a list of all the different (distinct) replacement costs of the films.

-- Question: What's the lowest replacement cost?

-- Answer: 9.99

SELECT DISTINCT replacement_cost
FROM film
ORDER BY replacement_cost
LIMIT 1


-- Question 2:

-- Level: Moderate

-- Topic: CASE + GROUP BY

-- Task: Write a query that gives an overview of how many films have replacements costs in the following cost ranges

--     low: 9.99 - 19.99

--     medium: 20.00 - 24.99

--     high: 25.00 - 29.99

-- Question: How many films have a replacement cost in the "low" group?

-- Answer: 514

SELECT count
FROM (
    SELECT
    CASE
        WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
        WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
        WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 'high'
    END AS replacement_cost_category,
    COUNT(replacement_cost) AS count
    FROM film
    GROUP BY replacement_cost_category
    ORDER BY COUNT DESC
)
LIMIT 1


-- Question 3:

-- Level: Moderate

-- Topic: JOIN

-- Task: Create a list of the film titles including their title, length, and category name ordered descendingly by length. Filter the results to only the movies in the category 'Drama' or 'Sports'.

-- Question: In which category is the longest film and how long is it?

-- Answer: Sports and 184

SELECT category.name, film.length
FROM film_category
LEFT JOIN film
ON film_category.film_id = film.film_id
LEFT JOIN category
ON film_category.category_id = category.category_id
WHERE category.name IN ('Drama', 'Sports')
ORDER BY film.length DESC
LIMIT 1


-- Question 4:

-- Level: Moderate

-- Topic: JOIN & GROUP BY

-- Task: Create an overview of how many movies (titles) there are in each category (name).

-- Question: Which category (name) is the most common among the films?

-- Answer: Sports with 74 titles

SELECT category.name, COUNT(film.title) AS title_count
FROM film_category
LEFT JOIN film
ON film_category.film_id = film.film_id
LEFT JOIN category
ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY title_count DESC
LIMIT 1


-- Question 5:

-- Level: Moderate

-- Topic: JOIN & GROUP BY

-- Task: Create an overview of the actors' first and last names and in how many movies they appear in.

-- Question: Which actor is part of most movies??

-- Answer: Susan Davis with 54 movies

SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS actor, COUNT(film.title) AS movies
FROM film_actor
LEFT JOIN actor
ON film_actor.actor_id = actor.actor_id
LEFT JOIN film
ON film_actor.film_id = film.film_id
GROUP BY actor
ORDER BY movies DESC
LIMIT 1


-- Question 6:

-- Level: Moderate

-- Topic: LEFT JOIN & FILTERING

-- Task: Create an overview of the addresses that are not associated to any customer.

-- Question: How many addresses are that?

-- Answer: 4

SELECT COUNT(address.address_id)
FROM address
LEFT JOIN customer
ON address.address_id = customer.address_id
WHERE customer.customer_id IS NULL


-- Question 7:

-- Level: Moderate

-- Topic: JOIN & GROUP BY

-- Task: Create the overview of the sales  to determine the from which city (we are interested in the city in which the customer lives, not where the store is) most sales occur.

-- Question: What city is that and how much is the amount?

-- Answer: Cape Coral with a total amount of 221.55

SELECT city.city, SUM(payment.amount) AS amount
FROM payment
LEFT JOIN customer
ON payment.customer_id = customer.customer_id
LEFT JOIN address
ON customer.address_id = address.address_id
LEFT JOIN city
ON address.city_id = city.city_id
GROUP BY city.city 
ORDER BY amount DESC
LIMIT 1


-- Question 8:

-- Level: Moderate to difficult

-- Topic: JOIN & GROUP BY

-- Task: Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".

-- Question: Which country, city has the least sales?

-- Answer: United States, Tallahassee with a total amount of 50.85.

SELECT country.country, city.city, SUM(payment.amount) AS revenue
FROM payment
LEFT JOIN customer
ON payment.customer_id = customer.customer_id
LEFT JOIN address
ON customer.address_id = address.address_id
LEFT JOIN city
ON address.city_id = city.city_id
LEFT JOIN country
ON city.country_id = country.country_id
GROUP BY country.country, city.city 
ORDER BY revenue
LIMIT 1


-- Question 9:

-- Level: Difficult

-- Topic: Uncorrelated subquery

-- Task: Create a list with the average of the sales amount each staff_id has per customer.

-- Question: Which staff_id makes on average more revenue per customer?

-- Answer: staff_id 2 with an average revenue of 56.64 per customer.

SELECT staff_id, ROUND(AVG(revenue), 2) AS average
FROM (
    SELECT customer_id, staff_id, SUM(amount) AS revenue
    FROM payment
    GROUP BY customer_id, staff_id
) AS customer_revenue
GROUP BY staff_id
ORDER BY average DESC
LIMIT 1


-- Question 10:

-- Level: Difficult to very difficult

-- Topic: EXTRACT + Uncorrelated subquery

-- Task: Create a query that shows average daily revenue of all Sundays.

-- Question: What is the daily average revenue of all Sundays?

-- Answer: 1410.65

SELECT ROUND(AVG(revenue), 2)
FROM (
    SELECT EXTRACT(DOW FROM payment_date) AS sunday, SUM(amount) AS revenue, DATE(payment_date) AS sundate
    FROM payment
    WHERE EXTRACT(DOW FROM payment_date) = 0
    GROUP BY sundate, sunday
) AS daily_revenue


-- Question 11:

-- Level: Difficult to very difficult

-- Topic: Correlated subquery

-- Task: Create a list of movies - with their length and their replacement cost - that are longer than the average length in each replacement cost group.

-- Question: Which two movies are the shortest on that list and how long are they?

-- Answer: CELEBRITY HORN and SEATTLE EXPECTATIONS with 110 minutes.

SELECT title, length, replacement_cost 
FROM film AS film_
WHERE length > (
	SELECT AVG(length)
	FROM film film__
	WHERE film_.replacement_cost = film__.replacement_cost
)
ORDER BY length
LIMIT 2


-- Question 12:

-- Level: Very difficult

-- Topic: Uncorrelated subquery

-- Task: Create a list that shows the "average customer lifetime value" grouped by the different districts.

-- Example:
-- If there are two customers in "District 1" where one customer has a total (lifetime) spent of $1000 and the second customer has a total spent of $2000 then the "average customer lifetime spent" in this district is $1500.

-- So, first, you need to calculate the total per customer and then the average of these totals per district.

-- Question: Which district has the highest average customer lifetime value?

-- Answer: Saint-Denis with an average customer lifetime value of 216.54.

SELECT address.district, ROUND(AVG(total), 2) AS lifetime_total
FROM (
    SELECT customer.customer_id, customer.address_id, SUM(payment.amount) AS total
    FROM payment
    LEFT JOIN customer
    ON payment.customer_id = customer.customer_id
    GROUP BY customer.customer_id
) AS lifetime
LEFT JOIN address
ON lifetime.address_id = address.address_id
GROUP BY address.district
ORDER BY lifetime_total DESC
LIMIT 1


-- Question 13:

-- Level: Very difficult

-- Topic: Correlated query

-- Task: Create a list that shows all payments including the payment_id, amount, and the film category (name) plus the total amount that was made in this category. Order the results ascendingly by the category (name) and as second order criterion by the payment_id ascendingly.

-- Question: What is the total revenue of the category 'Action' and what is the lowest payment_id in that category 'Action'?

-- Answer: Total revenue in the category 'Action' is 4375.85 and the lowest payment_id in that category is 16055.

SELECT SUM(amount)
FROM (
    -- executing this subquery alone will show the lowest payment_id
	SELECT payment.payment_id, payment.amount, category.name
	FROM payment
	LEFT JOIN rental
	ON payment.rental_id = rental.rental_id
	LEFT JOIN inventory
	ON rental.inventory_id = inventory.inventory_id
	LEFT JOIN film_category
	ON inventory.film_id = film_category.film_id
	LEFT JOIN category
	ON film_category.category_id = category.category_id
	WHERE category.name IN ('Action')
	ORDER BY payment_id
)


-- Bonus question 14:

-- Level: Extremely difficult

-- Topic: Correlated and uncorrelated subqueries (nested)

-- Task: Create a list with the top overall revenue of a film title (sum of amount per title) for each category (name).

-- Question: Which is the top-performing film in the animation category?

-- Answer: DOGMA FAMILY with 178.70.


SELECT film.title, SUM(payment.amount) AS top_performing
FROM payment
LEFT JOIN rental
ON payment.rental_id = rental.rental_id
LEFT JOIN inventory
ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film_category
ON inventory.film_id = film_category.film_id
LEFT JOIN film
ON film_category.film_id = film.film_id
LEFT JOIN category
ON film_category.category_id = category.category_id
WHERE category.name IN ('Animation')
GROUP BY film.title
ORDER BY top_performing DESC