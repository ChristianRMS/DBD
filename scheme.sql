/*  <ABO971> mit eurer A-Nummer ersetzen! */
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ABO971.BESTELLUNGEN';
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE <> -942 THEN
    RAISE;
  END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ABO971.TEILE';
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE <> -942 THEN
    RAISE;
  END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ABO971.LIEFERANTEN';
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE <> -942 THEN
    RAISE;
  END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ABO971.KUNDEN';
EXCEPTION
WHEN OTHERS THEN
  IF SQLCODE <> -942 THEN
    RAISE;
  END IF;
END;
/
CREATE TABLE KUNDEN
  (
    KUNDENID   NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    VORNAME    VARCHAR2(20) NOT NULL,
    NACHNAME   VARCHAR2(20) NOT NULL,
    STRASSE    VARCHAR2(255) NOT NULL,
    HAUSNUMMER VARCHAR2(4) NOT NULL,
    PLZ        NUMBER(5) NOT NULL,
    EMAIL      VARCHAR2(255) NOT NULL,
    TELEFON    INTEGER
  );
CREATE TABLE LIEFERANTEN
  (
    LIEFERANTENID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    FIRMENNAME    VARCHAR2(255) NOT NULL,
    INHABER       VARCHAR2(255) NOT NULL,
    STRASSE       VARCHAR2(255) NOT NULL,
    HAUSNUMMER    NUMBER NOT NULL,
    TELEFON       NUMBER(10) NOT NULL
  );
CREATE TABLE TEILE
  (
    TEILEID       NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    BEZEICHNUNG   VARCHAR2(255) NOT NULL,
    LIEFERANTENID NUMBER NOT NULL,
    TEILVON       NUMBER,
    ANZAHL        NUMBER NOT NULL CHECK (ANZAHL > 0),
    PREIS         NUMBER CHECK (PREIS          >= 0),
    FOREIGN KEY (LIEFERANTENID) REFERENCES LIEFERANTEN(LIEFERANTENID)
  );
CREATE TABLE BESTELLUNGEN
  (
    BESTELLUNGENID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY ,
    TEILEID        NUMBER NOT NULL,
    KUNDENID       NUMBER NOT NULL,
    ANZAHL         NUMBER NOT NULL CHECK (ANZAHL > 0) ,
    PREIS          NUMBER NOT NULL CHECK (PREIS >= 0),
    DATUM          DATE NOT NULL,
    FOREIGN KEY (KUNDENID) REFERENCES KUNDEN(KUNDENID),
    FOREIGN KEY (TEILEID) REFERENCES TEILE(TEILEID),
    CONSTRAINT B_PK PRIMARY KEY (BESTELLUNGENID, TEILEID, KUNDENID)
  );
  CREATE OR REPLACE TRIGGER ORDER_INSERT BEFORE
  INSERT ON bestellungen FOR EACH ROW DECLARE incorrect_order EXCEPTION;
  PRAGMA EXCEPTION_INIT (incorrect_order, -20002);
  n_count NUMBER(1);
  BEGIN
    SELECT COUNT (*)
    INTO n_count
    FROM ABO971.BESTELLUNGEN
    WHERE DATUM     = :NEW.DATUM
    AND RICHTUNG    = 0;
    IF (:NEW.RICHTUNG = 0 AND n_count=1) THEN
      UPDATE ABO971.BESTELLUNGEN
      SET TEILEID  = :NEW.TEILEID,
        KUNDENID   = :NEW.TEILEID,
        ANZAHL     =:NEW.ANZAHL,
        PREIS      =:NEW.PREIS,
        DATUM      =:NEW.DATUM,
        RICHTUNG   = 1
      WHERE DATUM  = :NEW.DATUM
      AND RICHTUNG = 0;
    ELSE
      INSERT
      INTO ABO971.BESTELLUNGEN
        (
          TEILEID,
          KUNDENID,
          ANZAHL,
          PREIS,
          DATUM,
          RICHTUNG
        )
        VALUES
        (
          :NEW.TEILEID,
          :NEW.KUNDENID,
          :NEW.ANZAHL,
          :NEW.PREIS,
          :NEW.DATUM,
          1
        );
    END IF;
  EXCEPTION
  WHEN incorrect_order THEN
    raise_application_error (-20002, 'try again');
  END;
  /
  create or replace TRIGGER PLZ_TRIGGER
  --CREATE OR REPLACE TRIGGER rental_unavailable
  BEFORE
  INSERT ON kunden FOR EACH ROW DECLARE plz_not_found EXCEPTION;
  PRAGMA EXCEPTION_INIT (plz_not_found, -20001);
  n_count NUMBER (1);
  BEGIN
    SELECT COUNT (*) INTO n_count FROM GERKEN.PLZVERZEICHNIS WHERE PLZ = :NEW.PLZ;
    IF n_count < 1 THEN
      RAISE plz_not_found;
    END IF;
  EXCEPTION
  WHEN plz_not_found THEN
    raise_application_error (-20001, 'Ungueltige Postleitzahl');
  END;
