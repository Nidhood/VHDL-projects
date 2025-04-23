LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fifo_ctrl IS
    GENERIC (ADDR_WIDTH : NATURAL := 4);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        rd : IN STD_LOGIC;
        wr : IN STD_LOGIC;
        empty : OUT STD_LOGIC;
        full : OUT STD_LOGIC;
        w_addr : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
        r_addr : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
        r_addr_next : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF fifo_ctrl IS
    TYPE State IS (Idle, escr, Lect, RdRw);
    SIGNAL w_ptr_reg, w_ptr_next, w_ptr_succ : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    SIGNAL r_ptr_reg, r_ptr_next, r_ptr_succ : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    SIGNAL full_reg, full_next : STD_LOGIC;
    SIGNAL empty_reg, empty_next : STD_LOGIC;
    SIGNAL w_op : State;

    SIGNAL Temp : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
    -- Registro de los punteros de lectura y escritura
    PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            w_ptr_reg <= (OTHERS => '0');
            r_ptr_reg <= (OTHERS => '0');
            full_reg <= '0';
            empty_reg <= '1';
        ELSIF (rising_edge(clk)) THEN
            w_ptr_reg <= w_ptr_next;
            r_ptr_reg <= r_ptr_next;
            full_reg <= full_next;
            empty_reg <= empty_next;
        END IF;
    END PROCESS;

    w_ptr_succ <= STD_LOGIC_VECTOR(unsigned(w_ptr_reg) + 1);
    r_ptr_succ <= STD_LOGIC_VECTOR(unsigned(r_ptr_reg) + 1);

    -- Logica de actualizacion de los punteros
    Temp <= (wr & rd);
    WITH Temp SELECT
        w_op <= IDLE WHEN "00",
        escr WHEN "10",
        Lect WHEN "01",
        RdRw WHEN OTHERS;

    PROCESS (w_ptr_reg, w_ptr_succ, r_ptr_reg, r_ptr_succ, w_op, full_reg, empty_reg)
    BEGIN
        CASE w_op IS

                -- Sin operacion: se mantienen los valores actuales.
            WHEN Idle =>
                w_ptr_next <= w_ptr_reg;
                r_ptr_next <= r_ptr_reg;
                full_next <= full_reg;
                empty_next <= empty_reg;

                -- Operacion de lectura
            WHEN Lect =>

                -- No se actualiza el apuntador de escritura:
                w_ptr_next <= w_ptr_reg;
                full_next <= '0';

                -- Si los punteros son iguales, la FIFO esta vacia y no se avanza el puntero de lectura;
                -- en caso contrario, se incrementa.
                IF empty_reg = '0' THEN
                    IF (r_ptr_succ = w_ptr_reg) THEN
                        r_ptr_next <= r_ptr_reg;
                        empty_next <= '1';
                    ELSE
                        r_ptr_next <= r_ptr_succ;
                        empty_next <= '0';
                    END IF;
                ELSE
                    r_ptr_next <= r_ptr_reg;
                    empty_next <= empty_reg;
                    full_next <= full_reg;
                END IF;

                -- Operación de escritura (wr='1', rd='0')
            WHEN Escr =>

                -- No se actualiza el apuntador de lectura:
                r_ptr_next <= r_ptr_reg;
                full_next <= '0';
                empty_next <= '0';

                -- Si el sucesor de w_ptr es igual a r_ptr, la FIFO esta llena: no se avanza el apuntador de escritura.
                IF full_reg = '0' THEN
                    IF (w_ptr_succ = r_ptr_reg) THEN
                        w_ptr_next <= w_ptr_reg; -- No se avanza
                        full_next <= '1';
                    ELSE
                        w_ptr_next <= w_ptr_succ;
                        full_next <= '0';
                    END IF;
                ELSE
                    w_ptr_next <= w_ptr_reg;
                    full_next <= full_reg;
                    empty_next <= empty_reg;
                END IF;

                -- Operacion simultanea (wr='1', rd='1')
            WHEN RdRw =>
                w_ptr_next <= w_ptr_succ;
                r_ptr_next <= r_ptr_succ;
                full_next <= full_reg;
                empty_next <= empty_reg;
        END CASE;
    END PROCESS;

    -- Salidas
    w_addr <= w_ptr_reg;
    r_addr <= r_ptr_reg;
    full <= full_reg;
    empty <= empty_reg;
    r_addr_next <= r_ptr_next;

END ARCHITECTURE;