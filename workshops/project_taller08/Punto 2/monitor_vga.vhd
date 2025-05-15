LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;
USE WORK.SquarePkg.ALL;

ENTITY monitor_vga IS
    PORT (
        Rst : IN uint01;
        Clk : IN uint01;
        Btn_Up : IN uint01;
        Btn_Down : IN uint01;
        Btn_Left : IN uint01;
        Btn_Right : IN uint01;
        HSync : OUT uint01;
        VSync : OUT uint01;
        VGA_clk : OUT uint01;
        RGB : OUT ColorT
    );
END monitor_vga;

ARCHITECTURE MainArch OF monitor_vga IS
    -- Señales internas
    SIGNAL VideoOn : uint01;
    SIGNAL PixelX : uint11;
    SIGNAL PixelY : uint11;
    SIGNAL Sq_X : uint10 := std_logic_vector(to_unsigned(400, 10));
    SIGNAL Sq_Y : uint10 := std_logic_vector(to_unsigned(300, 10));

BEGIN
    

    -- Controlador de posición con botones limpios
    CtrlSquare : ENTITY WORK.FSMSquareController(Behavioral)
        PORT MAP(
            clk => Clk,
            rst => Rst,
            btn_up => Btn_up,
            btn_down => Btn_down,
            btn_left => Btn_left,
            btn_right => Btn_right,
            pos_x => Sq_X,
            pos_y => Sq_Y
        );

    -- Generador de sincronismo VGA
    ImageSync : ENTITY WORK.ImageSync(MainArch)
        PORT MAP(
            Reset => Rst,
            SyncClk => Clk,
            HSync => HSync,
            VSync => VSync,
            VideoOn => VideoOn,
            PixelX => PixelX,
            PixelY => PixelY
        );

    -- Generador de color del píxel
    Colores : ENTITY WORK.PixelGenerate(MainArch)
        PORT MAP(
            PosX => PixelX,
            PosY => PixelY,
            SQ_X0 => Sq_X,
            SQ_Y0 => Sq_Y,
            VideoOn => VideoOn,
            RGB => RGB
        );

    VGA_clk <= Clk;

END ARCHITECTURE; 