drop table if exists pe2_employeesprojects;
drop table if exists pe2_projects;
drop table if exists pe2_employees;
drop table if exists pe2_cities;
drop sequence if exists seq_emp_id;
drop sequence if exists seq_project_id;

create table pe2_cities (
  zip_code varchar2(6),
  city_name varchar2(40),
  inhabitants number(12),
  area number(5, 2),
  constraint pk_zip_code primary key (zip_code),
  constraint uq_city_name unique (city_name)
);

create table pe2_employees (
  emp_id number,
  firstname varchar2(20) not null,
  lastname varchar2(20) not null,
  zip_code varchar2(6),
  age number(2),
  hired_date date default sysdate,
  fee number(5, 2),
  manager number,
  constraint pk_emp_id primary key (emp_id),
  constraint fn_not_empty_chk check (firstname != ''),
  constraint ln_not_empty_chk check (lastname != ''),
  constraint fk_zip_code foreign key (zip_code) references cities(zip_code),
  constraint lwr_age_chk check (age > 17),
  constraint upr_age_chk check (age < 68),
  constraint fk_manager foreign key (manager) references employees(emp_id)
);

create table pe2_projects (
  project_id number,
  project_desc varchar2(40) not null,
  budget number(5, 2) not null,
  constraint pk_project_id primary key (project_id),
  constraint project_desc_not_empty_chk check (project_desc != '')
);

create table pe2_employeesprojects (
  emp_id number,
  project_id number,
  assig_date date default sysdate,
  unassig_date date,
  constraint pk_emp_id_project_id primary key (emp_id, project_id),
  constraint fk_emp_id foreign key (emp_id) references pe2_employees(emp_id),
  constraint fk_project_id foreign key (project_id) references pe2_projects(project_id)
);

--  CREATE SEQUENCE sequence
--  INCREMENT by n
--  START with n
--  MAXVALUE n or NOMAXVALUE
--  MINVALUE n or NOMINVALUE

create sequence seq_emp_id start with 1 increment by 1;
create sequence seq_project_id start with 100 increment by 10 maxvalue 2100; -- 10 × 200 + 100 = 2100

insert into pe2_cities values ('08080', 'Barcelona', 1600000, 101.9);
insert into pe2_cities values ('08901', 'L’Hospitalet de Llobregat', 210000, 12.4);
insert into pe2_cities values ('08635', 'Sant Esteve Sesrovires', 5000, 18.6);

insert into pe2_employees values (seq_emp_id.nextval, 'Name1', 'Lastname1', '08080', 20, '', 10, NULL);
insert into pe2_employees values (seq_emp_id.nextval, 'Name2', 'Lastname2', '08901', 24, '', 25, (seq_emp_id.currval - 1));
insert into pe2_employees values (seq_emp_id.nextval, 'Name3', 'Lastname3', '08635', 56, '', 40, (seq_emp_id.currval + 1));
insert into pe2_employees values (seq_emp_id.nextval, 'Name4', 'Lastname4', '08901', 35, '', 60, 1);
