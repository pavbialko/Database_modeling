------------Paweł Biełko nr:473601------------

SET LANGUAGE polski;
GO

------------USUWANIE TABELI(DELETE TABLES)------------

DROP TABLE IF EXISTS Sprzedaz
DROP TABLE IF EXISTS Specjalizacja_dealera
DROP TABLE IF EXISTS Posiadanie_ddtk_wpsz
DROP TABLE IF EXISTS Dodatkowe_wyposazenie
DROP TABLE IF EXISTS Samochod_ciezarowy
DROP TABLE IF EXISTS Samochod_osobowy
DROP TABLE IF EXISTS Samochod
DROP TABLE IF EXISTS Typ_silnika_dla_modeli
DROP TABLE IF EXISTS Model
DROP TABLE IF EXISTS Dealer
DROP TABLE IF EXISTS Klient
DROP TABLE IF EXISTS Marka
DROP TABLE IF EXISTS Typ_silnika

------------TWORZENIE TABELI(CREATE NEW TABLES)------------

CREATE TABLE Marka
(
    nazwa						CHAR(50) NOT NULL CONSTRAINT pk_marka_nazwa PRIMARY KEY,
    rok_założenia				DATE
);

CREATE TABLE Model
(
    id							INT CONSTRAINT pk_model_id PRIMARY KEY(id),
	nazwa						VARCHAR(100),
	rok_wprowadzania_na_rynek	DATE,
	Marka_nazwa					CHAR(50) CONSTRAINT fg_Model_marka_nazwa NOT NULL REFERENCES Marka(nazwa),
	Model_id_poprzednik		    INT CONSTRAINT fg_Model_model_id REFERENCES Model(id) NULL
);

CREATE UNIQUE INDEX 
    idx_Model_id_poprzednik ON Model 
    ( 
     Model_id_poprzednik 
    ) 
WHERE Model_id_poprzednik IS NOT NULL;

CREATE TABLE Samochod_osobowy
(
   Model_id						INT CONSTRAINT fg_Samochod_osobowy_model_nazwa NOT NULL REFERENCES Model(id),
   liczba_pasażerów				INT, 
   pojemność_bagażnuka			INT,
   CONSTRAINT pk_Samochod_osobowy PRIMARY KEY(Model_id)
);

CREATE TABLE Samochod_ciezarowy
(
   Model_id						INT CONSTRAINT fg_Samochod_ciezarowy_model_nazwa NOT NULL REFERENCES Model(id),
   Ładowność					INT,
   CONSTRAINT pk_Samochod_ciezarowy PRIMARY KEY(Model_id)
);

CREATE TABLE Typ_silnika
(
    id							INT CONSTRAINT pk_typ_silnika_id PRIMARY KEY(id),
	rodzaj_paliwa				VARCHAR(3) CONSTRAINT ck_rodzaj_paliwa CHECK (rodzaj_paliwa IN ('Pb','ON','LPG','CNG')),
	opis_parametrow				VARCHAR(100)
);

CREATE TABLE Typ_silnika_dla_modeli
(
    Model_id					INTEGER CONSTRAINT Typ_śilnika_dla_modelu_Model_FK REFERENCES Model(id), 
    Typ_silnika_id				INTEGER CONSTRAINT Typ_śilnika_dla_modelu_Typ_śilnika_FK NOT NULL REFERENCES Typ_silnika(id),
    CONSTRAINT pk_Typ_silnika_dla_modeli PRIMARY KEY (Model_id, Typ_silnika_id)
);

CREATE TABLE Dealer
(
    nazwa						CHAR(50) CONSTRAINT pk_dealer_nazwa PRIMARY KEY(nazwa),
	adres						VARCHAR(50)
);

CREATE TABLE Specjalizacja_dealera
(
    Dealer_nazwa				CHAR(50) CONSTRAINT fg_Specjalizacja_dealera_dealer_nazwa REFERENCES Dealer(nazwa),
	Model_id					INT CONSTRAINT fg_Specjalizacja_dealera_model_id REFERENCES Model(id),
	CONSTRAINT pk_Specjalizacja_dealera PRIMARY KEY(Dealer_nazwa,Model_id)
);

