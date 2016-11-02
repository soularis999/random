-- Module Name :		EDPP001
-- Author :		 	John Abel
-- Creation Date :		14/06/2002
-- Description :		Decrypt any clear data using Triple DES decryption and
--				pass the decrypted data out via a RAW datatype
--
-- Version History
-- Name           	Version     	Date 	           	Description
-- John Abel		1.0		14/06/2002			Initial

-- EDPP001 Decryption of the vote

CREATE OR REPLACE PACKAGE EDPP001_denc1 AS

FUNCTION decrypt(	P_input_value	IN	RAW)

RETURN VARCHAR2;

END EDPP001_denc1;
/

CREATE OR REPLACE PACKAGE BODY EDPP001_denc1 AS

FUNCTION decrypt(	P_input_value	IN	RAW)

RETURN VARCHAR2

IS
-- Declare variables

l6		RAW(128);
l3		RAW(128);
IV		RAW(128);
l9		RAW(128);
l4		RAW(128);
l5		RAW(128);
l8		RAW(128);
l1		RAW(128);
l7		RAW(128);
l2		RAW(128);
l		NUMBER;
xord		RAW(128);
enc_data_1	RAW(128);
enc_data_2	RAW(128);
enc_data_3	RAW(128);
v_output_value 	VARCHAR2(256);
v_segment 	VARCHAR2(16);
v_decrypt_value RAW(2048);
v_decrypted 	VARCHAR2(256);
v_encrypted 	RAW(2048);
v_uncon_value 	VARCHAR2(256);
e_decryption			EXCEPTION;
e_exception_occured_EDPP009	EXCEPTION;
PRAGMA	EXCEPTION_INIT(e_exception_occured_EDPP009, -20914);
PRAGMA	EXCEPTION_INIT(e_decryption, -20911);

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
	
		v_encrypted := P_input_value;

		-- Determine the length
		l := ceil(length(v_encrypted)/16);
  
		-- Divide string into segments
		v_segment := substrb(v_encrypted, 1, 16);

		-- 3 key 3des decryption implementation

		DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT(	input => v_segment,
							key => l3 || l6,
							decrypted_data => enc_data_1);

		DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT(	input => enc_data_1,
							key => l2 || l5 || l7,
							encrypted_data => enc_data_2);

		DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT(	input => enc_data_2,
							key => l1 || l4,
							decrypted_data => enc_data_3);

		xord := UTL_RAW.BIT_XOR(IV, enc_data_3);

		v_decrypt_value := xord;

		-- Loop through for each segment
		FOR i in 2..l LOOP
			v_segment := substrb(v_encrypted, i*16-15, 16);

		-- 3 key 3des decryption implementation

			DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT(	input => v_segment,
								key => l3 || l6,
								decrypted_data => enc_data_1);

			DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT(	input => enc_data_1,
								key => l2 || l5 || l7,
								encrypted_data => enc_data_2);

			DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT(	input => enc_data_2,
								key => l1 || l4,
								decrypted_data => enc_data_3);

			xord := UTL_RAW.BIT_XOR(IV, enc_data_3);
						
			v_decrypt_value := v_decrypt_value||xord;
	
		END LOOP;

		--Determine length of input value i.e. first 3 numbers
		
		l := substr(utl_raw.cast_to_varchar2(v_decrypt_value), 1, 3);
		
		-- Remove padding added in encryption function

		v_decrypted := substr(utl_raw.cast_to_varchar2(v_decrypt_value), 4, l);

	RETURN v_decrypted;
	
	-- Exception handling

	EXCEPTION

		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Dec Err '||sqlerrm);
			RETURN NULL;
			
END decrypt;
END EDPP001_denc1;
/
