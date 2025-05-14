-- how many movies are there that contain 'Saga' in description 
-- and title starts with 'A' 
-- or ends with 'R'
-- use the alias of 'no_of_movies'
SELECT 
	COUNT(film_id) AS no_of_movies
FROM 
	film
WHERE 
	description LIKE '%Saga%' 
	AND (title LIKE 'A%' OR title LIKE '%R')


-- create a list of customers where first name contains 'ER'
-- and has 'A' as second letter
-- order by last name descendingly
SELECT
	*
FROM
	customer
WHERE
	first_name LIKE '_A%ER%'
ORDER BY
	last_name DESC


-- how many payments are there where amount is
-- either 0 or is between 3.99 and 7.99
-- and has happened in 2020-05-01
SELECT
	COUNT(payment_id)
FROM
	payment
WHERE
	(amount = 0
	OR amount BETWEEN 3.99 AND 7.99)
	AND payment_date BETWEEN '2020-05-01' AND '2020-05-02'