CREATE TABLE Samochod
(
    vin							CHAR(17) CONSTRAINT pk_samochod_vin PRIMARY KEY NOT NULL,
	przebieg					INT,
	skrzynia_biegow				VARCHAR(30),
	kraj_pochodzenia			VARCHAR(60),
	rok_produkcji				DATE,
	Model_id					INT CONSTRAINT fg_Samochod_model_id  NOT NULL REFERENCES Model(id),
	Typ_silnika_id				INT CONSTRAINT fg_Samochod_typ_silnika_id  NOT NULL REFERENCES Typ_silnika(id),
	Dealer_nazwa				CHAR(50) CONSTRAINT fg_Samochod_dealer_nazwa REFERENCES Dealer(nazwa)
);

CREATE TABLE Dodatkowe_wyposazenie
(
    nazwa						CHAR(100) CONSTRAINT pk_dodatkowe_wyposazenie_nazwa PRIMARY KEY
);

CREATE TABLE Posiadanie_ddtk_wpsz
(
    Samochod_vin				CHAR(17) CONSTRAINT fg_Posiadanie_ddtk_wpsz_Samochod_vin REFERENCES Samochod(vin),
	Dodatkowe_wyposazenie_nazwa CHAR(100) CONSTRAINT fg_Posiadanie_ddtk_wpsz_Dodatkowe_wyposazenie_nazwa REFERENCES Dodatkowe_wyposazenie(nazwa),
	CONSTRAINT pk_Posiadanie_ddtk_wpsz PRIMARY KEY(Samochod_vin,Dodatkowe_wyposazenie_nazwa)
);

CREATE TABLE Klient
(
    id							INT IDENTITY(1, 1) CONSTRAINT pk_klient_id PRIMARY KEY, 
    imię						VARCHAR (30), 
    nazwisko					VARCHAR (30),  
    numer_telefonu				VARCHAR (12)
);

CREATE TABLE Sprzedaz
(
    Samochód_vin				CHAR(17) CONSTRAINT fg_Sprzedaz_Samochod_vin REFERENCES Samochod(vin),
	Dealer_nazwa				CHAR(50) CONSTRAINT fg_Sprzedaz_Dealer_nazwa REFERENCES Dealer(nazwa),
	Klient_id					INT CONSTRAINT fg_Sprzedaz_Klient_id REFERENCES Klient(id),
	[data]						DATE,
	cena						INT,
	CONSTRAINT pk_Sprzedaz PRIMARY KEY(Samochód_vin,Dealer_nazwa,Klient_id,[data])
);

------------WSTAWENIE DANYCH DO TABELI(INSERT DATA INTO TABLES)------------

INSERT INTO Marka VALUES
('Mercedes', '2015-01-01'),
('Mazda', '2002-01-01'),
('Honda', '2021-01-01'),
('BMW', '2009-01-01'),
('Volkswagen', '2013-01-01')

INSERT INTO Model VALUES
(1,'Mercedes-Benz S-Class', '1972-01-01', 'Mercedes', NULL),
(2,'Mercedes-Benz C-Class', '1997-01-01', 'Mercedes', 1),
(3,'Mercedes-Benz A-Class', '2005-01-01', 'Mercedes', 2),
(4,'MAZDA2', '2002-01-01', 'Mazda', NULL),
(5,'MAZDA2 HYBRID', '2021-01-01', 'Mazda', 4),
(6,'ACCORD/INSPIRE', '1976-01-01', 'Honda', NULL),
(7,'ENVIX', '2018-01-01', 'Honda', NULL),
(8,'3 Series', '1975-01-01', 'BMW', NULL),
(9,'4 Series', '2014-01-01', 'BMW', 8 ),
(10,'8 Series', '2014-01-01', 'BMW', 9),
(11,'Mercedes', '1996-01-01', 'Mercedes', NULL)

INSERT INTO Samochod_osobowy VALUES
(1, 4, 550),
(2, 5, 455),
(3, 4, 341),
(4, 5, 250),
(5, 4, 286),
(6, 4, 510),
(7, 5, 520),
(8, 5, 480),
(9, 4, 480 ),
(10, 2, 440 );

INSERT INTO Samochod_ciezarowy VALUES
(11,18);

INSERT INTO Typ_silnika VALUES
(1,'Pb', '110kW'),
(2,'Pb', '150kW'),
(3,'Pb', '220kW'),
(4,'ON', '180kW'),
(5,'ON', '230kW'),
(6,'LPG', '80kW'),
(7,'LPG', '95kW'),
(8,'CNG', '165kW');

