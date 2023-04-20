ALTER ROLE rybinali WITH PaSSWORD 'rybinali';
--
-- CREATE TABLE accounts
-- (
--     ida     INT PRIMARY KEY,
--     number  VARCHAR(22)    NOT NULL UNIQUE,
--     owner   VARCHAR(100)   NOT NULL,
--     city    VARCHAR(50)    NOT NULL,
--     balance DECIMAL(15, 2) NOT NULL DEFAULT 0
-- );
--
-- CREATE TABLE transfers
-- (
--     idt      BIGINT PRIMARY KEY,
--     dateTime TIMESTAMP      NOT NULL,
--     source   INT            REFERENCES accounts (ida) ON DELETE SET NULL,
--     target   INT            REFERENCES accounts (ida) ON DELETE SET NULL,
--     amount   DECIMAL(15, 2) NOT NULL
-- );
--
--
-- INSERT INTO accounts(IDA, NUMBER, OWNER, CITY)
-- VALUES (501, '123456789/1111', 'Martin Svoboda', 'Liberec'),
--        (502, '101010101/1111', 'Irena Mlynkova', 'Praha');
--
--
-- UPDATE accounts
-- SET OWNER = 'Irena Holubova',
--     CITY  = 'Praha'
-- where ida = 502;
--
--
-- UPDATE accounts
-- set balance = balance * 0.01
-- where city = 'Liberec';
--
--
-- delete
-- from accounts
-- where number == '101010101/1111';
--
--
-- create view LIBEREC_BALANCED as
-- select *
-- from accounts
-- where city = 'Liberec'
--   and balance >= 10000.00;
--
--
-- insert into LIBEREC_BALANCED(ida, number, owner, city, balance)
-- VALUES (506, '1999888777/1111', 'Jakub Klimek', 'Liberec', 5000),
--        (507, '666555444/1111', 'Jakub Lokoc', 'Brno', 15000);
--


create table shopBranch
(
    number  int         not null primary key,
    street  text        not null,
    city    varchar(15) not null,
    zipCode char(6)     not null,
    constraint pk_shopBranch
        PRIMARY KEY (street, city, zipCode)
);

create table person
(
    gender    int,
    pid       int not null primary key,
    firstName varchar(15),
    lastName  varchar(15),
    constraint chk_gender check ( gender = 1 or gender = 2 )
);


create table employee
(
    id        serial primary key,
    salary    int,
    license   char(15) not null primary key,
    position  varchar(15),
    person_id int primary key,
    constraint fk_person
        foreign key (person_id) references person (pid)
);

create table boss
(
    employee_id int primary key,
    superior_id int,
    constraint fk_employee
        foreign key (employee_id) references employee (id),
    constraint fk_superior
        foreign key (superior_id) references employee (id)
);

create table client
(
    number    serial primary key,
    person_id int primary key,
    constraint fk_person
        foreign key (person_id) references person (pid)
);

create table discounts
(
    client_id   int not null,
    id          serial,
    expiredDate date,
    percent     int not null,
    constraint pk_discounts
        primary key (id, client_id),
    constraint fk_client
        foreign key (client_id) references client (number)
);

create table purchase
(
    client_id     int not null,
    shopBranch_id int not null,
    number        int not null,
--     не serial потому что ноиер покупки именно у клиента, если бы был serial то это бы был искусственный идентификатор
    totalSum      decimal(9, 3),
--     ???
    id            serial primary key,
--     ???
    constraint fk_shopBranch
        foreign key (shopBranch_id) references shopBranch (number),
    constraint fk_client
        foreign key (client_id) references client (number),
    constraint pk_purchase
        primary key (client_id, number)
);

create table product
(
    price int,
    name  varchar(30) not null,
    brand varchar(30) not null,
    size  varchar(10) not null,
    id    serial primary key,
    constraint pk_product primary key (name, brand, size)
);

create table images
(
    product_id int  not null,
    image      text not null,
    constraint pk_images primary key (product_id, image),
    constraint fk_product
        foreign key (product_id) references product (id)
);

create table "order"
(
    purchase_id int not null,
    product_id  int not null,
    constraint fk_purchase
        foreign key (purchase_id) references purchase (id),
    constraint fk_product
        foreign key (product_id) references product (id)
);

create table category
(
    name varchar(20) not null primary key
);

create table structure
(
    category_name varchar(20) not null,
    product_id    int         not null,
    constraint fk_product
        foreign key (product_id) references product (id),
    constraint fk_category
        foreign key (category_name) references category (name),
    constraint pk_structure primary key (category_name, product_id)
);

create table subCategory
(
    category_name    varchar(20) not null,
    subCategory_name varchar(20) not null,
    constraint fk_category
        foreign key (category_name) references category (name),
    constraint fk_subCategory
        foreign key (subCategory_name) references category (name),
    constraint pk_subCategory primary key (category_name, subCategory_name)
);

create table stock
(
    shopBranch int not null primary key,
    street  text        not null,
    city    varchar(15) not null,
    zipCode char(6)     not null,
    constraint fk_shopBranch
            foreign key (shopBranch) references shopBranch(number),
    constraint pk_stock primary key (street, city, zipCode)
);

create table storing
(
    product_id int not null,
    stock_number int not null ,
    constraint fk_stock
        foreign key (stock_number) references stock(shopBranch),
    constraint pk_storing primary key (product_id, stock_number)
)