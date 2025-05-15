------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: Demultiplexor 4:1                                                          --
--  Date: 18/02/2025                                                                    --         
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------------------------------
ENTITY pnt1_5_demux4_1 IS
    PORT (
        x : IN STD_LOGIC;
        s0 : IN STD_LOGIC;
        s1 : IN STD_LOGIC;
        y1 : OUT STD_LOGIC;
        y2 : OUT STD_LOGIC;
        y3 : OUT STD_LOGIC;
        y4 : OUT STD_LOGIC
    );
END ENTITY;
------------------------------------------------------------------------------------------
ARCHITECTURE pnt1_5_demux4_1_arch OF pnt1_5_demux4_1 IS
    SIGNAL concat : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN

    concat <= s0 & s1;

    WITH concat SELECT
        y1 <= x WHEN "00",
        '0' WHEN OTHERS;

    WITH concat SELECT
        y2 <= x WHEN "01",
        '0' WHEN OTHERS;

    WITH concat SELECT
        y3 <= x WHEN "10",
        '0' WHEN OTHERS;

    WITH concat SELECT
        y4 <= x WHEN "11",
        '0' WHEN OTHERS;

END pnt1_5_demux4_1_arch;

