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
        Trail1 : IN uint02; -- Usamos solo Moto1 para el trail
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

    -- Indices de vidas -
    SIGNAL i_vidas : uint06;
    SIGNAL j_vidas1_1, j_vidas1_2, j_vidas1_3 : uint06;
    SIGNAL j_vidas2_1, j_vidas2_2, j_vidas2_3 : uint06;
    SIGNAL j_vidas3_1, j_vidas3_2, j_vidas3_3 : uint06;

    -- Orientacion Motos --
    SIGNAL OrientationMoto1 : uint02;
    SIGNAL OrientationMoto2 : uint02;
    SIGNAL OrientationMoto3 : uint02;

    -- Constantes para el tamano de la celda 50×50 --
    CONSTANT N : uint06 := Int2SLV(50, 6);

    -- Para ubicar cada pixel del trail en la celda 50×50 --
    SIGNAL shifted_x : unsigned(10 DOWNTO 0);
    SIGNAL shifted_y : unsigned(10 DOWNTO 0);

    -- Para ubicar cada pixel del trail en la celda 50x50 --
    SIGNAL col_idx_u : uint04;
    SIGNAL row_idx_u : uint04;
    SIGNAL local_x_u : uint06;
    SIGNAL local_y_u : uint06;
    SIGNAL valid_cell : uint01;

    -- Constantes para limites (todos uint11)
    CONSTANT C10 : uint11 := Int2SLV(10, 11);
    CONSTANT C70 : uint11 := Int2SLV(70, 11);
    CONSTANT C790 : uint11 := Int2SLV(790, 11); -- 10 + 15*50 = 760; para < usamos 790
    CONSTANT C620 : uint11 := Int2SLV(620, 11); -- 70 + 11*50 = 620

    SIGNAL shifted_xt : unsigned(10 DOWNTO 0);
    SIGNAL shifted_yt : unsigned(10 DOWNTO 0);

    SIGNAL col_idx_ut : uint04; -- 0..14, “1111” = fuera de rango dentro de 20×20
    SIGNAL row_idx_ut : uint04; -- 0..10, “1111” = fuera de rango dentro de 20×20
    SIGNAL local_xt : uint06; -- 0..19 dentro de la celda 20×20
    SIGNAL local_yt : uint06; -- 0..19 dentro de la celda 20×20
    SIGNAL valid_trail : uint01; -- '1' si estamos dentro de la cancha 15×11 de 20×20

    CONSTANT CT10 : uint11 := Int2SLV(10, 11); -- mismo offset
    CONSTANT CT70 : uint11 := Int2SLV(70, 11);
    CONSTANT CT310 : uint11 := Int2SLV(10 + 15 * 20, 11); -- = 310
    CONSTANT CT290 : uint11 := Int2SLV(70 + 11 * 20, 11); -- = 290

