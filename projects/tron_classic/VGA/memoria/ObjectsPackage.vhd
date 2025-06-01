LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;

PACKAGE ObjectsPackage IS

	TYPE MotoT IS RECORD
		PosX : uint11;
		PosY : uint11;
		Size : uint11;
		Orientation : uint02;
		Vidas_PosX1 : uint11;
		Vidas_PosX2 : uint11;
		Vidas_PosX3 : uint11;
		Vidas_PosY : uint11;
		Vidas_SizeW : uint11;
		N_Vidas : uint02;
	END RECORD;
	--00 -> Arriba
	--01 -> Abajo
	--10 -> Derecha
	--11 -> Izquierda
	-- Valores iniciales de la moto 1
	CONSTANT Moto1_Initial : MotoT := (
		PosX => Int2SLV(10, 11),
		PosY => Int2SLV(70, 11),
		Size => Int2SLV(50, 11),
		Orientation => "10",
		Vidas_PosX1 => Int2SLV(10, 11),
		Vidas_PosX2 => Int2SLV((10 + 35), 11),
		Vidas_PosX3 => Int2SLV((10 + 35 + 35), 11),
		Vidas_PosY => Int2SLV(10, 11),
		Vidas_SizeW => Int2SLV(34, 11),
		N_Vidas => "11"
	);
	-- Valores iniciales de la moto 2
	CONSTANT Moto2_Initial : MotoT := (
		PosX => Int2SLV(740, 11),
		PosY => Int2SLV(70, 11),
		Size => Int2SLV(50, 11),
		Orientation => "11",
		Vidas_PosX1 => Int2SLV(195, 11),
		Vidas_PosX2 => Int2SLV((195 + 35), 11),
		Vidas_PosX3 => Int2SLV((195 + 35 + 35), 11),
		Vidas_PosY => Int2SLV(10, 11),
		Vidas_SizeW => Int2SLV(34, 11),
		N_Vidas => "11"
	);

	-- Valores iniciales de la moto 2
	CONSTANT Moto3_Initial : MotoT := (
		PosX => Int2SLV(740, 11),
		PosY => Int2SLV(500, 11),
		Size => Int2SLV(50, 11),
		Orientation => "11",
		Vidas_PosX1 => Int2SLV(380, 11),
		Vidas_PosX2 => Int2SLV((380 + 35), 11),
		Vidas_PosX3 => Int2SLV((380 + 35 + 35), 11),
		Vidas_PosY => Int2SLV(10, 11),
		Vidas_SizeW => Int2SLV(34, 11),
		N_Vidas => "11"
	);
END PACKAGE ObjectsPackage;
PACKAGE BODY ObjectsPackage IS
END PACKAGE BODY;