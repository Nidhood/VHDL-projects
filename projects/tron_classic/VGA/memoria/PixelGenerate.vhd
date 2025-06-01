LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;
USE WORK.texturas.ALL;
USE WORK.ObjectsPackage.ALL;

ENTITY PixelGenerate IS
    PORT (
        PosX : IN uint11;
        PosY : IN uint11;
        MotoX1 : IN uint11;
        MotoY1 : IN uint11;
        MotoX2 : IN uint11;
        MotoY2 : IN uint11;
        MotoX3 : IN uint11;
        MotoY3 : IN uint11;
        VideoOn : IN uint01;
        MotoCurrent1 : IN MotoT;
        MotoCurrent2 : IN MotoT;
        MotoCurrent3 : IN MotoT;
        Trail1 : IN uint02;
        Trail2 : IN uint02;
        Trail3 : IN uint02;
        RGB : OUT ColorT
    );
END ENTITY;

ARCHITECTURE MainArch OF PixelGenerate IS
    SIGNAL PX, PY : uint11;
    -- Areas de motos --
    SIGNAL en_moto1_area, en_moto2_area, en_moto3_area : BOOLEAN;
    -- Fondo Azul --
    SIGNAL en_cuadro_azul : BOOLEAN;
    -- Area de vidas --
    SIGNAL en_vidas1_1, en_vidas1_2, en_vidas1_3 : BOOLEAN;
    SIGNAL en_vidas2_1, en_vidas2_2, en_vidas2_3 : BOOLEAN;
    SIGNAL en_vidas3_1, en_vidas3_2, en_vidas3_3 : BOOLEAN;
    -- Fondo de motos --
    SIGNAL es_fondo_moto1, es_fondo_moto2, es_fondo_moto3 : BOOLEAN;
    -- Fondo de vidas --
    SIGNAL es_fondo_vidas1_1, es_fondo_vidas1_2, es_fondo_vidas1_3 : BOOLEAN;
    SIGNAL es_fondo_vidas2_1, es_fondo_vidas2_2, es_fondo_vidas2_3 : BOOLEAN;
    SIGNAL es_fondo_vidas3_1, es_fondo_vidas3_2, es_fondo_vidas3_3 : BOOLEAN;
    -- Indices iniciales motos --
    SIGNAL i1, j1 : uint06;
    SIGNAL i2, j2 : uint06;
    SIGNAL i3, j3 : uint06;
    -- Indices de rotacion motos --
    SIGNAL i1_rot, j1_rot : uint06;
    SIGNAL i2_rot, j2_rot : uint06;
    SIGNAL i3_rot, j3_rot : uint06;
    -- Indices de vidas --
    SIGNAL i_vidas, j_vidas1_1, j_vidas1_2, j_vidas1_3 : uint06;
    SIGNAL j_vidas2_1, j_vidas2_2, j_vidas2_3 : uint06;
    SIGNAL j_vidas3_1, j_vidas3_2, j_vidas3_3 : uint06;
    -- Orientacion Motos --
    SIGNAL OrientationMoto1 : uint02;
    SIGNAL OrientationMoto2 : uint02;
    SIGNAL OrientationMoto3 : uint02;

    CONSTANT N : uint06 := Int2SLV(50, 6);
