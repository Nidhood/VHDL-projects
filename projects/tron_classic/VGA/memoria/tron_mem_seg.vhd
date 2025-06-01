------------------------------------------------------------------
--              Ivan Dario Orozco Ibanez                        --
--  Project: Tron SRAM memory Block (segmented)                 --
--  Date: 22/25/2025                                            --          
------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.BasicPackage.ALL;

ENTITY tron_mem_seg IS
    PORT (

        -- Clock and Reset
        clk, rst : IN uint01;

        -- Write logic ports
        wr_en : IN uint01;
        wr_addr : IN uint08;
        wr_data : IN uint02;

        -- Moto1, Moto2, Moto3, Moto4 read logic ports
        r_addr1 : IN uint08;
        r_data1 : OUT uint02;
        r_addr2 : IN uint08;
        r_data2 : OUT uint02;
        r_addr3 : IN uint08;
        r_data3 : OUT uint02;
        r_addr4 : IN uint08;
        r_data4 : OUT uint02
    );
END;

ARCHITECTURE tron_mem_seg_arch OF tron_mem_seg IS

    -- Segmented block of SRAM, used to store the trail
    TYPE ram_t IS ARRAY (0 TO 164) OF uint02;

    -- Four instances of the SRAM block
    SIGNAL ram0, ram1, ram2, ram3 : ram_t := (OTHERS => (OTHERS => '0'));

BEGIN

    -- Process to handle write operations and reset
    PROCESS (clk)

        -- Index variable for writing to the SRAM data
        VARIABLE ia : INTEGER RANGE 0 TO 164;
    BEGIN
        IF rising_edge(clk) THEN

            -- Reset block of SRAM
            IF rst = '1' THEN
                ram0 <= (OTHERS => (OTHERS => '0'));
                ram1 <= (OTHERS => (OTHERS => '0'));
                ram2 <= (OTHERS => (OTHERS => '0'));
                ram3 <= (OTHERS => (OTHERS => '0'));
                -- Write operation
            ELSIF wr_en = '1' THEN
                ia := to_integer(unsigned(wr_addr));
                IF ia <= 164 THEN
                    ram0(ia) <= wr_data;
                    ram1(ia) <= wr_data;
                    ram2(ia) <= wr_data;
                    ram3(ia) <= wr_data;
                ELSE
                    -- If the address is out of bounds, do nothing
                    NULL;
                END IF;
            ELSE
                -- If not writing, do nothing
                NULL;
            END IF;
        END IF;
    END PROCESS;

    -- Read operations for the four SRAM instances
    r_data1 <= ram0(to_integer(unsigned(r_addr1))) WHEN unsigned(r_addr1) <= 164 ELSE
        (OTHERS => '0');
    r_data2 <= ram1(to_integer(unsigned(r_addr2))) WHEN unsigned(r_addr2) <= 164 ELSE
        (OTHERS => '0');
    r_data3 <= ram2(to_integer(unsigned(r_addr3))) WHEN unsigned(r_addr3) <= 164 ELSE
        (OTHERS => '0');
    r_data4 <= ram3(to_integer(unsigned(r_addr4))) WHEN unsigned(r_addr4) <= 164 ELSE
        (OTHERS => '0');
END tron_mem_seg_arch;