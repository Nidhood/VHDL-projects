-----------------------------------------------------------------------
--             Ivan Dario Orozco Ibanez
--  Project: Tron memory segment
--  Date: 22/25/2025
-----------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.BasicPackage.ALL;

ENTITY tron_mem_seg IS
    PORT (
        -- Clock and reset:
        clk : IN uint01;
        rst : IN uint01;

        -- Write logic ports:
        wr_en : IN uint01;
        wr_addr : IN uint11;
        wr_data : IN uint03;

        -- Read logic ports for each moto (asynchronous):
        r_addr1 : IN uint11;
        r_data1 : OUT uint03;
        r_addr2 : IN uint11;
        r_data2 : OUT uint03;
        r_addr3 : IN uint11;
        r_data3 : OUT uint03;
        r_addr4 : IN uint11;
        r_data4 : OUT uint03
    );
END ENTITY tron_mem_seg;

ARCHITECTURE tron_mem_seg_arch OF tron_mem_seg IS

    -- Single shared SRAM of 1064 entries:
    TYPE ram_t IS ARRAY (0 TO 1063) OF uint03;
    SIGNAL ram_shared : ram_t := (OTHERS => (OTHERS => '0'));

BEGIN

    -- Synchronous write process:
    PROCESS (clk)
        VARIABLE ia : INTEGER RANGE 0 TO 1063;
    BEGIN
        IF rising_edge(clk) THEN
            IF rst = '1' THEN
                ram_shared <= (OTHERS => (OTHERS => '0'));
            ELSIF wr_en = '1' THEN
                ia := to_integer(unsigned(wr_addr));
                IF (ia >= 0) AND (ia <= 1063) THEN
                    ram_shared(ia) <= wr_data;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Asynchronous read:
    r_data1 <= ram_shared(to_integer(unsigned(r_addr1)))
        WHEN (to_integer(unsigned(r_addr1)) >= 0 AND
        to_integer(unsigned(r_addr1)) <= 1063)
        ELSE
        (OTHERS => '0');

    r_data2 <= ram_shared(to_integer(unsigned(r_addr2)))
        WHEN (to_integer(unsigned(r_addr2)) >= 0 AND
        to_integer(unsigned(r_addr2)) <= 1063)
        ELSE
        (OTHERS => '0');

    r_data3 <= ram_shared(to_integer(unsigned(r_addr3)))
        WHEN (to_integer(unsigned(r_addr3)) >= 0 AND
        to_integer(unsigned(r_addr3)) <= 1063)
        ELSE
        (OTHERS => '0');

    r_data4 <= ram_shared(to_integer(unsigned(r_addr4)))
        WHEN (to_integer(unsigned(r_addr4)) >= 0 AND
        to_integer(unsigned(r_addr4)) <= 1063)
        ELSE
        (OTHERS => '0');

END ARCHITECTURE tron_mem_seg_arch;