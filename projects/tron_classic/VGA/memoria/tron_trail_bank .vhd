LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.BasicPackage.ALL;

ENTITY tron_trail_bank IS

    -- Definition of moto trail code
    GENERIC (TRAIL_CODE : uint02 := "01");
    PORT (

        -- Clock and Reset
        clk, rst : IN uint01;

        -- Write logic ports
        wr_en_pix : IN uint01;
        wr_x, wr_y : IN uint11;
        rd_x, rd_y : IN uint11;
        rd_trail : OUT uint02
    );
END;

------------------------------------------------------------------
ARCHITECTURE rtl OF tron_trail_bank IS
    ----------------------------------------------------------------
    --  Geometría de la arena (sin cambios)
    ----------------------------------------------------------------
    CONSTANT ORG_X : uint11 := "00000001010"; --  10
    CONSTANT ORG_Y : uint11 := "00001000110"; --  70

    TYPE t_left_array IS ARRAY (0 TO 50) OF uint11;
    CONSTANT L : t_left_array := (
        0 => "00000001010", 1 => "00000011001", 2 => "00000101000",
        3 => "00000110111", 4 => "00001000110", 5 => "00001010101",
        6 => "00001100100", 7 => "00001110011", 8 => "00010000010",
        9 => "00010010001", 10 => "00010100000", 11 => "00010101111",
        12 => "00010111110", 13 => "00011001101", 14 => "00011011100",
        15 => "00011101011", 16 => "00011111010", 17 => "00100001001",
        18 => "00100011000", 19 => "00100100111", 20 => "00100110110",
        21 => "00101000101", 22 => "00101010100", 23 => "00101100011",
        24 => "00101110010", 25 => "00110000001", 26 => "00110010000",
        27 => "00110011111", 28 => "00110101110", 29 => "00110111101",
        30 => "00111001100", 31 => "00111011011", 32 => "00111101010",
        33 => "00111111001", 34 => "01000001000", 35 => "01000010111",
        36 => "01000100110", 37 => "01000110101", 38 => "01001000100",
        39 => "01001010011", 40 => "01001100010", 41 => "01001110001",
        42 => "01010000000", 43 => "01010001111", 44 => "01010011110",
        45 => "01010101101", 46 => "01010111100", 47 => "01011001011",
        48 => "01011011010", 49 => "01011101001", 50 => "01011111000");

    ----------------------------------------------------------------
    --  Señales internas
    ----------------------------------------------------------------
    SIGNAL idx_wr, idx_rd : uint06; -- 0-49
    SIGNAL seg_left_wr, seg_left_rd : uint11;
    SIGNAL col_wr, col_rd : uint04;
    SIGNAL row_wr, row_rd : uint04;
    SIGNAL addr_wr, addr_rd : uint08;

    -- *** solo una franja (i = 0) ***
    SIGNAL we0 : uint01;
    SIGNAL rdb0 : uint02;
BEGIN
    ----------------------------------------------------------------
    -- 1) Índice de franja en X  (misma cadena de comparaciones)
    ----------------------------------------------------------------
    idx_wr <= "000000" WHEN wr_x < L(1) ELSE
        "000001" WHEN wr_x < L(2) ELSE
        -- … resto igual …
        "110001";

    idx_rd <= "000000" WHEN rd_x < L(1) ELSE
        "000001" WHEN rd_x < L(2) ELSE
        -- … resto igual …
        "110001";

    ----------------------------------------------------------------
    -- 2) Borde izquierdo de la franja activa
    ----------------------------------------------------------------
    seg_left_wr <= L(to_integer(unsigned(idx_wr)));
    seg_left_rd <= L(to_integer(unsigned(idx_rd)));

    ----------------------------------------------------------------
    -- 3) Cálculo de col-fila local y dirección dentro del bloque 15×11
    ----------------------------------------------------------------
    col_wr <= STD_LOGIC_VECTOR(unsigned(wr_x) - unsigned(seg_left_wr))(3 DOWNTO 0);
    row_wr <= STD_LOGIC_VECTOR(unsigned(wr_y) - unsigned(ORG_Y))(3 DOWNTO 0);

    col_rd <= STD_LOGIC_VECTOR(unsigned(rd_x) - unsigned(seg_left_rd))(3 DOWNTO 0);
    row_rd <= STD_LOGIC_VECTOR(unsigned(rd_y) - unsigned(ORG_Y))(3 DOWNTO 0);

    addr_wr <= STD_LOGIC_VECTOR((unsigned(row_wr) * 15) + unsigned(col_wr));
    addr_rd <= STD_LOGIC_VECTOR((unsigned(row_rd) * 15) + unsigned(col_rd));

    ----------------------------------------------------------------
    -- 4) Enable de escritura para la franja 0
    ----------------------------------------------------------------
    we0 <= wr_en_pix WHEN idx_wr = "000000" ELSE
        '0';

    ----------------------------------------------------------------
    -- 5)  ÚNICO bloque de memoria (franja 0 : X = 10…24)
    ----------------------------------------------------------------
    seg0 : ENTITY work.tron_mem_seg
        PORT MAP(
            clk => clk,
            rst => rst,
            wr_en => we0,
            wr_addr => addr_wr,
            wr_data => TRAIL_CODE,
            r_addr1 => addr_rd,
            r_data1 => rdb0,
            r_addr2 => (OTHERS => '0'),
            r_data2 => OPEN,
            r_addr3 => (OTHERS => '0'),
            r_data3 => OPEN,
            r_addr4 => (OTHERS => '0'),
            r_data4 => OPEN
        );

    ----------------------------------------------------------------
    -- 6)  Mux de lectura  (solo franja 0)
    ----------------------------------------------------------------
    rd_trail <= rdb0 WHEN idx_rd = "000000" ELSE
        (OTHERS => '0');
END rtl;