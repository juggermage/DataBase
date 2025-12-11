
create database Restaurant;

USE Restaurant;

CREATE TABLE Customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    contact_phone NVARCHAR(14),
    created_at DATETIME
);

CREATE TABLE Menu (
    menu_id INT IDENTITY(1,1) PRIMARY KEY,
    type NVARCHAR(50) NOT NULL,
    valid_time TIME NOT NULL
);

CREATE TABLE Dish (
    dish_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(300),
    price DECIMAL(10,2) NOT NULL,
    category NVARCHAR(50) NOT NULL,
    menu_id INT
);

CREATE TABLE OrderStatus (
    status_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    people_count INT NOT NULL,
    status_id INT,
    customer_id INT,
    table_id INT,
    employee_id INT
);

CREATE TABLE OrderDish (
    order_dish_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    dish_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1
);

CREATE TABLE Position (
    position_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
);

CREATE TABLE Employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    contact_phone NVARCHAR(14)
);

CREATE TABLE EmployeePositionHistory (
    eph_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    position_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL
);

CREATE TABLE RestaurantTable (
    table_id INT IDENTITY(1,1) PRIMARY KEY,
    table_number INT UNIQUE NOT NULL,
    seats INT NOT NULL,
    state NVARCHAR(20)
);

CREATE TABLE Supplier (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    contact_phone NVARCHAR(14),
    product_type NVARCHAR(100),
    company_name NVARCHAR(100)
);

CREATE TABLE ProductsList (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    supplier_id INT
);

CREATE TABLE Warehouse (
    warehouse_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    stock INT NOT NULL,
    delivery_time DATETIME
);

ALTER TABLE Warehouse
ADD expiration_date DATE NULL;

UPDATE Warehouse SET expiration_date = DATEADD(day, 7, delivery_time) WHERE product_id = 1;
UPDATE Warehouse SET expiration_date = DATEADD(day, 10, delivery_time) WHERE product_id = 2;
UPDATE Warehouse SET expiration_date = DATEADD(day, 90, delivery_time) WHERE product_id = 3;
UPDATE Warehouse SET expiration_date = DATEADD(day, 10, delivery_time) WHERE product_id = 4;
UPDATE Warehouse SET expiration_date = DATEADD(day, 7, delivery_time) WHERE product_id = 5;
UPDATE Warehouse SET expiration_date = DATEADD(day, 5, delivery_time) WHERE product_id = 6;
UPDATE Warehouse SET expiration_date = DATEADD(day, 21, delivery_time) WHERE product_id = 7;
UPDATE Warehouse SET expiration_date = DATEADD(day, 180, delivery_time) WHERE product_id = 8;
UPDATE Warehouse SET expiration_date = DATEADD(day, 14, delivery_time) WHERE product_id = 9;
UPDATE Warehouse SET expiration_date = DATEADD(day, 3, delivery_time) WHERE product_id = 10;
UPDATE Warehouse SET expiration_date = DATEADD(day, 60, delivery_time) WHERE product_id = 11;
UPDATE Warehouse SET expiration_date = DATEADD(day, 30, delivery_time) WHERE product_id = 12;
UPDATE Warehouse SET expiration_date = DATEADD(day, 14, delivery_time) WHERE product_id = 13;
UPDATE Warehouse SET expiration_date = DATEADD(day, 40, delivery_time) WHERE product_id = 14;
UPDATE Warehouse SET expiration_date = DATEADD(day, 30, delivery_time) WHERE product_id = 15;
UPDATE Warehouse SET expiration_date = DATEADD(day, 45, delivery_time) WHERE product_id = 16;
UPDATE Warehouse SET expiration_date = DATEADD(day, 7, delivery_time) WHERE product_id = 17;
UPDATE Warehouse SET expiration_date = DATEADD(day, 60, delivery_time) WHERE product_id = 18;
UPDATE Warehouse SET expiration_date = DATEADD(day, 5, delivery_time) WHERE product_id = 19;
UPDATE Warehouse SET expiration_date = DATEADD(day, 6, delivery_time) WHERE product_id = 20;
UPDATE Warehouse SET expiration_date = DATEADD(day, 5, delivery_time) WHERE product_id = 21;
UPDATE Warehouse SET expiration_date = DATEADD(day, 365, delivery_time) WHERE product_id = 22;
UPDATE Warehouse SET expiration_date = DATEADD(day, 365, delivery_time) WHERE product_id = 23;


CREATE TABLE MeasurementUnit(
    unit_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL          
);

INSERT INTO MeasurementUnit(name) VALUES
('шт'),
('кг'),
('л'),
('упак.');

