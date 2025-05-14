-- Create Database
CREATE DATABASE OnlineBookstore;

use database OnlineBookstore; 

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\WIN10\Downloads\Sql datasets\Books.csv'
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:/Users/WIN10/Downloads/Sql datasets/Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:/Users/WIN10/Downloads/Sql datasets/Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:
SELECT *
FROM Books
WHERE genre='Fiction';


-- 2) Find books published after the year 1950:
SELECT *
FROM Books
WHERE published_year>1950;

-- 3) List all customers from the Canada:
SELECT *
FROM Customers
WHERE Country='Canada';

-- 4) Show orders placed in November 2023:
SELECT *
FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND  '2023-11-30'

-- 5) Retrieve the total stock of books available:
SELECT Sum(stock)as total_stock FROM Books;


-- 6) Find the details of the most expensive book:
Select * FROM Books
Order by price limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
WHERE Quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders
WHERE total_amount>20;

-- 9) List all genres available in the Books table:
Select distinct genre from Books;

-- 10) Find the book with the lowest stock:
Select * FROM Books
Order by stock limit 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount)as revenue from Orders;
-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
Select b.genre,sum(o.quantity)
from Orders o
join Books b on o.book_id=b.book_id
group by b.genre;


-- 2) Find the average price of books in the "Fantasy" genre:
select genre, avg(price)
from Books
where genre='Fantasy'
group by genre

--or
select avg(price) as avg_price 
from Books
where genre= 'Fantasy'

-- 3) List customers who have placed at least 2 orders:
Select c.customer_id,c.name,count(o.order_id) as order_count
from Orders o join Customers c on o.customer_id=c.customer_id
group by c.customer_id,c.name
having count(o.order_id)>=2;

-- 4) Find the most frequently ordered book:
Select o.book_id,b.title,count(o.order_id) as order_count
from Orders o join Books b on o.book_id= b.book_id
group by o.book_id,b.title
order by count(o.order_id) desc

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
Select title,max(price)
from Books
where genre = 'Fantasy'
group by title
order by max(price) desc limit 3;

--or

Select * from Books
where genre = 'Fantasy'
order by price desc limit 3;


-- 6) Retrieve the total quantity of books sold by each author:
select b.author,sum(o.quantity)as total_quantity
from Books b join Orders o on b.book_id=o.book_id
group by b.author


-- 7) List the cities where customers who spent over $30 are located:
Select distinct c.city,o.total_amount
from Customers c join Orders o on c.customer_id=o.customer_id
where o.total_amount>30;

-- 8) Find the customer who spent the most on orders:
Select c.customer_id ,c.name,sum(o.total_amount) as total
from Customers c join Orders o on c.customer_id=o.customer_id
group by  c.customer_id, c.name
order by total desc limit 1

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;





