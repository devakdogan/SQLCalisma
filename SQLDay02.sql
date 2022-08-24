-- Personel isminde bir tablo olusturalim
create table personel(
pers_id int,
isim varchar(30),
sehir varchar(30),
maas int,
sirket varchar(20),
adres varchar(50)
);
-- Varolan personel tablosundan pers_id,sehir,adres fieldlarına sahip personel_adres adinda yeni bir tablo olusturalim.

create table personel_adres
as
select pers_id, sehir, adres from personel;

select * from personel;

-- DML --> Data Manipulation Language
-- INSERT - UPDATE - DELETE
-- Tabloya veri ekleme, tablodan veri guncelleme ve silme islemlerinde kullanilan komutlar
-- INSERT
create table student
(
id varchar(4),
st_name varchar(30),
age int
);
INSERT into student VALUES ('1001','Ali Can',25);
INSERT into student VALUES ('1002','Veli Can',35);
INSERT into student VALUES ('1003','Ayse Can',45);
INSERT into student VALUES ('1004','Derya Can',55);
-- Tabloya parcali veri ekleme
insert into student(st_name,age) values ('Murat Can',65);

-- DQL --> Data Query Language
-- SELECT
select * from student;
select st_name from student;
-- SELECT KOMUTU WHERE KOSULU
select * from student where age>35;

-- TCL - Transaction Control Language
-- Begin - Savepoint - Rollback - Commit
-- Transaction veritabani sistemlerinde bir islem basladiginda baslar ve islem bitince sona erer.
-- Bu islemler veri tabani olusturma, veri silme, veri guncelleme, veriyi geri getirme gibi islemler olabilir.

CREATE TABLE ogrenciler2
(
id serial,
isim VARCHAR(50),
veli_isim VARCHAR(50),
yazili_notu real
);
Begin;
insert into ogrenciler2 VALUES (default,'Ali Can','Hasan Can',75.5);
insert into ogrenciler2 VALUES (default,'Canan Gül','Ayşe Şen',90.5);
SAVEPOINT x;
insert into ogrenciler2 VALUES (default,'Kemal Can','Ahmet Can',85.5);
insert into ogrenciler2 VALUES (default,'Ahmet Şen','Ayşe Can',65.5);

rollback to x;

select * from ogrenciler2;

commit;
/*
* Transaction kullaniminda SERIAL data turu kullanimi tavsiye edilmez.
* Savepoint'ten sonra ekledigimiz veride sayac mantigi ile calistigi icin sayacta en son hangi sayida kaldiysa oradan devam eder.
NOT : PostgreSQL'de transaction kullanimi icin "begin;" komutuyla baslariz, sonrasinda tekrar yanlis bir veriyi duzeltmek
veya bizim icin onemli olan verilerden sonra ekleme yapabilmek icin "Savepoint savepointadi;" komutunu kullaniriz. Herhangi bir
sekilde savepointe donmemiz gerekirse "Rollback to savepointadi;" komutunu kullaniriz.
* "Rollback;" komutu kullanildiginda savepoint olusturulan noktadan sonraki degisiklikleri tablomuzdan siler ve olusturulmadan onceki
tabloya bizi geri dondurur.
* Transaction'i sonlandirmak icin mutlaka "Commit;" komutu kullaniriz. MySQL'de transaction olmadan da kullanilir.
*/

--DML - DELETE
-- DELETE FROM tablo_adi --> Tablonun tum icerigini siler.
-- Veriyi secerek silmek icin WHERE kosulu kullanilir.
-- DELETE FROM tablo_adi WHERE sutun_adi = veri --> Tablodaki istedigimiz veriyi siler.

CREATE TABLE ogrenciler
(
id int,
isim VARCHAR(50),
veli_isim VARCHAR(50),
yazili_notu int
);
INSERT INTO ogrenciler VALUES(123, 'Ali Can', 'Hasan',75);
INSERT INTO ogrenciler VALUES(124, 'Merve Gul', 'Ayse',85);
INSERT INTO ogrenciler VALUES(125, 'Kemal Yasa', 'Hasan',85);
INSERT INTO ogrenciler VALUES(126, 'Nesibe Yilmaz', 'Ayse',95);
INSERT INTO ogrenciler VALUES(127, 'Mustafa Bak', 'Can',99);
INSERT INTO ogrenciler VALUES(127, 'Mustafa Bak', 'Ali', 99);

select * from ogrenciler;

-- Soru : ID'si 124 olan ogrenciyi siliniz.

DELETE FROM ogrenciler WHERE id = 124;

-- Soru : ismi Kemal Yasa olan satiri siliniz
DELETE FROM ogrenciler WHERE isim = 'Kemal Yasa';