INSERT INTO Customer (name, contact_phone, created_at) VALUES
('Іван Петренко', '+380671234567', GETDATE()),
('Марія Іваненко', '+380661112233', '2025-10-19 15:08:00'),
('Олег Коваленко', '+380501234888', '2025-10-15 15:45:00');
INSERT INTO Customer (name, contact_phone) VALUES
('Дмитро Івасюк', '+380647531567')

SELECT * FROM Customer;

INSERT INTO OrderStatus (name) VALUES
('Очікує'),
('Готується'),
('Подано'),
('Оплачено'),
('Скасовано');

INSERT INTO Position (name) VALUES
('Офіціант'),
('Кухар'),
('Прибиральник');

INSERT INTO Employee (name, contact_phone) VALUES
('Анна Сидоренко', '+380931112233'),
('Петро Гнатюк', '+380992223344'),
('Ірина Мельник', '+380981112255');

INSERT INTO Supplier (name, contact_phone, product_type, company_name) VALUES
('ТОВ "Іван Петренко"', '+380671112233', 'Мясні продукти', 'Мясо-Сервіс'),
('ТОВ "Оксана Коваленко"', '+380662223344', 'Овочі', 'Овочі плюс'),
('ТОВ "Петро Іванців"', '+380501122334', 'Молочна продукція', 'Молочний дім');


INSERT INTO RestaurantTable (table_number, seats, state) VALUES
(1, 2, 'Вільний'),
(2, 4, 'Зайнятий'),
(3, 6, 'Вільний');

INSERT INTO EmployeePositionHistory (employee_id, position_id, start_date, end_date) VALUES
(1, 1, '2024-01-01', NULL),
(2, 2, '2025-06-01', NULL),
(3, 3, '2024-01-15', NULL);


INSERT INTO Menu (type, start_time, end_time) VALUES
('Сніданок', '08:00:00', '12:00:00'),
('Обід', '12:00:00', '16:00:00'),
('Вечеря', '17:00:00', '22:00:00'),
('Загальне', '08:00:00', '22:00:00');

ALTER TABLE Menu
ALTER COLUMN start_time TIME(0);

ALTER TABLE Menu
ALTER COLUMN end_time TIME(0);

INSERT INTO OrderDish (order_id, dish_id, quantity) VALUES
(1, 2, 1),
(1, 3, 1),
(2, 4, 2),
(2, 5, 1),
(3, 1, 1);

INSERT INTO OrderDish (order_id, dish_id, quantity) VALUES
(4, 8, 1),
(5, 6, 2),
(5, 4, 1),
(6, 9, 1),
(7, 12, 2),
(8, 11, 1),
(9, 7, 3),
(9, 5, 1),
(10, 14, 2);

INSERT INTO ProductsList (name, price, quantity, supplier_id, unit_id) VALUES
('Курятина', 90.00, 50, 1, 2),
('Помідори', 35.00, 60, 2, 2),
('Сир пармезан', 120.00, 30, 3, 2),
('Молоко', 50.00, 40, 3, 3),
('Стейк', 400.00, 30, 1, 1)

INSERT INTO Warehouse (product_id, stock, delivery_time) VALUES
(1, 40, '2025-10-19 08:00:00'),
(2, 90, '2025-10-18 10:00:00'),
(3, 25, '2025-10-20 12:00:00'),
(4, 35, '2025-10-18 09:00:00'),
(5, 20, '2025-10-19 12:00:00');

INSERT INTO Dish (name, description, price, category, menu_id) VALUES
('Омлет з овочами', 'Омлет з помідорами, перцем та зеленню', 85.00, 'Сніданок', 1),
('Борщ', 'Традиційний борщ зі сметаною та часником', 120.00, 'Супи', 4 ),
('Котлета по-київськи', 'Куряча котлета з маслом всередині', 180.00, 'Основна страва', 4),
('Цезар з куркою', 'Салат з куркою, пармезаном та соусом Цезар', 150.00, 'Салати', 4),
('Паста Карбонара', 'Паста з беконом, яйцем та сиром', 160.00, 'Основна страва', 4),
('Картопля з курячим філе', 'Картопляне пюре з курячим філе під вершковим соусом', 200, 'Основна страва', 2);

SELECT * FROM [dbo].[Customer]
SELECT * FROM [dbo].[Dish]
SELECT * FROM [dbo].[Employee]
SELECT * FROM [dbo].[EmployeePositionHistory]
SELECT * FROM [dbo].[Menu]
SELECT * FROM [dbo].[OrderDish]
SELECT * FROM [dbo].[Orders]
SELECT * FROM [dbo].[OrderStatus]
SELECT * FROM [dbo].[Position]
SELECT * FROM [dbo].[ProductsList]
SELECT * FROM [dbo].[RestaurantTable]
SELECT * FROM [dbo].[Supplier]
SELECT * FROM [dbo].[Warehouse]
SELECT * FROM [dbo].[MeasurementUnit]


