CREATE OR ALTER PROCEDURE dbo.sp_GetOrders
    @OrderId INT = NULL,
    @CustomerName NVARCHAR(100) = NULL,
    @StatusId INT = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @PageSize INT = 100,
    @PageNumber INT = 1,
    @SortColumn NVARCHAR(50) = 'order_date',
    @SortDirection BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        o.order_id,
        o.order_date,
        o.order_time,
        o.people_count,

        c.name AS customer_name,
        e.name AS employee_name,
        t.table_number,
        s.name AS status_name,

        -- Розрахунок загальної суми замовлення
        (
            SELECT SUM(d.price * od.quantity)
            FROM OrderDish od
            JOIN Dish d ON d.dish_id = od.dish_id
            WHERE od.order_id = o.order_id
        ) AS total_amount
    FROM Orders o
    LEFT JOIN Customer c ON c.customer_id = o.customer_id
    LEFT JOIN Employee e ON e.employee_id = o.employee_id
    LEFT JOIN RestaurantTable t ON t.table_id = o.table_id
    LEFT JOIN OrderStatus s ON s.status_id = o.status_id
    WHERE (@OrderId IS NULL OR o.order_id = @OrderId)
      AND (@CustomerName IS NULL OR c.name LIKE @CustomerName + '%')
      AND (@StatusId IS NULL OR o.status_id = @StatusId)
      AND (@DateFrom IS NULL OR o.order_date >= @DateFrom)
      AND (@DateTo   IS NULL OR o.order_date <= @DateTo)

    ORDER BY
        CASE WHEN @SortDirection = 0 THEN
            CASE @SortColumn
                WHEN 'order_date' THEN CONVERT(NVARCHAR, o.order_date)
                WHEN 'customer_name' THEN c.name
                WHEN 'status_name' THEN s.name
                ELSE CONVERT(NVARCHAR, o.order_id)
            END
        END ASC,
        CASE WHEN @SortDirection = 1 THEN
            CASE @SortColumn
                WHEN 'order_date' THEN CONVERT(NVARCHAR, o.order_date)
                WHEN 'customer_name' THEN c.name
                WHEN 'status_name' THEN s.name
                ELSE CONVERT(NVARCHAR, o.order_id)
            END
        END DESC

    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- 1. Усі замовлення
EXEC dbo.sp_GetOrders;

-- 2. Пошук за частиною імені клієнта
EXEC dbo.sp_GetOrders @CustomerName = N'Іва';

-- 3. Фільтр по статусу (наприклад 1 = 'Очікує')
EXEC dbo.sp_GetOrders @StatusId = 1;

-- 4. Фільтр по діапазону дат
EXEC dbo.sp_GetOrders
    @DateFrom = '2025-10-24', 
    @DateTo   = '2025-10-26';

-- 5. Пагінація: друга сторінка, по 5 записів
EXEC dbo.sp_GetOrders 
    @PageSize = 5,
    @PageNumber = 2;

-- 6. Сортування по імені клієнта DESC
EXEC dbo.sp_GetOrders 
    @SortColumn = 'customer_name',
    @SortDirection = 1;


CREATE OR ALTER PROCEDURE dbo.sp_GetDishes
    @DishId INT = NULL,
    @Name NVARCHAR(100) = NULL,
    @Category NVARCHAR(50) = NULL,
    @MenuId INT = NULL,
    @PriceFrom DECIMAL(10,2) = NULL,
    @PriceTo DECIMAL(10,2) = NULL,
    @PageSize INT = 100,
    @PageNumber INT = 1,
    @SortColumn NVARCHAR(50) = 'name',
    @SortDirection BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        d.dish_id,
        d.name,
        d.description,
        d.price,
        d.category,
        m.type AS menu_type
    FROM Dish d
    LEFT JOIN Menu m ON m.menu_id = d.menu_id
    WHERE (@DishId IS NULL OR d.dish_id = @DishId)
      AND (@Name IS NULL OR d.name LIKE '%' + @Name + '%')
      AND (@Category IS NULL OR d.category = @Category)
      AND (@MenuId IS NULL OR d.menu_id = @MenuId)
      AND (@PriceFrom IS NULL OR d.price >= @PriceFrom)
      AND (@PriceTo IS NULL OR d.price <= @PriceTo)

    ORDER BY
        CASE 
            WHEN @SortColumn = 'name'  AND @SortDirection = 0 THEN d.name
        END ASC,
        CASE 
            WHEN @SortColumn = 'name'  AND @SortDirection = 1 THEN d.name
        END DESC,

        CASE 
            WHEN @SortColumn = 'price' AND @SortDirection = 0 THEN d.price
        END ASC,
        CASE 
            WHEN @SortColumn = 'price' AND @SortDirection = 1 THEN d.price
        END DESC,

        CASE 
            WHEN @SortColumn = 'category' AND @SortDirection = 0 THEN d.category
        END ASC,
        CASE 
            WHEN @SortColumn = 'category' AND @SortDirection = 1 THEN d.category
        END DESC,

        d.dish_id

    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO


-- 1. Усі страви
EXEC dbo.sp_GetDishes @PageSize = 50;

