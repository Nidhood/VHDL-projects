LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;
ENTITY monitor_vga IS

    PORT (
        Rst : IN uint01;
        Clk : IN uint01;
        HSync : OUT uint01;
        VSync : OUT uint01;
        VGA_clk : OUT uint01;
        RGB : OUT ColorT
    );
END monitor_vga;

ARCHITECTURE MainArch OF monitor_vga IS
    SIGNAL VideoOn : uint01;
    SIGNAL PixelX : uint11;
    SIGNAL PixelY : uint11;
BEGIN

    -- Summon This Block:

    ImageSync : ENTITY WORK.ImageSync(MainArch)
        PORT MAP(
            Reset => Rst,
            SyncClk => Clk,
            HSync => HSync,
            VSync => VSync,
            VideoOn => VideoOn,
            PixelX => PixelX,
            PixelY => PixelY
        );
    Colores : ENTITY WORK.PixelGenerate(MainArch)
        PORT MAP(
            PosX => PixelX,
            PosY => PixelY,
            VideoOn => VideoOn,
            RGB => RGB
        );
    VGA_clk <= Clk;

END MainArch;