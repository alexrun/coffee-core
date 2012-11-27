

-----------------------------------------------------------------------------------------------------------
--
-- 							8_INPUTS MULTIPLEXER
--
-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
LIBRARY components;
use components.sys_definitions.all;


entity MUX4to1 is
    generic (width : integer :=8);
    port( in_a   : in Std_logic_vector(width-1 downto 0);
          in_b   : in Std_logic_vector(width-1 downto 0);
          in_c   : in Std_logic_vector(width-1 downto 0);
          in_d   : in Std_logic_vector(width-1 downto 0);
          sel    : in Std_logic_vector(1 downto 0);
          output : out Std_logic_vector(width-1 downto 0) );
end MUX4to1;



architecture behavior of MUX4to1 is

    begin  

    process(in_a,in_b,in_c,in_d,sel)
    begin
        if sel = "00" then
                output <= in_a;
        elsif sel = "01" then
                output <= in_b;
        elsif sel = "10" then
                output <= in_c;
        else
                output <= in_d;
        end if;
    end process;
  
end behavior;
