-----------------------------------------------------------------------
--             Ivan Dario Orozco Ibanez
--  Project: Tron trail bank
--  Date: 22/25/2025
-----------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.BasicPackage.ALL;

ENTITY tron_trail_bank IS
    GENERIC (
        TRAIL_CODE : uint03 := "001"
    );
    PORT (

        -- Clock and Reset:
        clk : IN uint01;
        rst : IN uint01;

        -- Write ports:
        wr_en_pix : IN uint01;
        wr_x : IN uint11;
        wr_y : IN uint11;

        -- Read ports:
        rd_x : IN uint11;
        rd_y : IN uint11;
        rd_trail : OUT uint03
    );
END ENTITY tron_trail_bank;

ARCHITECTURE tron_trail_bank_arch OF tron_trail_bank IS

    CONSTANT ORG_X : uint11 := Int2SLV(10, 11);
    CONSTANT ORG_Y : uint11 := Int2SLV(70, 11);

    CONSTANT CELL_W : INTEGER := 20;
    CONSTANT CELL_H : INTEGER := 20;

    CONSTANT NCOLS : INTEGER := 38;
    CONSTANT NROWS : INTEGER := 28;

    SIGNAL valid_cell_wr : STD_LOGIC;
    SIGNAL valid_cell_rd : STD_LOGIC;

    SIGNAL addr_wr_u : unsigned(10 DOWNTO 0);
    SIGNAL addr_rd_u : unsigned(10 DOWNTO 0);
    SIGNAL addr_wr : uint11;
    SIGNAL addr_rd : uint11;

    SIGNAL rdb : uint03 := (OTHERS => '0');

BEGIN

    valid_cell_wr <= '1' WHEN
        (unsigned(wr_x) >= unsigned(ORG_X)) AND
        (unsigned(wr_x) < unsigned(ORG_X) + to_unsigned(NCOLS * CELL_W, ORG_X'length)) AND
        (unsigned(wr_y) >= unsigned(ORG_Y)) AND
        (unsigned(wr_y) < unsigned(ORG_Y) + to_unsigned(NROWS * CELL_H, ORG_Y'length))
        ELSE
        '0';

    addr_wr_u <= to_unsigned(
        ((to_integer(unsigned(wr_y) - unsigned(ORG_Y)) / CELL_H) * NCOLS) +
        (to_integer(unsigned(wr_x) - unsigned(ORG_X)) / CELL_W),
        11
        )
        WHEN valid_cell_wr = '1'
        ELSE
        (OTHERS => '0');

    addr_wr <= STD_LOGIC_VECTOR(addr_wr_u);

    valid_cell_rd <= '1' WHEN
        (unsigned(rd_x) >= unsigned(ORG_X)) AND
        (unsigned(rd_x) < unsigned(ORG_X) + to_unsigned(NCOLS * CELL_W, ORG_X'length)) AND
        (unsigned(rd_y) >= unsigned(ORG_Y)) AND
        (unsigned(rd_y) < unsigned(ORG_Y) + to_unsigned(NROWS * CELL_H, ORG_Y'length))
        ELSE
        '0';

    addr_rd_u <= to_unsigned(
        ((to_integer(unsigned(rd_y) - unsigned(ORG_Y)) / CELL_H) * NCOLS) +
        (to_integer(unsigned(rd_x) - unsigned(ORG_X)) / CELL_W),
        11
        )
        WHEN valid_cell_rd = '1'
        ELSE
        (OTHERS => '0');

    addr_rd <= STD_LOGIC_VECTOR(addr_rd_u);

    seg : ENTITY work.tron_mem_seg
        PORT MAP(
            clk => clk,
            rst => rst,
            wr_en => wr_en_pix AND valid_cell_wr,
            wr_addr => addr_wr,
            wr_data => TRAIL_CODE,
            r_addr1 => addr_rd,
            r_data1 => rdb,

            -- Use for game logic:
            r_addr2 => (OTHERS => '0'),
            r_data2 => OPEN,
            r_addr3 => (OTHERS => '0'),
            r_data3 => OPEN,
            r_addr4 => (OTHERS => '0'),
            r_data4 => OPEN
        );

    rd_trail <= rdb WHEN valid_cell_rd = '1'
        ELSE
        (OTHERS => '0');

END ARCHITECTURE tron_trail_bank_arch;