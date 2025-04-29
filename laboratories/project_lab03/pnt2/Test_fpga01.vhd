LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Test_fpga01 IS
END Test_fpga01;

ARCHITECTURE Test_fpga01Arch OF Test_fpga01 IS
    SIGNAL bin : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL led : STD_LOGIC;
    
BEGIN
    DUT : ENTITY WORK.fpga01
        PORT MAP (
            bin => bin,
            led => led
        );

    bin <= "00" AFTER 20 ns,  
          "01" AFTER 40 ns, 
          "10" AFTER 60 ns,  
          "11" AFTER 80 ns;  

END Test_fpga01Arch;
