LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_counterGates IS
END ENTITY tb_counterGates;

ARCHITECTURE tb_counterGates_Arch OF tb_counterGates IS

    SIGNAL clk_tb : STD_LOGIC := '0';
    SIGNAL rst_tb : STD_LOGIC := '0';
    SIGNAL ena_tb : STD_LOGIC := '0';
    SIGNAL q_tb   : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');


BEGIN

    X1 : ENTITY work.counterGates
        PORT MAP(
            clk => clk_tb,
            rst => rst_tb,
            ena => ena_tb,
            q => q_tb
        );

    -- Generación de reloj
    clk_tb <= NOT clk_tb AFTER 5 ns;

    -- Estímulos
    rst_tb <= '1', '0' AFTER 10 ns;
    ena_tb <= '0', '1' AFTER 10 ns;

END ARCHITECTURE tb_counterGates_Arch;