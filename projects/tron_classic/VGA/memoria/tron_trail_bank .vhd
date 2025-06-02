------------------------------------------------------------------
--              Ivan Dario Orozco Ibanez                        --
--  Project: Tron trail bank                                    --
--  Date: 22/25/2025                                            --          
------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.BasicPackage.ALL;

ENTITY tron_trail_bank IS

    -- Definition of moto trail code
    GENERIC (
        TRAIL_CODE : uint02 := "01"
    );
    PORT (
        -- Clock and Reset:
        clk, rst : IN uint01;

        -- Write logic ports:
        wr_en_pix : IN uint01;
        wr_x, wr_y : IN uint11;

        -- Read logic ports for each moto:
        rd_x, rd_y : IN uint11;
        rd_trail : OUT uint02
    );
END ENTITY;

------------------------------------------------------------------
ARCHITECTURE tron_trail_bank_arch OF tron_trail_bank IS
    CONSTANT ORG_X : uint11 := Int2SLV(10, 11);
    CONSTANT ORG_Y : uint11 := Int2SLV(70, 11);

    -- Size of each cell in pixels
    CONSTANT CELL_W : INTEGER := 20;
    CONSTANT CELL_H : INTEGER := 20;

    -- Number of columns and rows in the game area
    CONSTANT NCOLS : INTEGER := 15;
    CONSTANT NROWS : INTEGER := 11;

    -- Memory address signals
    SIGNAL addr_wr_u : unsigned(7 DOWNTO 0);
    SIGNAL addr_rd_u : unsigned(7 DOWNTO 0);
    SIGNAL addr_wr : uint08;
    SIGNAL addr_rd : uint08;

    -- Memory read data signal
    SIGNAL rdb : uint02 := (OTHERS => '0');

BEGIN

    -- Calculate the write address based on the coordinates
    addr_wr_u <= to_unsigned(
        (
        (to_integer(unsigned(wr_y) - unsigned(ORG_Y)) / CELL_H) * NCOLS
        ) +
        (to_integer(unsigned(wr_x) - unsigned(ORG_X)) / CELL_W),
        8
        );
    addr_wr <= STD_LOGIC_VECTOR(addr_wr_u);

    -- Write address for the memory segment
    addr_rd_u <= to_unsigned(
        (
        (to_integer(unsigned(rd_y) - unsigned(ORG_Y)) / CELL_H) * NCOLS
        ) +
        (to_integer(unsigned(rd_x) - unsigned(ORG_X)) / CELL_W),
        8
        );
    addr_rd <= STD_LOGIC_VECTOR(addr_rd_u);

    -- Instantiate the memory segment entity
    seg : ENTITY work.tron_mem_seg
        PORT MAP(
            clk => clk,
            rst => rst,

            wr_en => wr_en_pix,
            wr_addr => addr_wr,
            wr_data => TRAIL_CODE,

            r_addr1 => addr_rd,
            r_data1 => rdb,
            r_addr2 => (OTHERS => '0'),
            r_data2 => OPEN,
            r_addr3 => (OTHERS => '0'),
            r_data3 => OPEN,
            r_addr4 => (OTHERS => '0'),
            r_data4 => OPEN
        );

    -- Assign the read data to the output
    rd_trail <= rdb;

END tron_trail_bank_arch;