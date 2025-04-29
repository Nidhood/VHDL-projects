------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: Demultiplexor 2:1                                                          --
--  Date: 18/02/2025                                                                    --          
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------------------------------
ENTITY pnt1_4_demux2_1 IS
    PORT (
        x : IN STD_LOGIC;
        s : IN STD_LOGIC;
        y0 : OUT STD_LOGIC;
        y1 : OUT STD_LOGIC
    );
END ENTITY;
------------------------------------------------------------------------------------------
ARCHITECTURE pnt1_4_demux2_1_arch OF pnt1_4_demux2_1 IS
BEGIN
    y0 <= (NOT s) AND x;
    y1 <= s AND x;
END pnt1_4_demux2_1_arch;