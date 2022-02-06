--   DROP TABLES   --
drop table compres;
drop table registres;
drop table transportadors;
drop table clients;
drop table forfaits;
drop table habitacions;
drop table hotels;
drop table zones;

--  CREATE TABLES  --
---------------------
create table zones (
  id_zona number(3),
  nom varchar2(15),
  constraint id_zona_pk primary key (id_zona)
);

create table hotels (
  nom_hotel varchar2(20),
  num_habitacions number(3),
  id_zona number(3),
  constraint nom_hotel_pk primary key (nom_hotel),
  constraint zones_id_zona_fk foreign key (id_zona) references zones(id_zona) on delete cascade
);

create table habitacions (
  nom_hotel varchar2(20),
  numero number(3),
  planta number(5),
  constraint nom_hotel_num_hab_pk primary key (numero, nom_hotel),
  constraint htls_nom_hotel_fk foreign key (nom_hotel) references hotels(nom_hotel) on delete cascade
);
---------------------
create table forfaits (
  codi varchar2(10),
  inici_valid date default sysdate,
  fi_valid date,
  nPers number(2) default 1,
  tipus varchar2(10) default 'diari',
  dte_Bar number(2) default 0,
  dte_Rest number(2) default 0,
  dte_Llog number(2) default 0,
  constraint codi_pk primary key (codi),
  constraint date_is_valid_chk check (inici_valid <= fi_valid),
  constraint dte_Bar_is_okay_chk check (dte_Bar < 41),
  constraint dte_Rest_is_okay_chk check (dte_Rest < 41),
  constraint dte_Llog_is_okay_chk check (dte_Llog < 41),
);

create table clients (
  targ_paga number(16),
  nom varchar2(20),
  congnom varchar2(20),
  constraint targ_paga_pk primary key (targ_paga)
);
---------------------
create table transportadors (
  id_tp number(5),
  id_zona number(3),
  nom varchar2(10),
  tipus varchar2(10),
  long number(4),
  constraint id_tp_pk primary key (id_tp)
);
---------------------
-- RELATION TABLES --
---------------------
create table registres (
  codi varchar2(10),
  nom_hotel varchar2(20),
  num number(3),
  chckin_date date default sysdate,
  chckout_date date,
  constraint codi_hotel_num_pk primary key (codi, hotel, num),
  constraint ff_codi_fk foreign key forfaits(codi),
  constraint htls_nom_hotel_fk foreign key hotels(nom_hotel)
);

create table compres (
  targ_paga number(16),
  codi varchar2(10),
  qtt_EUR number(4),
  data date default sysdate,
  constraint targ_codi_pk primary key (targ_paga, codi),
  constraint ff_codi_fk foreign key forfaits(codi),
);
