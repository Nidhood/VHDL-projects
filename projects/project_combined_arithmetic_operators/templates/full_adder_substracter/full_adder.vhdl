LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Full_Adder IS
    PORT( X, Y, Cin : IN std_logic;
          sum, Cout : OUT std_logic);
END Full_Adder;

ARCHITECTURE bhv OF Full_Adder IS
BEGIN
    sum <= (X XOR Y) XOR Cin;
    Cout <= (X AND (Y OR Cin)) OR (Cin AND Y);
END bhv;