-- 2. Пошук страви за назвою
EXEC dbo.sp_GetDishes @Name = N'Бур';

-- 3. Фільтр по категорії (наприклад 'Основні')
EXEC dbo.sp_GetDishes @Category = N'Салати';

-- 4. Фільтр по меню (наприклад menu_id = 2)
EXEC dbo.sp_GetDishes @MenuId = 2;

-- 5. Фільтр по ціновому діапазону
EXEC dbo.sp_GetDishes 
    @PriceFrom = 100, 
    @PriceTo   = 200;

-- 6. Сортування по ціні DESC
EXEC dbo.sp_GetDishes 
    @SortColumn = 'price',
    @SortDirection = 1;

-- 7. Пагінація
EXEC dbo.sp_GetDishes 
    @PageSize = 3, 
    @PageNumber = 2;


CREATE OR ALTER PROCEDURE dbo.sp_GetWarehouse
    @ProductName NVARCHAR(100) = NULL,
    @SupplierId INT = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @PageSize INT = 100,
    @PageNumber INT = 1,
    @SortColumn NVARCHAR(50) = 'delivery_time',
    @SortDirection BIT = 1  -- нові поставки зверху
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        w.warehouse_id,
        w.stock,
        w.delivery_time,
        w.expiration_date,

        p.name AS product_name,
        p.price AS product_price,
        mu.name AS unit_name,
        s.name AS supplier_name
    FROM Warehouse w
    JOIN ProductsList p ON p.product_id = w.product_id
    LEFT JOIN Supplier s ON s.supplier_id = p.supplier_id
    LEFT JOIN MeasurementUnit mu ON mu.unit_id = p.unit_id
    WHERE (@ProductName IS NULL OR p.name LIKE '%' + @ProductName + '%')
      AND (@SupplierId IS NULL OR p.supplier_id = @SupplierId)
      AND (@DateFrom IS NULL OR w.delivery_time >= @DateFrom)
      AND (@DateTo   IS NULL OR w.delivery_time <= @DateTo)

    ORDER BY
        CASE WHEN @SortDirection = 0 THEN
            CASE @SortColumn
                WHEN 'delivery_time' THEN CONVERT(NVARCHAR, w.delivery_time)
                WHEN 'product_name'  THEN p.name
                WHEN 'supplier_name' THEN s.name
                ELSE CONVERT(NVARCHAR, w.warehouse_id)
            END
        END ASC,
        CASE WHEN @SortDirection = 1 THEN
            CASE @SortColumn
                WHEN 'delivery_time' THEN CONVERT(NVARCHAR, w.delivery_time)
                WHEN 'product_name'  THEN p.name
                WHEN 'supplier_name' THEN s.name
                ELSE CONVERT(NVARCHAR, w.warehouse_id)
            END
        END DESC

    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- 1. Усі записи складу
EXEC dbo.sp_GetWarehouse;

-- 2. Пошук по частині назви товару
EXEC dbo.sp_GetWarehouse @ProductName = N'Сир';

-- 3. Фільтр по постачальнику
EXEC dbo.sp_GetWarehouse @SupplierId = 1;

-- 4. Вибірка за періодом поставки
EXEC dbo.sp_GetWarehouse 
    @DateFrom = '2025-10-01',
    @DateTo   = '2025-10-26';

-- 5. Пагінація
EXEC dbo.sp_GetWarehouse 
    @PageSize = 5,
    @PageNumber = 2;

-- 6. Сортування по назві продукту ASC
EXEC dbo.sp_GetWarehouse 
    @SortColumn = 'product_name',
    @SortDirection = 0;


CREATE OR ALTER PROCEDURE dbo.sp_GetOrdersRevenue
    @DateFrom  DATE = NULL,      -- початок періоду
    @DateTo    DATE = NULL,      -- кінець періоду
    @StatusId  INT  = NULL       -- статус "оплачене"/"завершене"
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        SUM(d.price * od.quantity) AS total_revenue
    FROM Orders o
    JOIN OrderDish od ON od.order_id = o.order_id
    JOIN Dish d       ON d.dish_id = od.dish_id
    WHERE (@DateFrom IS NULL OR o.order_date >= @DateFrom)
      AND (@DateTo   IS NULL OR o.order_date <= @DateTo)
      AND (@StatusId IS NULL OR o.status_id = @StatusId);
END;
GO

-- 1. Увесь дохід з усіх замовлень (без обмежень)
EXEC dbo.sp_GetOrdersRevenue;

-- 2. Дохід за січень 2024 року з оплачених замовлень (статус 4 = 'Оплачено')
EXEC dbo.sp_GetOrdersRevenue 
    @DateFrom = '2025-10-01',
    @DateTo   = '2025-10-30',
    @StatusId = 4;

-- 3. Дохід за поточний рік (будь-який статус)
EXEC dbo.sp_GetOrdersRevenue 
    @DateFrom = '2024-01-01',
    @DateTo   = '2024-12-31';

-- 4. Дохід тільки по оплачених замовленнях без обмеження по даті
EXEC dbo.sp_GetOrdersRevenue 
    @StatusId = 4;