INSERT INTO Typ_silnika_dla_modeli VALUES
(1, 8),
(2, 3),
(3, 6),
(4, 5),
(5, 4),
(6, 5),
(7, 2),
(8, 1),
(9, 5),
(10, 5),
(11, 5);

INSERT INTO Dealer VALUES
('BMW Motorrad Inchcape', 'Aleja Prymasa Tysiąclecia 64'),
('Mercedes-Benz Voyager Group', 'Świętego Michała 20'),
('Mazda Bednarscy', 'Poznańska 14/16'),
('Honda Karlik Malta', 'Baraniaka 4');

INSERT INTO Specjalizacja_dealera VALUES
('BMW Motorrad Inchcape', 10),
('BMW Motorrad Inchcape', 9),
('BMW Motorrad Inchcape', 8),
('Mercedes-Benz Voyager Group', 1),
('Mercedes-Benz Voyager Group', 2),
('Mercedes-Benz Voyager Group', 3),
('Mercedes-Benz Voyager Group', 11),
('Mazda Bednarscy', 4),
('Mazda Bednarscy', 5),
('Honda Karlik Malta', 6),
('Honda Karlik Malta',7);

INSERT INTO Samochod VALUES
('4T1BE32K25U430473', '12000', 'manualna', 'Niemcy', '2020-01-01', 1, 8, 'Mercedes-Benz Voyager Group'),
('5NMSG73D58H106953', '33000', 'półautomatyczna', 'Niemcy', '2021-01-01', 2, 3, 'Mercedes-Benz Voyager Group'),
('JNKCV51F96M600255', '65000', 'automatyczna', 'Niemcy', '2020-01-01', 10, 5, 'BMW Motorrad Inchcape'),
('19XFA1F52AE026236', '10000', 'automatyczna', 'USA', '2018-01-01', 8, 1, 'BMW Motorrad Inchcape'),
('1GNSCJE01ER280651', '12000', 'automatyczna', 'USA', '2019-01-01', 4, 5, 'Mazda Bednarscy'),
('1GBHG31V571138779', '600', 'automatyczna', 'Anglia', '2020-01-01', 6, 5, 'Honda Karlik Malta')

INSERT INTO Dodatkowe_wyposazenie VALUES
('Asystent pasa'),
('Asystent parkowania'),
('Czujnik i kamera cofania'),
('Tempomat i limit');

INSERT INTO Posiadanie_ddtk_wpsz VALUES
('4T1BE32K25U430473', 'Asystent pasa'),
('5NMSG73D58H106953', 'Asystent parkowania'),
('JNKCV51F96M600255', 'Czujnik i kamera cofania'),
('JNKCV51F96M600255', 'Tempomat i limit'),
('19XFA1F52AE026236', 'Asystent parkowania'),
('19XFA1F52AE026236', 'Tempomat i limit');

INSERT INTO Klient VALUES
('Mateusz', 'Morawiecki', '63061179939'),
('Michał', 'Pilipczuk', '93081618231'),
('Marcin', 'Jukiewicz', '05320845986'),
('Maciej ', 'Wieczorek', '57121731564'),
('Andrej ', 'Nosko', '92051266724');

INSERT INTO Sprzedaz VALUES
('4T1BE32K25U430473', 'Mercedes-Benz Voyager Group', 1, '2021-05-11', 100000),
('5NMSG73D58H106953', 'Mercedes-Benz Voyager Group', 2, '2021-08-15', 150000),
('JNKCV51F96M600255', 'BMW Motorrad Inchcape', 1, '2022-01-16', 20000),
('19XFA1F52AE026236', 'BMW Motorrad Inchcape', 5,  '2022-03-05', 80000),
('4T1BE32K25U430473', 'Mercedes-Benz Voyager Group', 3, '2022-02-22', 60000);

------------WYŚWIETLENIE TABELI(DISPLAY DATA FROM TABLES)------------

SELECT * FROM Marka
SELECT * FROM Model
SELECT * FROM Samochod_osobowy
SELECT * FROM Samochod_ciezarowy
SELECT * FROM Typ_silnika
SELECT * FROM Typ_silnika_dla_modeli
SELECT * FROM Dealer
SELECT * FROM Specjalizacja_dealera
SELECT * FROM Samochod
SELECT * FROM Dodatkowe_wyposazenie
SELECT * FROM Posiadanie_ddtk_wpsz
SELECT * FROM Klient
SELECT * FROM Sprzedaz