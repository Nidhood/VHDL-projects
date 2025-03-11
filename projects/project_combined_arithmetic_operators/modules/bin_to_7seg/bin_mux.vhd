------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: bin_mux                                                                    --
--  Date: 11/03/2025                                                                    --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bin_to_7seg IS

    PORT (
        x : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        sel : IN STD_LOGIC;
        sseg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;

ARCHITECTURE bin_to_7seg_arch OF bin_to_7seg IS

BEGIN

    WITH x SELECT
        sseg <=
        "1000000" WHEN "0000", -- 0
        "1111001" WHEN OTHERS; -- 1

END bin_to_7seg_arch;