INSERT INTO Position (name) VALUES
('Бармен'),
('Су-шеф'),
('Адміністратор'),
('Помічник кухаря'),
('Шеф-кухар');

INSERT INTO Employee (name, contact_phone) VALUES
('Олександр Бойко', '+380991234567'),
('Наталія Кравчук', '+380972223355'),
('Максим Іванов', '+380503331122'),
('Олена Гриценко', '+380631119988'),
('Віктор Мельник', '+380951554433'),
('Світлана Дорошенко', '+380932228877'),
('Юлія Романюк', '+380668899223'),
('Сергій Паламарчук', '+380952228844'),
('Катерина Коваль', '+380971234556'),
('Роман Дорошенко', '+380661234778'),
('Ольга Бублик', '+380981111999'),
('Денис Павленко', '+380992223388'),
('Сергій Гнатюк', '+380931234111'),
('Оксана Марчук', '+380961113322'),
('Валентина Сова', '+380951114433');

INSERT INTO EmployeePositionHistory (employee_id, position_id, start_date, end_date) VALUES
(4, 5, '2024-05-01', NULL),
(5, 1, '2023-11-01', NULL),
(6, 4, '2024-07-15', NULL),
(7, 3, '2024-09-01', NULL),
(8, 10, '2023-08-01', NULL);

INSERT INTO Dish (name, description, price, category, menu_id) VALUES
('Рибне асорті', 'Сет з лосося, тунця та лимонного соусу', 350.00, 'Основна страва', 4),
('Сирники зі сметаною', 'Домашні сирники з ваніллю та сметаною', 110.00, 'Десерт', 1),
('Панкейки з медом', 'Пухкі панкейки з медом і ягодами', 130.00, 'Сніданок', 1),
('Курячий бульйон', 'Легкий бульйон із зеленню та яйцем', 95.00, 'Супи', 4),
('Тірамісу', 'Класичний італійський десерт з маскарпоне', 160.00, 'Десерт', 4),
('Мікс салатів', 'Салат з овочів сезону з оливковою олією', 100.00, 'Салати', 4),
('Бургер з беконом', 'Соковитий бургер з беконом і сиром чеддер', 180.00, 'Основна страва', 4),
('Стейк з лосося', 'Обсмажений лосось з лимонним соусом', 400.00, 'Основна страва', 4),
('Плов з куркою', 'Ароматний плов з куркою та овочами', 140.00, 'Основна страва', 2),
('Суп-пюре з грибів', 'Ніжний крем-суп з білих грибів і вершків', 120.00, 'Супи', 2),
('Овочеве рагу', 'Овочі, тушковані у вершковому соусі', 130.00, 'Гарячі страви', 2),
('Салат "Олів’є"', 'Класичний салат з куркою, горошком і майонезом', 100.00, 'Салати', 2),
('Стейк Рібай', 'Соковитий яловичий стейк середнього прожарення', 420.00, 'Основна страва', 3),
('Печена риба з овочами', 'Філе риби запечене з лимоном та спаржею', 320.00, 'Основна страва', 3),
('Салат "Грецький"', 'Салат з фетою, оливками, огірком і томатами', 130.00, 'Салати', 3),
('Десерт "Шоколадний фондан"', 'Теплий шоколадний кекс із рідкою начинкою', 160.00, 'Десерт', 4);

INSERT INTO Supplier (name, contact_phone, product_type, company_name) VALUES
('ТОВ "Риба Маріс"', '+380671234555', 'Рибна продукція', 'Море Плюс'),
('ТОВ "Свіже повітря"', '+380631122334', 'Птиця та яйця', 'Ферма №7'),
('ТОВ "Хлібодар"', '+380992345678', 'Випічка', 'Хліб-Сервіс');

INSERT INTO RestaurantTable (table_number, seats, state) VALUES
(4, 4, 'Вільний'),
(5, 6, 'Зайнятий'),
(6, 2, 'Вільний'),
(7, 8, 'Резерв'),
(8, 4, 'Вільний');

