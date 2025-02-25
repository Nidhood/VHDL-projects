LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Test_fpga02 IS
END Test_fpga02;

ARCHITECTURE Test_fpga02Arch OF Test_fpga02 IS
    SIGNAL bin : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL led : STD_LOGIC_VECTOR(1 DOWNTO 0);
    
BEGIN
    DUT : ENTITY WORK.fpga02
        PORT MAP (
            bin => bin,
            led => led
        );

    bin <= "0000" AFTER 20 ns,  
          "0001" AFTER 40 ns, 
          "0010" AFTER 60 ns,  
          "0011" AFTER 80 ns, 
          "0100" AFTER 100 ns,
          "0101" AFTER 120 ns, 
          "0110" AFTER 140 ns, 
          "0111" AFTER 160 ns, 
          "1000" AFTER 180 ns, 
          "1001" AFTER 200 ns, 
          "1010" AFTER 220 ns, 
          "1011" AFTER 240 ns, 
          "1100" AFTER 260 ns, 
          "1101" AFTER 280 ns, 
          "1110" AFTER 300 ns, 
          "1111" AFTER 320 ns; 

END Test_fpga02Arch;
