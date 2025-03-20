---------------------------------------------------------------------------------
--    Description: Power of 0, 1 and 2 using a multiplier                        --
--    Author: Ivan Dario Orozco Ibanez (adaptado)                                --
--    Date: 11/02/2025                                                          --
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY power IS
    PORT (
        X : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        S : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END power;
---------------------------------------------------------------------------------
ARCHITECTURE power_arch OF power IS
    SIGNAL prod : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    mult_inst : ENTITY work.Multiplier
        PORT MAP(
            x => X,
            y => X,
            s => prod
        );
    WITH Y SELECT
        S <= "0000000001" WHEN "0000", -- X^0 = 1
        "000000" & X WHEN "0001", -- X^1 = X (se extiende a 10 bits)
        "00" & prod WHEN "0010", -- X^2= X * X (se extiende a 10 bits)
        "1111111111" WHEN OTHERS; -- Valor por defecto (por ejemplo, para otros exponentes)

END power_arch;