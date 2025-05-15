LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;
USE WORK.SquarePkg.ALL;

ENTITY PixelGenerate IS
    PORT (
        PosX : IN uint11;
        PosY : IN uint11;
        SquareXo : IN uint10;
        SquareYo : IN uint10;
        VideoOn : IN uint01;
        RGB : OUT ColorT
    );
END ENTITY;

ARCHITECTURE MainArch OF PixelGenerate IS
    SIGNAL xi, yi : INTEGER;
    SIGNAL idx : INTEGER RANGE 0 TO SQSZ - 1;
    SIGNAL px : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL is_inside : BOOLEAN;
    SIGNAL is_transparent : BOOLEAN;
    SIGNAL SQ_X0, SQ_Y0 : INTEGER;
BEGIN

    SQ_X0 <= SLV2Int(SquareXo);
    SQ_Y0 <= SLV2Int(SquareYo);
    -- Convertir a enteros
    xi <= to_integer(unsigned(PosX));
    yi <= to_integer(unsigned(PosY));

    -- Verifica si está dentro del sprite
    is_inside <= (xi >= SQ_X0) AND (xi < SQ_X0 + SQW) AND
        (yi >= SQ_Y0) AND (yi < SQ_Y0 + SQH);

    idx <= to_integer(
        (to_unsigned(yi - SQ_Y0, 16) SLL 5) +
        (to_unsigned(yi - SQ_Y0, 16) SLL 4) +
        (to_unsigned(yi - SQ_Y0, 16) SLL 1)
        ) + (xi - SQ_X0) WHEN is_inside ELSE
        0;

    -- Pixel leído del arreglo
    px <= SquareData(idx);

    -- Verifica transparencia (si es azul de fondo)
    is_transparent <= (px = x"FF");

    -- Asignación de colores según condiciones
    RGB.R <= (OTHERS => '0');
    RGB.G <= (OTHERS => '0');
    RGB.B <=
    (OTHERS => '1') WHEN (VideoOn = '1' AND (NOT is_inside OR is_transparent)) ELSE
    (OTHERS => '0');
END ARCHITECTURE;