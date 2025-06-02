-- Este es ejemplos de como crear tablas duras en sql 

-- para contar los resultados 
select count(name) from clients;

CREATE TABLE if not exists clients (
    clients_id integer primary key auto_increment,
    name varchar(100) not null,
    email varchar(100) not null unique,
    phone_number varchar(15),
    created_at timestamp not null default current_timestamp,
    modidied_at timestamp not null default current_timestamp on update current_timestamp

);

CREATE TABLE if not exists products (
    product_id integer  unsigned primary key auto_increment,
    name varchar(100) not null,
    slug varchar(100) not null unique,
    description text,
    created_at timestamp not null default current_timestamp,
    modidied_at timestamp not null default current_timestamp on update current_timestamp

);

-- Crear table para alamacenar los prductos de las facturas en cascada con los clientes el secreto esta en los 
-- ultimos tres campos 
-- estan ligados a clientes lade bills y la de bills_prducts esta ligada a bills.
--  estas tablas se conoce como tablas duras 
CREATE TABLE if not exists bills (
    bill_id integer unsigned primary key auto_increment,
    clients_id integer not null,
    total float,
    status enum( 'open', 'paid', 'lost') not null default 'open',
    created_at timestamp not null default current_timestamp,
    modidied_at timestamp not null default current_timestamp on update current_timestamp,
    foreign key (clients_id) references clients(clients_id)
    on delete cascade 
    on update cascade 
);

create table  if not exists bills_products (
    bill_product_id integer unsigned primary key auto_increment,
    bill_id integer unsigned not null, 
    product_id integer unsigned not null,
    quantity integer not null default 1,
    created_at timestamp not null default current_timestamp,
    modidied_at timestamp not null default current_timestamp on update current_timestamp,
    foreign key (bill_id) references bills(bill_id)
    on delete cascade
    on update cascade,
    foreign key (product_id) references products(product_id)
    on delete cascade
    on update cascade

    ); 


-- Instertar datos de ejemplo en las tablas creadas 

insert into clients (clients_id, name, email) value (10, 'Ruben', 'ruben@gmail.com');
insert into products (name,slug) values ( 'cocacola', 'slug-cocacola');
insert into bills (clients_id, total) values (10, 15.00 );
insert into bills_products (product_id, bill_id) values (20,20); 



-- Crear base de datos sueves a partir de las tablas creadas 

CREATE TABLE if not exists bills (
    bill_id integer unsigned primary key auto_increment,
    clients_id integer not null,
    total float,
    status enum( 'open', 'paid', 'lost') not null default 'open',
    created_at timestamp not null default current_timestamp,
    modidied_at timestamp not null default current_timestamp on update current_timestamp
);

create table  if not exists bills_products (
    bill_product_id integer unsigned primary key auto_increment,
    bill_id integer unsigned not null, 
    product_id integer unsigned not null,
    quantity integer not null default 1,
    created_at timestamp not null default current_timestamp,
    update_at timestamp not null default current_timestamp on update current_timestamp

    );


-- Se creo para manipulas columnas y datos 
create table test (
    test_id integer unsigned primary key auto_increment,
    name varchar(100) not null,
    qty integer,
    created_at timestamp not null default current_timestamp

);
-- Agregar una Columna a la tabla test 
alter table products add column price double (10,2) after slug;

--Eliminar una columna de la tabla test 
alter table products drop column price;

-- Agregar una Columna en otra posicion 
alter table test add column price float after | first qty; 

--MOdificar una columna en este caso price
alter table test modify column price decimal (10,3) not null;

-- Renombrar una columna 
alter table test rename column price to prices; 

--Renombrar la tabla test 
alter table test rename to tests;

-- Insertar Datos de ejemplo 
INSERT  INTO products (name, slug) values ('pluma azul', 'Pluma-azul');
-- Se inserto este ejemplo para probar la  funcion unique 
INSERT  INTO products (name, slug) values ('pluma morada', 'Pluma-azul');
INSERT  INTO products (name, slug) values ('pluma negra', 'Pluma-negra');
INSERT  INTO products (name, slug) values ('pluma roja', 'Pluma-roja');

--Insertar varios valores a la vez 
INSERT INTO products (name, slug, description) VALUES 
('pluma verde', 'Pluma-verde', 'Esto es una pluma para vender'),
('pluma naranja', 'Pluma-naranja', 'Esto es una pluma para vender');

--Se puede bajar el error de la insercion de datos duplicados con ignore
insert ignore into products (name, slug) values ('pluma azul', 'Pluma-azul');

--que hacer en caso de que se este duplicando un valor 
INSERT  INTO products (name, slug) values ('pluma azul', 'Pluma-azul')
ON DUPLICATE KEY UPDATE description = 'Ejecutado en el Duplicate Key'; 

-- Se puede mandar concatenado un mensaje 
INSERT  INTO products (name, slug) values ('pluma azul', 'Pluma-azul')
ON DUPLICATE KEY UPDATE description = (concat('hola :',values(slug)));

select rand();

-- Se puede agregar un valor a todas las fila de una columna 
update products set price = rand() * 100;


INSERT  INTO products (name, slug) values ('pluma azul', 'Pluma-azul')
ON DUPLICATE KEY UPDATE description = price;


-- Hacer una tabla real para los productos, vamos a crear una tabla real 

