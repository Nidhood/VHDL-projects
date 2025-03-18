LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4_1_select_out IS
    PORT (
        signal3 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal7 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal8 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal9 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        OUTPUT : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );

END ENTITY mux4_1_select_out;

ARCHITECTURE mux4_1_select_outArch OF mux4_1_select_out IS

BEGIN

    OUTPUT <= signal7 WHEN sel = "000" ELSE
        signal9 WHEN sel = "001" ELSE
        signal7 WHEN sel = "010" ELSE
        signal9 WHEN sel = "011" ELSE
        signal9 WHEN sel = "100" ELSE
        signal8 WHEN sel = "101" ELSE
        signal7 WHEN sel = "110" ELSE
        signal3 WHEN sel = "111" ELSE
        0000000000""0000000000";

END mux4_1_select_outArch;

------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.mux4_1_select_out(mux4_1_select_outArch)
--PORT MAP   (signal3 => SLV,
--            signal7 => SLV,
--            signal8 => SLV,
--            signal9 => SLV,
--            sel => SLV,
--            OUTPUT => SLV
--           );