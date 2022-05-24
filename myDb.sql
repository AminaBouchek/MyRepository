# changer le user 
sudo su postges

#se connecter a postgres
psql

#create role with superuser, login
create role lab_role with superuser password 'lab_passowrd'
alter role lab_role login

#create database owned by lab_role
create data base lab_db owner lab_role

#connect to lab_db as lab_role 
 psql -d lab_db -U lab_role

#create new schema
create schema lab_schema 
alter schema lab owner to lab_role
#switch to new schema
set search_path to lab_schema

#create tables in lab_schema
create table lab_schema.speciality (id_sp bigserial not null primary key, name_sp varchar(50));

create table lab_schema.intern (id_intern bigserial not null primary key, name_intern varchar(50),id_sp int ,
 constraint fk_speciality foreign key (id_sp) REFERENCES lab_schema.speciality(id_sp));

create table lab_schema.cours (id_cours bigserial not null primary key, name_cours varchar(50));

#table relation cours/speciality
create table lab_schema.relation (id_cours int, id_spec int, primary key (id_cours, id_spec),
 foreign key (id_cours) references lab_schema.cours(id_cours), foreign key (id_spec) REFERENCES lab_schema.speciality(id_sp));

#insert
insert into speciality (name_sp) values ('BDD');
insert into speciality (name_sp) values ('GRH');
insert into speciality (name_sp) values ('Dev');
insert into speciality (name_sp) values ('Commerce');

insert into cours (name_cours) values ('Maths');
insert into cours (name_cours) values ('Java');
insert into cours (name_cours) values ('T-SQL');
insert into cours (name_cours) values ('Comptabilité');
insert into cours (name_cours) values ('Marketing');

insert into intern (name_intern, id_sp) values ('Margaux', 1);
insert into intern (name_intern, id_sp) values ('Natasha', 2);
insert into intern (name_intern, id_sp) values ('Mechelle', 3);
insert into intern (name_intern, id_sp) values ('Maxie', 4);
insert into intern (name_intern, id_sp) values ('Gwen', 1);
insert into intern (name_intern, id_sp) values ('Orin', 4);
insert into intern (name_intern, id_sp) values ('Tanny', 3);
insert into intern (name_intern, id_sp) values ('Rhodie', 3);
insert into intern (name_intern, id_sp) values ('Phyllys', 3);
insert into intern (name_intern, id_sp) values ('Fairlie', 1);
insert into intern (name_intern, id_sp) values ('Benetta', 1);
insert into intern (name_intern, id_sp) values ('Ashley', 2);
insert into intern (name_intern, id_sp) values ('Charyl', 3);
insert into intern (name_intern, id_sp) values ('Ermin', 4);
insert into intern (name_intern, id_sp) values ('Otto', 1);
insert into intern (name_intern, id_sp) values ('Yelena', 1);
insert into intern (name_intern, id_sp) values ('Merrick', 1);
insert into intern (name_intern, id_sp) values ('Culver', 1);
insert into intern (name_intern, id_sp) values ('Tedi', 1);
insert into intern (name_intern, id_sp) values ('Darrel', 2);
insert into intern (name_intern, id_sp) values ('Con', 1);
insert into intern (name_intern, id_sp) values ('Vinson', 2);
insert into intern (name_intern, id_sp) values ('Hollie', 3);
insert into intern (name_intern, id_sp) values ('Skipper', 4);
insert into intern (name_intern, id_sp) values ('Theo', 2);
insert into intern (name_intern, id_sp) values ('Kev', 2);
insert into intern (name_intern, id_sp) values ('Courtnay', 2);
insert into intern (name_intern, id_sp) values ('Ximenez', 4);
insert into intern (name_intern, id_sp) values ('Stavros', 2);
insert into intern (name_intern, id_sp) values ('Carmelita', 1);

insert into relation (id_cours , id_spec) values (3,1);
insert into relation (id_cours , id_spec) values (1,1);
insert into relation (id_cours , id_spec) values (1,2);
insert into relation (id_cours , id_spec) values (1,4);
insert into relation (id_cours , id_spec) values (2,1);
insert into relation (id_cours , id_spec) values (2,3);
insert into relation (id_cours , id_spec) values (3,1);
insert into relation (id_cours , id_spec) values (4,2);
insert into relation (id_cours , id_spec) values (4,4);
insert into relation (id_cours , id_spec) values (5,4);