CREATE TABLE if not exists products (
    product_id integer unsigned primary key auto_increment,
    sku varchar (20) not null unique,
    name varchar(100) not null,
    slug varchar(100) not null unique,
    description text,
    created_at timestamp not null default current_timestamp,
    modidied_at timestamp not null default current_timestamp 
    on update current_timestamp
);


-- entrar a la librerias en mac 
cd ~/Downloads

-- Codigo para cargar archivos a la base de datos 
mysql -u usuario -p -D base_datos < archivo.sql


--Se va a empezar a trabajar con SELECT 
select count(name) 
from clients 
where name like 'Mr.%III';


select count(name) 
from clients 
where 
name like '%III'
or
name like '%IV';

select count(name) 
from clients 
where name like '%Gibson%';

select count(*)
from products
where price < 100;

select count(name) 
from products
where price * 10 > 5000;

select count(*)
from bill_products
where discount > 0;

SELECT count(*) FROM bill_products
WHERE date_added < '2024-09-24';

SELECT count(*) FROM bill_products
WHERE date_added BETWEEN '2024-09-24' AND '2024-09-30'
and product_id in (825,500,1986);


-- Acutalizacion de datos con el comando UPDATE
update clients 
set phone_number = '+525123456789',
name = 'Dr. Marquise Balistreri'
where client_id = 1
limit 1;

--set name = '+525169442496'

update clients 
set phone_number = null
where name like 'laura%'
or name like 'claire%'
limit 52;

select name, email, phone_number from clients
where 
name like 'laura%'
or 
name like 'claire%';

alter table products add column stock integer not null default 0 after price;

 update products set stock = round(100 * rand());



8 - 29
update products
set stock = stock - 1
where product_id = 8;


-- tinyint

alter table clients add column active 
tinyint  not null default 1 after phone_number ;

alter table clients add column active 


-- Delete de datos con el comando Delete id = 61398 

delete from clients 
where name like '%DVM';

delete from clients 
where email = 'deondre.ryan@hotmail.com';


--Select de datos 

select [columna]
from [tabla]
where [condicion]
group by [columna]
having [condicion]
order by [columna] asc|desc
limit 
--en que tiempo estoy ahorita 
select now();
-- en que base de datos estoy
select database();

select product_id, name, price, stock 
from products 
where price > 100;

select product_id, name, price, stock, price * stock as total_value
from products  
where price <= 100 and stock >90 
order by total_value;

select product_id, name, price, stock, price * stock as total_value
from products  
order by total_value desc
limit 10;


--sumar columna en total 
select sum(stock) from products as total_stock;

--Para sacar promedio de una columna 
select avg(price) from products as promedio;


select sum(price * stock)   as total
from products; 


-- hacer consultas profundas if dentro del select 

select email, 
if(email like '%@gmail.com', 1,0)  as gmail,
if(email like '%@hotmail.com', 1,0) as hotmail
from clients 
order by rand() 
limit 30; 

-- hacer cosnultas complejas con case 

select 
case 
    when email like '%@gmail.com' then 'Gmail'
    when email like '%@hotmail.com' then 'Hotmail'
    when email like '%@yahoo.com' then 'Yahoo'
    when email like '%@kozey.com' then 'kozey'
    else 'Otro'
end as email_provider,
count(*) as correos
from clients
group by email_provider; 

-- agrupar valores 
select name 
case 
    when email like '%@gmail.com' then 'Gmail'
    when email like '%@hotmail.com' then 'Hotmail'
    when email like '%@yahoo.com' then 'Yahoo'
    when email like '%@kozey.com' then 'kozey'
    else 'Otro'
end as email_provider,
count(*) as correos
from clients
where name like '%a'
group by email_provider
having correos < 100
order by correos desc;


-- agrupando valores 
select name, email, 
case
    when email like '%@gmail.com' then 'Gmail'
    when email like '%@hotmail.com' then 'Hotmail'
    when email like '%@yahoo.com' then 'Yahoo'
    when email like '%@kozey.com' then 'kozey'
    else 'Otro'
end as email_provider
from clients 
where name like 'a%' and email like '%@kozey.com';
--Segundo ejercico meter  datos de una tabla a otra tabla  

-- cracion de tabla nueva 
create table investment (
    investment_id integer unsigned primary key auto_increment,
    product_id integer unsigned not null,
    investment integer not null default 0,
    created_at timestamp not null default current_timestamp,
    modified_at timestamp not null default current_timestamp on update current_timestamp

);
--  insecion de datos a la tabla investment con datos de la tabla de products 

insert into investment (product_id, investment)
select  product_id, price * stock from products;


union de datos entre dos tablas 

select * from investment order by investment desc limit 10;

-- union de estas tablas 

select p.product_id, p.name, p.price, i.investment
from investment as i
left join products as p
on products.product_id = investment.product_id
where investment > 100000
and investment_id % 10 = 0
limit 3;

select b.bill_id,b.status, c.name, 
count(bp.bill_product_id) as number_of_products,
round(sum(bp.quantity * p.price * (1- bp.discount/100) )) as total
from bills as b 
left join clients as c 
  on b.client_id = c.client_id
left join bill_products as bp 
  on b.bill_id = bp.bill_id
left join products as p 
  on p.product_id = bp.product_id
where b.status = 'open'
group by b.bill_id;

