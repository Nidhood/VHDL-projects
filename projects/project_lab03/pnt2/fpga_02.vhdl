LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fpga02 IS
    PORT( bin  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
          led : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
END ENTITY fpga02;

ARCHITECTURE behaviour OF fpga02 IS
BEGIN
    WITH bin SELECT
        led <=
		      "11" WHEN "1110",
				  "00" WHEN OTHERS;
			
END behaviour;
