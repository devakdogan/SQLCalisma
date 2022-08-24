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


-- FOREIGN KEY --
CREATE TABLE adresler (
adres_id char(5),
sokak varchar(20),	
cadde varchar(30),					 
sehir varchar(20),					 
CONSTRAINT id_fk FOREIGN KEY (adres_id) REFERENCES calisanlar(id)
);

INSERT INTO adresler VALUES('10003','Mutlu Sok', '40.Cad.','IST');
INSERT INTO adresler VALUES('10003','Can Sok', '50.Cad.','Ankara');
INSERT INTO adresler VALUES('10002','Ağa Sok', '30.Cad.','Antep');

select * from adresler;

INSERT INTO adresler VALUES('10012','Ağa Sok', '30.Cad.','Antep');
-- Parent tabloda olmayan id ile child tabloya ekleme yapamayiz.

INSERT INTO adresler VALUES(NULL,'Ağa Sok', '30.Cad.','Antep');

-- Calisanlar id ile adresler tablosundaki adres_id ile eslesenlere bakmak icin
select * from calisanlar,adresler where calisanlar.id = adresler.adres_id;

DROP table calisanlar;
-- PARENT tabloyu yani PRIMARY KEY olan tabloyu silmek istedigimizde silemeyiz. Cunku once CHILD tablo silinmelidir.

delete from calisanlar where id='10002'; --Parent

delete from adresler where adres_id = '10002'; --Child

drop table calisanlar;

-- ON DELETE CASCADE --
-- Her defasinda once child tablodaki verileri silmek yerine ON DELETE CASCADE silme ozelligini aktif hale getirebiliriz.
-- Bunun icin FK olan satirin en sonuna ON DELETE CASCADE komutunu yazmamiz yeterli.

CREATE TABLE talebeler
(
id CHAR(3) primary key,
isim VARCHAR(50),
veli_isim VARCHAR(50),
yazili_notu int
);

INSERT INTO talebeler VALUES(123, 'Ali Can', 'Hasan',75);
INSERT INTO talebeler VALUES(124, 'Merve Gul', 'Ayse',85);
INSERT INTO talebeler VALUES(125, 'Kemal Yasa', 'Hasan',85);
INSERT INTO talebeler VALUES(126, 'Nesibe Yılmaz', 'Ayse',95);
INSERT INTO talebeler VALUES(127, 'Mustafa Bak', 'Can',99);

CREATE TABLE notlar(
talebe_id char(3),
ders_adi varchar(30),
yazili_notu int,
CONSTRAINT notlar_fk FOREIGN KEY (talebe_id) REFERENCES talebeler(id)
on delete cascade
);

INSERT INTO notlar VALUES ('123','kimya',75);
INSERT INTO notlar VALUES ('124', 'fizik',65);
INSERT INTO notlar VALUES ('125', 'tarih',90);
INSERT INTO notlar VALUES ('126', 'Matematik',90);

select * from talebeler;
select * from notlar;

delete from notlar where talebe_id='123';

delete from talebeler where id='126'; -- ON DELETE CASCADE kullandigimiz icin PARENT table'dan direkt silebildik. PARENT table'dan sildigimiz icin CHILD table'dan da silindi.
delete from talebeler;

Drop table talebeler cascade;-- PARENT tabloyu kaldirmak istersek DROP TABLE tablo_adi'ndan sonra CASCADE komutunu kullaniriz.

-- Talebeler tablosundaki isim sutununa NOT NULL kisitlamasi ekleyiniz ve veri tipini VARCHAR(30) olarak degistiriniz.
alter table talebeler
alter column isim TYPE varchar(30),
alter column isim SET NOT NULL;

-- Talebeler tablosundaki yazili_notu sutununa 60'dan buyuk rakam girilebilsin.
alter table talebeler
ADD CONSTRAINT sinir CHECK(yazili_notu>60);
-- CHECK kisitlamasi ile tablodaki istedigimiz sutunu sinirlandirabiliriz.

INSERT INTO talebeler VALUES(128, 'Mustafa Can', 'Hasan',45);-- Az once 60 sinirlamasi ekledigimiz icin bu girdiyi tabloya ekleyemedik.

create table ogrenciler(
id int,
isim varchar(45),
adres varchar(100),
sinav_notu int
);