INSERT
INTO KUNDEN
  (
    VORNAME,
    NACHNAME,
    STRASSE,
    HAUSNUMMER,
    EMAIL,
    TELEFON
  )
  VALUES
  (
    'IGOR',
    'LASTNAME',
    'Parkstrasse',
    '1',
    'igor@haw-hamburg.de',
    040123456
  );
INSERT
INTO KUNDEN
  (
    VORNAME,
    NACHNAME,
    STRASSE,
    HAUSNUMMER,
    EMAIL,
    TELEFON,
    PLZ
  )
  VALUES
  (
    'MARK',
    'LASTNAME',
    'Schloßstraße',
    '2',
    'mark@haw-hamburg.de',
    040123456,
    21035
  );
INSERT
INTO KUNDEN
  (
    VORNAME,
    NACHNAME,
    STRASSE,
    HAUSNUMMER,
    EMAIL,
    TELEFON,
    PLZ
  )
  VALUES
  (
    'LISA',
    'LASTNAME',
    'Riverside',
    '3',
    'lisa@haw-hamburg.de',
    040123456,
    22047
  );
INSERT
INTO KUNDEN
  (
    VORNAME,
    NACHNAME,
    STRASSE,
    HAUSNUMMER,
    EMAIL,
    TELEFON,
    PLZ
  )
  VALUES
  (
    'Christian',
    'Truempelmann',
    'Sesamstrasse',
    '1a',
    'mail@true.de',
    13241,
    22047
  );
INSERT
INTO KUNDEN
  (
    VORNAME,
    NACHNAME,
    STRASSE,
    HAUSNUMMER,
    EMAIL,
    TELEFON,
    PLZ
  )
  VALUES
  (
    'Peter',
    'Ramsauer',
    'Habastrasse',
    '1',
    'mail@true.de',
    125425,
    22145
  );
INSERT
INTO KUNDEN
  (
    VORNAME,
    NACHNAME,
    STRASSE,
    HAUSNUMMER,
    EMAIL,
    TELEFON,
    PLZ
  )
  VALUES
  (
    'Angy',
    'Merkel',
    'Habastrasse',
    '1',
    'mail@true.de',
    125425,
    21035
  );
INSERT
INTO KUNDEN
  (
    VORNAME,
    NACHNAME,
    STRASSE,
    HAUSNUMMER,
    EMAIL,
    TELEFON,
    PLZ
  )
  VALUES
  (
    'Vladi',
    'Putin',
    'Habastrasse',
    '1',
    'mail@true.de',
    125425,
    21035
  );
INSERT
INTO KUNDEN
  (
    VORNAME,
    NACHNAME,
    STRASSE,
    HAUSNUMMER,
    EMAIL,
    TELEFON,
    PLZ
  )
  VALUES
  (
    'George',
    'Dabbelju',
    'WeissesHaus',
    '1',
    'mail@true.de',
    125425,
    22222
  );
INSERT
INTO ABO971.LIEFERANTEN
  (
    LIEFERANTENID,
    FIRMENNAME,
    INHABER,
    STRASSE,
    HAUSNUMMER,
    TELEFON
  )
  VALUES
  (
    1,
    'VW_SUPPLY',
    'Mr. X',
    'VW Autostadt',
    1,1234
  );
INSERT
INTO ABO971.LIEFERANTEN
  (
    LIEFERANTENID,
    FIRMENNAME,
    INHABER,
    STRASSE,
    HAUSNUMMER,
    TELEFON
  )
  VALUES
  (
    2,
    'BMW_SUPPLY',
    'Mr. Y',
    'Munich Allee',
    1,5678
  );
INSERT
INTO ABO971.TEILE
  (
    TEILEID,
    BEZEICHNUNG,
    LIEFERANTENID,
    TEILVON,
    ANZAHL,
    PREIS
  )
  VALUES
  (
    2,
    'FELGE 17" BMW 1er',
    2,3,2,500
  );
INSERT
INTO ABO971.TEILE
  (
    TEILEID,
    BEZEICHNUNG,
    LIEFERANTENID,
    TEILVON,
    ANZAHL,
    PREIS
  )
  VALUES
  (
    3,
    'BMW 1er',
    2,
    NULL,
    100,25000
  );
  
