---------------------------------------------------------------------------------
--    Description: Cronómetro completo (mili, un, dec)                        --
--    Author: Jerónimo Rueda Giraldo                                         --
--    Date: 02/04/2025                                                       --
---------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY cronometro IS
    GENERIC (
        CICLOS_MILI : INTEGER := 5 -- Número de ciclos de clk para incrementar mili
    );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        go : IN STD_LOGIC;
        sync_rst : IN STD_LOGIC;
        dec : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        un : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        mili : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END cronometro;

ARCHITECTURE cronometro_Arch OF cronometro IS

    CONSTANT N : INTEGER := 4;

    -- Señales internas comunes
    SIGNAL ena_mili : STD_LOGIC := '0';
    SIGNAL load : STD_LOGIC := '0';
    SIGNAL up : STD_LOGIC := '1';
    SIGNAL d : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL max_val_9 : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := "1001";

    -- Señales internas de mili
    SIGNAL max_tick_mili : STD_LOGIC;
    SIGNAL min_tick_mili : STD_LOGIC;
    SIGNAL mili_int : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Señales internas de un
    SIGNAL max_tick_un : STD_LOGIC;
    SIGNAL min_tick_un : STD_LOGIC;
    SIGNAL un_int : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Señales internas de dec
    SIGNAL max_tick_dec : STD_LOGIC;
    SIGNAL min_tick_dec : STD_LOGIC;
    SIGNAL dec_int : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Control de ciclos para mili
    SIGNAL clk_count : INTEGER RANGE 0 TO CICLOS_MILI - 1 := 0;
    SIGNAL syn_clr_mili : STD_LOGIC;
    SIGNAL syn_clr_un : STD_LOGIC;

    -- Pulsos para un y dec
    SIGNAL max_tick_mili_reg : STD_LOGIC := '0';
    SIGNAL ena_un_pulse : STD_LOGIC := '0';
    SIGNAL ena_dec_pulse : STD_LOGIC := '0';

BEGIN
    -- Reset sincrónico de mili y un
    syn_clr_mili <= sync_rst OR max_tick_mili;
    syn_clr_un <= sync_rst OR max_tick_un;
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            clk_count <= 0;
            ena_mili <= '0';
            max_tick_mili_reg <= '0';
            ena_un_pulse <= '0';
            ena_dec_pulse <= '0';
        ELSIF rising_edge(clk) THEN
            -- Contador de ciclos para mili
            IF go = '1' THEN
                IF clk_count = CICLOS_MILI - 1 THEN
                    clk_count <= 0;
                    ena_mili <= '1';
                ELSE
                    clk_count <= clk_count + 1;
                    ena_mili <= '0';
                END IF;
            ELSE
                clk_count <= 0;
                ena_mili <= '0';
            END IF;

            -- Pulso para un (con flanco de max_tick_mili)
            max_tick_mili_reg <= max_tick_mili;
            ena_un_pulse <= (NOT max_tick_mili_reg) AND max_tick_mili;

            -- Pulso para dec (cuando un acaba de llegar a 9 al mismo tiempo que mili)
            IF ena_un_pulse = '1' AND un_int = "1001" THEN
                ena_dec_pulse <= '1';
            ELSE
                ena_dec_pulse <= '0';
            END IF;
        END IF;
    END PROCESS;

    -- Contador de milisegundos (mili)
    mili_counter : ENTITY work.univ_bin_counter_max
        GENERIC MAP(N => N)
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => ena_mili,
            syn_clr => syn_clr_mili,
            load => load,
            up => up,
            d => d,
            max_val => max_val_9,
            max_tick => max_tick_mili,
            min_tick => min_tick_mili,
            counter => mili_int
        );

    --  Contador de unidades (un)
    un_counter : ENTITY work.univ_bin_counter_max
        GENERIC MAP(N => N)
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => ena_un_pulse,
            syn_clr => syn_clr_un,
            load => load,
            up => up,
            d => d,
            max_val => max_val_9,
            max_tick => max_tick_un,
            min_tick => min_tick_un,
            counter => un_int
        );

    -- Contador de decenas (dec)
    dec_counter : ENTITY work.univ_bin_counter_max
        GENERIC MAP(N => N)
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => ena_dec_pulse,
            syn_clr => sync_rst,
            load => load,
            up => up,
            d => d,
            max_val => max_val_9,
            max_tick => max_tick_dec,
            min_tick => min_tick_dec,
            counter => dec_int
        );

    -- Asignación de salidas
    mili <= mili_int;
    un <= un_int;
    dec <= dec_int;

END ARCHITECTURE;