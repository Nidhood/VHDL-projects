--------------------------------------------------------------------------------- 
--    Descripcion: Converts a 4-bit binary number to a 7-segment display.      --
--    Author: Ivan Dario Orozco Ibanez                                         --
--    Date: 11/03/2025                                                         --
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY bin_to_7seg IS
    PORT (
        decimal : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        hexadecimal : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        in_sel : IN STD_LOGIC;
        sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY bin_to_7seg;
---------------------------------------------------------------------------------
ARCHITECTURE bin_to_7seg_arch OF bin_to_7seg IS
    SIGNAL dec_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL hex_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN

    dec_inst : ENTITY work.dec_mux
        PORT MAP(
            x => decimal,
            sseg => dec_out
        );

    hex_inst : ENTITY work.hex_mux
        PORT MAP(
            x => hexadecimal,
            sseg => hex_out
        );

    PROCESS (in_sel, dec_out, hex_out)
    BEGIN
        IF in_sel = '0' THEN
            sseg <= dec_out;
        ELSE
            sseg <= hex_out;
        END IF;
    END PROCESS;

END bin_to_7seg_arch;