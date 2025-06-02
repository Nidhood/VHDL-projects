------------------------------------------------------------------
--                    Ivan Dario Orozco Ibanez                  --
--  Project: Tron SRAM memory Block                             --
--  Date: 22/25/2025                                            --          
------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.BasicPackage.ALL;

------------------------------------------------------------------
ENTITY tron_mem_seg IS
    PORT (
        -- Clock and reset:
        clk : IN uint01;
        rst : IN uint01;

        -- Write logic ports:
        wr_en : IN uint01;
        wr_addr : IN uint08;
        wr_data : IN uint02;

        -- Read logic ports for each moto:
        r_addr1 : IN uint08;
        r_data1 : OUT uint02;

        r_addr2 : IN uint08;
        r_data2 : OUT uint02;

        r_addr3 : IN uint08;
        r_data3 : OUT uint02;

        r_addr4 : IN uint08;
        r_data4 : OUT uint02
    );
END ENTITY;

ARCHITECTURE tron_mem_seg_arch OF tron_mem_seg IS

    -- New data type for 2-bit values:
    TYPE ram_t IS ARRAY (0 TO 164) OF uint02;

    -- Internal RAM copies for each moto:
    SIGNAL ram0, ram1, ram2, ram3 : ram_t := (OTHERS => (OTHERS => '0'));
BEGIN

    -- Synchronous write process for all RAM moto memories:
    PROCESS (clk)
        VARIABLE ia : INTEGER RANGE 0 TO 164;
    BEGIN
        IF rising_edge(clk) THEN
            IF rst = '1' THEN
                ram0 <= (OTHERS => (OTHERS => '0'));
                ram1 <= (OTHERS => (OTHERS => '0'));
                ram2 <= (OTHERS => (OTHERS => '0'));
                ram3 <= (OTHERS => (OTHERS => '0'));
            ELSIF wr_en = '1' THEN
                ia := to_integer(unsigned(wr_addr));
                IF ia <= 164 THEN
                    ram0(ia) <= wr_data;
                    ram1(ia) <= wr_data;
                    ram2(ia) <= wr_data;
                    ram3(ia) <= wr_data;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    ------------------------------------------------------------
    -- Read operations for the four SRAM instances
    ------------------------------------------------------------
    r_data1 <= ram0(to_integer(unsigned(r_addr1))) WHEN unsigned(r_addr1) <= 164 ELSE
        (OTHERS => '0');
    r_data2 <= ram1(to_integer(unsigned(r_addr2))) WHEN unsigned(r_addr2) <= 164 ELSE
        (OTHERS => '0');
    r_data3 <= ram2(to_integer(unsigned(r_addr3))) WHEN unsigned(r_addr3) <= 164 ELSE
        (OTHERS => '0');
    r_data4 <= ram3(to_integer(unsigned(r_addr4))) WHEN unsigned(r_addr4) <= 164 ELSE
        (OTHERS => '0');
END tron_mem_seg_arch;