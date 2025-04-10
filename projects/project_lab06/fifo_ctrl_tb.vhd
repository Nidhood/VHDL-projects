LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fifo_ctrl_tb IS
END ENTITY fifo_ctrl_tb;

ARCHITECTURE fifo_ctrl_tb_arch OF fifo_ctrl_tb IS

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '1';
    SIGNAL rd : STD_LOGIC := '0';
    SIGNAL wr : STD_LOGIC := '0';
    SIGNAL w_data : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL r_data : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL w_addr : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL r_addr : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL empty : STD_LOGIC;
    SIGNAL full : STD_LOGIC;
    SIGNAL w_addr_ss : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL r_addr_ss : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL w_data_ss : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL r_data_ss : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    X : ENTITY WORK.fifo
        GENERIC MAP(
            ADDR_WIDTH => 4,
            DATA_WIDTH => 4
        )
        PORT MAP(
            clk => clk,
            reset => reset,
            rd => rd,
            wr => wr,
            w_data => w_data,
            r_data => r_data,
            w_addr => w_addr,
            r_addr => r_addr,
            empty => empty,
            full => full,
            w_addr_ss => w_addr_ss,
            r_addr_ss => r_addr_ss,
            w_data_ss => w_data_ss,
            r_data_ss => r_data_ss
        );

    -- Generación del reloj: periodo = 10 ns (5 ns alto, 5 ns bajo)
    clk <= NOT clk AFTER 5 ns;

    stimulus_process : PROCESS
        VARIABLE i : INTEGER;
    BEGIN
        -- 1. Reset inicial durante 20 ns
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        WAIT FOR 10 ns;

        -- 2. Intentar leer cuando la FIFO está vacía
        rd <= '1';
        WAIT FOR 10 ns;
        rd <= '0';
        WAIT FOR 10 ns;

        -- 3. Escribir 18 datos para llenar la FIFO (16 posiciones) y forzar el caso "full"
        FOR i IN 0 TO 17 LOOP
            w_data <= STD_LOGIC_VECTOR(to_unsigned(i + 1, 4)); -- Se escriben valores de 1 a 18 (los primeros 16 entran)
            wr <= '1';
            WAIT FOR 10 ns;
            wr <= '0';
            WAIT FOR 10 ns;
        END LOOP;

        -- 4. Intentar escribir extra cuando FIFO ya está llena
        w_data <= "1111";
        wr <= '1';
        WAIT FOR 10 ns;
        wr <= '0';
        WAIT FOR 10 ns;

        -- 5. Leer 16 veces para vaciar la FIFO
        FOR i IN 0 TO 15 LOOP
            rd <= '1';
            WAIT FOR 10 ns;
            rd <= '0';
            WAIT FOR 10 ns;
        END LOOP;

        -- 6. Intentar leer extra cuando la FIFO ya está vacía
        rd <= '1';
        WAIT FOR 10 ns;
        rd <= '0';
        WAIT FOR 10 ns;

        -- 7. Reset posterior y escribir 4 nuevos datos para verificar reinicialización
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        WAIT FOR 10 ns;
        FOR i IN 0 TO 3 LOOP
            w_data <= STD_LOGIC_VECTOR(to_unsigned(i + 5, 4)); -- Escribe valores 5,6,7,8
            wr <= '1';
            WAIT FOR 10 ns;
            wr <= '0';
            WAIT FOR 10 ns;
        END LOOP;

        WAIT;
    END PROCESS;

END ARCHITECTURE fifo_ctrl_tb_arch;