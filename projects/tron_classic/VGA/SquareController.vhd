LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;
USE WORK.SquarePkg.ALL;


ENTITY SquareController IS
    GENERIC (
        MAX_X : INTEGER := 799; -- máximo X (ancho de pantalla - 1)
        MAX_Y : INTEGER := 599; -- máximo Y (alto de pantalla - 1)
        STEP  : INTEGER := 4    -- desplazamiento por pulsación
    );
    PORT (
        clk     : IN uint01;
        rst     : IN uint01;
        btn_up    : IN uint01;
        btn_down  : IN uint01;
        btn_left  : IN uint01;
        btn_right : IN uint01;
        pos_x   : OUT INTEGER;
        pos_y   : OUT INTEGER
    );
END ENTITY;


ARCHITECTURE Behavioral OF SquareController IS
    SIGNAL x_pos : INTEGER := 400;
    SIGNAL y_pos : INTEGER := 300;
BEGIN
    PROCESS(clk, rst)
    BEGIN
        IF rst = '1' THEN
            x_pos <= 400;
            y_pos <= 300;
        ELSIF rising_edge(clk) THEN
            -- Movimiento horizontal
            IF btn_left = '0' AND x_pos > STEP THEN
                x_pos <= x_pos - STEP;
            ELSIF btn_right = '0' AND x_pos < (MAX_X - STEP) THEN
                x_pos <= x_pos + STEP;
            END IF;

            -- Movimiento vertical
            IF btn_up = '0' AND y_pos > STEP THEN
                y_pos <= y_pos - STEP;
            ELSIF btn_down = '0' AND y_pos < (MAX_Y - STEP) THEN
                y_pos <= y_pos + STEP;
            END IF;
        END IF;
    END PROCESS;

    pos_x <= x_pos;
    pos_y <= y_pos;
END ARCHITECTURE;