BEGIN
    PX <= PosX;
    PY <= PosY;
    -- Indices iniciales motos --
    i1 <= Int2SLV(SLV2Int(PY) - SLV2Int(MotoY1), 6);
    j1 <= Int2SLV(SLV2Int(PX) - SLV2Int(MotoX1), 6);

    i2 <= Int2SLV(SLV2Int(PY) - SLV2Int(MotoY2), 6);
    j2 <= Int2SLV(SLV2Int(PX) - SLV2Int(MotoX2), 6);

    i3 <= Int2SLV(SLV2Int(PY) - SLV2Int(MotoY3), 6);
    j3 <= Int2SLV(SLV2Int(PX) - SLV2Int(MotoX3), 6);
    -- Indices de rotacion motos --

    -- Moto 1
    OrientationMoto1 <= MotoCurrent1.Orientation;

    i1_rot <= i1 WHEN OrientationMoto1 = "10" ELSE
        i1 WHEN OrientationMoto1 = "11" ELSE
        Int2SLV(SLV2Int(N) - 1 - SLV2Int(j1), 6) WHEN OrientationMoto1 = "01" ELSE
        j1 WHEN OrientationMoto1 = "00" ELSE
        i1;

    j1_rot <= j1 WHEN OrientationMoto1 = "10" ELSE
        Int2SLV(SLV2Int(N) - 1 - SLV2Int(j1), 6) WHEN OrientationMoto1 = "11" ELSE
        i1 WHEN OrientationMoto1 = "01" ELSE
        Int2SLV(SLV2Int(N) - 1 - SLV2Int(i1), 6) WHEN OrientationMoto1 = "00" ELSE
        j1;
    -- Moto 2

    OrientationMoto2 <= MotoCurrent2.Orientation;

    i2_rot <= i2 WHEN OrientationMoto2 = "10" ELSE
        i2 WHEN OrientationMoto2 = "11" ELSE
        Int2SLV(SLV2Int(N) - 1 - SLV2Int(j2), 6) WHEN OrientationMoto2 = "01" ELSE
        j2 WHEN OrientationMoto2 = "00" ELSE
        i2;

    j2_rot <= j2 WHEN OrientationMoto2 = "10" ELSE
        Int2SLV(SLV2Int(N) - 1 - SLV2Int(j2), 6) WHEN OrientationMoto2 = "11" ELSE
        i2 WHEN OrientationMoto2 = "01" ELSE
        Int2SLV(SLV2Int(N) - 1 - SLV2Int(i2), 6) WHEN OrientationMoto2 = "00" ELSE
        j2;

    -- Moto 3

    OrientationMoto3 <= MotoCurrent3.Orientation;

    i3_rot <= i3 WHEN OrientationMoto3 = "10" ELSE
        i3 WHEN OrientationMoto3 = "11" ELSE
        Int2SLV(SLV2Int(N) - 1 - SLV2Int(j3), 6) WHEN OrientationMoto3 = "01" ELSE
        j3 WHEN OrientationMoto3 = "00" ELSE
        i3;

    j3_rot <= j3 WHEN OrientationMoto3 = "10" ELSE
        Int2SLV(SLV2Int(N) - 1 - SLV2Int(j3), 6) WHEN OrientationMoto3 = "11" ELSE
        i3 WHEN OrientationMoto2 = "01" ELSE
        Int2SLV(SLV2Int(N) - 1 - SLV2Int(i3), 6) WHEN OrientationMoto3 = "00" ELSE
        j3;

    -- Indices de las vidas --
    -- Moto 1				 
    i_vidas <= Int2SLV(SLV2Int(PY) - SLV2Int(Moto1_Initial.Vidas_PosY), 6);
    j_vidas1_1 <= Int2SLV(SLV2Int(PX) - SLV2Int(Moto1_Initial.Vidas_PosX1), 6);
    j_vidas1_2 <= Int2SLV(SLV2Int(PX) - SLV2Int(Moto1_Initial.Vidas_PosX2), 6);
    j_vidas1_3 <= Int2SLV(SLV2Int(PX) - SLV2Int(Moto1_Initial.Vidas_PosX3), 6);

    -- Moto 2
    j_vidas2_1 <= Int2SLV(SLV2Int(PX) - SLV2Int(Moto2_Initial.Vidas_PosX1), 6);
    j_vidas2_2 <= Int2SLV(SLV2Int(PX) - SLV2Int(Moto2_Initial.Vidas_PosX2), 6);
    j_vidas2_3 <= Int2SLV(SLV2Int(PX) - SLV2Int(Moto2_Initial.Vidas_PosX3), 6);

    -- Moto 3
    j_vidas3_1 <= Int2SLV(SLV2Int(PX) - SLV2Int(Moto3_Initial.Vidas_PosX1), 6);
    j_vidas3_2 <= Int2SLV(SLV2Int(PX) - SLV2Int(Moto3_Initial.Vidas_PosX2), 6);
    j_vidas3_3 <= Int2SLV(SLV2Int(PX) - SLV2Int(Moto3_Initial.Vidas_PosX3), 6);

    -- Areas de las motos
    -- Moto 1	 

    en_moto1_area <= (
        SLV2Int(PX) >= SLV2Int(MotoX1) AND SLV2Int(PX) < SLV2Int(MotoX1) + SLV2Int(Moto1_Initial.Size) AND
        SLV2Int(PY) >= SLV2Int(MotoY1) AND SLV2Int(PY) < SLV2Int(MotoY1) + SLV2Int(Moto1_Initial.Size)
        );

    -- Moto 2
    en_moto2_area <= (
        SLV2Int(PX) >= SLV2Int(MotoX2) AND SLV2Int(PX) < SLV2Int(MotoX2) + SLV2Int(Moto2_Initial.Size) AND
        SLV2Int(PY) >= SLV2Int(MotoY2) AND SLV2Int(PY) < SLV2Int(MotoY2) + SLV2Int(Moto2_Initial.Size)
        );

    -- Moto 3
    en_moto3_area <= (
        SLV2Int(PX) >= SLV2Int(MotoX3) AND SLV2Int(PX) < SLV2Int(MotoX3) + SLV2Int(Moto3_Initial.Size) AND
        SLV2Int(PY) >= SLV2Int(MotoY3) AND SLV2Int(PY) < SLV2Int(MotoY3) + SLV2Int(Moto3_Initial.Size)
        );
    -- Cuadro azul
    en_cuadro_azul <= (
        PX >= INT2SLV(10, 11) AND PX <= INT2SLV(790, 11) AND
        PY >= INT2SLV(70, 11) AND PY <= INT2SLV(580, 11)
        );

    -- Areas de las vidas
    -- Moto 1	 
    en_vidas1_1 <= (
        SLV2Int(PX) >= SLV2Int(Moto1_Initial.Vidas_PosX1) AND SLV2Int(PX) < SLV2Int(Moto1_Initial.Vidas_PosX1) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto1_Initial.Vidas_PosY) AND SLV2Int(PY) < SLV2Int(Moto1_Initial.Vidas_PosY) + 50
        );

    en_vidas1_2 <= (
        SLV2Int(PX) >= SLV2Int(Moto1_Initial.Vidas_PosX2) AND SLV2Int(PX) < SLV2Int(Moto1_Initial.Vidas_PosX2) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto1_Initial.Vidas_PosY) AND SLV2Int(PY) < SLV2Int(Moto1_Initial.Vidas_PosY) + 50
        );

    en_vidas1_3 <= (
        SLV2Int(PX) >= SLV2Int(Moto1_Initial.Vidas_PosX3) AND SLV2Int(PX) < SLV2Int(Moto1_Initial.Vidas_PosX3) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto1_Initial.Vidas_PosY) AND SLV2Int(PY) < SLV2Int(Moto1_Initial.Vidas_PosY) + 50
        );

    -- Moto 2 	 
    en_vidas2_1 <= (
        SLV2Int(PX) >= SLV2Int(Moto2_Initial.Vidas_PosX1) AND SLV2Int(PX) < SLV2Int(Moto2_Initial.Vidas_PosX1) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto2_Initial.Vidas_PosY) AND SLV2Int(PY) < SLV2Int(Moto2_Initial.Vidas_PosY) + 50
        );

    en_vidas2_2 <= (
        SLV2Int(PX) >= SLV2Int(Moto2_Initial.Vidas_PosX2) AND SLV2Int(PX) < SLV2Int(Moto2_Initial.Vidas_PosX2) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto2_Initial.Vidas_PosY) AND SLV2Int(PY) < SLV2Int(Moto2_Initial.Vidas_PosY) + 50
        );

    en_vidas2_3 <= (
        SLV2Int(PX) >= SLV2Int(Moto2_Initial.Vidas_PosX3) AND SLV2Int(PX) < SLV2Int(Moto2_Initial.Vidas_PosX3) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto2_Initial.Vidas_PosY) AND SLV2Int(PY) < SLV2Int(Moto2_Initial.Vidas_PosY) + 50
        );

    -- Moto 3 	 
    en_vidas3_1 <= (
        SLV2Int(PX) >= SLV2Int(Moto3_Initial.Vidas_PosX1) AND SLV2Int(PX) < SLV2Int(Moto3_Initial.Vidas_PosX1) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto2_Initial.Vidas_PosY) AND SLV2Int(PY) < SLV2Int(Moto2_Initial.Vidas_PosY) + 50
        );

    en_vidas3_2 <= (
        SLV2Int(PX) >= SLV2Int(Moto3_Initial.Vidas_PosX2) AND SLV2Int(PX) < SLV2Int(Moto3_Initial.Vidas_PosX2) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto3_Initial.Vidas_PosY) AND SLV2Int(PY) < SLV2Int(Moto3_Initial.Vidas_PosY) + 50
        );

    en_vidas3_3 <= (
        SLV2Int(PX) >= SLV2Int(Moto3_Initial.Vidas_PosX3) AND SLV2Int(PX) < SLV2Int(Moto3_Initial.Vidas_PosX3) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto3_Initial.Vidas_PosY) AND SLV2Int(PY) < SLV2Int(Moto3_Initial.Vidas_PosY) + 50
        );
    -- Fondos de las motos	 
    -- Moto 1	 
    es_fondo_moto1 <= (
        MotoPlantilla_DerechaR(SLV2Int(i1_rot), SLV2Int(j1_rot)) = x"FF" AND
        MotoPlantilla_DerechaG(SLV2Int(i1_rot), SLV2Int(j1_rot)) = x"00" AND
        MotoPlantilla_DerechaB(SLV2Int(i1_rot), SLV2Int(j1_rot)) = x"DC"
        );

    -- Moto 2	 
    es_fondo_moto2 <= (
        MotoPlantilla_DerechaR(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"FF" AND
        MotoPlantilla_DerechaG(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"00" AND
        MotoPlantilla_DerechaB(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"DC"
        );

    -- Moto 3	 
    es_fondo_moto3 <= (
        MotoPlantilla_DerechaR(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"FF" AND
        MotoPlantilla_DerechaG(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"00" AND
        MotoPlantilla_DerechaB(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"DC"
        );

    -- Fondo Vidas	 
    --Moto 1
    es_fondo_vidas1_1 <= (
        VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) = x"DC"
        );

    es_fondo_vidas1_2 <= (
        VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) = x"DC"
        );

    es_fondo_vidas1_3 <= (
        VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) = x"DC"
        );

    -- Moto 2	 

    es_fondo_vidas2_1 <= (
        VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"DC"
        );

    es_fondo_vidas2_2 <= (
        VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"DC"
        );

    es_fondo_vidas2_3 <= (
        VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"DC"
        );

    -- Moto 3	 

    es_fondo_vidas3_1 <= (
        VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"DC"
        );

    es_fondo_vidas3_2 <= (
        VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"DC"
        );

    es_fondo_vidas3_3 <= (
        VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"DC"
        );

    -------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------- RGB ------------------------------------------------------------------------------------------------------------- 
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -------------------------------------------------------------- RED ------------------------------------------------------------------------------------------------

    RGB.R <=
    ------------------------------------------------------- MOTO 1-------------------------------------------------------------------------------------------
    -- Impresión Moto
    MotoPlantilla_DerechaR(SLV2Int(i1_rot), SLV2Int(j1_rot)) WHEN (VideoOn = '1' AND en_moto1_area AND NOT es_fondo_moto1) ELSE

    -- Impresión Vidas
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) WHEN (VideoOn = '1' AND Slv2Int(Moto1_Initial.N_Vidas) >= 1 AND en_vidas1_1 AND NOT es_fondo_vidas1_1) ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) WHEN (VideoOn = '1' AND Slv2Int(Moto1_Initial.N_Vidas) >= 2 AND en_vidas1_2 AND NOT es_fondo_vidas1_2) ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) WHEN (VideoOn = '1' AND Slv2Int(Moto1_Initial.N_Vidas) = 3 AND en_vidas1_3 AND NOT es_fondo_vidas1_3) ELSE

    ------------------------------------------------------- MOTO 2-------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a naranja (R: FF G: A5 B: 00)
    -- Impresión Moto
    x"FF" WHEN (VideoOn = '1' AND en_moto2_area AND
    MotoPlantilla_DerechaR(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"FA") ELSE

    MotoPlantilla_DerechaR(SLV2Int(i2_rot), SLV2Int(j2_rot)) WHEN (VideoOn = '1' AND en_moto2_area AND NOT es_fondo_moto2) ELSE

    -- Impresión Vidas
    x"FF" WHEN (VideoOn = '1' AND en_vidas2_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"FA") ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) WHEN (VideoOn = '1' AND Slv2Int(Moto2_Initial.N_Vidas) >= 1 AND en_vidas2_1 AND NOT es_fondo_vidas2_1) ELSE

    x"FF" WHEN (VideoOn = '1' AND en_vidas2_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"FA") ELSE

    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) WHEN (VideoOn = '1' AND Slv2Int(Moto2_Initial.N_Vidas) >= 2 AND en_vidas2_2 AND NOT es_fondo_vidas2_2) ELSE

    x"FF" WHEN (VideoOn = '1' AND en_vidas2_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"FA") ELSE

    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) WHEN (VideoOn = '1' AND Slv2Int(Moto2_Initial.N_Vidas) = 3 AND en_vidas2_3 AND NOT es_fondo_vidas2_3) ELSE
    ------------------------------------------------------- MOTO 3-------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a amarillo (R: FF G: FF B: 00)
    -- Impresión Moto
    x"FF" WHEN (VideoOn = '1' AND en_moto3_area AND
    MotoPlantilla_DerechaR(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"FA") ELSE

    MotoPlantilla_DerechaR(SLV2Int(i3_rot), SLV2Int(j3_rot)) WHEN (VideoOn = '1' AND en_moto3_area AND NOT es_fondo_moto3) ELSE

    -- Impresión Vidas
    x"FF" WHEN (VideoOn = '1' AND en_vidas3_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"FA") ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) WHEN (VideoOn = '1' AND Slv2Int(Moto3_Initial.N_Vidas) >= 1 AND en_vidas3_1 AND NOT es_fondo_vidas3_1) ELSE

    x"FF" WHEN (VideoOn = '1' AND en_vidas3_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"FA") ELSE

    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) WHEN (VideoOn = '1' AND Slv2Int(Moto3_Initial.N_Vidas) >= 2 AND en_vidas3_2 AND NOT es_fondo_vidas3_2) ELSE

    x"FF" WHEN (VideoOn = '1' AND en_vidas3_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"FA") ELSE

    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) WHEN (VideoOn = '1' AND Slv2Int(Moto3_Initial.N_Vidas) = 3 AND en_vidas3_3 AND NOT es_fondo_vidas3_3) ELSE
    -- MOTO 4

    ------------------------------------------------------- TRAIL -------------------------------------------------------------------------------------------
    -- Trail Moto 1  (azul)
    x"0C" WHEN (VideoOn = '1' AND Trail1 = "01") ELSE
    -- Trail Moto 2  (naranja)
    x"FF" WHEN (VideoOn = '1' AND Trail2 = "10") ELSE
    -- Trail Moto 3  (amarillo)
    x"FF" WHEN (VideoOn = '1' AND Trail3 = "11") ELSE

    x"00" WHEN (VideoOn = '1' AND en_cuadro_azul) ELSE
    x"FF" WHEN (VideoOn = '1') ELSE
    x"00";

    -------------------------------------------------------------- GREEN ------------------------------------------------------------------------------------------------
    RGB.G <=
    ------------------------------------------------------- MOTO 1-------------------------------------------------------------------------------------------

    MotoPlantilla_DerechaG(SLV2Int(i1_rot), SLV2Int(j1_rot)) WHEN (VideoOn = '1' AND en_moto1_area AND NOT es_fondo_moto1) ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) WHEN (VideoOn = '1' AND Slv2Int(Moto1_Initial.N_Vidas) >= 1 AND en_vidas1_1 AND NOT es_fondo_vidas1_1) ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) WHEN (VideoOn = '1' AND Slv2Int(Moto1_Initial.N_Vidas) >= 2 AND en_vidas1_2 AND NOT es_fondo_vidas1_2) ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) WHEN (VideoOn = '1' AND Slv2Int(Moto1_Initial.N_Vidas) = 3 AND en_vidas1_3 AND NOT es_fondo_vidas1_3) ELSE

    ------------------------------------------------------- MOTO 2-------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a naranja (R: FF G: A5 B: 00)
    -- Impresión Moto

    x"A5" WHEN (VideoOn = '1' AND en_moto2_area AND
    MotoPlantilla_DerechaR(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"FA") ELSE

    MotoPlantilla_DerechaG(SLV2Int(i2_rot), SLV2Int(j2_rot)) WHEN (VideoOn = '1' AND en_moto2_area AND NOT es_fondo_moto2) ELSE

    -- Impresión Vidas

    x"A5" WHEN (VideoOn = '1' AND en_vidas2_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"FA") ELSE

    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) WHEN (VideoOn = '1' AND Slv2Int(Moto2_Initial.N_Vidas) >= 1 AND en_vidas2_1 AND NOT es_fondo_vidas2_1) ELSE

    x"A5" WHEN (VideoOn = '1' AND en_vidas2_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"FA") ELSE

    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) WHEN (VideoOn = '1' AND Slv2Int(Moto2_Initial.N_Vidas) >= 2 AND en_vidas2_2 AND NOT es_fondo_vidas2_2) ELSE

    x"A5" WHEN (VideoOn = '1' AND en_vidas2_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"FA") ELSE

    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) WHEN (VideoOn = '1' AND Slv2Int(Moto2_Initial.N_Vidas) = 3 AND en_vidas2_3 AND NOT es_fondo_vidas2_3) ELSE
    ------------------------------------------------------- MOTO 3-------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a amarillo (R: FF G: FF B: 00)
    -- Impresión Moto
    x"FF" WHEN (VideoOn = '1' AND en_moto3_area AND
    MotoPlantilla_DerechaR(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"FA") ELSE

    MotoPlantilla_DerechaG(SLV2Int(i3_rot), SLV2Int(j3_rot)) WHEN (VideoOn = '1' AND en_moto3_area AND NOT es_fondo_moto3) ELSE

    -- Impresión Vidas
    x"FF" WHEN (VideoOn = '1' AND en_vidas3_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"FA") ELSE

    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) WHEN (VideoOn = '1' AND Slv2Int(Moto3_Initial.N_Vidas) >= 1 AND en_vidas3_1 AND NOT es_fondo_vidas3_1) ELSE

    x"FF" WHEN (VideoOn = '1' AND en_vidas3_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"FA") ELSE

    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) WHEN (VideoOn = '1' AND Slv2Int(Moto3_Initial.N_Vidas) >= 2 AND en_vidas3_2 AND NOT es_fondo_vidas3_2) ELSE

    x"FF" WHEN (VideoOn = '1' AND en_vidas3_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"FA") ELSE

    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) WHEN (VideoOn = '1' AND Slv2Int(Moto3_Initial.N_Vidas) = 3 AND en_vidas3_3 AND NOT es_fondo_vidas3_3) ELSE
    -- MOTO 4
    ------------------------------------------------------- TRAIL -------------------------------------------------------------------------------------------
    -- Trail Moto 1  (azul)
    x"C7" WHEN (VideoOn = '1' AND Trail1 = "01") ELSE
    -- Trail Moto 2  (naranja)
    x"A5" WHEN (VideoOn = '1' AND Trail2 = "10") ELSE
    -- Trail Moto 3  (amarillo)
    x"FF" WHEN (VideoOn = '1' AND Trail3 = "11") ELSE

    x"35" WHEN (VideoOn = '1' AND en_cuadro_azul) ELSE
    x"FF" WHEN (VideoOn = '1') ELSE
    x"00";
    -------------------------------------------------------------- BLUE ------------------------------------------------------------------------------------------------
    RGB.B <=
    ------------------------------------------------------- MOTO 1-------------------------------------------------------------------------------------------
    MotoPlantilla_DerechaB(SLV2Int(i1_rot), SLV2Int(j1_rot)) WHEN (VideoOn = '1' AND en_moto1_area AND NOT es_fondo_moto1) ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) WHEN (VideoOn = '1' AND Slv2Int(Moto1_Initial.N_Vidas) >= 1 AND en_vidas1_1 AND NOT es_fondo_vidas1_1) ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) WHEN (VideoOn = '1' AND Slv2Int(Moto1_Initial.N_Vidas) >= 2 AND en_vidas1_2 AND NOT es_fondo_vidas1_2) ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) WHEN (VideoOn = '1' AND Slv2Int(Moto1_Initial.N_Vidas) = 3 AND en_vidas1_3 AND NOT es_fondo_vidas1_3) ELSE

    ------------------------------------------------------- MOTO 2-------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a naranja (R: FF G: A5 B: 00)
    -- Impresión Moto
    x"00" WHEN (VideoOn = '1' AND en_moto2_area AND
    MotoPlantilla_DerechaR(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"FA") ELSE

    MotoPlantilla_DerechaB(SLV2Int(i2_rot), SLV2Int(j2_rot)) WHEN (VideoOn = '1' AND en_moto2_area AND NOT es_fondo_moto2) ELSE

    -- Impresión Moto

    x"00" WHEN (VideoOn = '1' AND en_vidas2_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"FA") ELSE

    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) WHEN (VideoOn = '1' AND Slv2Int(Moto2_Initial.N_Vidas) >= 1 AND en_vidas2_1 AND NOT es_fondo_vidas2_1) ELSE

    x"00" WHEN (VideoOn = '1' AND en_vidas2_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"FA") ELSE

    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) WHEN (VideoOn = '1' AND Slv2Int(Moto2_Initial.N_Vidas) >= 2 AND en_vidas2_2 AND NOT es_fondo_vidas2_2) ELSE
    x"00" WHEN (VideoOn = '1' AND en_vidas2_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"FA") ELSE

    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) WHEN (VideoOn = '1' AND Slv2Int(Moto2_Initial.N_Vidas) = 3 AND en_vidas2_3 AND NOT es_fondo_vidas2_3) ELSE

    ------------------------------------------------------- MOTO 3-------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a amarillo (R: FF G: FF B: 00)
    -- Impresión Moto
    x"00" WHEN (VideoOn = '1' AND en_moto3_area AND
    MotoPlantilla_DerechaR(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"FA") ELSE

    MotoPlantilla_DerechaB(SLV2Int(i3_rot), SLV2Int(j3_rot)) WHEN (VideoOn = '1' AND en_moto3_area AND NOT es_fondo_moto3) ELSE
    -- Impresión Motos

    x"00" WHEN (VideoOn = '1' AND en_vidas3_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"FA") ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) WHEN (VideoOn = '1' AND Slv2Int(Moto3_Initial.N_Vidas) >= 1 AND en_vidas3_1 AND NOT es_fondo_vidas3_1) ELSE

    x"00" WHEN (VideoOn = '1' AND en_vidas3_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"FA") ELSE

    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) WHEN (VideoOn = '1' AND Slv2Int(Moto3_Initial.N_Vidas) >= 2 AND en_vidas3_2 AND NOT es_fondo_vidas3_2) ELSE

    x"00" WHEN (VideoOn = '1' AND en_vidas3_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"FA") ELSE

    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) WHEN (VideoOn = '1' AND Slv2Int(Moto3_Initial.N_Vidas) = 3 AND en_vidas3_3 AND NOT es_fondo_vidas3_3) ELSE
    -- MOTO 4
    ------------------------------------------------------- TRAIL -------------------------------------------------------------------------------------------
    -- Trail Moto 1  (azul)
    x"FA" WHEN (VideoOn = '1' AND Trail1 = "01") ELSE
    -- Trail Moto 2  (naranja)
    x"00" WHEN (VideoOn = '1' AND Trail2 = "10") ELSE
    -- Trail Moto 3  (amarillo)
    x"00" WHEN (VideoOn = '1' AND Trail3 = "11") ELSE
    x"8A" WHEN (VideoOn = '1' AND en_cuadro_azul) ELSE
    x"FF" WHEN (VideoOn = '1') ELSE
    x"00";
END MainArch;