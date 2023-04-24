create table shopBranch
(
    number  int         not null primary key,
    street  text        not null,
    city    varchar(15) not null,
    zipCode char(6)     not null
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
    license   char(15) not null,
    position  varchar(15),
    person_id int      not null,
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
    person_id int not null,
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
        foreign key (client_id) references client (number)
--     constraint pk_purchase
--         primary key (client_id, number)
);

create table product
(
    price int,
    name  varchar(30) not null,
    brand varchar(30) not null,
    size  varchar(10) not null,
    id    serial primary key
--     constraint pk_product primary key (name, brand, size)
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
    constraint pk_order
        primary key (purchase_id, product_id),
    constraint fk_purchase
        foreign key (purchase_id) references purchase (id),
    constraint fk_product
        foreign key (product_id) references product (id)
);

create table category
(
    name varchar(20) not null,
    id   serial      not null primary key
);

create table structure
(
    category_id int not null,
    product_id  int not null,
    constraint fk_product
        foreign key (product_id) references product (id),
    constraint fk_category
        foreign key (category_id) references category (id),
    constraint pk_structure primary key (category_id, product_id)
);

create table subCategory
(
    category_id    int not null,
    subCategory_id int not null,
    constraint fk_category
        foreign key (category_id) references category (id),
    constraint fk_subCategory
        foreign key (subCategory_id) references category (id),
    constraint pk_subCategory primary key (category_id, subCategory_id)
);

create table stock
(
    shopBranch int         not null primary key,
    street     text        not null,
    city       varchar(15) not null,
    zipCode    char(6)     not null,
    constraint fk_shopBranch
        foreign key (shopBranch) references shopBranch (number)
--     constraint pk_stock primary key (street, city, zipCode)
);

create table storing
(
    product_id       int not null,
    stock_shopBranch int not null,
    constraint fk_stock
        foreign key (stock_shopBranch) references stock (shopBranch),
    constraint pk_storing primary key (product_id, stock_shopBranch)
)

