LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

ENTITY tb_project_combined_arithmetic_operators IS
END tb_project_combined_arithmetic_operators;

ARCHITECTURE behavior OF tb_project_combined_arithmetic_operators IS

    -- Declaración del componente a testear
    COMPONENT project_combined_arithmetic_operators IS
        PORT (
            n_operation : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            select_dec_or_hex : IN STD_LOGIC;
            A, B, C, D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sseg_1 : OUT STD_LOGIC;
            sseg_2, sseg_3, sseg_4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            binary_response : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            multiplier_response_1 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            multiplier_response_2 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            adder_substractor_response_1 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            adder_substractor_response_2 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            adder_substractor_response_3 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            adder_substractor_response_4 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            bit_shift_left_response_1 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            bit_shift_left_response_2 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            signal_aux_3_response : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            signal_aux_4_response : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            power_response : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;

    -- Señales de interconexión
    SIGNAL n_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL select_dec_or_hex : STD_LOGIC := '0';
    SIGNAL A, B, C, D : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sseg_1 : STD_LOGIC;
    SIGNAL sseg_2, sseg_3, sseg_4 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL binary_response : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL multiplier_response_1 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL multiplier_response_2 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL adder_substractor_response_1 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL adder_substractor_response_2 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL adder_substractor_response_3 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL adder_substractor_response_4 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL bit_shift_left_response_1 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL bit_shift_left_response_2 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_aux_3_response : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL signal_aux_4_response : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL power_response : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN

    -- Instanciación de la entidad a testear
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
        binary_response => binary_response,
        multiplier_response_1 => multiplier_response_1,
        multiplier_response_2 => multiplier_response_2,
        adder_substractor_response_1 => adder_substractor_response_1,
        adder_substractor_response_2 => adder_substractor_response_2,
        adder_substractor_response_3 => adder_substractor_response_3,
        adder_substractor_response_4 => adder_substractor_response_4,
        bit_shift_left_response_1 => bit_shift_left_response_1,
        bit_shift_left_response_2 => bit_shift_left_response_2,
        signal_aux_3_response => signal_aux_3_response,
        signal_aux_4_response => signal_aux_4_response,
        power_response => power_response
    );

    stim : PROCESS
        VARIABLE result_int : INTEGER;
    BEGIN
        ---------------------------------------------------------------------
        -- Se fijan los valores de entrada:
        -- Se asigna:
        --   A = 1, B = 2, C = 3, D = 4
        -- De modo que, por ejemplo:
        --   (A*B) = 1*2 = 2, (C*D) = 3*4 = 12, y 2+12 = 14.
        ---------------------------------------------------------------------
        A <= "0001"; -- 1
        B <= "0010"; -- 2
        C <= "0011"; -- 3
        D <= "0100"; -- 4
        select_dec_or_hex <= '0'; -- Salida en decimal

        ---------------------------------------------------------------------
        -- Se asume que la LUT dentro de UUT asigna los siguientes códigos:
        --
        -- Op1:  n_operation = "00000"  => (A*B) + (C*D)          = 14
        -- Op2:  n_operation = "00001"  => (A*B) - (C*D)          = -10
        -- Op3:  n_operation = "00010"  => (A*C) + (B*D)          = 11
        -- Op4:  n_operation = "00011"  => (A*C) - (B*D)          = -5
        -- Op5:  n_operation = "00100"  => (A*D) + (C*B)          = 10
        -- Op6:  n_operation = "00101"  => (A*D) - (C*B)          = -2
        -- Op7:  n_operation = "00110"  => (C*D) - (A*B)          = 10
        -- Op8:  n_operation = "00111"  => (B*D) - (A*C)          = 5
        -- Op9:  n_operation = "01000"  => (C*B) - (A*D)          = 2
        -- Op10: n_operation = "01001"  => A^B                    = 1
        -- Op11: n_operation = "01010"  => -(A^B)                 = -1
        -- Op12: n_operation = "01011"  => A^2 - B^2              = -3
        -- Op13: n_operation = "01100"  => A^2 - C^2              = -8
        -- Op14: n_operation = "01101"  => A^2 - D^2              = -15
        -- Op15: n_operation = "01110"  => B^2 - A^2              = 3
        -- Op16: n_operation = "01111"  => B^2 - C^2              = -5
        -- Op17: n_operation = "10000"  => B^2 - D^2              = -12
        -- Op18: n_operation = "10001"  => -A                     = -1
        -- Op19: n_operation = "10010"  => A+B+C+D                = 10
        -- Op20: n_operation = "10011"  => A-B+C+D                = 6
        -- Op21: n_operation = "10100"  => A+B-C+D                = 4
        -- Op22: n_operation = "10101"  => A+B+C-D                = 2
        -- Op23: n_operation = "10110"  => B-A+C+D                = 8
        -- Op24: n_operation = "10111"  => 2A+2B                  = 6
        -- Op25: n_operation = "11000"  => 2A-2B                  = -2
        -- Op26: n_operation = "11001"  => (2A+2B)+(C+D)          = 13  (pero en este caso se espera 18 con (C*D) en vez de C+D)
        -- Op27: n_operation = "11010"  => (C*D) - (A^2+2B)       = 7
        ---------------------------------------------------------------------

        -- Operación 1:
        n_operation <= "00000";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op1: (A*B)+(C*D) = " & INTEGER'image(result_int) & " (expected 14)";

        -- Operación 2:
        n_operation <= "00001";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op2: (A*B)-(C*D) = " & INTEGER'image(result_int) & " (expected -10)";

        -- Operación 3:
        n_operation <= "00010";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op3: (A*C)+(B*D) = " & INTEGER'image(result_int) & " (expected 11)";

        -- Operación 4:
        n_operation <= "00011";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op4: (A*C)-(B*D) = " & INTEGER'image(result_int) & " (expected -5)";

        -- Operación 5:
        n_operation <= "00100";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op5: (A*D)+(C*B) = " & INTEGER'image(result_int) & " (expected 10)";

        -- Operación 6:
        n_operation <= "00101";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op6: (A*D)-(C*B) = " & INTEGER'image(result_int) & " (expected -2)";

        -- Operación 7:
        n_operation <= "00110";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op7: (C*D)-(A*B) = " & INTEGER'image(result_int) & " (expected 10)";

        -- Operación 8:
        n_operation <= "00111";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op8: (B*D)-(A*C) = " & INTEGER'image(result_int) & " (expected 5)";

        -- Operación 9:
        n_operation <= "01000";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op9: (C*B)-(A*D) = " & INTEGER'image(result_int) & " (expected 2)";

        -- Operación 10:
        n_operation <= "01001";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op10: A^B = " & INTEGER'image(result_int) & " (expected 1)";

        -- Operación 11:
        n_operation <= "01010";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op11: -(A^B) = " & INTEGER'image(result_int) & " (expected -1)";

        -- Operación 12:
        n_operation <= "01011";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op12: A^2-B^2 = " & INTEGER'image(result_int) & " (expected -3)";

        -- Operación 13:
        n_operation <= "01100";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op13: A^2-C^2 = " & INTEGER'image(result_int) & " (expected -8)";

        -- Operación 14:
        n_operation <= "01101";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op14: A^2-D^2 = " & INTEGER'image(result_int) & " (expected -15)";

        -- Operación 15:
        n_operation <= "01110";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op15: B^2-A^2 = " & INTEGER'image(result_int) & " (expected 3)";

        -- Operación 16:
        n_operation <= "01111";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op16: B^2-C^2 = " & INTEGER'image(result_int) & " (expected -5)";

        -- Operación 17:
        n_operation <= "10000";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op17: B^2-D^2 = " & INTEGER'image(result_int) & " (expected -12)";

        -- Operación 18:
        n_operation <= "10001";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op18: -A = " & INTEGER'image(result_int) & " (expected -1)";

        -- Operación 19:
        n_operation <= "10010";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op19: A+B+C+D = " & INTEGER'image(result_int) & " (expected 10)";

        -- Operación 20:
        n_operation <= "10011";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op20: A-B+C+D = " & INTEGER'image(result_int) & " (expected 6)";

        -- Operación 21:
        n_operation <= "10100";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op21: A+B-C+D = " & INTEGER'image(result_int) & " (expected 4)";

        -- Operación 22:
        n_operation <= "10101";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op22: A+B+C-D = " & INTEGER'image(result_int) & " (expected 2)";

        -- Operación 23:
        n_operation <= "10110";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op23: B-A+C+D = " & INTEGER'image(result_int) & " (expected 8)";

        -- Operación 24:
        n_operation <= "10111";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op24: 2A+2B = " & INTEGER'image(result_int) & " (expected 6)";

        -- Operación 25:
        n_operation <= "11000";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op25: 2A-2B = " & INTEGER'image(result_int) & " (expected -2)";

        -- Operación 26:
        n_operation <= "11001";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op26: (2A+2B)+(C*D) = " & INTEGER'image(result_int) & " (expected 18)";

        -- Operación 27:
        n_operation <= "11010";
        WAIT FOR 20 ns;
        result_int := to_integer(signed(binary_response));
        REPORT "Op27: (C*D)-(A^2+2B) = " & INTEGER'image(result_int) & " (expected 7)";

        WAIT; -- Finaliza la simulación
    END PROCESS stim;

END behavior;