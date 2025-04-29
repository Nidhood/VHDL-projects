LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;

ENTITY PixelGenerate IS

    PORT (
        PosX : IN uint11;
        PosY : IN uint11;
        VideoOn : IN uint01;
        RGB : OUT ColorT
    );

END PixelGenerate;

ARCHITECTURE MainArch OF PixelGenerate IS
    SIGNAL Color : uint08;

BEGIN

    RGB.R <= Color;
    RGB.G <= Color;
    RGB.B <= Color;

    WITH VideoOn SELECT
        Color <= "11111111" WHEN '1',
        "00000000" WHEN OTHERS;

END MainArch;