-- Вибрати всі замовлення з іменем клієнта та статусом "Оплачено" за минулий місяць
SELECT o.order_id,c.name AS customer_name,os.name AS order_status,o.order_date,o.people_count
FROM Orders AS o
JOIN Customer AS c ON o.customer_id = c.customer_id
JOIN OrderStatus AS os ON o.status_id = os.status_id
WHERE 
    os.name = N'оплачено'
    AND o.order_date >= DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
    AND o.order_date < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
ORDER BY o.order_date;

-- Вибрати всі замовлення з іменем клієнта та статусом "Очікує" за сьогодні
SELECT o.order_id, c.name AS customer_name, os.name AS order_status, o.order_date, o.people_count
FROM Orders AS o
JOIN Customer AS c ON o.customer_id = c.customer_id
JOIN OrderStatus AS os ON o.status_id = os.status_id
WHERE os.name = N'очікує' AND o.order_date = CAST(GETDATE() AS DATE)
ORDER BY o.order_time DESC;

-- Вибрати всі страви з назвами меню, до яких вони належать
SELECT d.name AS dish_name, d.category, d.price, m.type AS menu_type, m.start_time, m.end_time
FROM Dish AS d
LEFT JOIN Menu AS m ON d.menu_id = m.menu_id
ORDER BY dish_name;

-- Вибрати ID всіх офіціантів які працюють зараз
SELECT E.employee_id FROM EMPLOYEE AS E 
JOIN EmployeePositionHistory EPH ON EPH.employee_id = E.employee_id AND GETDATE() BETWEEN start_date AND ISNULL( end_date, '2999-12-31')
JOIN Position P ON P.position_id = EPH.position_id
WHERE P.[name] = 'Офіціант';

-- Вибрати всі позиції працівників за історією
SELECT e.name AS employee_name, p.name AS position_name, eph.start_date, eph.end_date
FROM Employee AS e
JOIN EmployeePositionHistory AS eph ON e.employee_id = eph.employee_id
JOIN Position AS p ON eph.position_id = p.position_id
ORDER BY e.name;

-- Вибрати всі продукти з постачальниками та кількістю на складі і тільки не прострочені
SELECT p.name AS product_name, s.name AS supplier_name, s.company_name, p.price, w.stock, w.delivery_time, w.expiration_date
FROM ProductsList AS p
JOIN Supplier AS s 
    ON p.supplier_id = s.supplier_id
JOIN Warehouse AS w 
    ON p.product_id = w.product_id
WHERE w.expiration_date > GETDATE()
ORDER BY s.name;

-- Вивести список усіх замовлень із працівником, який їх обслуговував, і номером столика
SELECT o.order_id, o.order_date, o.people_count, e.name AS employee_name, t.table_number, os.name AS order_status
FROM Orders AS o                                                                                        
LEFT JOIN Employee AS e ON o.employee_id = e.employee_id
LEFT JOIN RestaurantTable AS t ON o.table_id = t.table_id
LEFT JOIN OrderStatus AS os ON o.status_id = os.status_id
ORDER BY o.order_date DESC, o.order_id;

-- Кошти з оплачених замовлень в певний період 
SELECT SUM(d.price * od.quantity) AS TotalRevenue
FROM Orders o
JOIN OrderDish od ON o.order_id = od.order_id
JOIN Dish d ON d.dish_id = od.dish_id
JOIN OrderStatus os ON os.status_id = o.status_id
WHERE os.name = N'Оплачено'
  AND o.order_date BETWEEN '2025-10-01' AND '2025-10-30';


