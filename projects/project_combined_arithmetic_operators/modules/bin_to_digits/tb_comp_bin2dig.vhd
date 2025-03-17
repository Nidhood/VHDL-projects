LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY tb_comp_bin2dig IS
END ENTITY tb_comp_bin2dig;

ARCHITECTURE tb_comp_bin2dig_Arch OF tb_comp_bin2dig IS

    -- Señales de prueba
    SIGNAL Ans_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL Comp_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL Val_out_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL Val_sum_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL GT_out_tb : STD_LOGIC;

BEGIN
    -- Instancia del módulo a probar
    DUT : ENTITY work.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => Ans_tb,
            Comp => Comp_tb,
            Val_out => Val_out_tb,
            Val_sum => Val_sum_tb,
            GT_out => GT_out_tb
        );

    -- Estímulos con AFTER en lugar de WAIT FOR
    Ans_tb <= "0011111010" AFTER 0 ns, -- 250 en binario 
        "0001100100" AFTER 20 ns, -- 100 en binario
        "0001101000" AFTER 40 ns, -- 200 en binario
        "0000001111" AFTER 60 ns, -- 15 en binario
        "0000000101" AFTER 80 ns, -- 5 en binario
        "0000000010" AFTER 100 ns; -- 2 en binario 

    Comp_tb <= "0011001000" AFTER 0 ns, -- 200 en binario
        "0000101000" AFTER 20 ns, -- 40 en binario
        "0000010100" AFTER 40 ns, -- 20 en binario
        "0000001010" AFTER 60 ns, -- 10 en binario
        "0000000111" AFTER 80 ns, -- 7 en binario
        "0000000001" AFTER 100 ns; -- 1 en binario
END ARCHITECTURE tb_comp_bin2dig_Arch;