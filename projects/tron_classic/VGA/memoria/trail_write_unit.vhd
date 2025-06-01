LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.BasicPackage.ALL;

ENTITY trail_write_unit IS
    PORT (
        clk, rst : IN uint01;
        cur_x, cur_y : IN uint11;
        wr_en : OUT uint01;
        wr_x, wr_y : OUT uint11
    );
END;

ARCHITECTURE behavior OF trail_write_unit IS
    SIGNAL prev_x, prev_y : uint11 := (OTHERS => '0');
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF rst = '1' THEN
                wr_en <= '0';
                prev_x <= cur_x;
                prev_y <= cur_y;
            ELSE
                wr_en <= '0';
                IF cur_x /= prev_x OR cur_y /= prev_y THEN
                    wr_en <= '1';
                    wr_x <= prev_x;
                    wr_y <= prev_y;
                END IF;
                prev_x <= cur_x;
                prev_y <= cur_y;
            END IF;
        END IF;
    END PROCESS;
END behavior;