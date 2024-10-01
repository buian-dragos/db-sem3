ALTER TABLE Materials
ADD CONSTRAINT CK_mat CHECK (material_name IN ('wood', 'plastic', 'metal', 'textile', 'leather'));

INSERT INTO Furniture_Categories (category_id, category_name)
VALUES
    (1, 'chair'),
    (2, 'table'),
    (3, 'bed'),
    (4, 'desk'),
    (5, 'wardrobe'),
    (6, 'cupboard'),
    (7, 'sofa');

INSERT INTO Products (product_id, product_name, price, FK_category)
VALUES
    (1, 'Red Chair', 49, 1),          
    (2, 'Kitchen Chair', 20, 1),      
    (3, 'Dining Table', 150, 2),      
    (4, 'Office Desk', 300, 4),        
    (5, 'Wardrobe', 250, 5),          
    (6, 'Leather Sofa', 200, 7),             
    (7, 'Coffee Table', 80, 2),       
    (8, 'Desk Chair', 200, 1),         
    (9, 'Kids Bed', 190, 3),          
    (10, 'Bookshelf', 50, 6)

INSERT INTO Materials(material_id,material_name,product_id)
VALUES
	(1,'metal',1),
	(2,'textile',1),
	(3,'plastic',3),
	(4,'wood',3),
	(5,'wood',4),
	(6,'metal',4),
	(7,'wood',5),
	(8,'metal',5),
	(9,'leather',6),
	(10,'wood',6),
	(11,'wood',7),
	(12,'metal',8),
	(13,'textile',8),
	(14,'wood',9),
	(15,'textile',9),
	(16,'wood',10);


INSERT INTO Room_Departments (departament_id, room_name)
VALUES
    (1, 'Living Room'),    
    (2, 'Kitchen'),       
    (3, 'Dining Room'),    
    (4, 'Office'),         
    (5, 'Bedroom');

INSERT INTO Aux_Rooms (aux_rooms_id, FK_departament_id, FK_product_id)
VALUES
    (1, 1, 6),    
    (2, 2, 2),       
    (3, 3, 3),    
    (4, 4, 4),         
    (5, 5, 9),        
    (6, 5, 5),        
    (7, 1, 7),          
    (8, 4, 8),
	(9, 2,7);

INSERT INTO Employees (employee_id, employee_name, salary)
VALUES
    (1, 'John Smith', 5500),
    (2, 'John Doe', 6000),
    (3, 'Alex Lee', 4800),
    (4, 'Mihai Mihai', 6200),
    (5, 'Michael Jackson', 5800);

INSERT INTO Employee_Room_Assignment(assignment_id, FK_room_id, FK_employee_id)
VALUES
	(1,2,1),
	(2,3,1),
	(3,1,2),
	(4,4,2),
	(5,4,3),
	(6,1,4),
	(7,3,4),
	(8,5,4),
	(9,5,5);
 
 SELECT * FROM Products
 SELECT * FROM Materials
 SELECT * FROM Employees

 UPDATE Employees
 SET salary=4801
 WHERE employee_id=3

 INSERT INTO Products(product_id,product_name,price)
 VALUES
	(27,'chir',2000);

UPDATE Products
SET product_name = 'char', price = 200
WHERE product_id=27

DELETE FROM Products
WHERE product_id=27

 -- invalid add
INSERT INTO Materials(material_id,material_name,product_id)
VALUES (17,'glass',7);

INSERT INTO Materials(material_id,material_name,product_id)
VALUES (17,'wood',7);

UPDATE Materials
SET material_name='textile'
WHERE material_id=17

DELETE FROM Materials
WHERE material_id=17

 -- a
 -- products > 100 and chairs
SELECT product_name
FROM Products
WHERE price > 100
UNION ALL
SELECT product_name
FROM Products
WHERE FK_category = 1;

SELECT product_name
FROM Products
WHERE price < 100
OR FK_category = 1;


-- b
-- chairs that cost < 100
SELECT product_name
FROM Products
WHERE FK_category = 1
INTERSECT
SELECT product_name
FROM Products
WHERE price < 100;

-- products that have textile material
SELECT product_name
FROM Products
WHERE product_id IN (
    SELECT product_id
    FROM Materials
    WHERE material_name = 'textile'
)


-- c
-- chairs, except chairs that cost < 100
SELECT product_name
FROM Products
WHERE FK_category = 1
EXCEPT
SELECT product_name
FROM Products
WHERE price < 100;

-- products that don't have textile material
SELECT product_name
FROM Products
WHERE product_id NOT IN (
    SELECT product_id
    FROM Materials
    WHERE material_name = 'textile'
);


-- d
-- Employees and their assigned rooms
SELECT E.employee_name, R.room_name
FROM Employees AS E
INNER JOIN Employee_Room_Assignment AS ERA ON E.employee_id = ERA.FK_employee_id
INNER JOIN Room_Departments AS R ON ERA.FK_room_id = R.departament_id;

-- products and their departament
SELECT P.product_name, RD.room_name AS department_name
FROM Products AS P
LEFT JOIN Aux_Rooms AS AR ON P.product_id = AR.FK_product_id
LEFT JOIN Room_Departments AS RD ON AR.FK_departament_id = RD.departament_id;

