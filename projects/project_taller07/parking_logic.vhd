

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.ALL;

--******************************************************--
-- Comentarios: Este código es de una maquina de estados finitos que maneja la lógica de 
-- un parqueadero por medio de dos sensores. Con estos dos sensores se puede detectar la 
-- secuencia cuando un carro esta saliendo o entrando, de esta manera se maneja el cupo 
-- máximo del parqueadero que son 9 cupos.
--******************************************************--

ENTITY parking_count IS

    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        sensor0 : IN STD_LOGIC;
        sensor1 : IN STD_LOGIC;
        car_enter : OUT STD_LOGIC;
        car_exit : OUT STD_LOGIC;
        --car_count_b : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        --car_count_h : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        parking_full : OUT STD_LOGIC
    );

END ENTITY parking_count;

ARCHITECTURE parking_count_Arch OF parking_count IS

    TYPE state IS (init, e1, e2, e3, s1, s2, s3);

    SIGNAL NextState, PrevState : state;
    SIGNAL car_count : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

    -- Señales para temporizador universal
    SIGNAL car_enter_enable : STD_LOGIC := '0';
    SIGNAL car_exit_enable : STD_LOGIC := '0';
    SIGNAL car_enter_done : STD_LOGIC;
    SIGNAL car_exit_done : STD_LOGIC;
BEGIN

    --******************************************************--
    -- 
    -- 
    -- 
    --******************************************************--

    StateMemory : PROCESS (rst, Clk)
    BEGIN

        IF (rst = '1') THEN

            PrevState <= init;

        ELSIF (RISING_EDGE(Clk)) THEN
            PrevState <= NextState;

        END IF;

    END PROCESS StateMemory;
    --=========================
    -- INSTANCIA DEL CONTADOR UNIVERSAL PARA car_enter
    --=========================
    CarEnter_Timer : ENTITY work.univ_bin_counter
        GENERIC MAP(N => 3)
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => car_enter_enable,
            syn_clr => '0',
            load => '0',
            up => '1',
            d => (OTHERS => '0'),
            max_val => "101", -- 5 ciclos
            max_tick => car_enter_done,
            min_tick => OPEN,
            counter => OPEN
        );

    --=========================
    -- INSTANCIA DEL CONTADOR UNIVERSAL PARA car_exit
    --=========================
    CarExit_Timer : ENTITY work.univ_bin_counter
        GENERIC MAP(N => 3)
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => car_exit_enable,
            syn_clr => '0',
            load => '0',
            up => '1',
            d => (OTHERS => '0'),
            max_val => "101",
            max_tick => car_exit_done,
            min_tick => OPEN,
            counter => OPEN
        );

    StateChange : PROCESS (PrevState, sensor0, sensor1)
    BEGIN

        CASE PrevState IS
                ----------------------------------------------------------
            WHEN init =>

                IF (sensor0 = '1' AND sensor1 = '0' AND car_count /= "1001") THEN
                    NextState <= e1;

                ELSIF (sensor0 = '0' AND sensor1 = '1') THEN
                    NextState <= s1;
                ELSE
                    NextState <= init;

                END IF;
                ----------------------------------------------------------
            WHEN e1 =>

                IF (sensor0 = '1' AND sensor1 = '0') THEN
                    NextState <= e1;
                ELSIF (sensor0 = '1' AND sensor1 = '1') THEN
                    NextState <= e2;
                ELSE
                    NextState <= init;
                END IF;
                ----------------------------------------------------------
            WHEN e2 =>

                IF (sensor0 = '1' AND sensor1 = '1') THEN
                    NextState <= e2;
                ELSIF (sensor0 = '0' AND sensor1 = '1') THEN
                    NextState <= e3;
                ELSE
                    NextState <= init;
                END IF;

                ----------------------------------------------------------
            WHEN e3 =>
                IF (sensor0 = '0' AND sensor1 = '0') THEN
                    IF car_enter_done = '0' THEN
                        car_enter_enable <= '1';
                    ELSE
                        car_enter_enable <= '0'; -- apagar cuando termina
                    END IF;
                    car_count <= STD_LOGIC_VECTOR(unsigned(car_count) + 1);
                    NextState <= init;
                ELSE
                    NextState <= e3;
                END IF;
                ----------------------------------------------------------
            WHEN s1 =>

                IF (sensor0 = '0' AND sensor1 = '1') THEN
                    NextState <= s1;
                ELSIF (sensor0 = '1' AND sensor1 = '1') THEN
                    NextState <= s2;
                ELSE
                    NextState <= init;
                END IF;
                ----------------------------------------------------------
            WHEN s2 =>

                IF (sensor0 = '1' AND sensor1 = '1') THEN
                    NextState <= s2;
                ELSIF (sensor0 = '1' AND sensor1 = '0') THEN
                    NextState <= s3;
                ELSE
                    NextState <= init;
                END IF;
                ----------------------------------------------------------
            WHEN s3 =>

                IF (sensor0 = '0' AND sensor1 = '0') THEN
                    IF car_exit_done = '0' THEN
                        car_exit_enable <= '1';
                    ELSE
                        car_exit_enable <= '0';
                    END IF;
                    car_count <= STD_LOGIC_VECTOR(unsigned(car_count) - 1);
                    NextState <= init;
                ELSE
                    NextState <= s3;

                END IF;
                ----------------------------------------------------------
        END CASE;

    END PROCESS StateChange;
    car_enter <= '1' WHEN car_enter_enable = '1' ELSE
        '0';
    car_exit <= '1' WHEN car_exit_enable = '1' ELSE
        '0';
    parking_full <= '1' WHEN car_count = "1001" ELSE
        '0';

    --******************************************************--
    -- 
    -- Summon This Block:
    -- 
    --******************************************************--
    --BlockN: ENTITY WORK.StateMachine 
    --GENERIC MAP(GenericVar => #
    --              )
    --PORT MAP      (Sig => SLV,
    --                Sig => SLV,
    --                Sig => SLV,
    --                Sig => SLV
    --              );
    --******************************************************--

END parking_count_Arch;