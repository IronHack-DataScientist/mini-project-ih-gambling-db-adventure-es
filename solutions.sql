-- Pregunta 1
SELECT Title, FirstName, LastName, DateOfBirth FROM Customer;

-- Pregunta 2
SELECT CustomerGroup, COUNT(*) AS NumberOfCustomers FROM Customer GROUP BY CustomerGroup;

-- Pregunta 3
SELECT Customer.*, Account.CurrencyCode 
FROM Customer 
JOIN Account ON Customer.CustId = Account.CustId;

-- Pregunta 4
SELECT BetDate, Product, SUM(Bet_Amt) AS TotalBet
FROM Betting
GROUP BY BetDate, Product;

-- Pregunta 5
SELECT BetDate, Product, SUM(Bet_Amt) AS TotalBet 
FROM Betting 
WHERE BetDate >= '2012-11-01' AND Product = 'Sportsbook'
GROUP BY BetDate, Product;

-- Pregunta 6
SELECT Product, Account.CurrencyCode, Customer.CustomerGroup, SUM(Bet_Amt) AS TotalBet
FROM Betting
JOIN Account ON Betting.AccountNo = Account.AccountNo
JOIN Customer ON Account.CustId = Customer.CustId
WHERE BetDate >= '2012-12-01'
GROUP BY Product, Account.CurrencyCode, Customer.CustomerGroup;

-- Pregunta 7
SELECT 
    Customer.Title, 
    Customer.FirstName, 
    Customer.LastName, 
    IFNULL(SUM(Bet_Amt), 0) AS TotalBet
FROM 
    Customer
LEFT JOIN 
    Account ON Customer.CustId = Account.Custid
LEFT JOIN 
    Betting ON Account.AccountNo = Betting.AccountNo AND MONTH(BetDate) = 11
GROUP BY 
    Customer.CustId, 
    Customer.Title, 
    Customer.FirstName, 
    Customer.LastName;

-- Pregunta 8.1
SELECT Customer.CustId, COUNT(DISTinct Product) AS NumberOfProducts
FROM Betting
JOIN Account ON Betting.AccountNo = Account.AccountNo
JOIN Customer ON Account.CustId = Customer.CustId
GROUP BY Customer.CustId;

-- Pregunta 8.2
SELECT Customer.CustId
FROM Betting
JOIN Account ON Betting.AccountNo = Account.AccountNo
JOIN Customer ON Account.CustId = Customer.CustId
WHERE Product IN ('Sportsbook', 'Vegas')
GROUP BY Customer.CustId
HAVING COUNT(DISTINCT Product) = 2;

-- Pregunta 9
SELECT Customer.CustId, SUM(Bet_Amt) AS TotalBet
FROM Betting
JOIN Account ON Betting.AccountNo = Account.AccountNo
JOIN Customer ON Account.CustId = Customer.CustId
WHERE Product = 'Sportsbook' AND Bet_Amt > 0
GROUP BY Customer.CustId
HAVING COUNT(DISTINCT Product) = 1;

-- Pregunta 10
SELECT 
    a.CustId,
    a.Product,
    a.FavoriteProduct
FROM (
    SELECT
        Customer.CustId,
        Betting.Product,
        MAX(Bet_Amt) AS FavoriteProduct
    FROM
        Betting
    JOIN
        Account ON Betting.AccountNo = Account.AccountNo
    JOIN
        Customer ON Account.CustId = Customer.CustId
    GROUP BY
        Customer.CustId,
        Betting.Product
) AS a
JOIN (
    SELECT
        Customer.CustId,
        MAX(Bet_Amt) AS MaxBet
    FROM
        Betting
    JOIN
        Account ON Betting.AccountNo = Account.AccountNo
    JOIN
        Customer ON Account.CustId = Customer.CustId
    GROUP BY
        Customer.CustId
) AS b ON a.CustId = b.CustId AND a.FavoriteProduct = b.MaxBet;

-- Pregunta 11
SELECT student_name, GPA
FROM students
ORDER BY GPA DESC
LIMIT 5;

-- Pregunta 12
SELECT schools.school_name, COUNT(students.student_id) AS student_count
FROM schools
LEFT JOIN students ON schools.school_id = students.school_id
GROUP BY schools.school_name;

-- Pregunta 13
SELECT school_name, student_name, GPA
FROM (
    SELECT school_name, student_name, GPA,
           RANK() OVER (PARTITION BY school_name ORDER BY GPA DESC) AS ranking
    FROM students
    JOIN schools ON students.school_id = schools.school_id
) ranked_students
WHERE ranking <= 3;




