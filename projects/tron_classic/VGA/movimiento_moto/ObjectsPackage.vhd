LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;

PACKAGE ObjectsPackage IS

  TYPE Moto IS RECORD
    PosX : uint11;
    PosY : uint11;
    Size : uint11;
	 Orientation : uint02;
  END RECORD;

--00 -> Arriba
--01 -> Abajo
--10 -> Derecha
--11 -> Izquierda
  
  
  -- Objeto de la moto
  CONSTANT Moto1 : Moto := (
    PosX => Int2SLV(400, 11),
    PosY => Int2SLV(300, 11),
    Size => Int2SLV(40, 11),
	 Orientation => "11"
  );

  CONSTANT Titulo : Moto := (
    PosX => Int2SLV(330, 11),
    PosY => Int2SLV(10, 11),
    Size => Int2SLV(100, 11),
	 Orientation => "00"
  );

END PACKAGE ObjectsPackage;


PACKAGE BODY ObjectsPackage IS
END PACKAGE BODY;
