LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Test_bin_to_sseg IS
END Test_bin_to_sseg;

ARCHITECTURE Test_bin_to_ssegArch OF Test_bin_to_sseg IS
    SIGNAL bin  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL sseg : STD_LOGIC_VECTOR(6 DOWNTO 0);
    
BEGIN
    TB : ENTITY WORK.bin_to_sseg
        PORT MAP (
            bin  => bin,
            sseg => sseg
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
          "1010" AFTER 220 ns,  -- A
          "1011" AFTER 240 ns,  -- B
          "1100" AFTER 260 ns,  -- C
          "1101" AFTER 280 ns,  -- D
          "1110" AFTER 300 ns,  -- E
          "1111" AFTER 320 ns;  -- F

END Test_bin_to_ssegArch;
