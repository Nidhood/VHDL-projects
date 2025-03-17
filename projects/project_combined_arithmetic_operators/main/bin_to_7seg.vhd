LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bin_to_7seg IS
    PORT (
        decimal : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Dígito en formato decimal (4 bits)
        hexadecimal : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Dígito en formato hexadecimal (4 bits)
        in_sel : IN STD_LOGIC; -- Selector: '0' para decimal, '1' para hexadecimal
        sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- Salida para display de 7 segmentos
    );
END ENTITY bin_to_7seg;

ARCHITECTURE bin_to_7seg_arch OF bin_to_7seg IS
    SIGNAL dec_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL hex_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN

    -- Instancia del conversor decimal
    dec_inst : ENTITY work.dec_mux
        PORT MAP(
            x => decimal, -- Se utiliza la entrada de 4 bits
            sseg => dec_out
        );

    -- Instancia del conversor hexadecimal
    hex_inst : ENTITY work.hex_mux
        PORT MAP(
            x => hexadecimal, -- Se utiliza la entrada de 4 bits
            sseg => hex_out
        );

    -- Según el selector se envía la salida correspondiente:
    WITH in_sel SELECT
        sseg <= dec_out WHEN '0',
        hex_out WHEN '1',
        "1000000" WHEN OTHERS; -- Valor por defecto (representa 0)

END bin_to_7seg_arch;