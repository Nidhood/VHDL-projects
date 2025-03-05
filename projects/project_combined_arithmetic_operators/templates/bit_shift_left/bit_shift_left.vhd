LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
--                                                                             -- 
--    Two shifter: Shifts the input one times to the left, to multiply by 2.   --
--    Author: Ivan Dario Orozco Ibanez                                         --
--                                                                             --
---------------------------------------------------------------------------------
ENTITY bit_shift_left IS
    PORT (
        X : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        S : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END ENTITY bit_shift_left;
---------------------------------------------------------------------------------
ARCHITECTURE bit_shift_left_arch OF bit_shift_left IS
BEGIN
    S <= X(3) & X(2) & X(1) & X(0) & '0';
END ARCHITECTURE bit_shift_left_arch;