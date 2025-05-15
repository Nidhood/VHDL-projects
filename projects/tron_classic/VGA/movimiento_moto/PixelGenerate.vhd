LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;
USE WORK.texturas.ALL;
USE WORK.ObjectsPackage.ALL;

ENTITY PixelGenerate IS
    PORT (
        PosX    : IN uint11;
        PosY    : IN uint11;
        VideoOn : IN uint01;
        RGB     : OUT ColorT
    );
END PixelGenerate;

ARCHITECTURE MainArch OF PixelGenerate IS
    SIGNAL PX, PY : uint11;

    SIGNAL en_moto_area    : BOOLEAN;
    SIGNAL en_titulo_area  : BOOLEAN;
    SIGNAL en_cuadro_azul  : BOOLEAN;

    SIGNAL es_fondo_moto   : BOOLEAN;

    SIGNAL i, j : uint06;
    SIGNAL i_rot, j_rot : uint06;
	 
	 SIGNAL OrientationMoto1 : uint02;

    CONSTANT N : uint06 := Int2SLV(40, 6);
	 
--00 -> Arriba
--01 -> Abajo
--10 -> Derecha
--11 -> Izquierda
  

BEGIN


    PX <= PosX;
    PY <= PosY;

    i <= Int2SLV(SLV2Int(PY) - SLV2Int(Moto1.PosY), 6);
    j <= Int2SLV(SLV2Int(PX) - SLV2Int(Moto1.PosX), 6);

    OrientationMoto1 <= Moto1.Orientation;

    i_rot <= i when OrientationMoto1 = "10" else
             i when OrientationMoto1 = "11" else
             Int2SLV(SLV2Int(N) - 1 - SLV2Int(j), 6) when OrientationMoto1 = "01" else
             j when OrientationMoto1 = "00" else
             i;

    j_rot <= j when OrientationMoto1 = "10" else
             Int2SLV(SLV2Int(N) - 1 - SLV2Int(j), 6) when OrientationMoto1 = "11" else
             i when OrientationMoto1 = "01" else
             Int2SLV(SLV2Int(N) - 1 - SLV2Int(i), 6) when OrientationMoto1 = "00" else
             j;

    en_moto_area <= (
        SLV2Int(PX) >= SLV2Int(Moto1.PosX) AND SLV2Int(PX) < SLV2Int(Moto1.PosX) + SLV2Int(Moto1.Size) AND
        SLV2Int(PY) >= SLV2Int(Moto1.PosY) AND SLV2Int(PY) < SLV2Int(Moto1.PosY) + SLV2Int(Moto1.Size)
    );

    en_cuadro_azul <= (
        PX >= Int2SLV(0, 11) AND PX <= Int2SLV(800, 11) AND
        PY >= Int2SLV(70, 11) AND PY <= Int2SLV(600, 11)
    );

    -- Transparencia
    es_fondo_moto <= (
        MotoPlantilla_DerechaR(SLV2Int(i_rot), SLV2Int(j_rot)) = x"E1" AND
        MotoPlantilla_DerechaG(SLV2Int(i_rot), SLV2Int(j_rot)) = x"07" AND
        MotoPlantilla_DerechaB(SLV2Int(i_rot), SLV2Int(j_rot)) = x"FF"
    );

    -- RGB.R
    RGB.R <=
        MotoPlantilla_DerechaR(SLV2Int(i_rot), SLV2Int(j_rot)) when (VideoOn = '1' AND en_moto_area AND NOT es_fondo_moto) else
        x"00" when (VideoOn = '1' AND en_cuadro_azul) else
        x"FF" when (VideoOn = '1') else
        x"00";

    -- RGB.G
    RGB.G <=
        MotoPlantilla_DerechaG(SLV2Int(i_rot), SLV2Int(j_rot)) when (VideoOn = '1' AND en_moto_area AND NOT es_fondo_moto) else
        x"00" when (VideoOn = '1' AND en_cuadro_azul) else
        x"FF" when (VideoOn = '1') else
        x"00";

    -- RGB.B
    RGB.B <=
        MotoPlantilla_DerechaB(SLV2Int(i_rot), SLV2Int(j_rot)) when (VideoOn = '1' AND en_moto_area AND NOT es_fondo_moto) else
        x"80" when (VideoOn = '1' AND en_cuadro_azul) else
        x"FF" when (VideoOn = '1') else
        x"00";

END MainArch;