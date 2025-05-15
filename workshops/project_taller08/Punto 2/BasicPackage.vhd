LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE BasicPackage IS

  -- Subtipos para vectores de longitud fija
  SUBTYPE uint01 IS STD_LOGIC;
  SUBTYPE uint02 IS STD_LOGIC_VECTOR(1 DOWNTO 0);
  SUBTYPE uint03 IS STD_LOGIC_VECTOR(2 DOWNTO 0);
  SUBTYPE uint04 IS STD_LOGIC_VECTOR(3 DOWNTO 0);
  SUBTYPE uint05 IS STD_LOGIC_VECTOR(4 DOWNTO 0);
  SUBTYPE uint06 IS STD_LOGIC_VECTOR(5 DOWNTO 0);
  SUBTYPE uint07 IS STD_LOGIC_VECTOR(6 DOWNTO 0);
  SUBTYPE uint08 IS STD_LOGIC_VECTOR(7 DOWNTO 0);
  SUBTYPE uint09 IS STD_LOGIC_VECTOR(8 DOWNTO 0);
  SUBTYPE uint10 IS STD_LOGIC_VECTOR(9 DOWNTO 0);
  SUBTYPE uint11 IS STD_LOGIC_VECTOR(10 DOWNTO 0);

  -- Funciones de conversión
  PURE FUNCTION Slv2Int(Input : STD_LOGIC_VECTOR) RETURN INTEGER;
  PURE FUNCTION Int2Slv(Input : INTEGER; Size : INTEGER) RETURN STD_LOGIC_VECTOR;

  -- Funciones auxiliares para subtipos específicos
  FUNCTION to_uint04(i : INTEGER) RETURN uint04;
  FUNCTION to_uint08(i : INTEGER) RETURN uint08;
  FUNCTION to_uint10(i : INTEGER) RETURN uint10;

END PACKAGE BasicPackage;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

PACKAGE BODY BasicPackage IS

  -- Conversión de SLV a entero
  PURE FUNCTION Slv2Int(Input : STD_LOGIC_VECTOR) RETURN INTEGER IS
  BEGIN
    RETURN TO_INTEGER(UNSIGNED(Input));
  END Slv2Int;

  -- Conversión de entero a SLV
  PURE FUNCTION Int2Slv(Input : INTEGER; Size : INTEGER) RETURN STD_LOGIC_VECTOR IS
  BEGIN
    RETURN STD_LOGIC_VECTOR(TO_UNSIGNED(Input, Size));
  END Int2Slv;

  -- Conversión específica a uint04
  FUNCTION to_uint04(i : INTEGER) RETURN uint04 IS
  BEGIN
    RETURN STD_LOGIC_VECTOR(TO_UNSIGNED(i, 4));
  END to_uint04;

  -- Conversión específica a uint08
  FUNCTION to_uint08(i : INTEGER) RETURN uint08 IS
  BEGIN
    RETURN STD_LOGIC_VECTOR(TO_UNSIGNED(i, 8));
  END to_uint08;

  -- Conversión específica a uint10
  FUNCTION to_uint10(i : INTEGER) RETURN uint10 IS
  BEGIN
    RETURN STD_LOGIC_VECTOR(TO_UNSIGNED(i, 10));
  END to_uint10;

END PACKAGE BODY BasicPackage;



