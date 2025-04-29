------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: Decoder 2:4 con when/else                                                  --
--  Date: 20/02/2025                                                                    --
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY pnt1_decorder2_4 IS
    PORT (
        x : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        en : IN STD_LOGIC;
        y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY pnt1_decorder2_4;
---------------------------------------------------------------------------------
ARCHITECTURE pnt1_decorder2_4_arch OF pnt1_decorder2_4 IS

BEGIN

    y <=
        "0001" WHEN (en = '1' AND x = "00") ELSE
        "0010" WHEN (en = '1' AND x = "01") ELSE
        "0100" WHEN (en = '1' AND x = "10") ELSE
        "1000" WHEN (en = '1' AND x = "11") ELSE
        "0000";

END ARCHITECTURE pnt1_decorder2_4_arch;