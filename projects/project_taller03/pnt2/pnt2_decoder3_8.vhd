------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: Decoder 3:8                                                                --
--  Date: 20/02/2025                                                                    --
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------------------------------
ENTITY pnt2_decoder3_8 IS
    PORT (
        x : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        en : IN STD_LOGIC;
        y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ENTITY pnt2_decoder3_8;
------------------------------------------------------------------------------------------
ARCHITECTURE pnt2_decoder3_8_arch OF pnt2_decoder3_8 IS

    SIGNAL y0, y1 : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL en0, en1 : STD_LOGIC;

BEGIN

    en0 <= en AND (NOT x(2));
    en1 <= en AND x(2);

    Decoder1 : ENTITY work.pnt1_decorder2_4 PORT MAP (x(1 DOWNTO 0), en0, y0);
    Decoder2 : ENTITY work.pnt1_decorder2_4 PORT MAP (x(1 DOWNTO 0), en1, y1);

    y <= y1 & y0;

END ARCHITECTURE pnt2_decoder3_8_arch;