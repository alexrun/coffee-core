
-----------------------------------------------------------------------------------------------------------
--
-- DECODER 5:32
--
-- The output addressed by dec_addr is the only one to get an "high" logic value
--
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
LIBRARY components;
USE components.sys_definitions.ALL;

ENTITY decoder5_32 IS
   PORT
      (
         dec_addr : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         dec_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END decoder5_32;


ARCHITECTURE rtl OF decoder5_32 IS
BEGIN


   dec_out(0) <= (NOT(dec_addr(4)) AND (NOT(dec_addr(3)) AND NOT(dec_addr(2)) AND NOT(dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(1) <= (NOT(dec_addr(4)) AND (NOT(dec_addr(3)) AND NOT(dec_addr(2)) AND NOT(dec_addr(1)) AND (dec_addr(0))));
   dec_out(2) <= (NOT(dec_addr(4)) AND (NOT(dec_addr(3)) AND NOT(dec_addr(2)) AND (dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(3) <= (NOT(dec_addr(4)) AND (NOT(dec_addr(3)) AND NOT(dec_addr(2)) AND (dec_addr(1)) AND (dec_addr(0))));
   dec_out(4) <= (NOT(dec_addr(4)) AND (NOT(dec_addr(3)) AND (dec_addr(2)) AND NOT(dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(5) <= (NOT(dec_addr(4)) AND (NOT(dec_addr(3)) AND (dec_addr(2)) AND NOT(dec_addr(1)) AND (dec_addr(0))));
   dec_out(6) <= (NOT(dec_addr(4)) AND (NOT(dec_addr(3)) AND (dec_addr(2)) AND (dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(7) <= (NOT(dec_addr(4)) AND (NOT(dec_addr(3)) AND (dec_addr(2)) AND (dec_addr(1)) AND (dec_addr(0))));
   dec_out(8) <= (NOT(dec_addr(4)) AND ((dec_addr(3)) AND NOT(dec_addr(2)) AND NOT(dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(9) <= (NOT(dec_addr(4)) AND ((dec_addr(3)) AND NOT(dec_addr(2)) AND NOT(dec_addr(1)) AND (dec_addr(0))));
   dec_out(10) <= (NOT(dec_addr(4)) AND ((dec_addr(3)) AND NOT(dec_addr(2)) AND (dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(11) <= (NOT(dec_addr(4)) AND ((dec_addr(3)) AND NOT(dec_addr(2)) AND (dec_addr(1)) AND (dec_addr(0))));
   dec_out(12) <= (NOT(dec_addr(4)) AND ((dec_addr(3)) AND (dec_addr(2)) AND NOT(dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(13) <= (NOT(dec_addr(4)) AND ((dec_addr(3)) AND (dec_addr(2)) AND NOT(dec_addr(1)) AND (dec_addr(0))));
   dec_out(14) <= (NOT(dec_addr(4)) AND ((dec_addr(3)) AND (dec_addr(2)) AND (dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(15) <= (NOT(dec_addr(4)) AND ((dec_addr(3)) AND (dec_addr(2)) AND (dec_addr(1)) AND (dec_addr(0))));
   dec_out(16) <= (dec_addr(4) AND (NOT(dec_addr(3)) AND NOT(dec_addr(2)) AND NOT(dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(17) <= (dec_addr(4) AND (NOT(dec_addr(3)) AND NOT(dec_addr(2)) AND NOT(dec_addr(1)) AND (dec_addr(0))));
   dec_out(18) <= (dec_addr(4) AND (NOT(dec_addr(3)) AND NOT(dec_addr(2)) AND (dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(19) <= (dec_addr(4) AND (NOT(dec_addr(3)) AND NOT(dec_addr(2)) AND (dec_addr(1)) AND (dec_addr(0))));
   dec_out(20) <= (dec_addr(4) AND (NOT(dec_addr(3)) AND (dec_addr(2)) AND NOT(dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(21) <= (dec_addr(4) AND (NOT(dec_addr(3)) AND (dec_addr(2)) AND NOT(dec_addr(1)) AND (dec_addr(0))));
   dec_out(22) <= (dec_addr(4) AND (NOT(dec_addr(3)) AND (dec_addr(2)) AND (dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(23) <= (dec_addr(4) AND (NOT(dec_addr(3)) AND (dec_addr(2)) AND (dec_addr(1)) AND (dec_addr(0))));
   dec_out(24) <= (dec_addr(4) AND ((dec_addr(3)) AND NOT(dec_addr(2)) AND NOT(dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(25) <= (dec_addr(4) AND ((dec_addr(3)) AND NOT(dec_addr(2)) AND NOT(dec_addr(1)) AND (dec_addr(0))));
   dec_out(26) <= (dec_addr(4) AND ((dec_addr(3)) AND NOT(dec_addr(2)) AND (dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(27) <= (dec_addr(4) AND ((dec_addr(3)) AND NOT(dec_addr(2)) AND (dec_addr(1)) AND (dec_addr(0))));
   dec_out(28) <= (dec_addr(4) AND ((dec_addr(3)) AND (dec_addr(2)) AND NOT(dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(29) <= (dec_addr(4) AND ((dec_addr(3)) AND (dec_addr(2)) AND NOT(dec_addr(1)) AND (dec_addr(0))));
   dec_out(30) <= (dec_addr(4) AND ((dec_addr(3)) AND (dec_addr(2)) AND (dec_addr(1)) AND NOT(dec_addr(0))));
   dec_out(31) <= (dec_addr(4) AND ((dec_addr(3)) AND (dec_addr(2)) AND (dec_addr(1)) AND (dec_addr(0))));


END rtl;

