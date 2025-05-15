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
        SQ_X0   : IN uint10;
        SQ_Y0   : IN uint10;
        VideoOn : IN uint01;
        RGB : OUT ColorT
    );
END ENTITY;

ARCHITECTURE MainArch OF PixelGenerate IS
    SIGNAL sx, sy : INTEGER;
BEGIN
    -- Conversión de posición del sprite a tipo INTEGER
    sx <= to_integer(unsigned(SQ_X0));
    sy <= to_integer(unsigned(SQ_Y0));

    PROCESS (PosX, PosY, sx, sy, VideoOn)
        VARIABLE xi, yi : INTEGER;
        VARIABLE idx_v : INTEGER RANGE 0 TO SQSZ - 1;
        VARIABLE px_v : STD_LOGIC_VECTOR(7 DOWNTO 0);
    BEGIN
        xi := to_integer(unsigned(PosX));
        yi := to_integer(unsigned(PosY));

        IF VideoOn = '1' THEN
            -- Verificar si el píxel actual está dentro del área del cuadrado
            IF xi >= sx AND xi < sx + SQW AND yi >= sy AND yi < sy + SQH THEN
                -- Cálculo del índice del pixel en el arreglo del sprite
                idx_v := (yi - sy) * SQW + (xi - sx);
                px_v := SquareData(idx_v);

                -- Dibujar color del cuadrado o fondo según el valor del pixel
                IF px_v = x"FF" THEN
                    RGB.R <= (OTHERS => '0');
                    RGB.G <= (OTHERS => '0');
                    RGB.B <= (OTHERS => '1'); -- Fondo azul
                ELSE
                    RGB.R <= (OTHERS => '0');
                    RGB.G <= (OTHERS => '0');
                    RGB.B <= (OTHERS => '0'); -- Sprite en negro
                END IF;
            ELSE
                -- Fondo azul
                RGB.R <= (OTHERS => '0');
                RGB.G <= (OTHERS => '0');
                RGB.B <= (OTHERS => '1');
            END IF;
        ELSE
            -- Pantalla en negro fuera de la zona visible
            RGB.R <= (OTHERS => '0');
            RGB.G <= (OTHERS => '0');
            RGB.B <= (OTHERS => '0');
        END IF;
    END PROCESS;
END ARCHITECTURE;
