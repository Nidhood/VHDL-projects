LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY parking_count_tb IS
END ENTITY;

ARCHITECTURE tb_arch OF parking_count_tb IS

    -- Señales de prueba
    SIGNAL clk_tb : STD_LOGIC := '0';
    SIGNAL rst_tb : STD_LOGIC := '1';
    SIGNAL sensor0_tb : STD_LOGIC := '0';
    SIGNAL sensor1_tb : STD_LOGIC := '0';
    SIGNAL car_enter_tb : STD_LOGIC := '0';
    SIGNAL car_exit_tb : STD_LOGIC := '0';
    SIGNAL parking_full_tb : STD_LOGIC := '0';
BEGIN

    -- Generación del reloj (20 ns por ciclo)
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk_tb <= '0';
            WAIT FOR 10 ns;
            clk_tb <= '1';
            WAIT FOR 10 ns;
        END LOOP;
    END PROCESS;

    -- Activación de reset
    rst_process : PROCESS
    BEGIN
        WAIT FOR 25 ns;
        rst_tb <= '0';
        WAIT;
    END PROCESS;

    -- DUT: FSM principal
    DUT_inst : ENTITY WORK.parking_count(parking_count_Arch)
        PORT MAP(
            clk => clk_tb,
            rst => rst_tb,
            sensor0 => sensor0_tb,
            sensor1 => sensor1_tb,
            car_enter => car_enter_tb,
            car_exit => car_exit_tb,
            parking_full => parking_full_tb
        );

    -- BIST: Generador de estímulos para sensores
    BIST_inst : ENTITY WORK.parking_count_bist
        PORT MAP(
            clk => clk_tb,
            rst => rst_tb,
            car_enter => car_enter_tb,
            car_exit => car_exit_tb,
            parking_full => parking_full_tb,
            s0 => sensor0_tb,
            s1 => sensor1_tb
        );

END ARCHITECTURE;