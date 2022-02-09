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
  id number(3),
  nom varchar2(15),
  constraint id_zona_pk primary key (id)
);

create table hotels (
  id number(3),
  nom_hotel varchar2(20),
  num_habitacions number(3),
  id_zona number(3),
  constraint id_hotels_pk primary key (id),
  constraint zones_id_zona_fk foreign key (id_zona) references zones(id) on delete cascade
);

create table habitacions (
  hotel_id number(3),
  id number(3),
  planta number(5),
  constraint nom_hotel_num_hab_pk primary key (id, hotel_id),
  constraint htls_nom_hotel_fk foreign key (hotel_id) references hotels(id) on delete cascade
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
  constraint dte_Llog_is_okay_chk check (dte_Llog < 41)
);

create table clients (
  tgt_paga number(16),
  nom varchar2(20),
  congnom varchar2(20),
  constraint targ_paga_pk primary key (targ_paga)
);
---------------------
create table transportadors (
  id number(2),
  id_zona number(3),
  nom varchar2(10),
  tipus varchar2(10),
  longitud number(4),
  constraint id_tp_pk primary key (id),
  constraint zones_id_zona_tp_fk foreign key (id_zona) references zones(id)
);
---------------------
-- RELATION TABLES --
---------------------
create table registres (
  codi_forfait varchar2(10),
  id_hotel number(20),
  id_habitacio number(3),
  chckin_date date default sysdate,
  chckout_date date,
  constraint registres_pk primary key (codi_forfait, id_hotel, id_habitacio),
  -- constraint htls_id_hotel_reg_fk foreign key (id_hotel) references hotels(id),
  constraint ff_codi_reg_fk foreign key (codi_forfait) references forfaits(codi),
  constraint hbtc_id_num_fk foreign key (id_habitacio, id_hotel) references habitacions(id, hotel_id)
);

create table compres (
  tgt_paga number(16),
  codi varchar2(10),
  qtt_EUR number(4),
  data date default sysdate,
  constraint targ_codi_pk primary key (targ_paga, codi),
  constraint ff_codi_compra_fk foreign key (codi) references forfaits(codi),
  constraint clnts_targ_paga_fk foreign key (targ_paga) references clients(targ_paga)
);

create table viatge (
  codi_forfait varchar2(10),
  id_tp number(3),
  data date,
  hora int(4),
  constraint viatge_pk primary key (codi_forfait, id_tp),
  constraint ttd_vtg_id_fk foreign key transportadors(id),
  constraint ff_codi_vtg_fk foreign key forfaits(codi)
);

---------------------
--   DATA INSERT   --
---------------------
