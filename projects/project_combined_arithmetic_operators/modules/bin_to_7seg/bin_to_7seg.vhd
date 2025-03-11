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
        sseg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE bin_to_7seg_arch OF bin_to_7seg IS

    SIGNAL bin_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL dec_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL hex_out : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    bin_inst : ENTITY work.bin_mux
        PORT MAP(
            x => x(3 DOWNTO 0),
            sseg => bin_out
        );

    dec_inst : ENTITY work.dec_mux
        PORT MAP(
            x => x(3 DOWNTO 0),
            sseg => dec_out
        );

    hex_inst : ENTITY work.hex_mux
        PORT MAP(
            x => x(6 DOWNTO 3),
            sseg => hex_out
        );

    WITH in_sel SELECT
        sseg(6 DOWNTO 0) <=
        bin_out WHEN "00",
        dec_out WHEN "01",
        hex_out WHEN "10",
        "1000000" WHEN OTHERS;

END bin_to_7seg_arch;