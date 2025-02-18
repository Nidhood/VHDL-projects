------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: Binary code to Gray code                                                   --
--  Date: 20/02/2025                                                                    --
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY pnt3_bin_to_gray IS
    PORT (
        x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        en : IN STD_LOGIC;
        y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END pnt3_bin_to_gray;
---------------------------------------------------------------------------------
ARCHITECTURE pnt3_bin_to_gray_arch OF pnt3_bin_to_gray IS

    SIGNAL enx : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

    enx <= en & x;

    WITH enx SELECT
        y <=
        "0000" WHEN "10000",
        "0001" WHEN "10001",
        "0011" WHEN "10010",
        "0010" WHEN "10011",
        "0110" WHEN "10100",
        "0111" WHEN "10101",
        "0101" WHEN "10110",
        "0100" WHEN "10111",
        "1100" WHEN "11000",
        "1101" WHEN "11001",
        "1111" WHEN "11010",
        "1110" WHEN "11011",
        "1010" WHEN "11100",
        "1011" WHEN "11101",
        "1001" WHEN "11110",
        "1000" WHEN "11111",
        "0000" WHEN OTHERS;

END pnt3_bin_to_gray_arch;