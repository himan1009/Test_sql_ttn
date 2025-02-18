-- Table creation query for employees
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    salary DECIMAL(10,2),
    department_id INT
);

-- Table creation query for orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

-- Table creation query for products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    quantity INT,
    status VARCHAR(20) -- 'active' or 'discontinued'
);

-- Table creation query for sales
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT,
    quantity INT,
    sale_date DATE
);


-- Inserting records into the employees table
INSERT INTO employees (first_name, last_name, age, salary, department_id) VALUES
('John', 'Doe', 35, 50000, 101),
('Jane', 'Smith', 28, 60000, 102),
('Michael', 'Johnson', 42, 70000, 103);

-- Inserting records into the orders table
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-02-10'),
(2, '2024-02-15'),
(3, '2024-02-18'),
(1, '2024-02-20'),
(4, '2024-02-22');

-- Inserting records into the products table
INSERT INTO products (product_name, category, price, quantity, status) VALUES
('Smartphone', 'Electronics', 799.99, 100, 'active'),
('Laptop', 'Electronics', 1299.99, 50, 'active'),
('T-shirt', 'Clothing', 19.99, 200, 'active'),
('Sneakers', 'Clothing', 59.99, 150, 'active'),
('Headphones', 'Electronics', 99.99, 75, 'discontinued');

-- Inserting records into the sales table
INSERT INTO sales (product_id, quantity, sale_date) VALUES
(1, 10, '2024-02-10'),
(2, 5, '2024-02-12'),
(3, 20, '2024-02-15'),
(4, 15, '2024-02-18'),
(1, 8, '2024-02-20');

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO customers (name, email) VALUES
    ('Alice Johnson', 'alice@example.com'),
    ('Bob Smith', 'bob@example.com'),
    ('Charlie Brown', 'charlie@example.com'),
    ('Charlie Brown1', 'charlie1@example.com')   
,('Charlie 123', 'charlie123@example.com')   ;


CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO departments (id, name) VALUES
    (101, 'HR'),
    (102, 'Finance'),
    (103, 'Sales');



--1.Write a query to retrieve the names and ages of employees, sorted by age in descending order.
select first_name, last_name, age 
from employees
order by age desc;



--2.Retrieve orders placed between '2024-02-15' and '2024-02-20' from the "orders" table.
select order_id, order_date
from orders
where order_date between '2024-02-15' and '2024-02-20';



--3.Write a query to retrieve the product names and categories for products belonging to either 'Electronics' or 'Clothing'.
select product_name
from products
where category in ('Electronics', 'Clothing');



--4.Retrieve the total sales amount for each product from the "sales" table, sorted in descending order of sales.
select p.product_id, p.product_name, sum(s.quantity*p.price) as total_sales
from sales as s
join products as p 
on s.product_id=p.product_id
group by p.product_id, p.product_name
order by total_sales desc;



--5.Calculate the average salary per department for departments with more than five employees.
select e.department_id, d.name as department_name, AVG(e.salary) as avg_salary
from employees as e
join departments d 
on e.department_id=d.id
group by e.department_id, d.name 
having count(e.employee_id)>5;




--6.Write a query to find the number of orders placed by each customer in the "orders" table.
select o.customer_id, c.name, count(o.customer_id) as no_of_orders
from orders as o 
join customers c 
on o.customer_id=c.customer_id
group by o.customer_id, c.name;




--7.Retrieve the names of employees who have not been assigned to any department.
select first_name, last_name
from employees
where department_id is null;



--8.Find the highest and lowest salaries among employees in the "employees" table.
select max(salary) as highest_salary, min(salary) as lowest_salary
from employees;



--9.Write a query to retrieve the names of employees who have orders placed after '2024-02-15'.
select distinct e.first_name, e.last_name, o.order_date
from employees as e 
join orders as o 
on e.employee_id = o.customer_id 
where o.order_date >'2024-02-15';

--10.Retrieve the order IDs along with the corresponding customer IDs, including orders where the customer ID is not available.
select o.customer_id, o.order_id
from orders as o
left join customers as c
on o.customer_id=c.customer_id 
order by o.customer_id;

--11.Combine the results of two queries: one retrieving active products and the other retrieving discontinued products, eliminating duplicate entries.
select *
from products p 
where status='active'
union
select *
from products p 
where status='discontinued';



--12.Retrieve the product names along with the total quantity sold for each product, sorted in descending order of total quantity sold.
select p.product_name, sum(s.quantity) as total_quantity_sold
from products as p
join sales s 
on p.product_id =s.product_id 
group by p.product_name
order by total_quantity_sold desc;



--13.Write a query to find the total number of orders placed in the month of February 2024.
select count(*)
from orders
where order_date between '2024-02-01' and '2024-02-29';



--14.Retrieve the names of employees along with the total number of orders placed by each employee.
select e.first_name, e.last_name, count(o.order_id) as total_orders
from employees as e
left join orders as o
on e.employee_id=o.customer_id 
group by e.employee_id, e.first_name, e.last_name
order by total_orders desc;


--15.Calculate the total sales amount for each product category.
select p.category, sum(s.quantity * p.price) as total_sales_amount
from products p 
join sales s 
on p.product_id=s.product_id 
group by p.category;



--16.Write a query to find the product names containing the word 'phone' in their name.
select product_name
from products 
where product_name ilike '%phone%';



--17.Retrieve the order IDs and dates for orders placed by customers with IDs 1, 3, or 5.
select order_id, order_date
from orders
where customer_id in (1, 3, 5);



--18.Find the average age of employees in the company.
select avg(age) as avg_age
from employees;



--19.Retrieve the names and ages of employees who have a salary greater than the average salary.
select first_name, last_name, age
from employees 
where salary>(select avg(salary) from employees);



--20. Write a query to find the number of active and discontinued products in each category.
select category,
	   count(case when status='active' then 1 end) as active_products,
	   count(case when status='discontinued' then 1 end) as discontinued_products
from products
group by category;

