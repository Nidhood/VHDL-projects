LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE SquarePkg IS

    -- Dimensiones del sprite
    CONSTANT SQW : INTEGER := 50;
    CONSTANT SQH : INTEGER := 50;
    CONSTANT SQSZ : INTEGER := SQW * SQH;

    -- Tipo: un array de bytes (8-bit) para cada píxel
    TYPE SquareMem_t IS ARRAY(0 TO SQSZ - 1) OF STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- Datos del sprite:
    CONSTANT SquareData : SquareMem_t := (OTHERS => x"00");

END PACKAGE SquarePkg;