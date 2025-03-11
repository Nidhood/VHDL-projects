------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: bin_to_7seg (test)                                                         --
--  Date: 11/03/2025                                                                    --
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_bin_to_7seg IS
END ENTITY tb_bin_to_7seg;

ARCHITECTURE test_arch OF tb_bin_to_7seg IS

    -- Señales de prueba
    SIGNAL x_tb : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sel_tb : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL sseg_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    ----------------------------------------------------------------------------
    -- Instanciación del módulo a testear (UUT)
    ----------------------------------------------------------------------------
    UUT : ENTITY work.bin_to_7seg
        PORT MAP(
            x => x_tb,
            in_sel => sel_tb,
            sseg => sseg_tb
        );

    ----------------------------------------------------------------------------
    -- Proceso de estimulación
    ----------------------------------------------------------------------------
    stim_proc : PROCESS
    BEGIN
        -- 1) Modo BIN (in_sel = "00") -> usa x(1 DOWNTO 0)
        sel_tb <= "00";

        -- Probaremos bin=0..3 ajustando sólo x(1..0); el resto de bits pueden ser 0.
        x_tb <= "0000000"; -- bin=0
        WAIT FOR 20 ns;
        x_tb <= "0000001"; -- bin=1
        WAIT FOR 20 ns;
        x_tb <= "0000010"; -- bin=2
        WAIT FOR 20 ns;
        x_tb <= "0000011"; -- bin=3
        WAIT FOR 20 ns;

        -- 2) Modo DEC (in_sel = "01") -> usa x(3 DOWNTO 0)
        sel_tb <= "01";

        -- Probaremos dec=0..9 ajustando x(3..0); bits [6..4] pueden ser 0.
        x_tb <= "0000000"; -- dec=0
        WAIT FOR 20 ns;
        x_tb <= "0000001"; -- dec=1
        WAIT FOR 20 ns;
        x_tb <= "0000010"; -- dec=2
        WAIT FOR 20 ns;
        x_tb <= "0000011"; -- dec=3
        WAIT FOR 20 ns;
        x_tb <= "0000100"; -- dec=4
        WAIT FOR 20 ns;
        x_tb <= "0000101"; -- dec=5
        WAIT FOR 20 ns;
        x_tb <= "0000110"; -- dec=6
        WAIT FOR 20 ns;
        x_tb <= "0000111"; -- dec=7
        WAIT FOR 20 ns;
        x_tb <= "0001000"; -- dec=8
        WAIT FOR 20 ns;
        x_tb <= "0001001"; -- dec=9
        WAIT FOR 20 ns;

        -- 3) Modo HEX (in_sel = "10") -> usa x(6 DOWNTO 3)
        sel_tb <= "10";

        -- Probaremos varios valores hex (0..F). 
        -- Observa que x(6..3) define el nibble alto y x(2..0) pueden ser 0.

        x_tb <= "0000000"; -- hex=0  (x(6..3)="0000")
        WAIT FOR 20 ns;
        x_tb <= "0010000"; -- hex=2  (x(6..3)="0010")
        WAIT FOR 20 ns;
        x_tb <= "0101000"; -- hex=5  (x(6..3)="0101")
        WAIT FOR 20 ns;
        x_tb <= "1010000"; -- hex=A  (x(6..3)="1010")
        WAIT FOR 20 ns;
        x_tb <= "1011000"; -- hex=B  (x(6..3)="1011")
        WAIT FOR 20 ns;
        x_tb <= "1100000"; -- hex=C  (x(6..3)="1100")
        WAIT FOR 20 ns;
        x_tb <= "1101000"; -- hex=D  (x(6..3)="1101")
        WAIT FOR 20 ns;
        x_tb <= "1110000"; -- hex=E  (x(6..3)="1110")
        WAIT FOR 20 ns;
        x_tb <= "1111000"; -- hex=F  (x(6..3)="1111")
        WAIT FOR 20 ns;

        WAIT; -- Espera indefinidamente
    END PROCESS;

END ARCHITECTURE test_arch;