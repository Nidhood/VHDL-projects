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
        MotoX   : IN uint10;
        MotoY   : IN uint10;
        OrientationMoto : IN uint02;
        VideoOn : IN uint01;
        RGB     : OUT ColorT
    );
END ENTITY;

ARCHITECTURE MainArch OF PixelGenerate IS
    SIGNAL PX, PY : INTEGER;
    SIGNAL i, j   : INTEGER;
    SIGNAL i_rot, j_rot : INTEGER;

    SIGNAL en_moto_area    : BOOLEAN;
    SIGNAL es_fondo_moto   : BOOLEAN;
    SIGNAL en_cuadro_azul  : BOOLEAN;

    SIGNAL N : INTEGER := 40;  -- Tamaño del sprite de la moto

    -- Color del cuadro azul oscuro
    CONSTANT BLUE_DARK : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"80";
    -- Color de fondo blanco
    CONSTANT WHITE : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"FF";
BEGIN

    -- Conversión de coordenadas a INTEGER
    PX <= SLV2Int(PosX);
    PY <= SLV2Int(PosY);

    -- Índices relativos
    i <= PY - SLV2Int(MotoY);
    j <= PX - SLV2Int(MotoX);

    -- Rotación según orientación
    PROCESS (OrientationMoto, i, j, N)
    BEGIN
        CASE OrientationMoto IS
            WHEN "00" => -- Arriba
                i_rot <= j;
                j_rot <= N - 1 - i;
            WHEN "01" => -- Abajo
                i_rot <= N - 1 - j;
                j_rot <= i;
            WHEN "10" => -- Derecha
                i_rot <= i;
                j_rot <= j;
            WHEN OTHERS => -- "11", Izquierda
                i_rot <= i;
                j_rot <= N - 1 - j;
        END CASE;
    END PROCESS;

    -- Área de la moto (dentro de sprite)
    en_moto_area <= (
        i_rot >= 0 AND i_rot < N AND
        j_rot >= 0 AND j_rot < N
    );

    -- Área del cuadro azul oscuro (ajusta según tus límites)
    en_cuadro_azul <= (
        PX >= 20 AND PX <= 780 AND
        PY >= 100 AND PY <= 580
    );

    -- Fondo rosado = transparente
    es_fondo_moto <= (
        en_moto_area AND
        MotoPlantilla_DerechaR(i_rot, j_rot) = x"E1" AND
        MotoPlantilla_DerechaG(i_rot, j_rot) = x"07" AND
        MotoPlantilla_DerechaB(i_rot, j_rot) = x"FF"
    );

    -- Salida RGB robusta
    RGB.R <=
        MotoPlantilla_DerechaR(i_rot, j_rot) WHEN (VideoOn = '1' AND en_moto_area AND NOT es_fondo_moto) ELSE
        x"00" WHEN (VideoOn = '1' AND en_cuadro_azul) ELSE
        WHITE WHEN (VideoOn = '1') ELSE
        x"00";

    RGB.G <=
        MotoPlantilla_DerechaG(i_rot, j_rot) WHEN (VideoOn = '1' AND en_moto_area AND NOT es_fondo_moto) ELSE
        x"00" WHEN (VideoOn = '1' AND en_cuadro_azul) ELSE
        WHITE WHEN (VideoOn = '1') ELSE
        x"00";

    RGB.B <=
        MotoPlantilla_DerechaB(i_rot, j_rot) WHEN (VideoOn = '1' AND en_moto_area AND NOT es_fondo_moto) ELSE
        BLUE_DARK WHEN (VideoOn = '1' AND en_cuadro_azul) ELSE
        WHITE WHEN (VideoOn = '1') ELSE
        x"00";

END MainArch;
