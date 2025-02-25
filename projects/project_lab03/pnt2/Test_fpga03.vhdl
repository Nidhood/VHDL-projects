LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Test_fpga03 IS
END Test_fpga03;

ARCHITECTURE Test_fpga03Arch OF Test_fpga03 IS
    SIGNAL bin : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL led : STD_LOGIC_VECTOR(1 DOWNTO 0);
    
BEGIN
    DUT : ENTITY WORK.fpga03
        PORT MAP (
            bin => bin,
            led => led
        );

    bin <= "000" AFTER 20 ns, 
          "001" AFTER 40 ns,  
          "010" AFTER 60 ns,  
          "011" AFTER 80 ns,  
          "100" AFTER 100 ns, 
          "101" AFTER 120 ns, 
          "110" AFTER 140 ns, 
          "111" AFTER 160 ns; 
			 
END Test_fpga03Arch;
