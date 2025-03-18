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
-- (Control instruction #1)   00     01     10     11        0000          0000
-- (Control instruction #2)   00     01     10     11        0000          1000
-- (Control instruction #3)   00     10     01     11        0000          0000
-- (Control instruction #4)   00     10     01     11        0000          1000
-- (Control instruction #5)   00     11     10     01        0000          0000
-- (Control instruction #6)   00     11     10     01        0000          1000
-- (Control instruction #7)   10     11     00     01        0000          1000
-- (Control instruction #8)   01     11     00     10        0000          1000
-- (Control instruction #9)   10     01     00     11        0000          1000
-- (Control instruction #10)  00     00     00     00        0101          0000
-- (Control instruction #11)  00     00     00     00        0011          0100
-- (Control instruction #12)  00     00     01     01        0000          1000
-- (Control instruction #13)  00     00     10     10        0000          1000
-- (Control instruction #14)  00     00     11     11        0000          1000
-- (Control instruction #15)  01     01     00     00        0000          1000
-- (Control instruction #16)  01     01     10     10        0000          1000
-- (Control instruction #17)  01     01     11     11        0000          1000
-- (Control instruction #18)  00     00     00     00        0111          0010
-- (Control instruction #19)  00     01     00     00        0001          0000
-- (Control instruction #20)  00     10     00     00        0001          0010
-- (Control instruction #21)  00     01     00     00        0001          0100
-- (Control instruction #22)  00     01     00     00        0001          0001
-- (Control instruction #23)  01     00     00     00        0001          0010
-- (Control instruction #24)  00     00     00     00        0010          0000
-- (Control instruction #25)  00     00     00     00        0010          0100
-- (Control instruction #26)  00     00     10     11        0100          0000
-- (Control instruction #27)  10     11     00     00        0011          1000
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
        sseg_4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Tercer digito
        number_A_sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Numero A en 7 segmentos
        number_B_sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Numero B en 7 segmentos
        number_C_sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Numero C en 7 segmentos
        number_D_sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- Numero D en 7 segmentos
    );

END ENTITY project_combined_arithmetic_operators;

ARCHITECTURE project_combined_arithmetic_operators_arch OF project_combined_arithmetic_operators IS

    -- Senales:
    SIGNAL control_instructions : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Senales de salida para los componentes de multiplicaciones:
    SIGNAL signal_1, signal_2 : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Senales de salida para los componentes de suma/resta:
    SIGNAL signal_aux_3, signal_aux_4 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL signal_cout_3, signal_cout_4 : STD_LOGIC;
    SIGNAL signal_3, signal_4 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_7, signal_8 : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Senales para potencia:
    SIGNAL signal_9 : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Senales para complemento a 2:
    SIGNAL A_aux_10 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_10 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_11 : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_12 : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Senales de salida para los componentes de desplazamiento a 1 hacia la izquierda (multipliacion por  2):
    SIGNAL signal_5, signal_6 : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Senales de salida para los muxes:
    SIGNAL mux_1_out, mux_2_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mux_3_out, mux_4_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mux_5_out, mux_6_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mux_7_out : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Senales de salida para los selectors:
    SIGNAL select_1_outX, select_1_outY, select_1_outZ : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL select_2_outX, select_2_outY : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL signal_response : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- Senales de salida para las respuestas finales para cada digito:
    SIGNAL first_digit_hex, first_digit_dec : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL second_digit_hex, second_digit_dec : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL third_digit_hex, third_digit_dec : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

    -- Look-Up table de las instrucciones para cada operacion:
    control_instructions <=
        "0001101100000000" WHEN n_operation = "00000" ELSE
        "0001101100000100" WHEN n_operation = "00001" ELSE
        "0010011100000000" WHEN n_operation = "00010" ELSE
        "0010011100000100" WHEN n_operation = "00011" ELSE
        "0011100100000000" WHEN n_operation = "00100" ELSE
        "0011100100000100" WHEN n_operation = "00101" ELSE
        "1011000100000100" WHEN n_operation = "00110" ELSE
        "0111001000000100" WHEN n_operation = "00111" ELSE
        "1001001100000100" WHEN n_operation = "01000" ELSE
        "0000000001010000" WHEN n_operation = "01001" ELSE
        "0001000010010000" WHEN n_operation = "01010" ELSE
        "0000010100000100" WHEN n_operation = "01011" ELSE
        "0000101000000100" WHEN n_operation = "01100" ELSE
        "0000111100000100" WHEN n_operation = "01101" ELSE
        "0101000000000100" WHEN n_operation = "01110" ELSE
        "0101101000000100" WHEN n_operation = "01111" ELSE
        "0101111100000100" WHEN n_operation = "10000" ELSE
        "0001000010000000" WHEN n_operation = "10001" ELSE
        "0000000100010000" WHEN n_operation = "10010" ELSE
        "0000000100010010" WHEN n_operation = "10011" ELSE
        "0000000100010100" WHEN n_operation = "10100" ELSE
        "0000000100010001" WHEN n_operation = "10101" ELSE
        "0000010000010010" WHEN n_operation = "10110" ELSE
        "0000000000100000" WHEN n_operation = "10111" ELSE
        "0000000000100100" WHEN n_operation = "11000" ELSE
        "0000101101000000" WHEN n_operation = "11001" ELSE
        "0000101100111000" WHEN n_operation = "11010" ELSE
        "0000000000000000"; -- Default case

    ------------------------------------------------------------
    --                 MUX(4:1): 1,2,3,4,5,6                  --
    ------------------------------------------------------------     
    MUX1 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(15),
            sel(0) => control_instructions(14),
            OUTPUT => mux_1_out
        );

    MUX2 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(13),
            sel(0) => control_instructions(12),
            OUTPUT => mux_2_out
        );

    MUX3 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(11),
            sel(0) => control_instructions(10),
            OUTPUT => mux_3_out
        );

    MUX4 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(9),
            sel(0) => control_instructions(8),
            OUTPUT => mux_4_out
        );

    MUX5 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(11),
            sel(0) => control_instructions(10),
            OUTPUT => mux_5_out
        );

    MUX6 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => A,
            B => B,
            C => C,
            D => D,
            sel(1) => control_instructions(9),
            sel(0) => control_instructions(8),
            OUTPUT => mux_6_out
        );

    MUX7 : ENTITY WORK.mux4_1_when_else(mux4_1_when_elseArch)
        PORT MAP(
            A => "0000",
            B => "0001",
            C => "0010",
            D => (OTHERS => '0'),
            sel => B(1 DOWNTO 0),
            OUTPUT => mux_7_out
        );

    ------------------------------------------------------------
    --                 Selectors 1,2,3,4                      --
    ------------------------------------------------------------ 
    select_1 : ENTITY WORK.mux6_2_when_else_1(mux6_2_when_else_1Arch)
        PORT MAP(
            signal1 => signal_1,
            signal2 => signal_2,
            signal3 => signal_3,
            signal4 => signal_4,
            signal5 => signal_5,
            signal6 => signal_6,
            sel(3) => control_instructions(7),
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
            sel(3) => control_instructions(7),
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
            signal9 => signal_9,
            signal11 => signal_11,
            signal12 => signal_12,
            sel(3) => control_instructions(7),
            sel(2) => control_instructions(6),
            sel(1) => control_instructions(5),
            sel(0) => control_instructions(4),
            OUTPUT => signal_response
        );

    A_aux_10 <= "000000" & A;
    select_4 : ENTITY WORK.mux2_1_when_else_4(mux2_1_when_else_4Arch)
        PORT MAP(
            signal9 => signal_9,
            signal10 => A_aux_10,
            sel(3) => control_instructions(7),
            sel(2) => control_instructions(6),
            sel(1) => control_instructions(5),
            sel(0) => control_instructions(4),
            OUTPUT => signal_12
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
            X => A,
            S => signal_5
        );

    bit_shift_left_2 : ENTITY work.bit_shift_left(bit_shift_left_arch)
        PORT MAP(
            X => B,
            S => signal_6
        );

    ------------------------------------------------------------
    --                       Potencia                         --
    ------------------------------------------------------------
    power : ENTITY work.power_3cases(no_if_for_arch)
        PORT MAP(
            X => A,
            Y => mux_7_out,
            S => signal_9
        );

    ------------------------------------------------------------
    --                    Complemento a 2                     --
    ------------------------------------------------------------

    two_complement : ENTITY work.complement2_10bits(ripple_adder)
        PORT MAP(
            X => signal_12,
            S => signal_11
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
    --                Bin to 7 Segment numbers                --
    ------------------------------------------------------------

    number_A : ENTITY work.hex_mux(hex_mux_arch)
        PORT MAP(
            x => A,
            sseg => number_A_sseg
        );

    number_B : ENTITY work.hex_mux(hex_mux_arch)
        PORT MAP(
            x => B,
            sseg => number_B_sseg
        );

    number_C : ENTITY work.hex_mux(hex_mux_arch)
        PORT MAP(
            x => C,
            sseg => number_C_sseg
        );

    number_D : ENTITY work.hex_mux(hex_mux_arch)
        PORT MAP(
            x => D,
            sseg => number_D_sseg
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