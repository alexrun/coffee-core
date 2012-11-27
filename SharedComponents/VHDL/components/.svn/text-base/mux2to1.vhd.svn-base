

-----------------------------------------------------------------------------------------------------------
--
-- 							2_INPUTS MULTIPLEXER
--
-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
LIBRARY components;
use components.sys_definitions.all;

entity MUX2to1 is
    generic (width : integer :=8);
    port( in_a   : in Std_logic_vector(width-1 downto 0);
          in_b   : in Std_logic_vector(width-1 downto 0);
          sel    : in Std_logic;
          output : out Std_logic_vector(width-1 downto 0) );
end MUX2to1;



architecture behavior of MUX2to1 is

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
