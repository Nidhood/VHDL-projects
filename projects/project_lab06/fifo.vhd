LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fifo IS
    GENERIC (
        ADDR_WIDTH : INTEGER := 4;
        DATA_WIDTH : INTEGER := 4);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        rd : IN STD_LOGIC;
        wr : IN STD_LOGIC;
        w_data : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        r_data : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        empty : OUT STD_LOGIC;
        full : OUT STD_LOGIC;
        w_addr_ss : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        r_addr_ss : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        w_data_ss : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        r_data_ss : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE structural OF fifo IS
    SIGNAL full_s : STD_LOGIC;
    SIGNAL wr_en_s : STD_LOGIC;
    SIGNAL w_addr_s : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    SIGNAL r_addr_s : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    SIGNAL r_data_s : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

BEGIN
    -- write enable only when FIFO is not full
    wr_en_s <= wr AND (NOT full_s);
    full <= full_s;

    -- instantiate fifo control unit
    ctrl_unit : ENTITY work.fifo_ctrl
        GENERIC MAP(ADDR_WIDTH => ADDR_WIDTH)
        PORT MAP(
            clk => clk,
            reset => reset,
            rd => rd,
            wr => wr,
            empty => empty,
            full => full_s,
            w_addr => w_addr_s,
            r_addr => r_addr_s
        );

    -- instantiate register file
    reg_file_unit : ENTITY work.register_file
        GENERIC MAP(
            ADDR_WIDTH => ADDR_WIDTH,
            DATA_WIDTH => DATA_WIDTH)
        PORT MAP(
            clk => clk,
            w_addr => w_addr_s,
            r_addr => r_addr_s,
            w_data => w_data,
            r_data => r_data_s,
            wr_en => wr_en_s
        );

    r_data <= r_data_s;

    wr_addr1 : ENTITY work.bin_to_7seg
        PORT MAP(x => w_addr_s, sseg => w_addr_ss);

    wr_data1 : ENTITY work.bin_to_7seg
        PORT MAP(x => w_data, sseg => w_data_ss);

    rd_addr1 : ENTITY work.bin_to_7seg
        PORT MAP(x => r_addr_s, sseg => r_addr_ss);

    rd_data1 : ENTITY work.bin_to_7seg
        PORT MAP(x => r_data_s, sseg => r_data_ss);

END ARCHITECTURE;