
-----------------------------------------------------------------------------------------------------------
--
-- DECODER 4:16
--
-- The output addressed by dec_addr is the only one to get an "high" logic value
--
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
LIBRARY components;
USE components.sys_definitions.ALL;

ENTITY decoder4_16 IS
   PORT
      (
         data : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
         eq0  : OUT STD_LOGIC;
         eq1  : OUT STD_LOGIC;
         eq10 : OUT STD_LOGIC;
         eq11 : OUT STD_LOGIC;
         eq12 : OUT STD_LOGIC;
         eq13 : OUT STD_LOGIC;
         eq14 : OUT STD_LOGIC;
         eq15 : OUT STD_LOGIC;
         eq2  : OUT STD_LOGIC;
         eq3  : OUT STD_LOGIC;
         eq4  : OUT STD_LOGIC;
         eq5  : OUT STD_LOGIC;
         eq6  : OUT STD_LOGIC;
         eq7  : OUT STD_LOGIC;
         eq8  : OUT STD_LOGIC;
         eq9  : OUT STD_LOGIC
         );
END decoder4_16;


ARCHITECTURE rtl OF decoder4_16 IS
BEGIN


   eq0  <= (NOT(data(3)) AND NOT(data(2)) AND NOT(data(1)) AND NOT(data(0)));
   eq1  <= (NOT(data(3)) AND NOT(data(2)) AND NOT(data(1)) AND (data(0)));
   eq2  <= (NOT(data(3)) AND NOT(data(2)) AND (data(1)) AND NOT(data(0)));
   eq3  <= (NOT(data(3)) AND NOT(data(2)) AND (data(1)) AND (data(0)));
   eq4  <= (NOT(data(3)) AND (data(2)) AND NOT(data(1)) AND NOT(data(0)));
   eq5  <= (NOT(data(3)) AND (data(2)) AND NOT(data(1)) AND (data(0)));
   eq6  <= (NOT(data(3)) AND (data(2)) AND (data(1)) AND NOT(data(0)));
   eq7  <= (NOT(data(3)) AND (data(2)) AND (data(1)) AND (data(0)));
   eq8  <= ((data(3)) AND NOT(data(2)) AND NOT(data(1)) AND NOT(data(0)));
   eq9  <= ((data(3)) AND NOT(data(2)) AND NOT(data(1)) AND (data(0)));
   eq10 <= ((data(3)) AND NOT(data(2)) AND (data(1)) AND NOT(data(0)));
   eq11 <= ((data(3)) AND NOT(data(2)) AND (data(1)) AND (data(0)));
   eq12 <= ((data(3)) AND (data(2)) AND NOT(data(1)) AND NOT(data(0)));
   eq13 <= ((data(3)) AND (data(2)) AND NOT(data(1)) AND (data(0)));
   eq14 <= ((data(3)) AND (data(2)) AND (data(1)) AND NOT(data(0)));
   eq15 <= ((data(3)) AND (data(2)) AND (data(1)) AND (data(0)));


END rtl;