Create table ogrenci_adres
AS
SELECT id, adres from ogrenciler;

select * from ogrenciler;
select * from ogrenci_adres;

-- Tablodaki bir sutuna PRIMARY KEY ekleme
alter table ogrenciler
ADD PRIMARY KEY(id);

-- PRIMARY KEY olusturmada 2.yol
alter table ogrenciler 
ADD CONSTRAINT pk_id PRIMARY KEY(id);

-- PK'den sonra FK atamasi
alter table ogrenci_adres
ADD foreign key(id) REFERENCES ogrenciler;
-- Child tabloyu parent tablodan olusturdugumuz icin sutun adi verilmedi.

-- PK'yi CONSTRAINT silme
alter table ogrenciler DROP CONSTRAINT pk_id;
-- FK'yi CONSTRAINT silme
alter table ogrenci_adres DROP CONSTRAINT ogrenci_adres_id_fkey;

-- Yazili notu 85'den buyuk talebe bilgilerini getirin.
SELECT * from talebeler where yazili_notu>85;

-- Ismi Mustafa Bak olan talebenin tum bilgilerini getirin.
select * from talebeler where isim='Mustafa Bak';

-- SELECT komutunda -- BETWEEN kosulu
-- Between belirttiginiz 2 veri arasindaki bilgileri listeler
-- Between'de belirttigimiz degerlerde listelemeye dahildir.

create table personel
(
id char(4),
isim varchar(50),
maas int
);

insert into personel values('1001', 'Ali Can', 70000);
insert into personel values('1002', 'Veli Mert', 85000);
insert into personel values('1003', 'Ayşe Tan', 65000);
insert into personel values('1004', 'Derya Soylu', 95000);
insert into personel values('1005', 'Yavuz Bal', 80000);
insert into personel values('1006', 'Sena Beyaz', 100000);

/*
   AND (VE): Belirtilen sartlarin her ikiside gerceklesiyorsa o kayit listelenir. Bir tanesi gerceklesmezse listelemez.
   Select * from matematik sinavi > 50 AND sinav2 > 50
Hem sinavi hem de sinav2 alani, 50'den buyuk olan kayitlari listeler.

	OR (VEYA): Belirtilen sartlardan biri gerceklesirse, kayit listelenir
    select * From matematik sinav>50 OR sinav2>50 
Hem sinavi veya sinav2 alani, 50 den büyük olan kayitlari listeler.
*/
select * from personel;

-- ID'si 1003 ile 1005 arasinda olan personel bilgisini listeleyiniz.
select * from personel where id between '1003' and '1005';

-- 2. Yol
select * from personel where id>='1003' and id <='1005';

-- Derya Soylu ile Yavuz Bal arasindaki personel bilgisini listeleyiniz
select * from personel where isim between 'Derya Soylu' and 'Yavuz Bal';

-- Maasi 70000 veya ismi Sena olan personeli listele
select * from personel where maas=70000 or isim='Sena Beyaz';

-- IN : Birden fazla mantıksal ifade ile tanımlayabileceğimiz durumları tek komutta yazabilme imkanı verir
-- Farklı sütunlar için IN kullanılamaz

-- ID'si 1001,1002 ve 1004 olan personelin bilgilerini listele
select * from personel where id='1001' or id='1002' or id='1004';

-- 2. Yol
select * from personel where id IN('1001','1002','1004');

-- Maaşı sadece 70000, 100000 olan personeli listele
select * from personel where maas IN(70000,100000);

/*
SELECT - LIKE kosulu
LIKE : Sorgulama yaparken belirli kalip ifadeleri kullanabilmemizi saglar
ILIKE : Sorgulama yaparken buyuk/kucuk harfe duyarsiz olarak eslestirir.
LIKE : ~~
ILIKE : ~~*
NOT LIKE : !~~
NOT ILIKE : !~~*

% --> 0 veya daha fazla karakteri belirtir.
_ --> Tek bir karakteri belirtir.
*/

-- Ismı A harfi ile baslayan personeli listele
select * from personel WHERE isim like 'A%';

-- Ismi t harfi ile biten personeli listele
select * from personel where isim like '%t';

-- Isminin 2.harfi e olan personeli listeleyiniz
select * from personel where isim like '_e%';