### Afficher le nombre de stagiaires dans chaque spécialité 
select count(id_intern), name_sp from intern, speciality where intern.id_sp = speciality.id_sp  group by name_sp;

### Afficher le nombre de stagiaires par cour 
select count(id_intern), name_cours from intern, relation, cours where intern.id_sp = relation.id_spec and cours.id_cours = relation.id_cours   group by name_cours;

### Afficher le cour qui est suivi par le plus de stagiaire 
with tmp as(select cs.name_cours, count(*) folow from cours cs inner join relation rl on rl.id_cours = cs.id_cours 
inner join speciality sp on sp.id_sp = rl.id_spec inner join intern ins on ins.id_sp = sp.id_sp group by cs.name_cours) 
select * from tmp where tmp.folow = (select max(folow) from tmp );


### le nbr de cours par speciality
select count(*) nb_cour, id_spec from relation group by id_spec order by nb_cour

### le cours ensegné dans plus de 2 speciality
with req as (select count(*) nb_cour, id_cours from relation group by id_cours)
select * from req where req.nb_cour > 2;

### ou
select * from (select count(*) nb_cour, id_cours from relation 
group by id_cours)req where req.nb_cour > 2;

## ou
select count(*) nb_cour from relation 
group by id_cours having count(*) >2

### le nbr des intern par cours 
select count(id_intern) nb_int, name_cours from intern inner join speciality sp  on sp.id_sp = intern.id_sp 
inner join relation rl on rl.id_spec = sp.id_sp inner join cours cs on cs.id_cours = rl.id_cours
group by  cs.name_cours

### nbr de speciality ayant plus de 2 cours 
select count (id_spec) from (select count(*) nb_cour, id_spec from relation group by id_spec
having count(*) >2)req;


## le nbr de speciality enseignat le meme cour
select count(id_spec)  from relation group by id_cours having count(id_spec)>2;


## Afficher le nombre moyen des stagiaires suivant un cour enseigné dans plus de deux spécialités  
select (
        select count(*) nb_stg 
        from    intern 
                inner join speciality sp  on sp.id_sp = intern.id_sp 
                inner join relation rl on rl.id_spec = sp.id_sp 
                inner join cours cs on cs.id_cours = rl.id_cours
        where cs.id_cours = (
                                select id_cours 
                                from (
                                        select count(*) nb_cour , relation.id_cours 
                                        from relation 
                                        group by id_cours 
                                        having count(*) >2)req) 
        group by  cs.name_cours) / (
                                        select count(id_spec)  
                                        from relation 
                                        group by id_cours 
                                        having count(id_spec)>2
                                        )req;

 ### better query
select avg(nbr) as my_result from
 (SELECT sp.id_sp, count(*)nbr FROM (select cr.name_cours, cr.id_cours , count(*) nbr 
 from cours cr inner join relation rl on rl.id_cours = cr.id_cours group by cr.name_cours, cr.id_cours 
 having count(*) >2) rel inner join relation rl on rl.id_cours = rel.id_cours 
 inner join speciality sp on sp.id_sp = rl.id_spec
 inner join intern nt on nt.id_sp = sp.id_sp group by sp.id_sp)req;


### les speciality with +2 cours
select count(*) nb_cour, id_spec from relation
group by id_spec having count(*) > 2

## Afficher le nombre de cours des spécialités ayant plus de 2 cours 
select sum(nb_cour) from (select count(*) nb_cour, id_spec from relation
group by id_spec having count(*) > 2)requ 

### les speciality with += 6 intern
select count(*), id_sp from intern group by id_sp having count(*) >= 6;

## Afficher le nombre de cours des spécialités ayant plus de 6 stagiaires et plus de 2 cours enseignés 
select count(distinct name_cours) from cours , relation
where id_spec in (select id_spec from (select count(*) from relation 
group by id_spec having count(*) > 2)req1) 
and id_spec in (select id_sp from (select count(*), id_sp from intern
group by id_sp having count(*) >= 6)req2);

### Afficher les cours des spécialités ayant plus de 6 stagiaires et plus de 2 cours enseignés 
select distinct name_cours from cours , relation
where id_spec in (select id_spec from (select count(*) from relation 
group by id_spec having count(*) > 2)req1) 
and id_spec in (select id_sp from (select count(*), id_sp from intern
group by id_sp having count(*) >= 6)req2);



"""with name_query as <<< cte common tablke expression"""
"""(select id_sp from (select count(*) from intern group by id_sp having count(*) >= 6)req2)<<< sub_query