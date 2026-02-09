DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS OrderHeader;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    Id INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Price NUMERIC(10,2) NOT NULL
);

CREATE TABLE Cart (
    ProductId INT PRIMARY KEY,
    Qty INT NOT NULL CHECK (Qty > 0),
    FOREIGN KEY (ProductId) REFERENCES Products(Id)
);

CREATE TABLE OrderHeader (
    OrderID SERIAL PRIMARY KEY,
    User_ID INT NOT NULL,
    OrderDate TIMESTAMP NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProdID INT,
    Qty INT NOT NULL,
    PRIMARY KEY (OrderID, ProdID),
    FOREIGN KEY (OrderID) REFERENCES OrderHeader(OrderID),
    FOREIGN KEY (ProdID) REFERENCES Products(Id)
);

INSERT INTO Users VALUES
(1, 'Arnold'),
(2, 'Sheryl');

INSERT INTO Products VALUES
(1, 'Coke', 10),
(2, 'Chips', 5);

SELECT * FROM Users;
SELECT * FROM Products;

INSERT INTO Cart (ProductId, Qty)
VALUES (1, 1)
ON CONFLICT (ProductId)
DO UPDATE SET Qty = Cart.Qty + 1;

SELECT * FROM Cart;

INSERT INTO Cart (ProductId, Qty)
VALUES (2, 1)
ON CONFLICT (ProductId)
DO UPDATE SET Qty = Cart.Qty + 1;

SELECT * FROM Cart;

UPDATE Cart
SET Qty = Qty - 1
WHERE ProductId = 1
AND Qty > 1;

DELETE FROM Cart
WHERE ProductId = 1
AND Qty = 1;

SELECT * FROM Cart;

INSERT INTO OrderHeader (User_ID, OrderDate)
VALUES (1, NOW())
RETURNING OrderID;

INSERT INTO OrderDetails (OrderID, ProdID, Qty)
SELECT 
    (SELECT MAX(OrderID) FROM OrderHeader),
    ProductId,
    Qty
FROM Cart;

SELECT * FROM OrderDetails;

DELETE FROM Cart;

SELECT * FROM Cart;

INSERT INTO Cart VALUES (1, 2);
INSERT INTO Cart VALUES (2, 1);

INSERT INTO OrderHeader (User_ID, OrderDate)
VALUES (2, NOW());

INSERT INTO OrderDetails (OrderID, ProdID, Qty)
SELECT 
    (SELECT MAX(OrderID) FROM OrderHeader),
    ProductId,
    Qty
FROM Cart;

DELETE FROM Cart;

SELECT 
    oh.OrderID,
    u.Username,
    oh.OrderDate,
    p.Name,
    od.Qty,
    p.Price,
    od.Qty * p.Price AS LineTotal
FROM OrderHeader oh
JOIN Users u ON oh.User_ID = u.User_ID
JOIN OrderDetails od ON oh.OrderID = od.OrderID
JOIN Products p ON od.ProdID = p.Id
WHERE oh.OrderID = 1;

SELECT 
    oh.OrderID,
    u.Username,
    oh.OrderDate,
    p.Name,
    od.Qty
FROM OrderHeader oh
JOIN Users u ON oh.User_ID = u.User_ID
JOIN OrderDetails od ON oh.OrderID = od.OrderID
JOIN Products p ON od.ProdID = p.Id
WHERE DATE(oh.OrderDate) = CURRENT_DATE
ORDER BY oh.OrderID;

CREATE OR REPLACE FUNCTION AddToCart(p_product_id INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Cart (ProductId, Qty)
    VALUES (p_product_id, 1)
    ON CONFLICT (ProductId)
    DO UPDATE SET Qty = Cart.Qty + 1;
END;
$$ LANGUAGE plpgsql;

SELECT AddToCart(1);
SELECT AddToCart(2);

CREATE OR REPLACE FUNCTION RemoveFromCart(p_product_id INT)
RETURNS VOID AS $$
BEGIN
    UPDATE Cart
    SET Qty = Qty - 1
    WHERE ProductId = p_product_id
    AND Qty > 1;

    DELETE FROM Cart
    WHERE ProductId = p_product_id
    AND Qty = 1;
END;
$$ LANGUAGE plpgsql;

SELECT RemoveFromCart(1);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

SELECT current_database();

ALTER TABLE cart
ADD CONSTRAINT fk_cart_product
FOREIGN KEY (productid)
REFERENCES products(id);

ALTER TABLE orderheader
ADD CONSTRAINT fk_orderheader_user
FOREIGN KEY (user_id)
REFERENCES users(user_id);

ALTER TABLE orderdetails
ADD CONSTRAINT fk_orderdetails_order
FOREIGN KEY (orderid)
REFERENCES orderheader(orderid);

ALTER TABLE orderdetails
ADD CONSTRAINT fk_orderdetails_product
FOREIGN KEY (prodid)
REFERENCES products(id);
