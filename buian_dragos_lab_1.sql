use [Furniture Shop]

CREATE TABLE Customer(
	customer_id INT PRIMARY KEY,
	customer_name VARCHAR(50),
);

CREATE TABLE Orders(
	order_id INT PRIMARY KEY,
	FK_customer_id INT 
	FOREIGN KEY (FK_customer_id) REFERENCES Customer(customer_id),
	product_name VARCHAR(50),
	price INT
);

CREATE TABLE Furniture_Categories(
	category_id INT PRIMARY KEY,
	category_name VARCHAR(50)
);


CREATE TABLE Products(
	product_id INT PRIMARY KEY,
	product_name VARCHAR(50),
	price INT,
	FK_category INT
	FOREIGN KEY (FK_category) REFERENCES Furniture_Categories(category_id),
);

CREATE TABLE Room_Departments(
	departament_id INT PRIMARY KEY,
	room_name VARCHAR(50),
	FK_product INT
	FOREIGN KEY (FK_product) REFERENCES Products(product_id)
);

CREATE TABLE Employees(
	employee_id INT PRIMARY KEY,
	employee_name VARCHAR(50),
	salary INT NOT NULL,
);

CREATE TABLE Employee_Room_Assignment(
	assignment_id INT PRIMARY KEY,
	FK_employee_id INT
	FOREIGN KEY (FK_employee_id) REFERENCES Employees(employee_id),
	FK_room_id INT
	FOREIGN KEY (FK_room_id) REFERENCES Room_Departments(departament_id)
);

CREATE TABLE Reviews(
	review_id INT PRIMARY KEY,
	score FLOAT,
	review_desc VARCHAR(255),
	FK_product INT
	FOREIGN KEY (FK_product) REFERENCES Products(product_id),
	FK_customer INT
	FOREIGN KEY (FK_customer) REFERENCES Customer(customer_id)
);

CREATE TABLE Materials(
    material_id INT PRIMARY KEY,
    material_name VARCHAR(50),
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    sale_percent INT CHECK (sale_percent >= 1 AND sale_percent <= 99),
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);