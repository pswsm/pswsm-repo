-- DROP TABLES
drop table habitacio
drop table hotel;
drop table zona;

-- CREATE TABLES
--------------------
create table zones (
  id_zona number(3),
  nom varchar2(15),
  constraint id_zona_pk primary key (id_zona)
);

create table hotels (
  nom_hotel varchar2(20),
  num_habitacions number(3),
  id_zona number(3),
  constraint zones_id_zona_fk foreign key (id_zona) references zones(id_zona) on delete cascade
);

create table habitacions (
  nom_hotel varchar2(20),
  numero number(3),
  planta number(5),
  constraint nom_hotel_num_hab_pk primary key (numero, nom_hotel),
  constraint htls_nom_hotel_fk foreign key (nom_hotel) references hotels(nom_hotel) on delete cascade
);
--------------------
