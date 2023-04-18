create database non_dairy_barn;

use non_dairy_barn;

create table Employees
(
    employeeID  CHAR(10) primary key,
    SSN         char(11) unique NOT NULL,
    first_name  varchar(40),
    last_name   varchar(40),
    hourly_wage DECIMAL(4, 2),
    home_store  char(10)
);

insert into Employees (employeeID, SSN, first_name, last_name, hourly_wage, home_store)
VALUES (000001, 99 - 999 - 9999, 'Tyrin', 'Rannington', 15.00, 000001),
       (000002, 88 - 888 - 8888, 'Velma', 'Leming', 20.00, 000002),
       (000003, 77 - 777 - 7777, 'Weyrin', 'Smith', 25.00, 000003);

create table Store_Locations
(
    storeID        char(10) primary key,
    street_address varchar(100),
    city           varchar(40),
    state          varchar(40),
    zipcode        char(10),
    phone_number   char(15) unique,
    manager_name   varchar(100),
    managerID      char(10),
    CONSTRAINT fk_1
        FOREIGN KEY (managerID) references Employees (employeeID)
);

insert into Store_Locations (storeID, street_address, city, state, zipcode, phone_number, manager_name, managerID)
values (000001, '800 Hemingway Rd', 'Milkton', 'Vermont', '02929', 555 - 555 - 5555, 'Tyrin Rannington', 000001),
       (000002, '50 Old Mill Way', 'Westin', 'Vermont', '23123', 717 - 282 - 2931, 'Velma Leming', 000002),
       (000003, '182 Tommorrow Way', 'Burlington', 'Vermont', '12312', 226 - 235 - 5473, 'Weyrin Smith', 000003);

CREATE TABLE IF NOT EXISTS Company_Payroll(
   primary_storeID  INTEGER  NOT NULL PRIMARY KEY AUTO_INCREMENT
  ,total_wages      VARCHAR(8) NOT NULL
  ,month_start_date DATE  NOT NULL
  ,employeeID       VARCHAR(10) NOT NULL
);


create table Products
(
    productID char(10) primary key,
    name      varchar(100),
    price     DECIMAL(6, 2),
    milk_type char(10)
);

insert into Products (productID, name, price, milk_type)
values (00001, 'Sams Sensational Soy Milk', 8.50, 'Soy'),
       (00002, 'Als Awesome Almond Milk', 10.00, 'Almond'),
       (00003, 'Oaks Outstanding Oat Milk', 4.50, 'Oat');

create table Discounts
(
    discount_code char(10) primary key,
    start_date    DATE,
    end_date      DATE,
    percent_off   decimal(6, 2)
);

insert into Discounts (discount_code, start_date, end_date, percent_off)
values (00001, '2023-04-23', '2023-05-23', 10),
       (00002, '2023-01-23', '2023-03-23', 25),
       (00003, '2023-09-23', '2023-10-23', 50);

create table Disc_Prod
(
    discount_code char(10),
    productID     char(10),
    PRIMARY KEY (discount_code, productID),
    constraint fk_3
        foreign key (discount_code) references Discounts (discount_code),
    constraint fk_4
        foreign key (productID) references Products (productID)
);

insert into Disc_Prod (discount_code, productID)
VALUES (00001, 00001),
       (00002, 00002),
       (00003, 00003);

create table Customers
(
    customerID      char(10) primary key,
    email           varchar(60) unique,
    payment_info    varchar(60),
    last_name       varchar(40),
    first_name      varchar(40),
    phone_num       char(15) unique,
    primary_storeID char(10),
    street_address  varchar(100),
    city            varchar(40),
    state           varchar(40),
    zipcode         char(10)
);

INSERT INTO Customers (customerID, email, payment_info, last_name, first_name,
                       phone_num, primary_storeID, street_address, city, state, zipcode)
VALUES (00001, 'someguy@email.com', '2342343423', 'Guy', 'Some', 123 - 546 - 5456, 00001, '18 Harold ln', 'Milkton',
        'Vermont', 12939),
       (00002, 'thatdude@email.com', '2342343423', 'Dude', 'That', 354 - 546 - 7445, 00002, '18 Tomorrow ln',
        'Burlington', 'Vermont', 12939),
       (00003, 'goodpal@email.com', '2342343423', 'Pal', 'Good', 343 - 588 - 9546, 00003, '18 Homeward ln', 'Westin',
        'Vermont', 12939);

create table StoreLoc_Cust
(
    customerID char(10),
    storeID    char(10),
    PRIMARY KEY (customerID, storeID),
    CONSTRAINT fk_5
        FOREIGN KEY (customerID) references Customers (customerID),
    CONSTRAINT fk_6
        foreign key (storeID) references Store_Locations (storeID)
);

insert into StoreLoc_Cust (customerID, storeID)
VALUES (00001, 00001),
       (00002, 00002),
       (00003, 00003);

create table Location_Payroll
(
    week_start_date DATE,
    hours_worked    DECIMAL(8, 2),
    employeeID      char(10),
    storeID         char(10),
    PRIMARY KEY (employeeID, storeID),
    constraint fk_7
        foreign key (employeeID) references Employees (employeeID)
);

