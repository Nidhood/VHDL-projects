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
        VideoOn : OUT uint01;
        PixelX : OUT uint11;
        PixelY : OUT uint11
    );
END ENTITY ImageSync;

ARCHITECTURE MainArch OF ImageSync IS

    CONSTANT Zero : uint11 := (OTHERS => ('0'));

    SIGNAL vEnable : uint01;
    SIGNAL HCount : uint11;
    SIGNAL VCount : uint11;
    SIGNAL videoOn : uint01;
    SIGNAL VideoHon : uint01;
    SIGNAL TmpVideoOn : uint01;

    SIGNAL TmpHs1 : uint01;
    SIGNAL TmpHs2 : uint01;
    SIGNAL TmpVs1 : uint01;
    SIGNAL TmpVs2 : uint01;

BEGIN

    -- Get the Video on signal, which is set to one when the Vertical (V) and Horizontal (H)
    -- counters are within the Display range.

    TmpVideoOn <= VideoOn AND VideoHon;
    VideoOn <= TmpVideoOn;
    VideoHon <= '1' WHEN (UNSIGNED(HCount) <= UNSIGNED(HTime.Display)) ELSE
        '0';
    VideoOn <= '1' WHEN (UNSIGNED(VCount) <= UNSIGNED(VTime.Display)) ELSE
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
        GENERIC MAP(Size => 11)
        PORT MAP(
            Clk => SyncClk,
            MR => Reset,
            SR => '0',
            ER => '1',
            Up => '1',
            Dwn => '0',
            Limit => HTime.FullScan,
            MaxCount => vEnable,
            MinCount => OPEN,
            Count => HCount
        );

    VCounter : ENTITY WORK.GraLimCounter(CounterArch)
        GENERIC MAP(Size => 11)
        PORT MAP(
            Clk => SyncClk,
            MR => Reset,
            SR => '0',
            ER => vEnable,
            Up => '1',
            Dwn => '0',
            Limit => VTime.FullScan,
            MaxCount => OPEN,
            MinCount => OPEN,
            Count => VCount
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