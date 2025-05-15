LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.BasicPackage.ALL; -- Asegúrate de que esta contenga uint01, uint10, etc.

ENTITY FSMMotoController IS
    GENERIC (
        STEP  : INTEGER := 4    -- Desplazamiento por pulsación
    );
    PORT (
        clk       : IN  uint01;
        rst       : IN  uint01;
        btn_up    : IN  uint01;
        btn_down  : IN  uint01;
        btn_left  : IN  uint01;
        btn_right : IN  uint01;
        pos_x     : OUT uint10;
        pos_y     : OUT uint10
    );
END ENTITY;

ARCHITECTURE Behavioral OF FSMMotoController IS

    SIGNAL x_pos : uint10 := std_logic_vector(to_unsigned(400, 10));
    SIGNAL y_pos : uint10 := std_logic_vector(to_unsigned(300, 10));

    TYPE state IS (init, up, down, left, right);
    SIGNAL NextState, PrevState : state;

    SIGNAL up_tick, down_tick, left_tick, right_tick : STD_LOGIC;
	 
	 CONSTANT MIN_X : INTEGER := 20;
	 CONSTANT MAX_X : INTEGER := 740;  -- 780-40
	 CONSTANT MIN_Y : INTEGER := 100;
	 CONSTANT MAX_Y : INTEGER := 540;  -- 580-40

BEGIN

    -- Anti-rebote para los botones
    AntiDB_Up : ENTITY work.anti_debouncing
        PORT MAP(clk => clk, rst => rst, btn_in => NOT btn_up, signal_out => up_tick);

    AntiDB_Down : ENTITY work.anti_debouncing
        PORT MAP(clk => clk, rst => rst, btn_in => NOT btn_down, signal_out => down_tick);

    AntiDB_Left : ENTITY work.anti_debouncing
        PORT MAP(clk => clk, rst => rst, btn_in => NOT btn_left, signal_out => left_tick);

    AntiDB_Right : ENTITY work.anti_debouncing
        PORT MAP(clk => clk, rst => rst, btn_in => NOT btn_right, signal_out => right_tick);

    -- Registro de estado
    StateMemory: PROCESS (rst, clk)
    BEGIN
        IF rst = '1' THEN
            PrevState <= init;
        ELSIF rising_edge(clk) THEN
            PrevState <= NextState;
        END IF;
    END PROCESS;

    -- Lógica de transición de estado
    StateChange: PROCESS (PrevState, up_tick, down_tick, right_tick, left_tick, x_pos, y_pos)
    BEGIN
        NextState <= init;  -- Por defecto

        CASE PrevState IS
            WHEN init =>
                IF up_tick = '1' AND to_integer(unsigned(y_pos)) > STEP THEN
                    NextState <= up;
                ELSIF down_tick = '1' AND to_integer(unsigned(y_pos)) < MAX_Y - STEP THEN
                    NextState <= down;
                ELSIF right_tick = '1' AND to_integer(unsigned(x_pos)) < MAX_X - STEP THEN
                    NextState <= right;
                ELSIF left_tick = '1' AND to_integer(unsigned(x_pos)) > STEP THEN
                    NextState <= left;
                END IF;
            WHEN OTHERS =>
                NextState <= init;
        END CASE;
    END PROCESS;

    -- Actualización de posición
    StateActions: PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            x_pos <= std_logic_vector(to_unsigned(400, 10));
            y_pos <= std_logic_vector(to_unsigned(300, 10));
        ELSIF rising_edge(clk) THEN
            CASE NextState IS
                WHEN up =>
                    IF to_integer(unsigned(y_pos)) > MIN_Y THEN
                        y_pos <= std_logic_vector(unsigned(y_pos) - STEP);
                    END IF;
                WHEN down =>
                    IF to_integer(unsigned(y_pos)) < MAX_Y - STEP THEN
                        y_pos <= std_logic_vector(unsigned(y_pos) + STEP);
                    END IF;
                WHEN left =>
                    IF to_integer(unsigned(x_pos)) > MIN_X THEN
                        x_pos <= std_logic_vector(unsigned(x_pos) - STEP);
                    END IF;
                WHEN right =>
                    IF to_integer(unsigned(x_pos)) < MAX_X THEN
                        x_pos <= std_logic_vector(unsigned(x_pos) + STEP);
                    END IF;
                WHEN OTHERS =>
                    NULL;
            END CASE;
        END IF;
    END PROCESS;

    -- Salidas
    pos_x <= x_pos;
    pos_y <= y_pos;

END ARCHITECTURE;
