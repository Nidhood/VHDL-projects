LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_mux6_2 IS
END ENTITY;

ARCHITECTURE testbench OF tb_mux6_2 IS

    COMPONENT mux6_2_when_else_1
        PORT (
            signal1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            signal2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            signal3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            signal4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            signal5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            signal6 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            X : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            Y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL signal1, signal2, signal3, signal4, signal5, signal6 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL sel : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL X, Y : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
    uut : mux6_2_when_else_1 PORT MAP(
        signal1 => signal1,
        signal2 => signal2,
        signal3 => signal3,
        signal4 => signal4,
        signal5 => signal5,
        signal6 => signal6,
        sel => sel,
        X => X,
        Y => Y
    );

    PROCESS
    BEGIN
        -- Valores de prueba
        signal1 <= "0001";
        signal2 <= "0010";
        signal3 <= "0011";
        signal4 <= "0100";
        signal5 <= "0101";
        signal6 <= "0110";

        -- Pruebas con diferentes valores de sel
        sel <= "000";
        WAIT FOR 10 ns;
        sel <= "001";
        WAIT FOR 10 ns;
        sel <= "010";
        WAIT FOR 10 ns;
        sel <= "011";
        WAIT FOR 10 ns;
        sel <= "100";
        WAIT FOR 10 ns;
        sel <= "101";
        WAIT FOR 10 ns;
        sel <= "110";
        WAIT FOR 10 ns;
        sel <= "111";
        WAIT FOR 10 ns;

        -- Finaliza la simulación
        WAIT;
    END PROCESS;

END ARCHITECTURE;