ALTER TABLE Employee
ADD 
    ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
        CONSTRAINT DF_Employee_ValidFrom DEFAULT SYSUTCDATETIME(),
    ValidTo DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
        CONSTRAINT DF_Employee_ValidTo DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);
GO

ALTER TABLE Employee
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory));
GO


UPDATE Employee
SET name = 'Аліна Сидоренко'
WHERE employee_id = 1;

SELECT * FROM Employee FOR SYSTEM_TIME ALL WHERE employee_id = 1;

UPDATE Employee
SET name = 'Петренко Іван'
WHERE employee_id = 4;

UPDATE Employee
SET contact_phone = '+380999999999'
WHERE employee_id = 4;

-- Показати стан таблиці на будь-яку дату в минулому
SELECT * FROM Employee
FOR SYSTEM_TIME AS OF '2025-11-24 21:10:00'
WHERE employee_id = 4;


ALTER TABLE Dish
ADD 
    ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
        CONSTRAINT DF_Dish_ValidFrom DEFAULT SYSUTCDATETIME(),
    ValidTo DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
        CONSTRAINT DF_Dish_ValidTo DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);
GO

ALTER TABLE Dish
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.DishHistory));
GO


UPDATE Dish
SET price = price + 20
WHERE dish_id = 3;

SELECT * FROM Dish FOR SYSTEM_TIME ALL WHERE dish_id = 3;

UPDATE Dish
SET price = price - 20
WHERE dish_id = 11;

UPDATE Dish
SET category = 'Десерт дня'
WHERE dish_id = 11;

-- Показати, як змінювалась ціна страви з часом
SELECT name, price, ValidFrom, ValidTo FROM Dish
FOR SYSTEM_TIME ALL
WHERE dish_id = 11
ORDER BY ValidFrom;

-- Показати стан таблиці на будь-яку дату в минулому
SELECT *
FROM Dish
FOR SYSTEM_TIME AS OF '2025-11-24 21:10:00'
WHERE dish_id = 11;