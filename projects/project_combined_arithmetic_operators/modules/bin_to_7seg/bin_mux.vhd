------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: bin_mux                                                                    --
--  Date: 11/03/2025                                                                    --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bin_mux IS

    PORT (
        x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END ENTITY;

ARCHITECTURE bin_mux_arch OF bin_mux IS

BEGIN

    WITH x SELECT
        sseg <=
        "1000000" WHEN "0000", -- 0
        "1111001" WHEN OTHERS; -- 1

END bin_mux_arch;