insert into Location_Payroll (week_start_date, hours_worked, employeeID, storeID)
VALUES ('2023-01-05', 40, 00001, 00001),
       ('2023-01-05', 60, 00002, 00002),
       ('2023-01-05', 70, 00003, 00003);


create table Emp_LocPay
(
    storeID    char(10),
    employeeID char(10),
    PRIMARY KEY (storeID, employeeID),
    constraint fk_8
        foreign key (employeeID, storeID) references Location_Payroll (employeeID, storeID),
    constraint fk_9
        foreign key (storeID) references Store_Locations (storeID)
);

insert into Emp_LocPay (storeID, employeeID)
VALUES (00001, 00001),
       (00002, 00002),
       (00003, 00003);

create table Inventory
(
    units_in_stock int,
    units_on_order int,
    on_order       bool,
    storeID        char(10),
    productID      char(10),
    primary key (storeID, productID),
    constraint fk_10
        foreign key (storeID) references Store_Locations (storeID)

);

insert into Inventory (units_in_stock, units_on_order, on_order, storeID, productID)
VALUES (123, 0, 0, 00001, 00001),
       (20, 100, 1, 00002, 00002),
       (0, 100, 1, 00003, 00003);

create table Invent_Prod
(
    storeID   char(10),
    productID char(10),
    primary key (storeID, productID),
    constraint fk_11
        foreign key (productID) references Products (productID),
    constraint fk_12
        foreign key (storeID, productID) references Inventory (storeID, productID)
);

insert into Invent_Prod (storeID, productID)
VALUES (00001, 00001),
       (00002, 00002),
       (00003, 00003);

create table Ingredients
(
    productID       char(10) primary key,
    ingredient_name varchar(60),
    constraint fk_13
        foreign key (productID) references Products (productID)
);

INSERT INTO Ingredients (productID, ingredient_name)
VALUES (00001, 'soy bean'),
       (00002, 'almond'),
       (00003, 'oat');

create table Customer_Orders
(
    orderID    char(10),
    units      int,
    order_date DATE,
    customerID char(10),
    productID  char(10),
    primary key (customerID, productID),
    constraint fk_14
        foreign key (customerID) references Customers (customerID),
    constraint fk_15
        foreign key (productID) references Products (productID)
);

INSERT INTO Customer_Orders (orderID, units, order_date, customerID, productID)
values (00001, 10, '2023-03-28', 00001, 00001),
       (00002, 1, '2022-12-24', 00002, 00002),
       (00003, 5, '2023-01-12', 00003, 00003);

create table Prod_Cust
(
    productID  char(10),
    customerID char(10),
    primary key (productID, customerID),
    constraint fk_16
        foreign key (productID) references Customer_Orders (productID),
    constraint fk_17
        foreign key (productID) references Products (productID)
);

insert into Prod_Cust (productID, customerID)
VALUES (00001, 00001),
       (00002, 00002),
       (00003, 00003);

create table Suppliers
(
    supplierID     char(10) primary key,
    street_address varchar(100),
    city           varchar(40),
    state          varchar(40),
    zipcode        char(10),
    contact_l_name varchar(40),
    contact_f_name varchar(40),
    phone_num      char(15),
    email          varchar(60)
);

insert into Suppliers (supplierID, street_address, city, state, zipcode, contact_l_name, contact_f_name, phone_num,
                       email)
values (00001, '50 Fifteen ln', 'Milkton', 'Vermont', 10231, 'Farrow', 'Tom', 534 - 256 - 8364, 'farrow@farrow.org'),
       (00002, '10 Jon Rd', 'Burlington', 'Vermont', 12322, 'Dez', 'Lou', 194 - 225 - 4745, 'dez@loudez.org');

create table Stocking_Expenses
(
    storeID         char(10),
    week_start_date date,
    weekly_cost     DECIMAL(10, 2),
    supplierID      char(10),
    productID       char(10),
    primary key (supplierID, productID),
    constraint fk_18
        foreign key (storeID) references Store_Locations (storeID),
    constraint fk_19
        foreign key (productID) references Products (productID)
);

insert into Stocking_Expenses (storeID, week_start_date, weekly_cost, supplierID, productID)
Values (00001, '2023-01-04', 1000.00, 00001, 00001),
       (00002, '2023-01-04', 1000.00, 00002, 00002);

create table Supplier_Orders
(
    orderID       char(10),
    units         int,
    order_date    date,
    shipping_cost Decimal(8, 2),
    supplierID    char(10),
    productID     char(10),
    primary key (supplierID, productID),
    constraint fk_20
        foreign key (supplierID) references Suppliers (supplierID)
);

insert into  Supplier_Orders (orderID, units, order_date, shipping_cost, supplierID, productID)
VALUES (00001, 100, '2022-12-22', 200.00, 00001, 00001),
       (00002, 100, '2022-12-22', 200.00, 00002, 00002);

create table Prod_Sup
(
    productID  char(10),
    supplierID char(10),
    primary key (productID, supplierID),
    constraint fk_21
        foreign key (productID) references Products (productID),
    constraint fk_22
        foreign key (supplierID, productID) references Supplier_Orders (supplierID, productID)
);

insert into Prod_Sup (productID, supplierID)
VALUES (00001, 00001),
       (00002, 00002);