BEGIN
    ----------------------------------------------------------------
    -- Asignacion de entradas a senales internas
    ----------------------------------------------------------------
    PX <= PosX;
    PY <= PosY;

    ----------------------------------------------------------------
    -- shifted_x = unsigned(PX) - 10 si PX >= 10, sino 0
    ----------------------------------------------------------------
    shifted_x <= unsigned(PX) - unsigned(C10)
        WHEN unsigned(PX) >= unsigned(C10)
        ELSE
        (OTHERS => '0');

    ----------------------------------------------------------------
    -- shifted_y = unsigned(PY) - 70 si PY >= 70, sino 0
    ----------------------------------------------------------------
    shifted_y <= unsigned(PY) - unsigned(C70)
        WHEN unsigned(PY) >= unsigned(C70)
        ELSE
        (OTHERS => '0');

    ----------------------------------------------------------------
    -- valid_cell = '1' si (PX, PY) cae dentro de la cancha 15×11 celdas 50×50
    ----------------------------------------------------------------
    valid_cell <= '1' WHEN
        (unsigned(PX) >= unsigned(C10)) AND
        (unsigned(PX) < unsigned(C790)) AND
        (unsigned(PY) >= unsigned(C70)) AND
        (unsigned(PY) < unsigned(C620))
        ELSE
        '0';

    ----------------------------------------------------------------
    -- col_idx_u = (shifted_x / 50) en uint04, o "1111" si fuera de rango
    ----------------------------------------------------------------
    col_idx_u <= STD_LOGIC_VECTOR(
        resize(
        (shifted_x / to_unsigned(50, 11)),
        4
        )
        )
        WHEN
        (unsigned(PX) >= unsigned(C10)) AND (unsigned(PX) < unsigned(C790))
        ELSE
        (OTHERS => '1');

    ----------------------------------------------------------------
    -- row_idx_u = (shifted_y / 50) en uint04, o "1111" si fuera de rango
    ----------------------------------------------------------------
    row_idx_u <= STD_LOGIC_VECTOR(
        resize(
        (shifted_y / to_unsigned(50, 11)),
        4
        )
        )
        WHEN
        (unsigned(PY) >= unsigned(C70)) AND (unsigned(PY) < unsigned(C620))
        ELSE
        (OTHERS => '1');

    ----------------------------------------------------------------
    -- local_x_u = (shifted_x MOD 50) en uint06, o 0 si fuera de rango
    ----------------------------------------------------------------
    local_x_u <= STD_LOGIC_VECTOR(
        resize(
        (shifted_x MOD to_unsigned(50, 11)),
        6
        )
        )
        WHEN
        (unsigned(PX) >= unsigned(C10)) AND (unsigned(PX) < unsigned(C790))
        ELSE
        (OTHERS => '0');

    ----------------------------------------------------------------
    -- local_y_u = (shifted_y MOD 50) en uint06, o 0 si fuera de rango
    ----------------------------------------------------------------
    local_y_u <= STD_LOGIC_VECTOR(
        resize(
        (shifted_y MOD to_unsigned(50, 11)),
        6
        )
        )
        WHEN
        (unsigned(PY) >= unsigned(C70)) AND (unsigned(PY) < unsigned(C620))
        ELSE
        (OTHERS => '0');

    shifted_xt <= unsigned(PX) - unsigned(CT10)
        WHEN unsigned(PX) >= unsigned(CT10)
        ELSE
        (OTHERS => '0');

    shifted_yt <= unsigned(PY) - unsigned(CT70)
        WHEN unsigned(PY) >= unsigned(CT70)
        ELSE
        (OTHERS => '0');

    valid_trail <= '1' WHEN
        (unsigned(PX) >= unsigned(CT10)) AND (unsigned(PX) < unsigned(CT310)) AND
        (unsigned(PY) >= unsigned(CT70)) AND (unsigned(PY) < unsigned(CT290))
        ELSE
        '0';

    col_idx_ut <= STD_LOGIC_VECTOR(
        resize((shifted_xt / to_unsigned(20, 11)), 4)
        )
        WHEN (unsigned(PX) >= unsigned(CT10)) AND (unsigned(PX) < unsigned(CT310))
        ELSE
        (OTHERS => '1');

    row_idx_ut <= STD_LOGIC_VECTOR(
        resize((shifted_yt / to_unsigned(20, 11)), 4)
        )
        WHEN (unsigned(PY) >= unsigned(CT70)) AND (unsigned(PY) < unsigned(CT290))
        ELSE
        (OTHERS => '1');

    local_xt <= STD_LOGIC_VECTOR(
        resize((shifted_xt MOD to_unsigned(20, 11)), 6)
        )
        WHEN (unsigned(PX) >= unsigned(CT10)) AND (unsigned(PX) < unsigned(CT310))
        ELSE
        (OTHERS => '0');

    local_yt <= STD_LOGIC_VECTOR(
        resize((shifted_yt MOD to_unsigned(20, 11)), 6)
        )
        WHEN (unsigned(PY) >= unsigned(CT70)) AND (unsigned(PY) < unsigned(CT290))
        ELSE
        (OTHERS => '0');

    ----------------------------------------------------------------
    -- Calculo de indices y rotaciones para las texturas de las motos
    ----------------------------------------------------------------
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
        i3 WHEN OrientationMoto3 = "01" ELSE
        Int2SLV(SLV2Int(N) - 1 - SLV2Int(i3), 6) WHEN OrientationMoto3 = "00" ELSE
        j3;

    ----------------------------------------------------------------
    -- Calculo de indices para “vidas”
    ----------------------------------------------------------------
    i_vidas <= Int2SLV(SLV2Int(PY) - SLV2Int(Moto1_Initial.Vidas_PosY), 6);

    -- Moto 1
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

    ----------------------------------------------------------------
    -- Definir zonas de moto, vidas y fondo
    ----------------------------------------------------------------

    -- Moto 1
    en_moto1_area <=
        (SLV2Int(PX) >= SLV2Int(MotoX1) AND
        SLV2Int(PX) < SLV2Int(MotoX1) + SLV2Int(Moto1_Initial.Size) AND
        SLV2Int(PY) >= SLV2Int(MotoY1) AND
        SLV2Int(PY) < SLV2Int(MotoY1) + SLV2Int(Moto1_Initial.Size));

    -- Moto 2
    en_moto2_area <=
        (SLV2Int(PX) >= SLV2Int(MotoX2) AND
        SLV2Int(PX) < SLV2Int(MotoX2) + SLV2Int(Moto2_Initial.Size) AND
        SLV2Int(PY) >= SLV2Int(MotoY2) AND
        SLV2Int(PY) < SLV2Int(MotoY2) + SLV2Int(Moto2_Initial.Size));

    -- Moto 3
    en_moto3_area <=
        (SLV2Int(PX) >= SLV2Int(MotoX3) AND
        SLV2Int(PX) < SLV2Int(MotoX3) + SLV2Int(Moto3_Initial.Size) AND
        SLV2Int(PY) >= SLV2Int(MotoY3) AND
        SLV2Int(PY) < SLV2Int(MotoY3) + SLV2Int(Moto3_Initial.Size));

    -- Cuadro azul
    en_cuadro_azul <=
        (PX >= INT2SLV(10, 11) AND PX <= INT2SLV(790, 11) AND
        PY >= INT2SLV(70, 11) AND PY <= INT2SLV(580, 11));

    -- Moto 1 - 1
    en_vidas1_1 <=
        (SLV2Int(PX) >= SLV2Int(Moto1_Initial.Vidas_PosX1) AND
        SLV2Int(PX) < SLV2Int(Moto1_Initial.Vidas_PosX1) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto1_Initial.Vidas_PosY) AND
        SLV2Int(PY) < SLV2Int(Moto1_Initial.Vidas_PosY) + 50);

    -- Moto 1 - 2
    en_vidas1_2 <=
        (SLV2Int(PX) >= SLV2Int(Moto1_Initial.Vidas_PosX2) AND
        SLV2Int(PX) < SLV2Int(Moto1_Initial.Vidas_PosX2) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto1_Initial.Vidas_PosY) AND
        SLV2Int(PY) < SLV2Int(Moto1_Initial.Vidas_PosY) + 50);

    -- Moto 1 - 3
    en_vidas1_3 <=
        (SLV2Int(PX) >= SLV2Int(Moto1_Initial.Vidas_PosX3) AND
        SLV2Int(PX) < SLV2Int(Moto1_Initial.Vidas_PosX3) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto1_Initial.Vidas_PosY) AND
        SLV2Int(PY) < SLV2Int(Moto1_Initial.Vidas_PosY) + 50);

    -- Moto 2 - 1
    en_vidas2_1 <=
        (SLV2Int(PX) >= SLV2Int(Moto2_Initial.Vidas_PosX1) AND
        SLV2Int(PX) < SLV2Int(Moto2_Initial.Vidas_PosX1) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto2_Initial.Vidas_PosY) AND
        SLV2Int(PY) < SLV2Int(Moto2_Initial.Vidas_PosY) + 50);

    -- Moto 2 - 2
    en_vidas2_2 <=
        (SLV2Int(PX) >= SLV2Int(Moto2_Initial.Vidas_PosX2) AND
        SLV2Int(PX) < SLV2Int(Moto2_Initial.Vidas_PosX2) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto2_Initial.Vidas_PosY) AND
        SLV2Int(PY) < SLV2Int(Moto2_Initial.Vidas_PosY) + 50);

    -- Moto 2 - 3
    en_vidas2_3 <=
        (SLV2Int(PX) >= SLV2Int(Moto2_Initial.Vidas_PosX3) AND
        SLV2Int(PX) < SLV2Int(Moto2_Initial.Vidas_PosX3) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto2_Initial.Vidas_PosY) AND
        SLV2Int(PY) < SLV2Int(Moto2_Initial.Vidas_PosY) + 50);

    -- Moto 3 - 1
    en_vidas3_1 <=
        (SLV2Int(PX) >= SLV2Int(Moto3_Initial.Vidas_PosX1) AND
        SLV2Int(PX) < SLV2Int(Moto3_Initial.Vidas_PosX1) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto3_Initial.Vidas_PosY) AND
        SLV2Int(PY) < SLV2Int(Moto3_Initial.Vidas_PosY) + 50);

    -- Moto 3 - 2
    en_vidas3_2 <=
        (SLV2Int(PX) >= SLV2Int(Moto3_Initial.Vidas_PosX2) AND
        SLV2Int(PX) < SLV2Int(Moto3_Initial.Vidas_PosX2) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto3_Initial.Vidas_PosY) AND
        SLV2Int(PY) < SLV2Int(Moto3_Initial.Vidas_PosY) + 50);

    -- Moto 3 - 3
    en_vidas3_3 <=
        (SLV2Int(PX) >= SLV2Int(Moto3_Initial.Vidas_PosX3) AND
        SLV2Int(PX) < SLV2Int(Moto3_Initial.Vidas_PosX3) + 35 AND
        SLV2Int(PY) >= SLV2Int(Moto3_Initial.Vidas_PosY) AND
        SLV2Int(PY) < SLV2Int(Moto3_Initial.Vidas_PosY) + 50);

    ----------------------------------------------------------------
    -- Detectar magenta en plantillas (fondo de moto)
    ----------------------------------------------------------------

    -- Moto 1
    es_fondo_moto1 <=
        (MotoPlantilla_DerechaR(SLV2Int(i1_rot), SLV2Int(j1_rot)) = x"FF" AND
        MotoPlantilla_DerechaG(SLV2Int(i1_rot), SLV2Int(j1_rot)) = x"00" AND
        MotoPlantilla_DerechaB(SLV2Int(i1_rot), SLV2Int(j1_rot)) = x"DC");

    -- Moto 2
    es_fondo_moto2 <=
        (MotoPlantilla_DerechaR(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"FF" AND
        MotoPlantilla_DerechaG(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"00" AND
        MotoPlantilla_DerechaB(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"DC");

    -- Moto 3
    es_fondo_moto3 <=
        (MotoPlantilla_DerechaR(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"FF" AND
        MotoPlantilla_DerechaG(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"00" AND
        MotoPlantilla_DerechaB(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"DC");

    ----------------------------------------------------------------
    -- Detectar magenta en “vidas” (fondo de vidas)
    ----------------------------------------------------------------

    -- Moto 1 - 1
    es_fondo_vidas1_1 <=
        (VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) = x"DC");

    -- Moto 1 - 2
    es_fondo_vidas1_2 <=
        (VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) = x"DC");

    -- Moto 1 - 3
    es_fondo_vidas1_3 <=
        (VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) = x"DC");

    -- Moto 2 - 1
    es_fondo_vidas2_1 <=
        (VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"DC");

    -- Moto 2 - 2
    es_fondo_vidas2_2 <=
        (VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"DC");

    -- Moto 2 - 3
    es_fondo_vidas2_3 <=
        (VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"DC");

    -- Moto 3 - 1
    es_fondo_vidas3_1 <=
        (VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"DC");

    -- Moto 3 - 2
    es_fondo_vidas3_2 <=
        (VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"DC");

    -- Moto 3 - 3
    es_fondo_vidas3_3 <=
        (VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"FF" AND
        VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"00" AND
        VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"DC");

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------- RGB ------------------------------------------------------------------------------------------------------------- 
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -------------------------------------------------------------- RED -------------------------------------------------------------------------------------------------
    RGB.R <=
    ------------------------------------------------------- MOTO 1 -----------------------------------------------------------------------------------------------------
    -- Impresion moto
    MotoPlantilla_DerechaR(SLV2Int(i1_rot), SLV2Int(j1_rot)) WHEN (VideoOn = '1' AND en_moto1_area AND NOT es_fondo_moto1) ELSE

    -- Impresion vidas Moto 1
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) WHEN (VideoOn = '1' AND SLV2Int(Moto1_Initial.N_Vidas) >= 1 AND en_vidas1_1 AND NOT es_fondo_vidas1_1) ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) WHEN (VideoOn = '1' AND SLV2Int(Moto1_Initial.N_Vidas) >= 2 AND en_vidas1_2 AND NOT es_fondo_vidas1_2) ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) WHEN (VideoOn = '1' AND SLV2Int(Moto1_Initial.N_Vidas) = 3 AND en_vidas1_3 AND NOT es_fondo_vidas1_3) ELSE

    ------------------------------------------------------- MOTO 2 -------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a naranja (R: FF G: A5 B: 00)
    -- Impresion moto
    x"FF" WHEN (VideoOn = '1' AND en_moto2_area AND
    MotoPlantilla_DerechaR(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"FA") ELSE
    MotoPlantilla_DerechaR(SLV2Int(i2_rot), SLV2Int(j2_rot)) WHEN (VideoOn = '1' AND en_moto2_area AND NOT es_fondo_moto2) ELSE

    -- Impresion vidas Moto 2 - 1
    x"FF" WHEN (VideoOn = '1' AND en_vidas2_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"FA") ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_1))
    WHEN (VideoOn = '1' AND SLV2Int(Moto2_Initial.N_Vidas) >= 1 AND en_vidas2_1 AND NOT es_fondo_vidas2_1) ELSE

    -- Impresion vidas Moto 2 - 2
    x"FF"
    WHEN (VideoOn = '1' AND en_vidas2_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"FA") ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_2))
    WHEN (VideoOn = '1' AND SLV2Int(Moto2_Initial.N_Vidas) >= 2 AND en_vidas2_2 AND NOT es_fondo_vidas2_2) ELSE

    -- Impresion vidas Moto 2 - 3
    x"FF"
    WHEN (VideoOn = '1' AND en_vidas2_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"FA") ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_3))
    WHEN (VideoOn = '1' AND SLV2Int(Moto2_Initial.N_Vidas) = 3 AND en_vidas2_3 AND NOT es_fondo_vidas2_3) ELSE

    ------------------------------------------------------- MOTO 3 -------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a amarillo (R: FF G: FF B: 00)
    -- Impresion Moto
    x"FF" WHEN (VideoOn = '1' AND en_moto3_area AND
    MotoPlantilla_DerechaR(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"FA") ELSE
    MotoPlantilla_DerechaR(SLV2Int(i3_rot), SLV2Int(j3_rot)) WHEN (VideoOn = '1' AND en_moto3_area AND NOT es_fondo_moto3) ELSE

    -- Impresion vidas Moto 3 - 1
    x"FF" WHEN (VideoOn = '1' AND en_vidas3_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"FA") ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_1))
    WHEN (VideoOn = '1' AND SLV2Int(Moto3_Initial.N_Vidas) >= 1 AND en_vidas3_1 AND NOT es_fondo_vidas3_1) ELSE

    -- Impresion vidas Moto 3 - 2
    x"FF" WHEN (VideoOn = '1' AND en_vidas3_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"FA") ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_2))
    WHEN (VideoOn = '1' AND SLV2Int(Moto3_Initial.N_Vidas) >= 2 AND en_vidas3_2 AND NOT es_fondo_vidas3_2) ELSE

    -- Impresion vidas Moto 3 - 3
    x"FF" WHEN (VideoOn = '1' AND en_vidas3_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"FA") ELSE
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_3))
    WHEN (VideoOn = '1' AND SLV2Int(Moto3_Initial.N_Vidas) = 3 AND en_vidas3_3 AND NOT es_fondo_vidas3_3) ELSE

    ------------------------------------------------------- TRAIL (20×20 bloque completo) --------------------------------------------------------------------------------
    x"0C" WHEN (VideoOn = '1' AND valid_cell = '1' AND Trail1 = "01") ELSE

    ------------------------------------------------------- FONDO AZUL DE LA CANCHA --------------------------------------------------------------------------------
    x"00" WHEN (VideoOn = '1' AND en_cuadro_azul) ELSE
    x"FF" WHEN (VideoOn = '1') ELSE
    x"00";

    -------------------------------------------------------------- GREEN ------------------------------------------------------------------------------------------------
    RGB.G <=
    ------------------------------------------------------- MOTO 1 -------------------------------------------------------------------------------------------
    MotoPlantilla_DerechaG(SLV2Int(i1_rot), SLV2Int(j1_rot))
    WHEN (VideoOn = '1' AND en_moto1_area AND NOT es_fondo_moto1) ELSE

    -- Vidas Moto 1
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) WHEN (VideoOn = '1' AND SLV2Int(Moto1_Initial.N_Vidas) >= 1 AND en_vidas1_1 AND NOT es_fondo_vidas1_1) ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) WHEN (VideoOn = '1' AND SLV2Int(Moto1_Initial.N_Vidas) >= 2 AND en_vidas1_2 AND NOT es_fondo_vidas1_2) ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) WHEN (VideoOn = '1' AND SLV2Int(Moto1_Initial.N_Vidas) = 3 AND en_vidas1_3 AND NOT es_fondo_vidas1_3) ELSE

    ------------------------------------------------------- MOTO 2 -------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a naranja (R: FF G: A5 B: 00)
    -- Impresion Moto

    x"A5" WHEN (VideoOn = '1' AND en_moto2_area AND
    MotoPlantilla_DerechaR(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"FA") ELSE
    MotoPlantilla_DerechaG(SLV2Int(i2_rot), SLV2Int(j2_rot)) WHEN (VideoOn = '1' AND en_moto2_area AND NOT es_fondo_moto2) ELSE

    -- Impresion vidas Moto 2 - 1
    x"A5" WHEN (VideoOn = '1' AND en_vidas2_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"FA") ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_1))WHEN (VideoOn = '1' AND SLV2Int(Moto2_Initial.N_Vidas) >= 1 AND en_vidas2_1 AND NOT es_fondo_vidas2_1) ELSE

    -- Impresion vidas Moto 2 - 2
    x"A5" WHEN (VideoOn = '1' AND en_vidas2_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"FA") ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) WHEN (VideoOn = '1' AND SLV2Int(Moto2_Initial.N_Vidas) >= 2 AND en_vidas2_2 AND NOT es_fondo_vidas2_2) ELSE

    -- Impresion vidas Moto 2 - 3
    x"A5" WHEN (VideoOn = '1' AND en_vidas2_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"FA") ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) WHEN (VideoOn = '1' AND SLV2Int(Moto2_Initial.N_Vidas) = 3 AND en_vidas2_3 AND NOT es_fondo_vidas2_3) ELSE

    ------------------------------------------------------- MOTO 3 -------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a amarillo (R: FF G: FF B: 00)
    -- Impresion Moto
    x"FF" WHEN (VideoOn = '1' AND en_moto3_area AND
    MotoPlantilla_DerechaR(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"FA") ELSE
    MotoPlantilla_DerechaG(SLV2Int(i3_rot), SLV2Int(j3_rot)) WHEN (VideoOn = '1' AND en_moto3_area AND NOT es_fondo_moto3) ELSE

    -- Impresion vidas Moto 3 - 1
    x"FF" WHEN (VideoOn = '1' AND en_vidas3_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"FA") ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) WHEN (VideoOn = '1' AND SLV2Int(Moto3_Initial.N_Vidas) >= 1 AND en_vidas3_1 AND NOT es_fondo_vidas3_1) ELSE

    -- Impresion vidas Moto 3 - 2
    x"FF" WHEN (VideoOn = '1' AND en_vidas3_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"FA") ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) WHEN (VideoOn = '1' AND SLV2Int(Moto3_Initial.N_Vidas) >= 2 AND en_vidas3_2 AND NOT es_fondo_vidas3_2) ELSE

    -- Impresion vidas Moto 3 - 3
    x"FF" WHEN (VideoOn = '1' AND en_vidas3_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"FA") ELSE
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) WHEN (VideoOn = '1' AND SLV2Int(Moto3_Initial.N_Vidas) = 3 AND en_vidas3_3 AND NOT es_fondo_vidas3_3) ELSE

    ------------------------------------------------------- TRAIL (20×20 bloque completo) --------------------------------------------------------------------------------
    x"C7" WHEN (VideoOn = '1' AND valid_cell = '1' AND Trail1 = "01") ELSE

    ------------------------------------------------------- FONDO AZUL DE LA CANCHA --------------------------------------------------------------------------------
    x"00" WHEN (VideoOn = '1' AND en_cuadro_azul) ELSE
    x"FF"WHEN (VideoOn = '1') ELSE
    x"00";

    -------------------------------------------------------------- BLUE ------------------------------------------------------------------------------------------------
    RGB.B <=
    ------------------------------------------------------- MOTO 1 -------------------------------------------------------------------------------------------
    MotoPlantilla_DerechaB(SLV2Int(i1_rot), SLV2Int(j1_rot)) WHEN (VideoOn = '1' AND en_moto1_area AND NOT es_fondo_moto1) ELSE

    -- Vidas Moto 1
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_1)) WHEN (VideoOn = '1' AND SLV2Int(Moto1_Initial.N_Vidas) >= 1 AND en_vidas1_1 AND NOT es_fondo_vidas1_1) ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_2)) WHEN (VideoOn = '1' AND SLV2Int(Moto1_Initial.N_Vidas) >= 2 AND en_vidas1_2 AND NOT es_fondo_vidas1_2) ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas1_3)) WHEN (VideoOn = '1' AND SLV2Int(Moto1_Initial.N_Vidas) = 3 AND en_vidas1_3 AND NOT es_fondo_vidas1_3) ELSE

    ------------------------------------------------------- MOTO 2 -------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a naranja (R: FF G: A5 B: 00)
    -- Impresion Moto
    x"00" WHEN (VideoOn = '1' AND en_moto2_area AND
    MotoPlantilla_DerechaR(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i2_rot), SLV2Int(j2_rot)) = x"FA") ELSE
    MotoPlantilla_DerechaB(SLV2Int(i2_rot), SLV2Int(j2_rot)) WHEN (VideoOn = '1' AND en_moto2_area AND NOT es_fondo_moto2) ELSE

    -- Impresion vidas Moto 2 - 1
    x"00" WHEN (VideoOn = '1' AND en_vidas2_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) = x"FA") ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_1)) WHEN (VideoOn = '1' AND SLV2Int(Moto2_Initial.N_Vidas) >= 1 AND en_vidas2_1 AND NOT es_fondo_vidas2_1) ELSE

    -- Impresion vidas Moto 2 - 2
    x"00" WHEN (VideoOn = '1' AND en_vidas2_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) = x"FA") ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_2)) WHEN (VideoOn = '1' AND SLV2Int(Moto2_Initial.N_Vidas) >= 2 AND en_vidas2_2 AND NOT es_fondo_vidas2_2) ELSE

    -- Impresion vidas Moto 2 - 3
    x"00" WHEN (VideoOn = '1' AND en_vidas2_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) = x"FA") ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas2_3)) WHEN (VideoOn = '1' AND SLV2Int(Moto2_Initial.N_Vidas) = 3 AND en_vidas2_3 AND NOT es_fondo_vidas2_3) ELSE

    ------------------------------------------------------- MOTO 3 -------------------------------------------------------------------------------------------
    -- Cambio de color de azul (R: 0C G: C7 B: FA) a amarillo (R: FF G: FF B: 00)
    -- Impresion Moto
    x"00" WHEN (VideoOn = '1' AND en_moto3_area AND
    MotoPlantilla_DerechaR(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"0C" AND
    MotoPlantilla_DerechaG(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"C7" AND
    MotoPlantilla_DerechaB(SLV2Int(i3_rot), SLV2Int(j3_rot)) = x"FA") ELSE
    MotoPlantilla_DerechaB(SLV2Int(i3_rot), SLV2Int(j3_rot)) WHEN (VideoOn = '1' AND en_moto3_area AND NOT es_fondo_moto3) ELSE

    -- Impresion vidas Moto 3 - 1
    x"00" WHEN (VideoOn = '1' AND en_vidas3_1 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) = x"FA") ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_1)) WHEN (VideoOn = '1' AND SLV2Int(Moto3_Initial.N_Vidas) >= 1 AND en_vidas3_1 AND NOT es_fondo_vidas3_1) ELSE

    -- Impresion vidas Moto 3 - 2
    x"00" WHEN (VideoOn = '1' AND en_vidas3_2 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_2)) = x"FA") ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_2))
    WHEN (VideoOn = '1' AND SLV2Int(Moto3_Initial.N_Vidas) >= 2 AND en_vidas3_2 AND NOT es_fondo_vidas3_2) ELSE

    -- Impresion vidas Moto 3 - 3
    x"00" WHEN (VideoOn = '1' AND en_vidas3_3 AND
    VidasR(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"0C" AND
    VidasG(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"C7" AND
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) = x"FA") ELSE
    VidasB(SLV2Int(i_vidas), SLV2Int(j_vidas3_3)) WHEN (VideoOn = '1' AND SLV2Int(Moto3_Initial.N_Vidas) = 3 AND en_vidas3_3 AND NOT es_fondo_vidas3_3) ELSE

    ------------------------------------------------------- TRAIL (20×20 con bloque completo) --------------------------------------------------------------------------------
    x"FA" WHEN (VideoOn = '1' AND valid_cell = '1' AND Trail1 = "01") ELSE

    ------------------------------------------------------- FONDO AZUL DE LA CANCHA --------------------------------------------------------------------------------
    x"8A" WHEN (VideoOn = '1' AND en_cuadro_azul) ELSE
    x"FF"WHEN (VideoOn = '1') ELSE
    x"00";
END MainArch;