------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: bin_to_7seg                                                                --
--  Date: 11/03/2025                                                                    --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bin_to_7seg IS

    PORT (
        x : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        in_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        out_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE generic_mux_arch OF generic_mux IS
BEGIN

    bin_mux : ENTITY work.bin_mux PORT MAP (x(1 DOWNTO 0), in_sel(0), out_data(6 DOWNTO 0));
    dec_mux : ENTITY work.dec_mux PORT MAP (x(3 DOWNTO 0), in_sel(1), out_data(7 DOWNTO 0));
    hex_mux : ENTITY work.hex_mux PORT MAP (x(6 DOWNTO 0), in_sel(1), out_data(7 DOWNTO 0));

    WHIT in_sel SELECT
    out_data <=
        bin_mux WHEN "00",
        dec_mux WHEN "01",
        hex_mux WHEN OTHERS;

END generic_mux_arch;