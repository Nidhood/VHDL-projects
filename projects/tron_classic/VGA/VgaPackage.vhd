LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.BasicPackage.ALL;

PACKAGE VgaPackage IS

    --USE WORK.VgaPackage.ALL;

    TYPE ColorT IS RECORD
        R : uint08;
        G : uint08;
        B : uint08;
    END RECORD ColorT;

    TYPE VgaCtrlT IS RECORD
        Clk : uint01;
        Blank : uint01;
        Sync : uint01;
        Hsync : uint01;
        Vsync : uint01;
    END RECORD VgaCtrlT;

    -- Definition of constant timestamps of the Svga standard

    TYPE SvgaDataT IS RECORD
        Display : INTEGER;
        FrontP : INTEGER;
        Retrace : INTEGER;
        BackP : INTEGER;
    END RECORD SvgaDataT;

    CONSTANT HData : SvgaDataT := (Display => 799,
    FrontP => 16,
    Retrace => 80,
    BackP => 160);

    CONSTANT VData : SvgaDataT := (Display => 599,
    FrontP => 13,
    Retrace => 2,
    BackP => 21);

    -- Definition of constant timestamps used to calculate the sync signals, composed of the
    -- previously defined times

    TYPE TimestampT IS RECORD
        Display : uint11;
        FrontPorch : uint11;
        Retrace : uint11;
        FullScan : uint11;
    END RECORD TimestampT;

    CONSTANT HTime : TimestampT := (Display => (Int2Slv((HData.Display), 11)),
    FrontPorch => (Int2Slv((HData.Display + HData.FrontP), 11)),
    Retrace => (Int2Slv((HData.Display + HData.FrontP + HData.Retrace), 11)),
    FullScan => (Int2Slv((HData.Display + HData.FrontP + HData.Retrace + HData.BackP), 11)));

    CONSTANT VTime : TimestampT := (Display => (Int2Slv((VData.Display), 11)),
    FrontPorch => (Int2Slv((VData.Display + VData.FrontP), 11)),
    Retrace => (Int2Slv((VData.Display + VData.FrontP + VData.Retrace), 11)),
    FullScan => (Int2Slv((VData.Display + VData.FrontP + VData.Retrace + VData.BackP), 11)));

END PACKAGE VgaPackage;
PACKAGE BODY VgaPackage IS
END VgaPackage;