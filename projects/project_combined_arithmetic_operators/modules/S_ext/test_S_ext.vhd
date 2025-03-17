LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_S_ext IS
END ENTITY test_S_ext;

ARCHITECTURE test_S_ext_Arch OF test_S_ext IS

    -- Señales de prueba
    SIGNAL S_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL OP_tb : STD_LOGIC;
    SIGNAL C_tb : STD_LOGIC;

BEGIN

    -- Instanciación del DUT (Device Under Test)
    DUT : ENTITY WORK.S_ext(S_ext_Arch)
        PORT MAP(
            S => S_tb,
            R => R_tb,
            OP => OP_tb,
            C => C_tb
        );

    -- Asignaciones con `AFTER` para pruebas
    S_tb <= "1001" AFTER 0 ns, -- 0
        "0110" AFTER 20 ns, -- -10
        "0001" AFTER 40 ns;

    C_tb <= '0' AFTER 0 ns, -- 0
        '1' AFTER 20 ns, -- -10
        '0' AFTER 40 ns;

    OP_tb <= '1' AFTER 0 ns, -- 0
        '0' AFTER 20 ns, -- 10
        '1' AFTER 40 ns;

END ARCHITECTURE test_S_ext_Arch;