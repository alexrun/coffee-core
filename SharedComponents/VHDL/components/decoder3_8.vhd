
-----------------------------------------------------------------------------------------------------------
--
-- DECODER 3:8
--
-- The output addressed by dec_addr is the only one to get an "high" logic value
--
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
LIBRARY components;
USE components.sys_definitions.ALL;


ENTITY decoder3_8 IS
   PORT( dec_addr : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
         dec_out  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );
END decoder3_8;



ARCHITECTURE rtl OF decoder3_8 IS

BEGIN

   PROCESS(dec_addr)
   BEGIN
      dec_out(7) <= (dec_addr(2) AND dec_addr(1) AND dec_addr(0));
      dec_out(6) <= (dec_addr(2) AND dec_addr(1) AND NOT (dec_addr(0)));
      dec_out(5) <= (dec_addr(2) AND NOT (dec_addr(1)) AND dec_addr(0));
      dec_out(4) <= (dec_addr(2) AND NOT (dec_addr(1)) AND NOT (dec_addr(0)));
      dec_out(3) <= (NOT(dec_addr(2)) AND dec_addr(1) AND dec_addr(0));
      dec_out(2) <= (NOT(dec_addr(2)) AND dec_addr(1) AND NOT(dec_addr(0)));
      dec_out(1) <= (NOT(dec_addr(2)) AND NOT(dec_addr(1)) AND dec_addr(0));
      dec_out(0) <= (NOT(dec_addr(2)) AND NOT(dec_addr(1)) AND NOT(dec_addr(0)));
   END PROCESS;

END rtl;
