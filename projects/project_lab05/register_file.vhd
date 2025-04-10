LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--------------------------------------------------------------
ENTITY register_file IS
    GENERIC (
        data_width : INTEGER := 8; -- Ancho de datos (bits)
        addr_width : INTEGER := 4); -- Ancho de dirección (bits)

    PORT (
        clk : IN STD_LOGIC; -- Reloj
        wr_en : IN STD_LOGIC; -- Habilitacion de escritura
        w_addrs : IN STD_LOGIC; -- Direccion de escritura
        r_addr : IN INTEGER RANGE 0 TO 2 ** addr_width - 1; -- Direccion de lectura
        w_data : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0); -- Datos a escribir
        r_data : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0) -- Datos leidos
    );
END register_file;
--------------------------------------------------------------
ARCHITECTURE rtl OF register_file IS
    TYPE mem_2d_type IS ARRAY (0 TO 2 ** addr_width - 1) OF STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL array_reg : mem_2d_type;
    SIGNAL en : STD_LOGIC_VECTOR(2 ** addr_width - 1 DOWNTO 0);
    SIGNAL addr_reg : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0);

BEGIN

    -- Write process:
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (wr_en = '1') THEN
                array_reg(to_integer(unsigned(w_addrs))) <= w_data;
            END IF;
            addr_reg <= r_addr;
        END IF;
    END IF;

    -- Read port:
    r_data <= array_reg(to_integer(unsigned(addr_re)));
END ARCHITECTURE;