INSERT INTO Customer (name, contact_phone, created_at) VALUES
('Олег Сидоренко', '+380933334455', '2025-09-20'),
('Марія Іваненко', '+380971112244', '2025-10-01'),
('Дмитро Петренко', '+380662223344', '2025-10-15'),
('Наталія Шевченко', '+380931111222', '2025-10-10'),
('Володимир Кравчук', '+380671223344', '2025-10-18'),
('Ірина Левченко', '+380662334455', '2025-09-30'),
('Михайло Бондар', '+380952334466', '2025-10-05'),
('Світлана Романюк', '+380972224466', '2025-10-17'),
('Тетяна Гаврилюк', '+380982112233', '2025-10-22'),
('Богдан Іващенко', '+380501224466', '2025-10-27'),
('Оксана Ткаченко', '+380931554433', '2025-10-25');

INSERT INTO ProductsList (name, price, quantity, supplier_id, unit_id) VALUES
('Лосось філе', 480.00, 25, 4, 2),
('Яйця курячі', 75.00, 100, 5, 1),
('Борошно пшеничне', 40.00, 80, 6, 2),
('Бекон', 220.00, 40, 1, 2),
('Хліб білий', 30.00, 60, 6, 4),
('Масло вершкове', 180.00, 20, 3, 2),
('Капуста', 20.00, 100, 2, 2),
('Сметана', 90.00, 50, 3, 3),
('Картопля', 25.00, 100, 2, 2),
('Морква', 22.00, 80, 2, 2),
('Цибуля ріпчаста', 18.00, 90, 2, 2),
('Кефір 2.5%', 60.00, 40, 3, 3),
('Сир твердий', 150.00, 25, 3, 2),
('Курячі стегна', 95.00, 60, 1, 2),
('Хек філе', 210.00, 30, 4, 2),
('Круасани', 65.00, 40, 6, 4),
('Мед натуральний', 240.00, 15, 6, 3),
('Олія соняшникова', 80.00, 50, 2, 3);

INSERT INTO Warehouse (product_id, stock, delivery_time) VALUES
(6, 20, '2025-10-25 10:00:00'),
(7, 80, '2025-10-24 09:30:00'),
(8, 45, '2025-10-26 11:00:00'),
(9, 35, '2025-10-27 08:00:00'),
(10, 40, '2025-10-26 14:00:00'),
(11, 15, '2025-10-25 16:00:00'),
(12, 60, '2025-10-24 12:00:00'),
(13, 30, '2025-10-23 09:00:00'),
(14, 80, '2025-10-26 09:00:00'),
(15, 60, '2025-10-25 11:00:00'),
(16, 75, '2025-10-24 08:30:00'),
(17, 30, '2025-10-27 10:15:00'),
(18, 25, '2025-10-26 13:00:00'),
(19, 55, '2025-10-25 14:20:00'),
(20, 40, '2025-10-28 09:45:00'),
(21, 30, '2025-10-24 12:00:00'),
(22, 10, '2025-10-25 16:00:00'),
(23, 45, '2025-10-26 08:00:00');


INSERT INTO EmployeePositionHistory (employee_id, position_id, start_date, end_date)
VALUES 
(4, 1, '2024-02-01', NULL),
(5, 2, '2024-03-01', NULL),
(6, 4, '2024-03-15', NULL),
(7, 8, '2024-04-01', NULL),
(8, 7, '2024-04-10', NULL),
(9, 6, '2024-05-01', NULL),
(10, 4, '2024-06-01', NULL),
(11, 5, '2024-05-12', NULL),
(12, 1, '2025-01-10', NULL),
(13, 1, '2025-03-15', NULL),
(14, 3, '2025-02-01', NULL),
(15, 6, '2025-04-01', NULL),
(16, 2, '2025-05-01', NULL),
(17, 2, '2025-06-01', NULL),
(18, 7, '2025-07-01', NULL);


INSERT INTO Orders (order_date, order_time, people_count, status_id, customer_id, table_id, employee_id)
VALUES
('2025-10-25', '12:30:00', 2, 1, 1, 1, 1),   
('2025-10-25', '13:00:00', 4, 2, 2, 2, 12),  
('2025-10-26', '14:15:00', 3, 3, 3, 3, 13),  
('2025-10-26', '19:00:00', 6, 4, 4, 5, 4),  
('2025-10-27', '18:45:00', 2, 5, 5, 6, 4),   
('2025-10-27', '11:20:00', 3, 1, 6, 4, 12), 
('2025-10-27', '15:40:00', 5, 2, 7, 7, 13),  
('2025-10-28', '17:10:00', 2, 3, 8, 8, 1),   
('2025-10-28', '20:30:00', 4, 4, 9, 2, 12),  
('2025-10-28', '21:00:00', 3, 1, 10, 1, 13); 

