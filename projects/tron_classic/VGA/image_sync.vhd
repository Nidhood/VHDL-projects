LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;

ENTITY ImageSync IS
    PORT (
        Reset : IN uint01;
        SyncClk : IN uint01;
        HSync : OUT uint01;
        VSync : OUT uint01;
        RGB : OUT ColorT
    );
END ENTITY ImageSync;

ARCHITECTURE MainArch OF ImageSync IS

    CONSTANT Zero : uint11 := (OTHERS => ('0'));

    SIGNAL vEnable : uint01;
    SIGNAL HCount : uint11;
    SIGNAL VCount : uint11;
    SIGNAL VideoHon : uint01;
    SIGNAL VideoVon : uint01;
    SIGNAL TmpVideoOn : uint01;

    SIGNAL TmpHs1 : uint01;
    SIGNAL TmpHs2 : uint01;
    SIGNAL TmpVs1 : uint01;
    SIGNAL TmpVs2 : uint01;

    SIGNAL PixelX : uint11;
    SIGNAL PixelY : uint11;
    SIGNAL VideoOn : uint01;

BEGIN

    -- Get the Video on signal, which is set to one when the Vertical (V) and Horizontal (H)
    -- counters are within the Display range.

    TmpVideoOn <= VideoVOn AND VideoHon;
    VideoOn <= TmpVideoOn;
    VideoHon <= '1' WHEN (UNSIGNED(HCount) <= UNSIGNED(HTime.Display)) ELSE
        '0';
    VideoVOn <= '1' WHEN (UNSIGNED(VCount) <= UNSIGNED(VTime.Display)) ELSE
        '0';

    -- Route the H Count and V Count to the Pixel X and Pixel Y outputs when the counters are
    -- within the Display range.

    WITH TmpVideoOn SELECT
        PixelX <= HCount WHEN '1',
        Zero WHEN OTHERS;

    WITH TmpVideoOn SELECT
        PixelY <= VCount WHEN '1',
        Zero WHEN OTHERS;

    -- Calculate the H and V Sync signals. Each signal must be set to one for the front
    -- porch, display and back porch time

    TmpHs1 <= '1' WHEN (UNSIGNED(HCount) <= UNSIGNED(HTime.FrontPorch)) ELSE
        '0';
    TmpHs2 <= '1' WHEN (UNSIGNED(HCount) > UNSIGNED(HTime.Retrace)) ELSE
        '0';
    TmpVs1 <= '1' WHEN (UNSIGNED(VCount) <= UNSIGNED(VTime.FrontPorch)) ELSE
        '0';
    TmpVs2 <= '1' WHEN (UNSIGNED(VCount) > UNSIGNED(VTime.Retrace)) ELSE
        '0';

    HSync <= TmpHs1 OR TmpHs2;
    VSync <= TmpVs1 OR TmpVs2;

    -- Counter circuits to get the correct timing for the SVGA@60Hz standard.
    -- HTime and VTime are defined on the VgaPackage.

    HCounter : ENTITY WORK.GraLimCounter(CounterArch)
        GENERIC MAP(N => 11)
        PORT MAP(
            clk => SyncClk,
            rst => Reset,
            ena => '1',
            syn_clr => '0',
            load => '0',
            up => '1',
            d => "00000000000",
            max_val => HTime.FullScan,
            max_tick => vEnable,
            min_tick => OPEN,
            counter => HCount
        );

    VCounter : ENTITY WORK.GraLimCounter(CounterArch)
        GENERIC MAP(N => 11)
        PORT MAP(
            clk => SyncClk,
            rst => Reset,
            ena => VEnable,
            syn_clr => '0',
            load => '0',
            up => '1',
            d => "00000000000",
            max_val => VTime.FullScan,
            max_tick => OPEN,
            min_tick => OPEN,
            counter => VCount
        );

    Colores : ENTITY WORK.PixelGenerate(MainArch)
        PORT MAP(
            PosX => PixelX,
            PosY => PixelY,
            VideoOn => VideoOn,
            RGB => RGB
        );

END MainArch;

-- Summon This Block:

--BlockN: ENTITY WORK.ImageSync(MainArch)
--    PORT MAP (
--        Reset   => SLV,
--        SyncClk => SLV,
--        HSync   => SLV,
--        VSync   => SLV,
--        VideoOn => SLV,
--        PixelX  => SLV,
--        PixelY  => SLV
--    );