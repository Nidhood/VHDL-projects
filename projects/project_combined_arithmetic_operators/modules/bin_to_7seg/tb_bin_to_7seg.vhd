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

ARCHITECTURE tb_bin_to_7seg_arch OF tb_bin_to_7seg IS

    -- Señales de prueba
    SIGNAL x_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL sel_tb : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL sseg_tb : STD_LOGIC_VECTOR(6 DOWNTO 0);

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
    -- Estímulos usando asignaciones concurrentes con "AFTER"
    ----------------------------------------------------------------------------

    -- 1) Control del selector (in_sel)
    --    "00" (modo binario) desde 0 ns hasta 80 ns
    --    "01" (modo decimal) desde 80 ns hasta 280 ns
    --    "10" (modo hexadecimal) desde 280 ns en adelante
    sel_tb <=
        "00" AFTER 0 ns, -- Modo binario hasta 80 ns
        "01" AFTER 80 ns, -- Modo decimal hasta 280 ns
        "10" AFTER 280 ns; -- Modo hexadecimal en adelante

    -- 2) Valores de x_tb
    --    Modo BIN (in_sel="00"): usaremos x(1..0) => probamos bin=0..3
    x_tb <=
        -- BIN: 0..3 (cada 20 ns)
        "0000" AFTER 0 ns, -- bin=00
        "0001" AFTER 20 ns, -- bin=01
        "0010" AFTER 40 ns, -- bin=10
        "0011" AFTER 60 ns, -- bin=11

        -- DEC: 0..9 (cambiamos a "01" en_sel en 80 ns)
        "0000" AFTER 80 ns, -- dec=0
        "0001" AFTER 100 ns, -- dec=1
        "0010" AFTER 120 ns, -- dec=2
        "0011" AFTER 140 ns, -- dec=3
        "0100" AFTER 160 ns, -- dec=4
        "0101" AFTER 180 ns, -- dec=5
        "0110" AFTER 200 ns, -- dec=6
        "0111" AFTER 220 ns, -- dec=7
        "1000" AFTER 240 ns, -- dec=8
        "1001" AFTER 260 ns, -- dec=9

        -- HEX: probamos varios (0,2,5,A,B,C,D,E,F) cuando in_sel="10" (280 ns en adelante)
        "0000" AFTER 280 ns, -- hex=0  (x(6..3)="0000")
        "0010" AFTER 300 ns, -- hex=2  (x(6..3)="0010")
        "0101" AFTER 320 ns, -- hex=5  (x(6..3)="0101")
        "1010" AFTER 340 ns, -- hex=A  (x(6..3)="1010")
        "1011" AFTER 360 ns, -- hex=B  (x(6..3)="1011")
        "1100" AFTER 380 ns, -- hex=C  (x(6..3)="1100")
        "1101" AFTER 400 ns, -- hex=D  (x(6..3)="1101")
        "1110" AFTER 420 ns, -- hex=E  (x(6..3)="1110")
        "1111" AFTER 440 ns; -- hex=F  (x(6..3)="1111")

END ARCHITECTURE tb_bin_to_7seg_arch;