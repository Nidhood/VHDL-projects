LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_project_combined_arithmetic_operators IS
    -- Testbench no tiene puertos
END tb_project_combined_arithmetic_operators;

ARCHITECTURE behavior OF tb_project_combined_arithmetic_operators IS

    -- Declaración del componente a probar
    COMPONENT project_combined_arithmetic_operators
        PORT (
            n_operation : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            select_dec_or_hex : IN STD_LOGIC;
            A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            C : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sseg_1 : OUT STD_LOGIC;
            sseg_2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            sseg_3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            sseg_4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    -- Señales para conectar al DUT
    SIGNAL n_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL select_dec_or_hex : STD_LOGIC := '0';
    SIGNAL A, B, C, D : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sseg_1 : STD_LOGIC;
    SIGNAL sseg_2, sseg_3, sseg_4 : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    -- Instanciación del dispositivo bajo prueba (DUT)
    uut : project_combined_arithmetic_operators
    PORT MAP(
        n_operation => n_operation,
        select_dec_or_hex => select_dec_or_hex,
        A => A,
        B => B,
        C => C,
        D => D,
        sseg_1 => sseg_1,
        sseg_2 => sseg_2,
        sseg_3 => sseg_3,
        sseg_4 => sseg_4
    );

    -- Proceso de estímulo
    stim_proc : PROCESS
    BEGIN
        -- Asigna valores fijos a las entradas (modifícalos si lo requieres)
        A <= "0001"; -- Ejemplo: 1
        B <= "0010"; -- Ejemplo: 2
        C <= "0011"; -- Ejemplo: 3
        D <= "0100"; -- Ejemplo: 4
        select_dec_or_hex <= '0'; -- Selección: 0 = decimal, 1 = hexadecimal

        -- Prueba de las operaciones 1 a 9

        n_operation <= "00000"; -- Operación 1
        WAIT FOR 50 ns;
        n_operation <= "00001"; -- Operación 2
        WAIT FOR 50 ns;
        n_operation <= "00010"; -- Operación 3
        WAIT FOR 50 ns;
        n_operation <= "00011"; -- Operación 4
        WAIT FOR 50 ns;
        n_operation <= "00100"; -- Operación 5
        WAIT FOR 50 ns;
        n_operation <= "00101"; -- Operación 6
        WAIT FOR 50 ns;
        n_operation <= "00110"; -- Operación 7
        WAIT FOR 50 ns;
        n_operation <= "00111"; -- Operación 8
        WAIT FOR 50 ns;
        n_operation <= "01000"; -- Operación 9
        WAIT FOR 50 ns;

        -- Prueba de las operaciones 12 a 17

        n_operation <= "01011"; -- Operación 12
        WAIT FOR 50 ns;
        n_operation <= "01100"; -- Operación 13
        WAIT FOR 50 ns;
        n_operation <= "01101"; -- Operación 14
        WAIT FOR 50 ns;
        n_operation <= "01110"; -- Operación 15
        WAIT FOR 50 ns;
        n_operation <= "01111"; -- Operación 16
        WAIT FOR 50 ns;
        n_operation <= "10000"; -- Operación 17
        WAIT FOR 50 ns;

        -- Finaliza la simulación
        WAIT;
    END PROCESS stim_proc;

END behavior;