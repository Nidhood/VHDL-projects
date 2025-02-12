LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Full_Adder4 IS
    PORT (
        A0, A1, A2, A3 : IN STD_LOGIC;
        B0, B1, B2, B3 : IN STD_LOGIC;
        Cin : IN STD_LOGIC;
        S0, S1, S2, S3 : OUT STD_LOGIC;
        Cout : OUT STD_LOGIC
    );
END ENTITY Full_Adder4;

ARCHITECTURE functional OF Full_Adder4 IS
    SIGNAL concat0, concat1, concat2, concat3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Carry0, Carry1, Carry2 : STD_LOGIC;

BEGIN
    concat0 <= A0 & B0 & Cin;
    concat1 <= A1 & B1 & Carry0;
    concat2 <= A2 & B2 & Carry1;
    concat3 <= A3 & B3 & Carry2;

    WITH concat0 SELECT
        S0 <= '0' WHEN "000",
        '1' WHEN "001",
        '1' WHEN "010",
        '0' WHEN "011",
        '1' WHEN "100",
        '0' WHEN "101",
        '0' WHEN "110",
        '1' WHEN "111",
        '0' WHEN OTHERS;

    WITH concat0 SELECT
        Carry0 <= '0' WHEN "000",
        '0' WHEN "001",
        '0' WHEN "010",
        '1' WHEN "011",
        '0' WHEN "100",
        '1' WHEN "101",
        '1' WHEN "110",
        '1' WHEN "111",
        '0' WHEN OTHERS;

    WITH concat1 SELECT
        S1 <= '0' WHEN "000",
        '1' WHEN "001",
        '1' WHEN "010",
        '0' WHEN "011",
        '1' WHEN "100",
        '0' WHEN "101",
        '0' WHEN "110",
        '1' WHEN "111",
        '0' WHEN OTHERS;

    WITH concat1 SELECT
        Carry1 <= '0' WHEN "000",
        '0' WHEN "001",
        '0' WHEN "010",
        '1' WHEN "011",
        '0' WHEN "100",
        '1' WHEN "101",
        '1' WHEN "110",
        '1' WHEN "111",
        '0' WHEN OTHERS;

    WITH concat2 SELECT
        S2 <= '0' WHEN "000",
        '1' WHEN "001",
        '1' WHEN "010",
        '0' WHEN "011",
        '1' WHEN "100",
        '0' WHEN "101",
        '0' WHEN "110",
        '1' WHEN "111",
        '0' WHEN OTHERS;

    WITH concat2 SELECT
        Carry2 <= '0' WHEN "000",
        '0' WHEN "001",
        '0' WHEN "010",
        '1' WHEN "011",
        '0' WHEN "100",
        '1' WHEN "101",
        '1' WHEN "110",
        '1' WHEN "111",
        '0' WHEN OTHERS;

    WITH concat3 SELECT
        S3 <= '0' WHEN "000",
        '1' WHEN "001",
        '1' WHEN "010",
        '0' WHEN "011",
        '1' WHEN "100",
        '0' WHEN "101",
        '0' WHEN "110",
        '1' WHEN "111",
        '0' WHEN OTHERS;

    WITH concat3 SELECT
        Cout <= '0' WHEN "000",
        '0' WHEN "001",
        '0' WHEN "010",
        '1' WHEN "011",
        '0' WHEN "100",
        '1' WHEN "101",
        '1' WHEN "110",
        '1' WHEN "111",
        '0' WHEN OTHERS;

END ARCHITECTURE functional;