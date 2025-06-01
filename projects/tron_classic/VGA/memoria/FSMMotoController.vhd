LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;
USE WORK.texturas.ALL;
USE WORK.ObjectsPackage.ALL;

ENTITY FSMMotoController IS
    GENERIC (
        STEP : INTEGER := 4
    );
    PORT (
        clk : IN uint01;
        rst : IN uint01;
        btn_up : IN uint01;
        btn_down : IN uint01;
        btn_left : IN uint01;
        btn_right : IN uint01;
        MotoInitial : IN MotoT;
        MotoOut : OUT MotoT;
        pos_x : OUT uint11;
        pos_y : OUT uint11
    );
END ENTITY;

ARCHITECTURE Behavioral OF FSMMotoController IS

    SIGNAL x_pos : uint11 := (OTHERS => '0');
    SIGNAL y_pos : uint11 := (OTHERS => '0');

    TYPE state IS (init, up, down, left, right);
    SIGNAL NextState, PrevState : state := right;

    -- Señales de flanco (anti-rebote)
    SIGNAL up_tick, down_tick, left_tick, right_tick : STD_LOGIC;

    -- Señal de reloj lento generada con anti_debouncing
    SIGNAL tick_lento : STD_LOGIC;

    CONSTANT MIN_X : INTEGER := 10;
    CONSTANT MAX_X : INTEGER := 740;
    CONSTANT MIN_Y : INTEGER := 70;
    CONSTANT MAX_Y : INTEGER := 530;

BEGIN

    -------------------------------------------------------------------------
    -- Anti-debouncing como tick lento (activado siempre)
    -------------------------------------------------------------------------
    Tick_Generator : ENTITY work.anti_debouncing
        PORT MAP(
            clk => clk,
            rst => rst,
            btn_in => '1', -- siempre activo
            signal_out => tick_lento
        );

    -------------------------------------------------------------------------
    -- Anti-rebote para los botones
    -------------------------------------------------------------------------
    AntiDB_Up : ENTITY work.anti_debouncing
        PORT MAP(clk => clk, rst => rst, btn_in => NOT btn_up, signal_out => up_tick);

    AntiDB_Down : ENTITY work.anti_debouncing
        PORT MAP(clk => clk, rst => rst, btn_in => NOT btn_down, signal_out => down_tick);

    AntiDB_Left : ENTITY work.anti_debouncing
        PORT MAP(clk => clk, rst => rst, btn_in => NOT btn_left, signal_out => left_tick);

    AntiDB_Right : ENTITY work.anti_debouncing
        PORT MAP(clk => clk, rst => rst, btn_in => NOT btn_right, signal_out => right_tick);

    -------------------------------------------------------------------------
    -- Registro del estado (mantiene la dirección actual)
    -------------------------------------------------------------------------
    StateMemory : PROCESS (rst, clk)
    BEGIN
        IF rst = '1' THEN
            PrevState <= right;
        ELSIF rising_edge(clk) THEN
            PrevState <= NextState;
        END IF;
    END PROCESS;

    -------------------------------------------------------------------------
    -- Cambio de dirección al presionar un botón
    -------------------------------------------------------------------------
    StateChange : PROCESS (PrevState, up_tick, down_tick, left_tick, right_tick)
    BEGIN
        -- Mantener dirección por defecto
        NextState <= PrevState;

        IF up_tick = '1' THEN
            NextState <= up;
        ELSIF down_tick = '1' THEN
            NextState <= down;
        ELSIF left_tick = '1' THEN
            NextState <= left;
        ELSIF right_tick = '1' THEN
            NextState <= right;
        END IF;
    END PROCESS;

    -------------------------------------------------------------------------
    -- Movimiento automático con tick lento
    -------------------------------------------------------------------------
    StateActions : PROCESS (clk, rst)
        VARIABLE x_int, y_int : INTEGER;
    BEGIN
        IF rst = '1' THEN
            x_pos <= MotoInitial.PosX;
            y_pos <= MotoInitial.PosY;
            MotoOut.Orientation <= "10"; -- Derecha por defecto
        ELSIF rising_edge(clk) THEN
            IF tick_lento = '1' THEN
                x_int := to_integer(unsigned(x_pos));
                y_int := to_integer(unsigned(y_pos));

                CASE PrevState IS
                    WHEN right =>
                        IF x_int < MAX_X THEN
                            x_int := x_int + STEP;
                            MotoOut.Orientation <= "10";
                        END IF;
                    WHEN left =>
                        IF x_int > MIN_X THEN
                            x_int := x_int - STEP;
                            MotoOut.Orientation <= "11";
                        END IF;
                    WHEN up =>
                        IF y_int > MIN_Y THEN
                            y_int := y_int - STEP;
                            MotoOut.Orientation <= "00";
                        END IF;
                    WHEN down =>
                        IF y_int < MAX_Y THEN
                            y_int := y_int + STEP;
                            MotoOut.Orientation <= "01";
                        END IF;
                    WHEN OTHERS =>
                        NULL;
                END CASE;

                x_pos <= STD_LOGIC_VECTOR(to_unsigned(x_int, 11));
                y_pos <= STD_LOGIC_VECTOR(to_unsigned(y_int, 11));
            END IF;
        END IF;
    END PROCESS;

    -------------------------------------------------------------------------
    -- Salidas
    -------------------------------------------------------------------------
    pos_x <= x_pos;
    pos_y <= y_pos;

END ARCHITECTURE;