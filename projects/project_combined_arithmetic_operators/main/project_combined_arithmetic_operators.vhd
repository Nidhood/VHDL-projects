------------------------------------------------------------------------------------------
--                                                                                      --
--                              Jeronimo Rueda                                          --
--                              Andres David Villalobos Torres                          --
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project:                   project_combined_arithmetic_operators                    --                                                        --
--  Date:                      16/03/2025                                               --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------------------------------------
-- Intructions:
--                            Mux#1  Mux#2  Mux#3  Mux#4     Instruccion  Adder/Substracter               
-- (Control instruction #1)   00     01     10     11        000          0000
-- (Control instruction #2)   00     01     10     11        000          1000
-- (Control instruction #3)   00     10     01     11        000          0000
-- (Control instruction #4)   00     10     01     11        000          1000
-- (Control instruction #5)   00     11     10     01        000          0000
-- (Control instruction #6)   00     11     10     01        000          1000
-- (Control instruction #7)   10     11     00     01        000          1000
-- (Control instruction #8)   01     11     00     10        000          1000
-- (Control instruction #9)   10     01     00     11        000          1000
-- (Control instruction #10)  00     00     00     00        101          0000
-- (Control instruction #11)  00     00     00     00        011          0100
-- (Control instruction #12)  00     00     01     01        000          1000
-- (Control instruction #13)  00     00     10     10        000          1000
-- (Control instruction #14)  00     00     11     11        000          1000
-- (Control instruction #15)  01     01     00     00        000          1000
-- (Control instruction #16)  01     01     10     10        000          1000
-- (Control instruction #17)  01     01     11     11        000          1000
-- (Control instruction #18)  00     00     00     00        111          0010
-- (Control instruction #19)  00     01     00     00        001          0000
-- (Control instruction #20)  00     10     00     00        001          0010
-- (Control instruction #21)  00     01     00     00        001          0100
-- (Control instruction #22)  00     01     00     00        001          0001
-- (Control instruction #23)  01     00     00     00        001          0010
-- (Control instruction #24)  00     00     00     00        010          0000
-- (Control instruction #25)  00     00     00     00        010          0100
-- (Control instruction #26)  00     00     10     11        100          0000
-- (Control instruction #27)  10     11     00     00        011          1000
------------------------------------------------------------------------------------------

ENTITY project_combined_arithmetic_operators IS

    PORT (

        -- Entradas:
        n_operation : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        select_dec_or_hex : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        C : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        -- Salidas:
        sseg_1 : OUT STD_LOGIC; -- Signo 
        sseg_2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Primer digito
        sseg_3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Segundo digito
        sseg_4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- Tercer digito
    );

END ENTITY project_combined_arithmetic_operators;

ARCHITECTURE project_combined_arithmetic_operators_arch OF project_combined_arithmetic_operators IS

    -- Senales:
    SIGNAL control_instructions : STD_LOGIC_VECTOR(14 DOWNTO 0);

    -- Senales de salida para los componentes de multiplicaciones:
    SIGNAL signal_1 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_2 : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Senales de salida para los componentes de suma/resta:
    SIGNAL signal_aux_3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL signal_aux_4 : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL signal_cout_3 : STD_LOGIC;
    SIGNAL signal_cout_4 : STD_LOGIC;

    SIGNAL signal_3 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_4 : STD_LOGIC_VECTOR(9 DOWNTO 0);

    SIGNAL signal_7 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_8 : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Senales de salida para los componentes de desplazamiento a 1 hacia la izquierda (multipliacion por  2):
    SIGNAL signal_5 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_6 : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Senales de salida para los muxes:
    SIGNAL mux_1_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mux_2_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mux_3_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mux_4_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mux_5_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mux_6_out : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Senales de salida para los selectors:
    SIGNAL select_1_outX : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL select_1_outY : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL select_2_outX : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL select_2_outY : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_response : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Senales de salida para las respuestas finales para cada digito:
    SIGNAL first_digit_hex : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL first_digit_dec : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL second_digit_hex : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL second_digit_dec : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL third_digit_hex : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL third_digit_dec : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

    -- Look-Up table de las instrucciones para cada operacion:
    control_instructions <=
        "000110110000000" WHEN n_operation = "00000" ELSE
        "000110110001000" WHEN n_operation = "00001" ELSE
        "001001110000000" WHEN n_operation = "00010" ELSE
        "001001110001000" WHEN n_operation = "00011" ELSE
        "001110010000000" WHEN n_operation = "00100" ELSE
        "001110010001000" WHEN n_operation = "00101" ELSE
        "101100010001000" WHEN n_operation = "00110" ELSE
        "011100100001000" WHEN n_operation = "00111" ELSE
        "100100110001000" WHEN n_operation = "01000" ELSE
        "000000001010000" WHEN n_operation = "01001" ELSE
        "000000000110100" WHEN n_operation = "01010" ELSE
        "000001010001000" WHEN n_operation = "01011" ELSE
        "000010100001000" WHEN n_operation = "01100" ELSE
        "000011110001000" WHEN n_operation = "01101" ELSE
        "010100000001000" WHEN n_operation = "01110" ELSE
        "010110100001000" WHEN n_operation = "01111" ELSE
        "010111110001000" WHEN n_operation = "10000" ELSE
        "000000001110010" WHEN n_operation = "10001" ELSE
        "000100000010000" WHEN n_operation = "10010" ELSE
        "001000000010010" WHEN n_operation = "10011" ELSE
        "000100000010100" WHEN n_operation = "10100" ELSE
        "000100000010001" WHEN n_operation = "10101" ELSE
        "010000000010010" WHEN n_operation = "10110" ELSE
        "000000000100000" WHEN n_operation = "10111" ELSE
        "000000000100100" WHEN n_operation = "11000" ELSE
        "000010111000000" WHEN n_operation = "11001" ELSE
        "101100000111000" WHEN n_operation = "11010" ELSE
        "000000000000000"; -- Default case

    ------------------------------------------------------------
    --                 MUX(4:1): 1,2,3,4,5,6                  --
    ------------------------------------------------------------     

    MUX1 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(14),
            sel(0) => control_instructions(13),
            OUTPUT => mux_1_out
        );

    MUX2 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(12),
            sel(0) => control_instructions(11),
            OUTPUT => mux_2_out
        );

    MUX3 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(10),
            sel(0) => control_instructions(9),
            OUTPUT => mux_3_out
        );

    MUX4 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(8),
            sel(0) => control_instructions(7),
            OUTPUT => mux_4_out
        );

    MUX5 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(10),
            sel(0) => control_instructions(9),
            OUTPUT => mux_5_out
        );

    MUX6 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(8),
            sel(0) => control_instructions(7),
            OUTPUT => mux_6_out
        );

    ------------------------------------------------------------
    --                   Multiplicaciones                     --
    ------------------------------------------------------------

    full_multiplier_1 : ENTITY work.Multiplier(MultiplierArch)
        PORT MAP(
            x => mux_1_out,
            y => mux_2_out,
            s => signal_1(7 DOWNTO 0)
        );

    signal_1(9 DOWNTO 8) <= "00";

    full_multiplier_2 : ENTITY work.Multiplier(MultiplierArch)
        PORT MAP(
            x => mux_3_out,
            y => mux_4_out,
            s => signal_2(7 DOWNTO 0)
        );

    signal_2(9 DOWNTO 8) <= "00";

    ------------------------------------------------------------
    --                   Sumas y restas                       --
    ------------------------------------------------------------

    full_adder_substractor_1 : ENTITY work.FULL_ADDER_SUBSTRACTOR_10(STRUCT)
        PORT MAP(
            OP => control_instructions(3),
            A => select_2_outX,
            B => select_2_outY,
            R => signal_8,
            COUT => OPEN
        );

    full_adder_substractor_2 : ENTITY work.FULL_ADDER_SUBSTRACTOR_10(STRUCT)
        PORT MAP(
            OP => control_instructions(2),
            A => select_1_outX,
            B => select_1_outY,
            R => signal_7,
            COUT => OPEN
        );

    full_adder_substractor_3 : ENTITY work.FULL_ADDER_SUBSTRACTOR_4(STRUCT)
        PORT MAP(
            OP => control_instructions(1),
            A => mux_5_out,
            B => mux_6_out,
            R => signal_aux_3,
            CARRY => signal_cout_3,
            OVERFLOW => OPEN
        );

    Sign_Extended_1 : ENTITY work.S_ext(S_ext_Arch)
        PORT MAP(
            S => signal_aux_3,
            C => signal_cout_3,
            OP => control_instructions(1),
            R => signal_3
        );

    full_adder_substractor_4 : ENTITY work.FULL_ADDER_SUBSTRACTOR_4(STRUCT)
        PORT MAP(
            OP => control_instructions(0),
            A => C (3 DOWNTO 0),
            B => D (3 DOWNTO 0),
            R => signal_aux_4,
            CARRY => signal_cout_4,
            OVERFLOW => OPEN
        );

    Sign_Extended_2 : ENTITY work.S_ext(S_ext_Arch)
        PORT MAP(
            S => signal_aux_4,
            C => signal_cout_4,
            OP => control_instructions(0),
            R => signal_4
        );

    ------------------------------------------------------------
    --                Multipliacion por 2                     --
    ------------------------------------------------------------

    bit_shift_left_1 : ENTITY work.bit_shift_left(bit_shift_left_arch)
        PORT MAP(
            X => A (3 DOWNTO 0),
            S => signal_5
        );

    bit_shift_left_2 : ENTITY work.bit_shift_left(bit_shift_left_arch)
        PORT MAP(
            X => B (3 DOWNTO 0),
            S => signal_6
        );

    ------------------------------------------------------------
    --                   Selectors 1,2,3                      --
    ------------------------------------------------------------ 

    select_1 : ENTITY WORK.mux6_2_when_else_1(mux6_2_when_else_1Arch)
        PORT MAP(
            signal1 => signal_1,
            signal2 => signal_2,
            signal3 => signal_3,
            signal4 => signal_4,
            signal5 => signal_5,
            signal6 => signal_6,
            sel(2) => control_instructions(6),
            sel(1) => control_instructions(5),
            sel(0) => control_instructions(4),
            X => select_1_outX,
            Y => select_1_outY
        );

    select_2 : ENTITY WORK.mux6_2_when_else_2(mux6_2_when_else_2Arch)
        PORT MAP(
            signal2 => signal_2,
            signal7 => signal_7,
            sel(2) => control_instructions(6),
            sel(1) => control_instructions(5),
            sel(0) => control_instructions(4),
            X => select_2_outX,
            Y => select_2_outY
        );

    select_3 : ENTITY WORK.mux4_1_select_out(mux4_1_select_outArch)
        PORT MAP(
            signal3 => signal_3,
            signal7 => signal_7,
            signal1 => signal_1,
            signal8 => signal_8,
            sel(2) => control_instructions(6),
            sel(1) => control_instructions(5),
            sel(0) => control_instructions(4),
            OUTPUT => signal_response
        );

    ------------------------------------------------------------
    --                Bin to digits                           --
    ------------------------------------------------------------
    bin_to_digits : ENTITY WORK.bin_to_digits(bin_to_digits_Arch)
        PORT MAP(
            R => signal_response,
            B1 => first_digit_dec,
            B2 => second_digit_dec,
            B3 => third_digit_dec,
            H1 => first_digit_hex,
            H2 => second_digit_hex,
            H3 => third_digit_hex,
            S => sseg_1
        );

    ------------------------------------------------------------
    --                Bin to 7 Segment                        --
    ------------------------------------------------------------
    bin_to_7_seg_1 : ENTITY WORK.bin_to_7seg(bin_to_7seg_arch)
        PORT MAP(
            decimal => first_digit_dec,
            hexadecimal => first_digit_hex,
            in_sel => select_dec_or_hex,
            sseg => sseg_2
        );

    bin_to_7_seg_2 : ENTITY WORK.bin_to_7seg(bin_to_7seg_arch)
        PORT MAP(
            decimal => second_digit_dec,
            hexadecimal => second_digit_hex,
            in_sel => select_dec_or_hex,
            sseg => sseg_3
        );

    bin_to_7_seg_3 : ENTITY WORK.bin_to_7seg(bin_to_7seg_arch)
        PORT MAP(
            decimal => third_digit_dec,
            hexadecimal => third_digit_hex,
            in_sel => select_dec_or_hex,
            sseg => sseg_4
        );

END project_combined_arithmetic_operators_arch;