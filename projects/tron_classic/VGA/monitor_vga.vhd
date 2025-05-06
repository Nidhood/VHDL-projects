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
    SIGNAL Sq_X : INTEGER := 400;
    SIGNAL Sq_Y : INTEGER := 300;

    -- Botones "limpios"
    SIGNAL btn_up_clean : STD_LOGIC;
    SIGNAL btn_down_clean : STD_LOGIC;
    SIGNAL btn_left_clean : STD_LOGIC;
    SIGNAL btn_right_clean : STD_LOGIC;

    SIGNAL btn_up_tick : STD_LOGIC;
    SIGNAL btn_down_tick : STD_LOGIC;
    SIGNAL btn_left_tick : STD_LOGIC;
    SIGNAL btn_right_tick : STD_LOGIC;
BEGIN
    BtnUpDebounce : ENTITY WORK.anti_debouncing
        PORT MAP(
            clk => Clk,
            rst => Rst,
            signal_out => btn_up_tick
        );

    BtnDownDebounce : ENTITY WORK.anti_debouncing
        PORT MAP(
            clk => Clk,
            rst => Rst,
            signal_out => btn_down_tick
        );

    BtnLeftDebounce : ENTITY WORK.anti_debouncing
        PORT MAP(
            clk => Clk,
            rst => Rst,
            signal_out => btn_left_tick
        );

    BtnRightDebounce : ENTITY WORK.anti_debouncing
        PORT MAP(
            clk => Clk,
            rst => Rst,
            signal_out => btn_right_tick
        );
    btn_up_clean <= NOT (Btn_Up) AND btn_up_tick;
    btn_down_clean <= NOT (Btn_Down) AND btn_down_tick;
    btn_left_clean <= NOT (Btn_Left) AND btn_left_tick;
    btn_right_clean <= NOT (Btn_Right) AND btn_right_tick;

    -- Controlador de posición con botones limpios
    CtrlSquare : ENTITY WORK.SquareController(Behavioral)
        PORT MAP(
            clk => Clk,
            rst => Rst,
            btn_up => btn_up_clean,
            btn_down => btn_down_clean,
            btn_left => btn_left_clean,
            btn_right => btn_right_clean,
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