------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --    
--  Project: Multiplexor 16:1                                                           --
--  Date: 18/02/2025                                                                    --         
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------------------------------
ENTITY pnt2_1_mux16_1 IS
    PORT (
        s : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        y : OUT STD_LOGIC
    );
END ENTITY;
------------------------------------------------------------------------------------------
ARCHITECTURE pnt2_1_mux16_1_arch OF pnt2_1_mux16_1 IS
BEGIN

    WITH s SELECT
        y <=
        '1' WHEN "0000",
        '1' WHEN "0001",
        '1' WHEN "0010",
        '0' WHEN "0011",
        '1' WHEN "0100",
        '1' WHEN "0101",
        '1' WHEN "0110",
        '0' WHEN "0111",
        '1' WHEN "1000",
        '1' WHEN "1001",
        '1' WHEN "1010",
        '0' WHEN "1011",
        '0' WHEN "1100",
        '0' WHEN "1101",
        '0' WHEN "1110",
        '0' WHEN "1111",
        '0' WHEN OTHERS;

END pnt2_1_mux16_1_arch;