-- 2 many to many relations
-- employees and their assigned products
-- achieved by linking Employees to room with Employees_Room_Assignment and the rooms are linked with Aux_Rooms to the products
SELECT E.employee_name, P.product_name
FROM Employees AS E
FULL JOIN Employee_Room_Assignment AS ERA ON E.employee_id = ERA.FK_employee_id
FULL JOIN Room_Departments AS R1 ON ERA.FK_room_id = R1.departament_id
FULL JOIN Aux_Rooms AS AR ON R1.departament_id = AR.FK_departament_id
FULL JOIN Products AS P ON AR.FK_product_id = P.product_id;

-- Products and their materials
SELECT M.material_name, P.product_name
FROM Materials AS M
RIGHT JOIN Products AS P ON M.product_id = P.product_id;


-- e
-- tables
SELECT product_name
FROM Products
WHERE FK_category IN (
    SELECT category_id
    FROM Furniture_Categories
    WHERE category_name = 'table'
);

-- employees assigned to the Living Room/Kitchen
SELECT employee_name
FROM Employees
WHERE employee_id IN (
    SELECT FK_employee_id
    FROM Employee_Room_Assignment
    WHERE FK_room_id IN (
        SELECT departament_id
        FROM Room_Departments
        WHERE room_name = 'Living Room'
		OR room_name = 'Kitchen'
    )
);


-- f
-- checks if room departement exists in aux_rooms
SELECT room_name
FROM Room_Departments AS RD
WHERE EXISTS (
    SELECT 1
    FROM Aux_Rooms AS AR
    WHERE RD.departament_id = AR.FK_departament_id
);

-- checks if products exist in materials and displays the ones that contain metal
SELECT product_name
FROM Products AS P
WHERE EXISTS (
    SELECT 1
    FROM Materials AS M
    WHERE P.product_id = M.product_id
    AND M.material_name = 'metal'
);


-- g
-- products that cost > 150
SELECT P.product_name, P.price
FROM (
    SELECT product_id, product_name, price
    FROM Products
    WHERE price > 150
) AS P;

-- employees that work in the Living Room
-- inner query returns the ids of the employyes working in the Living Room
SELECT E.employee_name
FROM (
    SELECT FK_employee_id
    FROM Employee_Room_Assignment
    WHERE FK_room_id = 1
) AS A
INNER JOIN Employees AS E ON A.FK_employee_id = E.employee_id;

-- h
-- shows how many employees are assigned to each room
SELECT RD.room_name, COUNT(E.employee_id) AS employee_count
FROM Employees AS E
INNER JOIN Employee_Room_Assignment AS ERA ON E.employee_id = ERA.FK_employee_id
INNER JOIN Room_Departments AS RD ON ERA.FK_room_id = RD.departament_id
GROUP BY RD.room_name;

-- shows average price of the category if it's higher than 100
SELECT FC.category_name, AVG(P.price) AS average_price
FROM Furniture_Categories AS FC
INNER JOIN Products AS P ON FC.category_id = P.FK_category
GROUP BY FC.category_name
HAVING AVG(P.price) > 100;

-- shows how many products there are in a category, if there is more than 1 product
SELECT FC.category_name, COUNT(P.product_id) AS product_count
FROM Furniture_Categories AS FC
LEFT JOIN Products AS P ON FC.category_id = P.FK_category
GROUP BY FC.category_name
HAVING COUNT(P.product_id) > 1;


-- shows departments where the minimum salary < 5000
SELECT RD.room_name, MIN(E.salary) AS min_salary
FROM Employees AS E
INNER JOIN Employee_Room_Assignment AS ERA ON E.employee_id = ERA.FK_employee_id
INNER JOIN Room_Departments AS RD ON ERA.FK_room_id = RD.departament_id
GROUP BY RD.room_name
HAVING MIN(E.salary) < 5000;

-- i1
-- employees with salaries > any employee in department 2
SELECT employee_name, salary
FROM Employees
WHERE salary > ANY (
    SELECT salary
    FROM Employees
    WHERE employee_id IN (
        SELECT FK_employee_id
        FROM Employee_Room_Assignment
        WHERE FK_room_id = 2
    )
);

-- employees with salaries < all employees in department 1
SELECT employee_name, salary
FROM Employees
WHERE salary < ALL (
    SELECT salary
    FROM Employees
    WHERE employee_id IN (
        SELECT FK_employee_id
        FROM Employee_Room_Assignment
        WHERE FK_room_id = 1
    )
);

-- products that cost > any chair
SELECT product_name, price
FROM Products
WHERE price > ANY (
    SELECT price
    FROM Products
    WHERE FK_category = 1
);

-- products that cost < all sofas
SELECT product_name, price
FROM Products
WHERE price < ALL (
    SELECT price
    FROM Products
    WHERE FK_category = 7
);


-- i2
-- employees with salaries > any employee in department 2
SELECT employee_name, salary
FROM Employees
WHERE salary NOT IN (
    SELECT salary
    FROM Employees
    WHERE employee_id IN (
        SELECT FK_employee_id
        FROM Employee_Room_Assignment
        WHERE FK_room_id = 2
    )
);


-- employees with salaries < all employees in department 1
SELECT employee_name, salary
FROM Employees
WHERE salary NOT IN (
    SELECT salary
    FROM Employees
    WHERE employee_id IN (
        SELECT FK_employee_id
        FROM Employee_Room_Assignment
        WHERE FK_room_id = 1
    )
);

-- products that cost > any chair
SELECT P.product_name, P.price
FROM Products AS P
WHERE P.price > (
    SELECT MAX(P2.price)
    FROM Products AS P2
    WHERE P2.FK_category = 1
);

-- products that cost < all sofas
SELECT product_name, price
FROM Products
WHERE price < (
    SELECT MIN(price)
    FROM Products
    WHERE FK_category = 7
);
