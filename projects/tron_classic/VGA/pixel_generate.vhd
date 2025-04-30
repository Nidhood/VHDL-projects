LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;
USE WORK.SquarePkg.ALL;

ENTITY PixelGenerate IS
    GENERIC (
        SQ_X0 : INTEGER := 400; -- X inicial del sprite
        SQ_Y0 : INTEGER := 300 -- Y inicial del sprite
    );
    PORT (
        PosX : IN uint11;
        PosY : IN uint11;
        VideoOn : IN uint01;
        RGB : OUT ColorT
    );
END ENTITY;

ARCHITECTURE MainArch OF PixelGenerate IS
    SIGNAL xi, yi : INTEGER;
BEGIN

    -- Convertir PosX/PosY a enteros
    xi <= to_integer(unsigned(PosX));
    yi <= to_integer(unsigned(PosY));

    PROCESS (xi, yi, VideoOn)
        -- Variables locales combinacionales
        VARIABLE idx_v : INTEGER RANGE 0 TO SQSZ - 1;
        VARIABLE px_v : STD_LOGIC_VECTOR(7 DOWNTO 0);
    BEGIN
        IF VideoOn = '1' THEN
            -- ¿Dentro del área del sprite?
            IF xi >= SQ_X0 AND xi < SQ_X0 + SQW
                AND yi >= SQ_Y0 AND yi < SQ_Y0 + SQH THEN

                -- Calcular índice en el array 1D
                idx_v := (yi - SQ_Y0) * SQW + (xi - SQ_X0);
                px_v := SquareData(idx_v);

                -- Transparencia: x"FF" muestra fondo (azul); otro valor pinta sprite (negro)
                IF px_v = x"FF" THEN
                    RGB.R <= (OTHERS => '0');
                    RGB.G <= (OTHERS => '0');
                    RGB.B <= (OTHERS => '1');
                ELSE
                    RGB.R <= (OTHERS => '0');
                    RGB.G <= (OTHERS => '0');
                    RGB.B <= (OTHERS => '0');
                END IF;

            ELSE
                -- Fondo azul
                RGB.R <= (OTHERS => '0');
                RGB.G <= (OTHERS => '0');
                RGB.B <= (OTHERS => '1');
            END IF;

        ELSE
            -- Fuera de video: negro
            RGB.R <= (OTHERS => '0');
            RGB.G <= (OTHERS => '0');
            RGB.B <= (OTHERS => '0');
        END IF;
    END PROCESS;

END ARCHITECTURE;