create database non_dairy_barn;
drop database non_dairy_barn;


grant all privileges on non_dairy_barn.* to 'webapp'@'%';
flush privileges;

use non_dairy_barn;
-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Employees'
-- -----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS Employees;
CREATE TABLE IF NOT EXISTS Employees(
   ssn         VARCHAR(11) UNIQUE NOT NULL,
   first_name  VARCHAR(10) NOT NULL,
   last_name   VARCHAR(13) NOT NULL,
   hourly_wage VARCHAR(6) NOT NULL,
   home_store  INTEGER  NOT NULL,
   employeeID  VARCHAR(10) NOT NULL PRIMARY KEY
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Store_Locations'
-- -----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS Store_Locations;
CREATE TABLE IF NOT EXISTS Store_Locations(
   storeID       INTEGER  NOT NULL PRIMARY KEY,
   street_address VARCHAR(24) NOT NULL,
   city           VARCHAR(11) NOT NULL,
   state          VARCHAR(13) NOT NULL,
   zipcode        INTEGER  NOT NULL,
   phone_number   VARCHAR(12) NOT NULL,
   manager_l_name VARCHAR(10) NOT NULL,
   manager_f_name VARCHAR(8) NOT NULL,
   managerID      VARCHAR(10) NOT NULL,
   CONSTRAINT fk_1
        FOREIGN KEY (managerID) references Employees (employeeID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Company_Payroll'
-- -----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS Company_Payroll;
CREATE TABLE IF NOT EXISTS Company_Payroll(
   primary_storeID  INTEGER  NOT NULL,
   total_wages      VARCHAR(8) NOT NULL,
   month_start_date VARCHAR(10)  NOT NULL,
   employeeID       VARCHAR(10) NOT NULL
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Products'
-- -----------------------------------------------------------------------------------------

drop table if exists Products;
CREATE TABLE if not exists Products(
   productID INTEGER  NOT NULL PRIMARY KEY,
   name      VARCHAR(30) NOT NULL,
   price     NUMERIC(4,2) NOT NULL,
   milk_type VARCHAR(9) NOT NULL
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Discounts'
-- -----------------------------------------------------------------------------------------

drop table if exists Discounts;
CREATE TABLE if not exists Discounts(
   start_date    VARCHAR(19) NOT NULL,
   end_date      VARCHAR(19) NOT NULL,
   percent_off   INTEGER  NOT NULL,
   discount_code VARCHAR(8) NOT NULL PRIMARY KEY
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Disc_Prod'
-- -----------------------------------------------------------------------------------------

drop table if exists Disc_Prod;
create table if not exists Disc_Prod
(
    discount_code VARCHAR(8) NOT NULL,
    productID     INTEGER  NOT NULL,
    PRIMARY KEY (discount_code, productID),
    constraint fk_3
        foreign key (discount_code) references Discounts (discount_code),
    constraint fk_4
        foreign key (productID) references Products (productID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Customers'
-- -----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS Customers;
CREATE TABLE if not exists Customers(
   customer_id      INTEGER  NOT NULL PRIMARY KEY,
   email            VARCHAR(29) NOT NULL,
   last_name        VARCHAR(11) NOT NULL,
   first_name       VARCHAR(11) NOT NULL,
   phone_num        VARCHAR(12) NOT NULL,
   payment_info     VARCHAR(16) NOT NULL,
   primary_store_id INTEGER  NOT NULL,
   street_address   VARCHAR(27) NOT NULL,
   city             VARCHAR(13) NOT NULL,
   state            VARCHAR(13) NOT NULL,
   zipcode          INTEGER  NOT NULL
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'StoreLoc_Cust'
-- -----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS StoreLoc_Cust;
create table if not exists StoreLoc_Cust
(
    customerID INTEGER  NOT NULL,
    storeID    INTEGER  NOT NULL,
    PRIMARY KEY (customerID, storeID),
    CONSTRAINT fk_5
        FOREIGN KEY (customerID) references Customers (customer_id),
    CONSTRAINT fk_6
        foreign key (storeID) references Store_Locations (storeID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Location_Payroll'
-- -----------------------------------------------------------------------------------------

drop table if exists Location_Payroll;
create table if not exists Location_Payroll
(
    week_start_date VARCHAR(19) NOT NULL,
    hours_worked    NUMERIC(5,2) NOT NULL,
    employeeID      VARCHAR(10) NOT NULL,
    storeID         INTEGER  NOT NULL,
    PRIMARY KEY (employeeID, storeID, week_start_date),
    constraint fk_7
        foreign key (employeeID) references Employees (employeeID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Emp_LocPay'
-- -----------------------------------------------------------------------------------------

drop table if exists Emp_LocPay;
create table if not exists Emp_LocPay
(
    storeID    INTEGER  NOT NULL,
    employeeID VARCHAR(10) NOT NULL,
    constraint fk_8
        foreign key (employeeID) references Location_Payroll (employeeID),
    constraint fk_9
        foreign key (storeID) references Store_Locations (storeID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Inventory'
-- -----------------------------------------------------------------------------------------

drop table if exists Inventory;
create table if not exists Inventory
(
    units_in_stock int,
    units_on_order int,
    on_order       bool,
    storeID        INTEGER NOT NULL,
    productID      INTEGER NOT NULL,
    primary key (storeID, productID, units_in_stock, units_on_order),
    constraint fk_10
        foreign key (storeID) references Store_Locations (storeID)

);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Invent_Prod'
-- -----------------------------------------------------------------------------------------

drop table if exists Invent_Prod;
create table if not exists Invent_Prod
(
    storeID   INTEGER NOT NULL,
    productID INTEGER NOT NULL,
    primary key (storeID, productID),
    constraint fk_11
        foreign key (productID) references Products (productID),
    constraint fk_12
        foreign key (storeID) references Inventory (storeID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Ingredients'
-- -----------------------------------------------------------------------------------------

drop table if exists Ingredients;
create table if not exists Ingredients
(
    productID       INTEGER  NOT NULL,
    ingredient_name VARCHAR(33) NOT NULL,
    constraint fk_13
        foreign key (productID) references Products (productID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Customer_Orders'
-- -----------------------------------------------------------------------------------------

drop table if exists Customer_Orders;
create table if not exists Customer_Orders
(
    orderID    INTEGER  NOT NULL,
    units      INTEGER  NOT NULL,
    order_date VARCHAR(19) NOT NULL,
    customerID INTEGER  NOT NULL,
    productID  INTEGER  NOT NULL,
    primary key (customerID, productID),
    constraint fk_14
        foreign key (customerID) references Customers (customer_id),
    constraint fk_15
        foreign key (productID) references Products (productID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Prod_Cust'
-- -----------------------------------------------------------------------------------------

drop table if exists Prod_Cust;
create table if not exists Prod_Cust
(
    productID  INTEGER  NOT NULL,
    customerID INTEGER  NOT NULL,
    primary key (productID, customerID),
    constraint fk_16
        foreign key (productID) references Customer_Orders (productID),
    constraint fk_17
        foreign key (productID) references Products (productID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Suppliers'
-- -----------------------------------------------------------------------------------------

drop table if exists Suppliers;
CREATE TABLE if not exists Suppliers(
   supplierID     INTEGER  NOT NULL PRIMARY KEY,
   company_name   VARCHAR(32) NOT NULL,
   street_address VARCHAR(25) NOT NULL,
   city           VARCHAR(12) NOT NULL,
   state          VARCHAR(20) NOT NULL,
   zipcode        INTEGER  NOT NULL,
   contact_l_name VARCHAR(11) NOT NULL,
   contact_f_name VARCHAR(9) NOT NULL,
   phone_num      VARCHAR(12) NOT NULL,
   email          VARCHAR(28) NOT NULL
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Stocking_Expenses'
-- -----------------------------------------------------------------------------------------

drop table if exists Stocking_Expenses;
create table if not exists Stocking_Expenses
(
    weekly_start_date VARCHAR(10)  NOT NULL,
    weekly_cost       VARCHAR(7) NOT NULL,
    storeID           INTEGER  NOT NULL,
    productID         INTEGER  NOT NULL,
    primary key (storeID, productID),
    constraint fk_18
        foreign key (storeID) references Store_Locations (storeID),
    constraint fk_19
        foreign key (productID) references Products (productID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Supplier Orders'
-- -----------------------------------------------------------------------------------------

drop table if exists Supplier_Orders;
create table if not exists Supplier_Orders
(
    orderID       INTEGER  NOT NULL,
    units         INTEGER  NOT NULL,
    order_date    VARCHAR(10)  NOT NULL,
    shipping_cost VARCHAR(6) NOT NULL,
    supplierID    INTEGER  NOT NULL,
    productID     INTEGER  NOT NULL,
    primary key (supplierID, productID),
    constraint fk_20
        foreign key (supplierID) references Suppliers (supplierID)
);

-- -----------------------------------------------------------------------------------------
-- Table 'non_dairy_barn'.'Prod_Sup'
-- -----------------------------------------------------------------------------------------

drop table if exists Prod_Sup;
create table Prod_Sup
(
    productID  INTEGER  NOT NULL,
    supplierID INTEGER  NOT NULL,
    primary key (productID, supplierID),
    constraint fk_21
        foreign key (productID) references Products (productID),
    constraint fk_22
        foreign key (supplierID) references Supplier_Orders (supplierID)
);