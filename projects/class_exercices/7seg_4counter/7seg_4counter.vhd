LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
--                                                                             -- 
--    'oneBitEquality' compares two bits to determine if their value is equal  --
--               The output eq is set to one if thath is true                  -- 
--                                                                             -- 
---------------------------------------------------------------------------------
ENTITY 7seg_4counter IS
    PORT (
        x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        en : IN STD_LOGIC;
        out_7seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY 7seg_4counter;
---------------------------------------------------------------------------------
ARCHITECTURE 7seg_4counter_arch OF 7seg_4counter IS
BEGIN
    enx <= en & x;
    WITH enx SELECT

        -- 0 --
        out_7seg <= "1111110" WHEN "10000",

        -- 1 --
        out_7seg <= "0110000" WHEN "10001",

        -- 2 --
        out_7seg <= "1101101" WHEN "10010",

        -- 3 --
        out_7seg <= "1111001" WHEN "10011",

        -- 4 --
        out_7seg <= "0110011" WHEN "10100",

        -- 5 --
        out_7seg <= "1011011" WHEN "10101",

        -- 6 --
        out_7seg <= "1011111" WHEN "10110",

        -- 7 --
        out_7seg <= "1110000" WHEN "10111",

        -- 8 --
        out_7seg <= "1111111" WHEN "11000",

        -- 9 --
        out_7seg <= "1111011" WHEN "11001",

        -- A --
        out_7seg <= "1110111" WHEN "11010",

        -- B --
        out_7seg <= "0011111" WHEN "11011",

        -- C --
        out_7seg <= "1001110" WHEN "11100",

        -- D --
        out_7seg <= "0111101" WHEN "11101",

        -- E --
        out_7seg <= "1001111" WHEN "11110",

        -- F --
        out_7seg <= "1000111" WHEN "11111";

END 7seg_4counter_arch;