INSERT INTO Orders (order_date, order_time, people_count, status_id, customer_id, table_id, employee_id)
VALUES
('2025-12-10', '16:30:00', 1, 1, 7, 1, 1),   
('2025-12-10', '15:00:00', 2, 1, 6, 8, 12),  
('2025-12-10', '17:15:00', 4, 1, 5, 3, 12); 

-- Dish
ALTER TABLE Dish
ADD CONSTRAINT FK_Dish_Menu
FOREIGN KEY (menu_id) REFERENCES Menu(menu_id);

-- Orders
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Status
FOREIGN KEY (status_id) REFERENCES OrderStatus(status_id),
    CONSTRAINT FK_Orders_Customer
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_Orders_Table
    FOREIGN KEY (table_id) REFERENCES RestaurantTable(table_id),
    CONSTRAINT FK_Orders_Employee
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id);

-- OrderDish
ALTER TABLE OrderDish
ADD CONSTRAINT FK_OrderDish_Order
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT FK_OrderDish_Dish
    FOREIGN KEY (dish_id) REFERENCES Dish(dish_id);

-- EmployeePositionHistory
ALTER TABLE EmployeePositionHistory
ADD CONSTRAINT FK_EPH_Employee
FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    CONSTRAINT FK_EPH_Position
    FOREIGN KEY (position_id) REFERENCES Position(position_id);

-- ProductsList
ALTER TABLE ProductsList
ADD CONSTRAINT FK_ProductsList_Supplier
FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    CONSTRAINT FK_ProductsList_Unit
    FOREIGN KEY (unit_id) REFERENCES MeasurementUnit(unit_id);

-- Warehouse
ALTER TABLE Warehouse
ADD CONSTRAINT FK_Warehouse_Product
FOREIGN KEY (product_id) REFERENCES ProductsList(product_id);


-- Customer Check
ALTER TABLE dbo.Customer
ADD CONSTRAINT [CK_Customer_ContactPhone]
CHECK (contact_phone LIKE '+380[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE Customer
ADD CONSTRAINT CK_Customer_Name_OnlyLetters
CHECK (name NOT LIKE '%[^A-Za-zА-Яа-яЁёІіЇїЄєҐґ'' -]%');


-- Employee Check
ALTER TABLE Employee
DROP CONSTRAINT CK_Employee_Name_NoDigits

ALTER TABLE Employee
ADD CONSTRAINT CK_Employee_Name_OnlyLetters CHECK (name NOT LIKE '%[^A-Za-zА-Яа-яЁёІіЇїЄєҐґ'' -]%');

ALTER TABLE Employee
ADD CONSTRAINT CK_Employee_Phone_Format CHECK (
    contact_phone LIKE '+380[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
);

-- Orders Check
ALTER TABLE Orders
ADD CONSTRAINT CK_Orders_PeopleCount_Positive CHECK (people_count > 0);

--OrderDish Check
ALTER TABLE OrderDish
ADD CONSTRAINT CK_OrderDish_Quantity_Positive CHECK (quantity > 0);

-- Dish Check
ALTER TABLE Dish
ADD CONSTRAINT CK_Dish_Price_Positive CHECK (price > 0);

-- RestaurantTable Check
ALTER TABLE RestaurantTable
ADD CONSTRAINT CK_RestaurantTable_Seats_Positive CHECK (seats > 0);

-- Warehouse Check
ALTER TABLE Warehouse
ADD CONSTRAINT CK_Warehouse_Stock_NonNegative CHECK (stock >= 0);

-- ProductsList Check
ALTER TABLE ProductsList
ADD CONSTRAINT CK_ProductsList_Quantity_NonNegative CHECK (quantity >= 0);


-- Unique
ALTER TABLE Customer
ADD CONSTRAINT UQ_Customer_Phone UNIQUE (contact_phone);

ALTER TABLE Supplier
ADD CONSTRAINT UQ_Supplier_Phone UNIQUE (contact_phone);

ALTER TABLE RestaurantTable
ADD CONSTRAINT UQ_RestaurantTable_Number UNIQUE (table_number);


-- Default 
ALTER TABLE dbo.Customer
ADD CONSTRAINT [DF_Customer_CreatedAt]
DEFAULT (GETDATE()) FOR [created_at];

-- Tests
INSERT INTO Customer (name, contact_phone)
VALUES ('Іван', '+380501234567');

INSERT INTO Customer (name, contact_phone)
VALUES ('Петро', '0501234567');

INSERT INTO Orders (order_date, order_time, people_count)
VALUES (GETDATE(), GETDATE(), 0);

INSERT INTO Employee(name, contact_phone)
VALUES ('Роман', '+380501234567');