-- Soru : ismi Ali Can ve ID'si 123 olan kaydi siliniz.


-- Soru : ismi Nesibe Yilmaz veya Mustafa Bak olan kayitlari silelim
DELETE FROM ogrenciler WHERE isim = 'Nesibe Yilmaz' Or isim= 'Mustafa Bak';

-- Soru : ismi Ali Can ve ID'si 123 olan kaydi siliniz
delete from ogrenciler where isim='Ali Can' or id=123;

-- Tablodaki tum verileri silelim
Delete from ogrenciler;

-- DELETE - TRUNCATE --
-- TRUNCATE komutu DELETE komutu gibi bir tablodaki verilerin tamamini siler.
-- Ancak secmeli silme yapamaz.
select * from ogrenciler;
TRUNCATE TABLE ogrenciler;

-- DDL - Data Definition Language
-- CREATE - ALTER - DROP
-- ALTER TABLE --
-- ALTER TABLE tabloda ADD, TYPE, SET, RENAME veya DROP COLUMNS islemleri icin kullanilir.
select * from isciler;
-- Personel tablosuna cinsiyet varchar(20) ve yas int seklinde yeni sütunlar ekleyiniz.
alter table personel add cinsiyet varchar(20),add yas int;

-- Personel tablosundan sirket field'ini siliniz.
alter table personel drop column sirket;

-- Personel tablosundaki sehir sütununun adini ulke olarak degistirelim.
alter table personel rename column sehir to ulke;

-- Personel tablosunun adini isciler olarak degistiriniz.
alter table personel rename to isciler;

-- DDL - DROP komutu
DROP table isciler;

-- CONSTRAINT -- Kısıtlamalar
-- PRIMARY KEY --> Bir sütunun NULL icermemesini ve sutundaki verilerin BENZERSIZ olmasini saglar.(NOT NULL - UNIQUE)
-- FOREIGN KEY --> Baska bir tablodaki PRIMARY KEY'i referans gostermek icin kullanilir. Boylelikle tablolar arasinda iliski kurmus oluruz.
-- UNIQUE --> Bir sutundaki tum degerlerin BENZERSIZ yani tek olmasini saglar.
-- NOT NULL --> Bir sutunun NULL icermemesini yani bos olmamasini saglar. NOT NULL kisitlamasi icin CONSTRAINT ismi tanimlanmaz. Bu kisitlama veri turunden hemen sonra yerlestirilir.
-- CHECK --> Bir sutuna yerlestirilebilecek deger araligini sinirlamak icin kullanilir.

CREATE TABLE calisanlar(
id CHAR(5) PRIMARY KEY, -- not null + unique
isim VARCHAR(50) UNIQUE, -- UNIQUE --> Bir sutundaki tum degerlerin BENZERSIZ yani tek olmasini saglar.
maas int NOT NULL, -- NOT NULL --> Bir sutunun NULL icermemesini yani bos olmamasini saglar. NOT NULL kisitlamasi icin CONSTRAINT ismi tanimlanmaz. Bu kisitlama veri turunden hemen sonra yerlestirilir.
ise_baslama DATE
);

INSERT INTO calisanlar VALUES('10002', 'Mehmet Yılmaz' ,12000, '2018-04-14');
INSERT INTO calisanlar VALUES('10008', null, 5000, '2018-04-14');
--INSERT INTO calisanlar VALUES('10010', Mehmet Yılmaz, 5000, '2018-04-14'); --Unique
INSERT INTO calisanlar VALUES('10004', 'Veli Han', 5000, '2018-04-14');
INSERT INTO calisanlar VALUES('10005', 'Mustafa Ali', 5000, '2018-04-14');
--INSERT INTO calisanlar VALUES('10006', 'Canan Yaş', NULL, '2019-04-12'); --NOT NULL
INSERT INTO calisanlar VALUES('10003', 'CAN', 5000, '2018-04-14');
--INSERT INTO calisanlar VALUES('10007', 'CAN', 5000, '2018-04-14'); --UNIQUE
--INSERT INTO calisanlar VALUES('10009', 'cem', '', '2018-04-14'); --NOT NULL
INSERT INTO calisanlar VALUES('', 'osman', 2000, '2018-04-14');
--INSERT INTO calisanlar VALUES('', 'osman can', 2000, '2018-04-14'); --PRIMARY KEY
--INSERT INTO calisanlar VALUES( '10002', 'ayse Yılmaz' ,12000, '2018-04-14'); --PRIMARY KEY
--INSERT INTO calisanlar VALUES( null, 'filiz ' ,12000, '2018-04-14'); -- PRIMARY KEY

select * from calisanlar;