LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fpga01 IS
    PORT( bin  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          led : OUT STD_LOGIC
        );
END ENTITY fpga01;

ARCHITECTURE behaviour OF fpga01 IS
BEGIN
    WITH bin SELECT
        led <=
	    '1' WHEN "01",
	    '0' WHEN OTHERS;
			
END behaviour;
