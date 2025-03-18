------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: dec_mux                                                                    --
--  Date: 11/03/2025                                                                    --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY dec_mux IS

    PORT (
        x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END ENTITY;

ARCHITECTURE dec_mux_arch OF dec_mux IS

BEGIN

    WITH x SELECT
        sseg <=
        "1000000" WHEN "0000", -- 0
        "1111001" WHEN "0001", -- 1
        "0100100" WHEN "0010", -- 2
        "0110000" WHEN "0011", -- 3
        "0011001" WHEN "0100", -- 4
        "0010010" WHEN "0101", -- 5
        "0000010" WHEN "0110", -- 6
        "1111000" WHEN "0111", -- 7
        "0000000" WHEN "1000", -- 8
        "1000000" WHEN "1001", -- 9
        "1000000" WHEN OTHERS; -- 0

END dec_mux_arch;