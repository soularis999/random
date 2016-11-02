-- Module Name :		EDPP001
-- Author :		 	John Abel
-- Creation Date :	14 June 2002
-- Description :		Encrypt any clear data using Triple DES encryption and 
--				pass the encrypted data out via a RAW datatype
-- Version History
-- Name           	Version     	Date 	           	Description
-- John Abel		1.0			14 June 2002	Data Encryption
-- EDPP001 Encryption

CREATE OR REPLACE PACKAGE EDPP001_enc AS

FUNCTION encrypt(	P_input_value	IN	VARCHAR2)

RETURN RAW;

END EDPP001_enc;
/

CREATE OR REPLACE PACKAGE BODY EDPP001_enc AS

FUNCTION encrypt(	P_input_value	IN	VARCHAR2)

RETURN RAW

IS

-- Declare variables

v_input_value	VARCHAR2(256);
l5		RAW(128);
l3		RAW(128);
l9		RAW(128);
l4		RAW(128);
IV		RAW(128);
l1		RAW(128);
l6		RAW(128);
l8		RAW(128);
l2		RAW(128);
l7		RAW(128);
l		NUMBER;
xord		RAW(128);
enc_data_1	RAW(128);
enc_data_2	RAW(128);
enc_data_3	RAW(128);
v_con_value 	RAW(128);
v_output_value 	RAW(128);
v_encrypted 	RAW(2048);
v_segment 	VARCHAR2(256);
v_rpad		VARCHAR2(256);
e_exception_occured_EDPP009	EXCEPTION;
PRAGMA	EXCEPTION_INIT(e_exception_occured_EDPP009, -20914);


BEGIN

	-- Initialise variables

	l2 := hextoraw('1E3DAC6E92DEBA43');
	l4 := hextoraw('EA5183AC67FD81D3');
	l8 := hextoraw('3EE4BDB779077A4F');
	l5 := hextoraw('18773334A3EBAFE3');
	l9 := hextoraw('F6F58436588321FF');
	l3 := hextoraw('A0F206FAE6272A1F');
	l1 := hextoraw('3FC833B82CCB31AE');
	l7 := hextoraw('2003775DFD394FA1');
	l6 := hextoraw('1B2845D7CB7222E1');
	IV := hextoraw('2108B0E6487226E1');	
	
	
	-- Prefix input value with input length
	v_input_value := (to_char(length(P_input_value), '00') || P_input_value);

	-- Pad the string out if less than 64
	IF length(v_input_value)<64 THEN
		v_rpad := RPAD(v_input_value, 64, v_input_value);
	--DBMS_OUTPUT.PUT_LINE('v_rpad <' || v_rpad || '>');
	v_input_value := v_rpad;
	END IF;

	-- Divide into segments of 8
	v_segment := substr(v_input_value, 1, 8);
	
	-- Convert input value to RAW datatype

	v_con_value := UTL_RAW.CAST_TO_RAW(v_segment);

	-- 3 key 3des encryption implementation

	xord := UTL_RAW.BIT_XOR(IV, v_con_value);

	DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT(	input => xord,
						key => l1 || l4,
						encrypted_data => enc_data_1);

	DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT(	input => enc_data_1,
						key => l2 || l5 || l7,
						decrypted_data => enc_data_2);

	DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT(	input => enc_data_2,
						key => l3 || l6,
						encrypted_data => enc_data_3);

	v_encrypted := enc_data_3;

	-- Determine the length and round up to nearest integer
	l := ceil(length(v_input_value)/8);

	-- Loop through for each segment
	FOR i in 2..l LOOP
		v_segment := substr(v_input_value, i*8-7, 8);

		-- Convert input value to RAW datatype

		v_con_value := UTL_RAW.CAST_TO_RAW(v_segment);

		-- 3 key 3des encryption implementation

		xord := UTL_RAW.BIT_XOR(IV, v_con_value);

		DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT(	input => xord,
							key => l1 || l4,
							encrypted_data => enc_data_1);

		DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT(	input => enc_data_1,
							key => l2 || l5 || l7,
							decrypted_data => enc_data_2);

		DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT(	input => enc_data_2,
							key => l3 || l6,
							encrypted_data => enc_data_3);

		v_encrypted := v_encrypted||enc_data_3;
		
	END LOOP;

	-- Set return value
	v_output_value := v_encrypted;
	
	RETURN v_output_value;

	-- Exception handling

	EXCEPTION
		WHEN OTHERS THEN
			RETURN NULL;
			
END encrypt;
END EDPP001_enc;
/
