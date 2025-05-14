LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE ObjectsPackage IS

  -- Tipo genérico de objeto con posición y tamaño
  TYPE Moto IS RECORD
    PosX : INTEGER;
    PosY : INTEGER;
    Size : INTEGER;
  END RECORD;

  -- Objeto de la moto
  CONSTANT Moto1 : Moto := (
    PosX => 400,
    PosY => 300,
    Size => 50
  );

  -- Objeto del título TRON (usa Plantilla_TronB de 100x100)
  CONSTANT Titulo : Moto := (
    PosX => 330,  -- Ajusta según la resolución de tu VGA
    PosY => 10,
    Size => 100
  );

END PACKAGE ObjectsPackage;


PACKAGE BODY ObjectsPackage IS
END PACKAGE BODY;
