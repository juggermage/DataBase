-- Dish
CREATE OR ALTER PROCEDURE dbo.sp_SetDish
    @dish_id     INT = NULL OUTPUT,
    @name        NVARCHAR(100) = NULL,
    @description NVARCHAR(300) = NULL,
    @price       DECIMAL(10,2) = NULL,
    @category    NVARCHAR(50)  = NULL,
    @menu_id     INT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Перевірка при вставці
        IF @dish_id IS NULL
        BEGIN
            IF (@name IS NULL OR LTRIM(RTRIM(@name)) = '')
            BEGIN
                RAISERROR(N'Назва страви є обов''язковою.', 16, 1);
                RETURN;
            END;

            IF (@price IS NULL OR @price <= 0)
            BEGIN
                RAISERROR(N'Ціна страви має бути додатною.', 16, 1);
                RETURN;
            END;

            INSERT INTO dbo.Dish (name, description, price, category, menu_id)
            VALUES (@name, @description, @price, @category, @menu_id);

            SET @dish_id = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE TOP(1) dbo.Dish
            SET name        = ISNULL(@name,        name),
                description = ISNULL(@description, description),
                price       = ISNULL(@price,       price),
                category    = ISNULL(@category,    category),
                menu_id     = ISNULL(@menu_id,     menu_id)
            WHERE dish_id = @dish_id;

            IF @@ROWCOUNT = 0
                RAISERROR(N'Страву з таким ID не знайдено.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- Додавання нової страви
DECLARE @NewDishId INT;

EXEC dbo.sp_SetDish
    @dish_id     = @NewDishId OUTPUT,
    @name        = N'Тестова страва',
    @description = N'Опис тестової страви',
    @price       = 199.99,
    @category    = N'Основна страва',
    @menu_id     = 4;

SELECT @NewDishId AS NewDishId;

-- Оновлення страви (зміна ціни)
DECLARE @NewDishId INT = 23;
EXEC dbo.sp_SetDish
    @dish_id = @NewDishId OUTPUT,
    @price   = 229.99;

SELECT * FROM dbo.Dish WHERE dish_id = @NewDishId;

-- Orders
CREATE OR ALTER PROCEDURE dbo.sp_SetOrders
    @order_id    INT = NULL OUTPUT,
    @order_date  DATE        = NULL,
    @order_time  TIME        = NULL,
    @people_count INT        = NULL,
    @status_id   INT         = NULL,
    @customer_id INT         = NULL,
    @table_id    INT         = NULL,
    @employee_id INT         = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @order_id IS NULL
        BEGIN
            -- Перевірки для вставки
            IF @order_date IS NULL
                SET @order_date = CAST(GETDATE() AS DATE);

            IF @order_time IS NULL
                SET @order_time = CAST(GETDATE() AS TIME);

            IF (@people_count IS NULL OR @people_count <= 0)
            BEGIN
                RAISERROR(N'Кількість гостей має бути більшою за нуль.', 16, 1);
                RETURN;
            END;

            INSERT INTO dbo.Orders (
                order_date, order_time, people_count,
                status_id, customer_id, table_id, employee_id
            )
            VALUES (
                @order_date, @order_time, @people_count,
                @status_id, @customer_id, @table_id, @employee_id
            );

            SET @order_id = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE TOP(1) dbo.Orders
            SET order_date   = ISNULL(@order_date,   order_date),
                order_time   = ISNULL(@order_time,   order_time),
                people_count = ISNULL(@people_count, people_count),
                status_id    = ISNULL(@status_id,    status_id),
                customer_id  = ISNULL(@customer_id,  customer_id),
                table_id     = ISNULL(@table_id,     table_id),
                employee_id  = ISNULL(@employee_id,  employee_id)
            WHERE order_id = @order_id;

            IF @@ROWCOUNT = 0
                RAISERROR(N'Замовлення з таким ID не знайдено.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

DECLARE @NewOrderId INT;

EXEC dbo.sp_SetOrders
    @order_id     = @NewOrderId OUTPUT,
    @order_date   = '2025-11-18',
    @order_time   = '13:30:00',
    @people_count = 3,
    @status_id    = 1,
    @customer_id  = 1,
    @table_id     = 1,
    @employee_id  = 4;

SELECT @NewOrderId AS NewOrderId;

DECLARE @NewOrderId INT = 17;
EXEC dbo.sp_SetOrders
    @order_id   = @NewOrderId OUTPUT,
    @status_id  = 4;

SELECT * FROM dbo.Orders WHERE order_id = @NewOrderId;

-- Products
CREATE OR ALTER PROCEDURE dbo.sp_SetProductsList
    @product_id  INT = NULL OUTPUT,
    @name        NVARCHAR(100) = NULL,
    @price       DECIMAL(10,2) = NULL,
    @quantity    INT           = NULL,
    @supplier_id INT           = NULL,
    @unit_id     INT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @product_id IS NULL
        BEGIN
            IF (@name IS NULL OR LTRIM(RTRIM(@name)) = '')
            BEGIN
                RAISERROR(N'Назва продукту є обов''язковою.', 16, 1);
                RETURN;
            END;

            IF (@price IS NULL OR @price < 0)
            BEGIN
                RAISERROR(N'Ціна продукту не може бути від''ємною.', 16, 1);
                RETURN;
            END;

            IF (@quantity IS NULL OR @quantity < 0)
            BEGIN
                RAISERROR(N'Кількість продукту не може бути від''ємною.', 16, 1);
                RETURN;
            END;

            INSERT INTO dbo.ProductsList (name, price, quantity, supplier_id, unit_id)
            VALUES (@name, @price, @quantity, @supplier_id, @unit_id);

            SET @product_id = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE TOP(1) dbo.ProductsList
            SET name        = ISNULL(@name,        name),
                price       = ISNULL(@price,       price),
                quantity    = ISNULL(@quantity,    quantity),
                supplier_id = ISNULL(@supplier_id, supplier_id),
                unit_id     = ISNULL(@unit_id,     unit_id)
            WHERE product_id = @product_id;

            IF @@ROWCOUNT = 0
                RAISERROR(N'Продукт з таким ID не знайдено.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- Додавання нового продукту
DECLARE @NewProductId INT;

EXEC dbo.sp_SetProductsList
    @product_id  = @NewProductId OUTPUT,
    @name        = N'Тестовий продукт',
    @price       = 100.00,
    @quantity    = 20,
    @supplier_id = 1,   -- існуючий постачальник
    @unit_id     = 2;   -- існуюча одиниця вимірювання

SELECT @NewProductId AS NewProductId;

-- Оновлення кількості та ціни продукту
DECLARE @NewProductId INT = 24;
EXEC dbo.sp_SetProductsList
    @product_id = @NewProductId OUTPUT,
    @price      = 120.00,
    @quantity   = 30;

SELECT * FROM dbo.ProductsList WHERE product_id = @NewProductId;

-- Customer
CREATE OR ALTER PROCEDURE dbo.sp_SetCustomer
    @customer_id    INT = NULL OUTPUT,
    @name           NVARCHAR(100) = NULL,
    @contact_phone  NVARCHAR(14) = NULL,
    @created_at     DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- INSERT (якщо @customer_id = NULL)
        IF @customer_id IS NULL
        BEGIN
            -- Перевірка обов'язкового поля name
            IF @name IS NULL OR LTRIM(RTRIM(@name)) = N''
            BEGIN
                RAISERROR(N'Ім''я клієнта (name) є обов''язковим.', 16, 1);
                RETURN;
            END;

            -- Якщо не передали created_at – ставимо поточну дату/час
            IF @created_at IS NULL
                SET @created_at = GETDATE();

            INSERT INTO dbo.Customer (name, contact_phone, created_at)
            VALUES (@name, @contact_phone, @created_at);

            -- Повертаємо згенерований IDENTITY
            SET @customer_id = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            -- Перевірка, що такий клієнт існує
            IF NOT EXISTS (SELECT 1 FROM dbo.Customer WHERE customer_id = @customer_id)
            BEGIN
                RAISERROR(N'Клієнта з таким ID не існує.', 16, 1);
                RETURN;
            END;

            -- UPDATE: оновлюємо тільки ті поля, які передані не NULL
            UPDATE TOP (1) dbo.Customer
            SET name          = ISNULL(@name,          name),
                contact_phone = ISNULL(@contact_phone, contact_phone),
                created_at    = ISNULL(@created_at,    created_at)
            WHERE customer_id = @customer_id;
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000),
                @ErrSeverity INT;

        SELECT @ErrMsg = ERROR_MESSAGE(),
               @ErrSeverity = ERROR_SEVERITY();

        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH
END;
GO

DECLARE @NewCustomerId INT;

EXEC dbo.sp_SetCustomer
    @customer_id   = @NewCustomerId OUTPUT,
    @name          = N'Іван Петренко',
    @contact_phone = N'+380501112233',
    @created_at    = NULL;

SELECT @NewCustomerId AS NewCustomerId;

DECLARE @ExistingCustomerId INT = 34;

EXEC dbo.sp_SetCustomer
    @customer_id   = @ExistingCustomerId OUTPUT,
    @name          = N'Тестовий клієнт',
    @contact_phone = N'+380671234187',
    @created_at    = NULL;
