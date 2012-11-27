

-----------------------------------------------------------------------------------------------------------
--
-- WE_register
--
-- General purpose register, "reg_width" wide. WRITE ENABLE and RESET commands are provided.
-- Default content at RESET is "zero". WRITE ENABLE and RESET commands polarity are
-- specified by dedicated constants.
--
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;

LIBRARY components;
USE components.sys_definitions.ALL;

ENTITY WE_register IS
   GENERIC(reg_width :     INTEGER;
           reset_value : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0')); 
   PORT( clk         : IN  STD_LOGIC;
          reset      : IN  STD_LOGIC;
          we         : IN  STD_LOGIC;
          data_in    : IN  STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);
          data_out   : OUT STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0) );
END WE_register;



ARCHITECTURE rtl OF WE_register IS

BEGIN

   PROCESS(clk, reset)
   BEGIN
      IF reset = reset_active THEN
         data_out    <= reset_value(reg_width-1 DOWNTO 0);
      ELSIF CLK'EVENT AND CLK = '1' THEN
         IF we = we_active THEN
            data_out <= data_in;
         END IF;
      END IF;
   END PROCESS;

END rtl;
