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
    SIGNAL PX, PY : INTEGER;

    -- Señales para verificar áreas activas
    SIGNAL en_moto_area    : BOOLEAN;
    SIGNAL en_titulo_area  : BOOLEAN;
    SIGNAL en_cuadro_azul  : BOOLEAN;

    -- Señales para fondos rosados
    SIGNAL es_fondo_moto   : BOOLEAN;
    SIGNAL es_fondo_titulo : BOOLEAN;

BEGIN
    -- Conversión de coordenadas
    PX <= Slv2Int(PosX);
    PY <= Slv2Int(PosY);

    -- Áreas de la moto y título
    en_moto_area <= (
        PX >= Moto1.PosX AND PX < Moto1.PosX + Moto1.Size AND
        PY >= Moto1.PosY AND PY < Moto1.PosY + Moto1.Size
    );

    en_titulo_area <= (
        PX >= Titulo.PosX AND PX < Titulo.PosX + Titulo.Size AND
        PY >= Titulo.PosY AND PY < Titulo.PosY + Titulo.Size
    );

    -- Área del cuadro azul oscuro
    en_cuadro_azul <= (
        PX >= 20 AND PX <= 780 AND
        PY >= 100 AND PY <= 580
    );

    -- Fondo rosado (255, 102, 255)
    es_fondo_moto <= (
        MotoPlantilla_DerechaR(PY - Moto1.PosY, PX - Moto1.PosX) = x"FF" AND
        MotoPlantilla_DerechaG(PY - Moto1.PosY, PX - Moto1.PosX) = x"66" AND
        MotoPlantilla_DerechaB(PY - Moto1.PosY, PX - Moto1.PosX) = x"FF"
    );

    es_fondo_titulo <= (
        Plantilla_TronB(PY - Titulo.PosY, PX - Titulo.PosX) = x"FF"
    );

    -- RGB.R
    RGB.R <=
        Plantilla_TronB(PY - Titulo.PosY, PX - Titulo.PosX) when (VideoOn = '1' AND en_titulo_area AND NOT es_fondo_titulo) else
        MotoPlantilla_DerechaR(PY - Moto1.PosY, PX - Moto1.PosX) when (VideoOn = '1' AND en_moto_area AND NOT es_fondo_moto) else
        x"00" when (VideoOn = '1' AND en_cuadro_azul) else
        x"10" when (VideoOn = '1') else
        x"00";

    -- RGB.G
    RGB.G <=
        Plantilla_TronB(PY - Titulo.PosY, PX - Titulo.PosX) when (VideoOn = '1' AND en_titulo_area AND NOT es_fondo_titulo) else
        MotoPlantilla_DerechaG(PY - Moto1.PosY, PX - Moto1.PosX) when (VideoOn = '1' AND en_moto_area AND NOT es_fondo_moto) else
        x"00" when (VideoOn = '1' AND en_cuadro_azul) else
        x"10" when (VideoOn = '1') else
        x"00";

    -- RGB.B
    RGB.B <=
        Plantilla_TronB(PY - Titulo.PosY, PX - Titulo.PosX) when (VideoOn = '1' AND en_titulo_area AND NOT es_fondo_titulo) else
        MotoPlantilla_DerechaB(PY - Moto1.PosY, PX - Moto1.PosX) when (VideoOn = '1' AND en_moto_area AND NOT es_fondo_moto) else
        x"80" when (VideoOn = '1' AND en_cuadro_azul) else
        x"10" when (VideoOn = '1') else
        x"00";

END MainArch;
