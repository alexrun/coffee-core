

-----------------------------------------------------------------------------------------------------------
--
-- 							2_INPUTS BIT MULTIPLEXER
--
-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
LIBRARY components;
use components.sys_definitions.all;

entity MUX2to1_BIT is
    port( in_a   : in Std_logic;
          in_b   : in Std_logic;
          sel    : in Std_logic;
          output : out Std_logic );
end MUX2to1_BIT;



architecture behavior of MUX2to1_BIT is

    begin  

    process(in_a,in_b,sel)
    begin
        if sel = '0' then
                output <= in_a;
        else
                output <= in_b;
        end if;
    end process;
  
end behavior;
