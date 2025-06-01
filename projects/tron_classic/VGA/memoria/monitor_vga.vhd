LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;
USE WORK.ObjectsPackage.ALL;
ENTITY monitor_vga IS
    PORT (
        Rst : IN uint01;
        Clk : IN uint01;
        btn_up1 : IN uint01;
        btn_down1 : IN uint01;
        btn_left1 : IN uint01;
        btn_right1 : IN uint01;
        btn_up2 : IN uint01;
        btn_down2 : IN uint01;
        btn_left2 : IN uint01;
        btn_right2 : IN uint01;
        HSync : OUT uint01;
        VSync : OUT uint01;
        VGA_clk : OUT uint01;
        RGB : OUT ColorT
    );
END monitor_vga;
ARCHITECTURE MainArch OF monitor_vga IS

    SIGNAL VideoOn : uint01;
    SIGNAL PixelX : uint11;
    SIGNAL PixelY : uint11;
    SIGNAL MotoX1 : uint11;
    SIGNAL MotoY1 : uint11;
    SIGNAL MotoX2 : uint11;
    SIGNAL MotoY2 : uint11;
    SIGNAL MotoX3 : uint11;
    SIGNAL MotoY3 : uint11;
    SIGNAL Moto1Initial : MotoT;
    SIGNAL Moto1 : MotoT;
    SIGNAL Moto2Initial : MotoT;
    SIGNAL Moto2 : MotoT;
    SIGNAL Moto3Initial : MotoT;
    SIGNAL Moto3 : MotoT;
    SIGNAL wr1, wr2, wr3 : uint01 := '0';
    SIGNAL wx1, wy1, wx2, wy2, wx3, wy3 : uint11 := (OTHERS => '0');
    SIGNAL trail1, trail2, trail3 : uint02;

BEGIN

    -----------------------------------------
    ---- Moto Valores iniciales -----------
    -----------------------------------------
    Moto1Initial <= Moto1_Initial;
    Moto2Initial <= Moto2_Initial;
    Moto3Initial <= Moto3_Initial;

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
    MotoControl : ENTITY WORK.FSMMotoController(Behavioral)
        GENERIC MAP(
            STEP => 1
        )
        PORT MAP(
            clk => Clk,
            rst => Rst,
            btn_up => btn_up2,
            btn_down => btn_down2,
            btn_left => btn_left2,
            btn_right => btn_right2,
            MotoInitial => Moto1Initial,
            MotoOut => Moto1,
            pos_x => MotoX1,
            pos_y => MotoY1
        );
    MotoContro2 : ENTITY WORK.FSMMotoController(Behavioral)
        GENERIC MAP(
            STEP => 1
        )
        PORT MAP(
            clk => Clk,
            rst => Rst,
            btn_up => btn_up2,
            btn_down => btn_down2,
            btn_left => btn_left2,
            btn_right => btn_right2,
            MotoInitial => Moto2Initial,
            MotoOut => Moto2,
            pos_x => MotoX2,
            pos_y => MotoY2
        );

    MotoContro3 : ENTITY WORK.FSMMotoController(Behavioral)
        GENERIC MAP(
            STEP => 1
        )
        PORT MAP(
            clk => Clk,
            rst => Rst,
            btn_up => btn_up2,
            btn_down => btn_down2,
            btn_left => btn_left2,
            btn_right => btn_right2,
            MotoInitial => Moto3Initial,
            MotoOut => Moto3,
            pos_x => MotoX3,
            pos_y => MotoY3
        );

    TWU1 : ENTITY WORK.trail_write_unit(behavior)
        PORT MAP(
            clk => Clk,
            rst => Rst,
            cur_x => MotoX1,
            cur_y => MotoY1,
            wr_en => wr1,
            wr_x => wx1,
            wr_y => wy1);

    TWU2 : ENTITY WORK.trail_write_unit(behavior)
        PORT MAP(
            clk => Clk,
            rst => Rst,
            cur_x => MotoX2,
            cur_y => MotoY2,
            wr_en => wr2,
            wr_x => wx2,
            wr_y => wy2);

    TWU3 : ENTITY WORK.trail_write_unit(behavior)
        PORT MAP(
            clk => Clk,
            rst => Rst,
            cur_x => MotoX3,
            cur_y => MotoY3,
            wr_en => wr3,
            wr_x => wx3,
            wr_y => wy3);

    Bank1 : ENTITY WORK.tron_trail_bank(rtl)
        GENERIC MAP(TRAIL_CODE => "01")
        PORT MAP(
            clk => Clk, rst => Rst,
            wr_en_pix => wr1, wr_x => wx1, wr_y => wy1,
            rd_x => PixelX, rd_y => PixelY,
            rd_trail => trail1);

    Bank2 : ENTITY WORK.tron_trail_bank(rtl)
        GENERIC MAP(TRAIL_CODE => "10")
        PORT MAP(
            clk => Clk, rst => Rst,
            wr_en_pix => wr2, wr_x => wx2, wr_y => wy2,
            rd_x => PixelX, rd_y => PixelY,
            rd_trail => trail2);

    Bank3 : ENTITY WORK.tron_trail_bank(rtl)
        GENERIC MAP(TRAIL_CODE => "11")
        PORT MAP(
            clk => Clk, rst => Rst,
            wr_en_pix => wr3, wr_x => wx3, wr_y => wy3,
            rd_x => PixelX, rd_y => PixelY,
            rd_trail => trail3);

    Colores : ENTITY WORK.PixelGenerate(MainArch)
        PORT MAP(
            PosX => PixelX,
            PosY => PixelY,
            MotoX1 => MotoX1, -- Nueva entrada que recibe posiciones FSM
            MotoY1 => MotoY1, -- Nueva entrada que recibe posiciones FSM
            MotoX2 => MotoX2, -- Nueva entrada que recibe posiciones FSM
            MotoY2 => MotoY2,
            MotoX3 => MotoX3, -- Nueva entrada que recibe posiciones FSM
            MotoY3 => MotoY3,
            VideoOn => VideoOn,
            MotoCurrent1 => Moto1,
            MotoCurrent2 => Moto2,
            MotoCurrent3 => Moto3,
            Trail1 => trail1, -- para el trail
            Trail2 => trail2, -- para el trail
            Trail3 => trail3, -- para el trail
            RGB => RGB
        );

    VGA_clk <= Clk;

END MainArch;