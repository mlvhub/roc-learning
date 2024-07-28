
create table products (
    id serial primary key,
    name text not null,
    price int not null
);

insert into products (name, price) values ('apple', 100);
insert into products (name, price) values ('banana', 200);
insert into products (name, price) values ('orange', 300);