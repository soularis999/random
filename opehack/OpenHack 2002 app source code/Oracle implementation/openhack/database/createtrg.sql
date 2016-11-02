-- This CLP file was created using ORACLELOOK Version 7.2
-- DATE: Wed 10 June 2002 11:15:48 AM EST
-- Database Name: AWARDS         
-- Database Manager Version:                               
-- Database Codepage:

spool buildtrg.log 

CONNECT EXADMIN/EXADMIN

CREATE SEQUENCE RANKINGS_SEQ;
CREATE SEQUENCE COMPANIES_SEQ;
CREATE SEQUENCE CATEGORIES_SEQ;
CREATE SEQUENCE PRODUCTS_SEQ;

-- Note trigger for ID column

CREATE OR REPLACE TRIGGER PRE_RANKINGS
BEFORE INSERT ON RANKINGS FOR EACH ROW 
BEGIN

  SELECT RANKINGS_SEQ.nextval 
  INTO :new.ID 
  FROM DUAL; 

END;
/

CREATE OR REPLACE TRIGGER PRE_COMPANIES
BEFORE INSERT ON COMPANIES FOR EACH ROW 
BEGIN

  SELECT COMPANIES_SEQ.nextval 
  INTO :new.ID 
  FROM DUAL; 

END;
/

CREATE OR REPLACE TRIGGER PRE_CATEGORIES
BEFORE INSERT ON CATEGORIES FOR EACH ROW 
BEGIN

  SELECT CATEGORIES_SEQ.nextval 
  INTO :new.ID 
  FROM DUAL; 

END;
/

CREATE OR REPLACE TRIGGER PRE_PRODUCTS
BEFORE INSERT ON PRODUCTS FOR EACH ROW 
BEGIN

  SELECT PRODUCTS_SEQ.nextval 
  INTO :new.ID 
  FROM DUAL; 

END;
/

spool off
