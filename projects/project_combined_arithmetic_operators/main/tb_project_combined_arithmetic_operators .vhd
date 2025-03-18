LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_project_combined_arithmetic_operators IS
END tb_project_combined_arithmetic_operators;

ARCHITECTURE behavior OF tb_project_combined_arithmetic_operators IS

    --------------------------------------------------------------------
    -- Declaración del componente a testear
    --------------------------------------------------------------------
    COMPONENT project_combined_arithmetic_operators IS
        PORT (
            n_operation : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            select_dec_or_hex : IN STD_LOGIC;
            A, B, C, D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sseg_1 : OUT STD_LOGIC;
            sseg_2, sseg_3, sseg_4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            number_A_sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            number_B_sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            number_C_sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            number_D_sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    --------------------------------------------------------------------
    -- Señales de interconexión
    --------------------------------------------------------------------
    SIGNAL n_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL select_dec_or_hex : STD_LOGIC := '0';
    SIGNAL A, B, C, D : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sseg_1 : STD_LOGIC;
    SIGNAL sseg_2, sseg_3, sseg_4 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL number_A_sseg : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL number_B_sseg : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL number_C_sseg : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL number_D_sseg : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN

    --------------------------------------------------------------------
    -- Instanciación de la entidad a testear (UUT)
    --------------------------------------------------------------------
    UUT : project_combined_arithmetic_operators
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
        sseg_4 => sseg_4,
        number_A_sseg => number_A_sseg,
        number_B_sseg => number_B_sseg,
        number_C_sseg => number_C_sseg,
        number_D_sseg => number_D_sseg
    );

    --------------------------------------------------------------------
    -- Proceso de estímulo (sin usar binary_response ni report)
    --------------------------------------------------------------------
    stim : PROCESS
    BEGIN
        ----------------------------------------------------------------
        -- Ajustar valores de A,B,C,D y n_operation en secuencia
        ----------------------------------------------------------------

        -- Fijamos A=1, B=2, C=3, D=4
        A <= "0001"; -- 1
        B <= "0010"; -- 2
        C <= "0011"; -- 3
        D <= "0100"; -- 4
        select_dec_or_hex <= '0'; -- salida en decimal

        -- Operación 1: n_operation = "00000"
        n_operation <= "00000";
        WAIT FOR 20 ns;

        -- Operación 2: n_operation = "00001"
        n_operation <= "00001";
        WAIT FOR 20 ns;

        -- Operación 3: n_operation = "00010"
        n_operation <= "00010";
        WAIT FOR 20 ns;

        -- Operación 4: n_operation = "00011"
        n_operation <= "00011";
        WAIT FOR 20 ns;

        -- Operación 5: n_operation = "00100"
        n_operation <= "00100";
        WAIT FOR 20 ns;

        -- Operación 6: n_operation = "00101"
        n_operation <= "00101";
        WAIT FOR 20 ns;

        -- Operación 7: n_operation = "00110"
        n_operation <= "00110";
        WAIT FOR 20 ns;

        -- Operación 8: n_operation = "00111"
        n_operation <= "00111";
        WAIT FOR 20 ns;

        -- Operación 9: n_operation = "01000"
        n_operation <= "01000";
        WAIT FOR 20 ns;

        -- Operación 10: n_operation = "01001"
        n_operation <= "01001";
        WAIT FOR 20 ns;

        -- Operación 11: n_operation = "01010"
        n_operation <= "01010";
        WAIT FOR 20 ns;

        -- Operación 12: n_operation = "01011"
        n_operation <= "01011";
        WAIT FOR 20 ns;

        -- Operación 13: n_operation = "01100"
        n_operation <= "01100";
        WAIT FOR 20 ns;

        -- Operación 14: n_operation = "01101"
        n_operation <= "01101";
        WAIT FOR 20 ns;

        -- Operación 15: n_operation = "01110"
        n_operation <= "01110";
        WAIT FOR 20 ns;

        -- Operación 16: n_operation = "01111"
        n_operation <= "01111";
        WAIT FOR 20 ns;

        -- Operación 17: n_operation = "10000"
        n_operation <= "10000";
        WAIT FOR 20 ns;

        -- Operación 18: n_operation = "10001"
        n_operation <= "10001";
        WAIT FOR 20 ns;

        -- Operación 19: n_operation = "10010"
        n_operation <= "10010";
        WAIT FOR 20 ns;

        -- Operación 20: n_operation = "10011"
        n_operation <= "10011";
        WAIT FOR 20 ns;

        -- Operación 21: n_operation = "10100"
        n_operation <= "10100";
        WAIT FOR 20 ns;

        -- Operación 22: n_operation = "10101"
        n_operation <= "10101";
        WAIT FOR 20 ns;

        -- Operación 23: n_operation = "10110"
        n_operation <= "10110";
        WAIT FOR 20 ns;

        -- Operación 24: n_operation = "10111"
        n_operation <= "10111";
        WAIT FOR 20 ns;

        -- Operación 25: n_operation = "11000"
        n_operation <= "11000";
        WAIT FOR 20 ns;

        -- Operación 26: n_operation = "11001"
        n_operation <= "11001";
        WAIT FOR 20 ns;

        -- Operación 27: n_operation = "11010"
        n_operation <= "11010";
        WAIT FOR 20 ns;

        ----------------------------------------------------------------
        -- Final de la simulación
        ----------------------------------------------------------------
        WAIT;
    END PROCESS stim;

END behavior;