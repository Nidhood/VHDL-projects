LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;


ENTITY monitor_vga IS
    PORT (
        Rst       : IN uint01;
        Clk       : IN uint01;
        btn_up    : IN uint01;
        btn_down  : IN uint01;
        btn_left  : IN uint01;
        btn_right : IN uint01;
        HSync     : OUT uint01;
        VSync     : OUT uint01;
        VGA_clk   : OUT uint01;
        RGB       : OUT ColorT
    );
END monitor_vga;


ARCHITECTURE MainArch OF monitor_vga IS

    SIGNAL VideoOn : uint01;
    SIGNAL PixelX : uint11;
    SIGNAL PixelY : uint11;
    SIGNAL MotoX  : uint10;
    SIGNAL MotoY  : uint10;
	 
BEGIN

    -- Generación sincronización VGA
    ImageSync : ENTITY WORK.ImageSync(MainArch)
        PORT MAP(
            Reset   => Rst,
            SyncClk => Clk,
            HSync   => HSync,
            VSync   => VSync,
            VideoOn => VideoOn,
            PixelX  => PixelX,
            PixelY  => PixelY
        );

    -- FSM para controlar posición de la moto según botones
    MotoControl : ENTITY WORK.FSMMotoController(Behavioral)
        GENERIC MAP(
            STEP  => 4
        )
        PORT MAP(
            clk       => Clk,
            rst       => Rst,
            btn_up    => btn_up,
            btn_down  => btn_down,
            btn_left  => btn_left,
            btn_right => btn_right,
            pos_x     => MotoX,
            pos_y     => MotoY
        );

    -- Generador píxeles (moto en pantalla)
    Colores : ENTITY WORK.PixelGenerate(MainArch)
        PORT MAP(
            PosX    => PixelX,
            PosY    => PixelY,
            MotoX   => MotoX,    -- Nueva entrada que recibe posiciones FSM
            MotoY   => MotoY,    -- Nueva entrada que recibe posiciones FSM
				OrientationMoto => "10",
            VideoOn => VideoOn,
            RGB     => RGB
        );

    VGA_clk <= Clk;

END MainArch;
