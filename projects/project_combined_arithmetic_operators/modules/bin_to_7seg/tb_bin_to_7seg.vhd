LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_bin_to_7seg IS
END ENTITY tb_bin_to_7seg;

ARCHITECTURE tb_bin_to_7seg_arch OF tb_bin_to_7seg IS

    -- Entradas para cada conversor (4 bits)
    SIGNAL dec_in_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL hex_in_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Selector: '0' para decimal, '1' para hexadecimal
    SIGNAL sel_tb : STD_LOGIC;

    -- Salida para display de 7 segmentos
    SIGNAL sseg_tb : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    ----------------------------------------------------------------------------
    -- Instanciación del módulo a testear (UUT)
    ----------------------------------------------------------------------------
    UUT : ENTITY work.bin_to_7seg
        PORT MAP(
            decimal => dec_in_tb,
            hexadecimal => hex_in_tb,
            in_sel => sel_tb,
            sseg => sseg_tb
        );

    ----------------------------------------------------------------------------
    -- Proceso de estímulos
    ----------------------------------------------------------------------------
    stim : PROCESS
    BEGIN
        ----------------------------------------------------------------------------
        -- Modo Decimal: in_sel = '0'
        ----------------------------------------------------------------------------
        sel_tb <= '0'; -- Selección: modo decimal
        -- Se aplican dígitos decimales de 0 a 9 (un dígito cada 40 ns)
        dec_in_tb <= "0000"; -- 0
        WAIT FOR 40 ns;
        dec_in_tb <= "0001"; -- 1
        WAIT FOR 40 ns;
        dec_in_tb <= "0010"; -- 2
        WAIT FOR 40 ns;
        dec_in_tb <= "0011"; -- 3
        WAIT FOR 40 ns;
        dec_in_tb <= "0100"; -- 4
        WAIT FOR 40 ns;
        dec_in_tb <= "0101"; -- 5
        WAIT FOR 40 ns;
        dec_in_tb <= "0110"; -- 6
        WAIT FOR 40 ns;
        dec_in_tb <= "0111"; -- 7
        WAIT FOR 40 ns;
        dec_in_tb <= "1000"; -- 8
        WAIT FOR 40 ns;
        dec_in_tb <= "1001"; -- 9
        WAIT FOR 40 ns;

        ----------------------------------------------------------------------------
        -- Modo Hexadecimal: in_sel = '1'
        ----------------------------------------------------------------------------
        sel_tb <= '1'; -- Selección: modo hexadecimal
        -- Se aplican dígitos hexadecimales: 0, 2, 5, A, B, C, D, E, F (un dígito cada 40 ns)
        hex_in_tb <= "0000"; -- 0
        WAIT FOR 40 ns;
        hex_in_tb <= "0010"; -- 2
        WAIT FOR 40 ns;
        hex_in_tb <= "0101"; -- 5
        WAIT FOR 40 ns;
        hex_in_tb <= "1010"; -- A
        WAIT FOR 40 ns;
        hex_in_tb <= "1011"; -- B
        WAIT FOR 40 ns;
        hex_in_tb <= "1100"; -- C
        WAIT FOR 40 ns;
        hex_in_tb <= "1101"; -- D
        WAIT FOR 40 ns;
        hex_in_tb <= "1110"; -- E
        WAIT FOR 40 ns;
        hex_in_tb <= "1111"; -- F
        WAIT FOR 40 ns;

        WAIT; -- Termina la simulación
    END PROCESS stim;

END ARCHITECTURE tb_bin_to_7seg_arch;