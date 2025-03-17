LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Full_Adder IS
    PORT (
        A, B, Cin : IN STD_LOGIC;
        S, Cout : OUT STD_LOGIC
    );
END Full_Adder;

ARCHITECTURE Full_AdderArch OF Full_Adder IS
BEGIN
    S <= (A XOR B) XOR Cin;
    Cout <= (A AND (B OR Cin)) OR (Cin AND B);
END Full_AdderArch;