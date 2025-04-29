LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY muxes IS
    PORT (
        x1 : IN STD_LOGIC;
        x2 : IN STD_LOGIC;
        sel : IN STD_LOGIC;
        y1 : OUT STD_LOGIC;
        y2 : OUT STD_LOGIC;
        y3 : OUT STD_LOGIC;
        y4 : OUT STD_LOGIC
    );
END ENTITY muxes;
---------------------------------------------------------------------------------
ARCHITECTURE gateLevel OF muxes IS

BEGIN
    mux_gates : ENTITY work.mux2_1_gates
        PORT MAP(
            x1 => x1,
            x2 => x2,
            sel => sel,
            y => y1
        );

    mux_with_select : ENTITY work.mux2_1_with_select
        PORT MAP(
            x1 => x1,
            x2 => x2,
            sel => sel,
            y => y2
        );

    mux_when_else : ENTITY work.mux2_1_when_else
        PORT MAP(
            x1 => x1,
            x2 => x2,
            sel => sel,
            y => y3
        );

    mux_process : ENTITY work.mux2_1_process
        PORT MAP(
            x1 => x1,
            x2 => x2,
            sel => sel,
            y => y4
        );

END ARCHITECTURE gateLevel;