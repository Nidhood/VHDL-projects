--======================================================================
--  tb_trail_banks.vhd  ·  Test four tron_trail_bank instances
--  Checks that each bank stores/returns its own 2-bit code and that
--  the other banks remain "00" at the same coordinates.
--======================================================================

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE WORK.BasicPackage.ALL; -- uint01 … uint11

ENTITY tb_trail_banks IS
END;

ARCHITECTURE sim OF tb_trail_banks IS
    --------------------------------------------------------------------
    -- 25-MHz clock and reset
    --------------------------------------------------------------------
    CONSTANT Tclk : TIME := 40 ns;
    SIGNAL clk : uint01 := '0';
    SIGNAL rst : uint01 := '1';

    --------------------------------------------------------------------
    -- Write / read signals for four banks
    --------------------------------------------------------------------
    -- Bank 1  (code "01")
    SIGNAL we1 : uint01 := '0';
    SIGNAL x1_w, y1_w : uint11 := (OTHERS => '0');
    SIGNAL x1_r, y1_r : uint11 := (OTHERS => '0');
    SIGNAL trail1 : uint02;

    -- Bank 2  (code "10")
    SIGNAL we2 : uint01 := '0';
    SIGNAL x2_w, y2_w : uint11 := (OTHERS => '0');
    SIGNAL x2_r, y2_r : uint11 := (OTHERS => '0');
    SIGNAL trail2 : uint02;

    -- Bank 3  (code "11")
    SIGNAL we3 : uint01 := '0';
    SIGNAL x3_w, y3_w : uint11 := (OTHERS => '0');
    SIGNAL x3_r, y3_r : uint11 := (OTHERS => '0');
    SIGNAL trail3 : uint02;

    -- Bank 4  (code "00")
    SIGNAL we4 : uint01 := '0';
    SIGNAL x4_w, y4_w : uint11 := (OTHERS => '0');
    SIGNAL x4_r, y4_r : uint11 := (OTHERS => '0');
    SIGNAL trail4 : uint02;
