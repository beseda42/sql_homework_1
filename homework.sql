-- Вывод названия самой взрослой категории товаров (как я поняла, у которой самая ранняя дата производства)

-- 1 вариант:
SELECT GoodCategory.name FROM Good JOIN GoodCategory ON (Good.id_GoodCategory = GoodCategory.id) WHERE Good.productionDate <= ALL
(SELECT Good.productionDate FROM Good WHERE Good.productionDate IS NOT NULL)

-- 2 вариант:
SELECT GoodCategory.name FROM GoodCategory WHERE GoodCategory.id IN 
(SELECT Good.id_GoodCategory FROM Good WHERE Good.productionDate <= ALL 
(SELECT Good.productionDate FROM Good WHERE Good.productionDate IS NOT NULL)
)

-- 3 вариант:
SELECT GoodCategory.name FROM GoodCategory WHERE GoodCategory.id IN 
(SELECT Good.id_GoodCategory FROM Good WHERE Good.productionDate >= ALL 
(SELECT Good.productionDate FROM Good WHERE Good.productionDate IS NOT NULL)
)

-- 4 вариант:
SELECT GoodCategory.name FROM GoodCategory WHERE GoodCategory.id = ANY 
(SELECT Good.id_GoodCategory FROM Good WHERE Good.productionDate <= ALL 
(SELECT Good.productionDate FROM Good WHERE Good.productionDate IS NOT NULL)
)

-- 5 вариант:
SELECT GoodCategory.name FROM GoodCategory WHERE GoodCategory.id = ANY 
(SELECT Good.id_GoodCategory FROM Good WHERE Good.productionDate >= ALL 
(SELECT Good.productionDate FROM Good WHERE Good.productionDate IS NOT NULL)
)


-- Вывод id и name товаров, которых нет в наличии 

-- 1 вариант:
SELECT DISTINCT Good.id, Good.name FROM Good JOIN Good_Shop ON (Good.id = Good_shop.id_good) 
JOIN Good_Warehouse ON (Good.id = Good_Warehouse.id_good) WHERE ((Good_Shop.count = 0 OR Good_Shop.count = NULL) AND (Good_Warehouse.count = 0 OR Good_Warehouse.count = NULL))

-- 2 вариант:
SELECT DISTINCT Good.id, Good.name FROM Good WHERE Good.id IN 
(SELECT Good_shop.id_good FROM Good_shop WHERE (Good_Shop.count = 0 OR Good_Shop.count = NULL))
AND Good.id IN (SELECT Good_Warehouse.id_good FROM Good_Warehouse WHERE (Good_Warehouse.count = 0 OR Good_Warehouse.count = NULL))

-- 3 вариант:
SELECT DISTINCT Good.id, Good.name FROM Good WHERE Good.id = ANY
(SELECT Good_shop.id_good FROM Good_shop WHERE (Good_Shop.count = 0 OR Good_Shop.count = NULL))
AND Good.id = ANY (SELECT Good_Warehouse.id_good FROM Good_Warehouse WHERE (Good_Warehouse.count = 0 OR Good_Warehouse.count = NULL))

-- 4 вариант: 
SELECT DISTINCT Good.id, Good.name FROM Good JOIN Good_Shop ON (Good.id = Good_shop.id_good) WHERE Good.id IN
(SELECT Good_Warehouse.id_good FROM Good_Warehouse WHERE (Good_Warehouse.count = 0 OR Good_Warehouse.count = NULL)) AND 
(Good_Shop.count = 0 OR Good_Shop.count = NULL)

--Вывод id и name категории товаров, которая не продается ни в одном магазине

-- 1 вариант:

SELECT DISTINCT GoodCategory.id, GoodCategory.name FROM GoodCategory WHERE NOT EXISTS
(SELECT Good.id FROM Good JOIN Good_Shop ON (Good.id = Good_Shop.id_good) WHERE Good.id_GoodCategory = GoodCategory.id)

-- 2 вариант:

SELECT DISTINCT GoodCategory.id, GoodCategory.name FROM GoodCategory WHERE NOT EXISTS
(SELECT Good.id FROM Good WHERE Good.id IN
(SELECT Good_Shop.id_good FROM Good_Shop WHERE Good.id_GoodCategory = GoodCategory.id)
)

-- 3 вариант

SELECT DISTINCT GoodCategory.id, GoodCategory.name FROM GoodCategory WHERE NOT EXISTS
(SELECT Good.id FROM Good WHERE Good.id = ANY
(SELECT Good_Shop.id_good FROM Good_Shop WHERE Good.id_GoodCategory = GoodCategory.id)
)

-- Блиц-задание: Вывести id и name товаров, которые хранятся на складах в минимальном количестве
SELECT DISTINCT Good.id, Good.name FROM Good_Warehouse JOIN Good ON Good.id = Good_Warehouse.id_good 
WHERE Good_Warehouse.count > 0 AND Good_Warehouse.count <= ALL 
(SELECT Good_Warehouse.count FROM Good_Warehouse WHERE Good_Warehouse.count > 0)
