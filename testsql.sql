use record_company;
drop table if exists albums;
drop table if exists bands;
create table bands(
    id int not null AUTO_INCREMENT,
    name varchar(255) not null,
    primary key (id)
);
create table albums(
    id int not null auto_increment,
    name varchar(255) not null,
    release_year int,
    band_id int not null,
    primary key (id),
    foreign key (band_id) references bands(id)
);


insert into bands (name) 
values ('Iron Maiden'), ('Deuce'), ('Avenged Sevenfold'), ("Ankor");

select * from bands;
select * from bands order by id limit 2;

insert into albums (name, release_year, band_id) VALUES
('The number of the beasts', 1985, 1), ('Power slave', 1984, 1),
("Nightmare", 2018, 2),
("Nightmare", 2010, 3),
('Test Album', NULL, 3);

select * from albums;

select distinct name from albums;

update albums set release_year = 1982 where id = 1;
select * from albums;

-- wildcards
select * from albums where LOWER(name) like "%er%";
select * from albums where release_year between 2000 and 2018;
select * from albums where release_year is null;
delete from albums where id=5;
select * from albums;

select * from bands, albums where bands.id = albums.band_id;
select * from bands left join albums on bands.id = albums.band_id;
select * from albums right join bands on bands.id = albums.band_id;

--JOINS:
--inner join: requires attribute on both sides
--left join: only requires attribute on the left side
--right join: only requires attribute on the right side

-- REPLACE(string, old_string, new_string)
-- string = 'fm'

-- row01 = 'f'. So, sex = 'f'. We'll now find 'f' in 'fm' and will replace it with ''. So, the result is 'm'.
-- row02 = 'm'. So, sex = 'm'. We'll now find 'm' in 'fm' and will replace it with ''. So, the result is 'f'.

select band_id, count(band_id) from albums group by band_id;

select b.name as band_name, count(a.id) as num_albums 
from bands as b
left join albums as a on b.id = a.band_id
group by band_id;

select * from bands left join albums on bands.id = albums.band_id;

select b.name as band_name, count(a.id) as num_albums 
from bands as b
left join albums as a on b.id = a.band_id
where b.name = 'Deuce'
group by band_id
having num_albums = 1;