BEGIN
    --------------------------------------------------------------------
    -- Clock generator
    --------------------------------------------------------------------
    clk <= NOT clk AFTER Tclk/2;

    --------------------------------------------------------------------
    -- Four instances of tron_trail_bank
    --------------------------------------------------------------------
    bank1 : ENTITY WORK.tron_trail_bank
        GENERIC MAP(TRAIL_CODE => "01")
        PORT MAP(
            clk => clk, rst => rst,
            wr_en_pix => we1, wr_x => x1_w, wr_y => y1_w,
            rd_x => x1_r, rd_y => y1_r,
            rd_trail => trail1);
    rd_trail => trail1);

    bank2 : ENTITY WORK.tron_trail_bank
        GENERIC MAP(TRAIL_CODE => "10")
        PORT MAP(
            clk => clk, rst => rst,
            wr_en_pix => we2, wr_x => x2_w, wr_y => y2_w,
            rd_x => x2_r, rd_y => y2_r,
            rd_trail => trail2);
    rd_trail => trail2);

    bank3 : ENTITY WORK.tron_trail_bank
        GENERIC MAP(TRAIL_CODE => "11")
        PORT MAP(
            clk => clk, rst => rst,
            wr_en_pix => we3, wr_x => x3_w, wr_y => y3_w,
            rd_x => x3_r, rd_y => y3_r,
            rd_trail => trail3);
    rd_trail => trail3);

    bank4 : ENTITY WORK.tron_trail_bank
        GENERIC MAP(TRAIL_CODE => "00")
        PORT MAP(
            clk => clk, rst => rst,
            wr_en_pix => we4, wr_x => x4_w, wr_y => y4_w,
            rd_x => x4_r, rd_y => y4_r,
            rd_trail => trail4);
    rd_trail => trail4);

    --------------------------------------------------------------------
    -- Stimulus
    --------------------------------------------------------------------
    stim : PROCESS
        -- Arena corners (11-bit literals)
        CONSTANT TL_X : uint11 := "00000001010"; --  10
        CONSTANT TL_Y : uint11 := "00001000110"; --  70
        CONSTANT TR_X : uint11 := "01011110111"; -- 759
        CONSTANT TR_Y : uint11 := "00001000110"; --  70
    CONSTANT BL_X : uint11 := "00000001010"; --  10
        CONSTANT BL_Y : uint11 := "01001101011"; -- 619
        CONSTANT BR_X : uint11 := "01011110111"; -- 759
        CONSTANT BR_Y : uint11 := "01001101011"; -- 619
        BEGIN
        ----------------------------------------------------------------
        -- Global reset
        ----------------------------------------------------------------
        WAIT FOR 4 * Tclk;
        rst <= '0';
        WAIT FOR Tclk;

        ----------------------------------------------------------------
        -- Write one pixel in each bank
        ----------------------------------------------------------------
        x1_w <= TL_X;
        y1_w <= TL_Y;
        we1 <= '1';
        WAIT FOR Tclk;
        we1 <= '0';
        x2_w <= TR_X;
        y2_w <= TR_Y;
        we2 <= '1';
        WAIT FOR Tclk;
        we2 <= '0';
        x3_w <= BL_X;
        y3_w <= BL_Y;
        we3 <= '1';
        WAIT FOR Tclk;
        we3 <= '0';
        x4_w <= BR_X;
        y4_w <= BR_Y;
        we4 <= '1';
        WAIT FOR Tclk;
        we4 <= '0';

        ----------------------------------------------------------------
        -- Read TL corner — only bank1 should return "01"
        ----------------------------------------------------------------
        x1_r <= TL_X;
        y1_r <= TL_Y;
        x2_r <= TL_X;
        y2_r <= TL_Y;
        x3_r <= TL_X;
        y3_r <= TL_Y;
        x4_r <= TL_X;
        y4_r <= TL_Y;
        WAIT FOR Tclk;
        ASSERT trail1 = "01" REPORT "bank1 wrong at TL" SEVERITY error;
        ASSERT trail2 = "00" AND trail3 = "00" AND trail4 = "00"
        REPORT "other bank non-zero at TL" SEVERITY error;

        ----------------------------------------------------------------
        -- Read TR corner
        ----------------------------------------------------------------
        x1_r <= TR_X;
        y1_r <= TR_Y;
        x2_r <= TR_X;
        y2_r <= TR_Y;
        x3_r <= TR_X;
        y3_r <= TR_Y;
        x4_r <= TR_X;
        y4_r <= TR_Y;
        WAIT FOR Tclk;
        ASSERT trail2 = "10" REPORT "bank2 wrong at TR" SEVERITY error;
        ASSERT trail1 = "00" AND trail3 = "00" AND trail4 = "00"
        REPORT "other bank non-zero at TR" SEVERITY error;

        ----------------------------------------------------------------
        -- Read BL corner
        ----------------------------------------------------------------
        x1_r <= BL_X;
        y1_r <= BL_Y;
        x2_r <= BL_X;
        y2_r <= BL_Y;
        x3_r <= BL_X;
        y3_r <= BL_Y;
        x4_r <= BL_X;
        y4_r <= BL_Y;
        WAIT FOR Tclk;
        ASSERT trail3 = "11" REPORT "bank3 wrong at BL" SEVERITY error;
        ASSERT trail1 = "00" AND trail2 = "00" AND trail4 = "00"
        REPORT "other bank non-zero at BL" SEVERITY error;

        ----------------------------------------------------------------
        -- Read BR corner
        ----------------------------------------------------------------
        x1_r <= BR_X;
        y1_r <= BR_Y;
        x2_r <= BR_X;
        y2_r <= BR_Y;
        x3_r <= BR_X;
        y3_r <= BR_Y;
        x4_r <= BR_X;
        y4_r <= BR_Y;
        WAIT FOR Tclk;
        ASSERT trail4 = "00" REPORT "bank4 wrong at BR" SEVERITY error;
        ASSERT trail1 = "00" AND trail2 = "00" AND trail3 = "00"
    REPORT "other bank non-zero at BR" SEVERITY error;

        REPORT "TEST PASSED" SEVERITY note;
        WAIT;
        END PROCESS;