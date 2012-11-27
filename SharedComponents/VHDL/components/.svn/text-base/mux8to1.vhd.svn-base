

-----------------------------------------------------------------------------------------------------------
--
-- 							8_INPUTS MULTIPLEXER
--
-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
LIBRARY components;
use components.sys_definitions.all;


entity MUX8to1 is
    generic (width : integer :=8);
    port( in_a   : in Std_logic_vector(width-1 downto 0);
          in_b   : in Std_logic_vector(width-1 downto 0);
          in_c   : in Std_logic_vector(width-1 downto 0);
          in_d   : in Std_logic_vector(width-1 downto 0);
          in_e   : in Std_logic_vector(width-1 downto 0);
          in_f   : in Std_logic_vector(width-1 downto 0);
          in_g   : in Std_logic_vector(width-1 downto 0);
          in_h   : in Std_logic_vector(width-1 downto 0);
          sel    : in Std_logic_vector(2 downto 0);
          output : out Std_logic_vector(width-1 downto 0) );
end MUX8to1;



architecture behavior of MUX8to1 is

    begin  

    process(in_a, in_b, in_c, in_d, in_e, in_f, in_g, in_h, sel)
    begin
        if sel = "000" then
                output <= in_a;
        elsif sel = "001" then
                output <= in_b;
        elsif sel = "010" then
                output <= in_c;
        elsif sel = "011" then
                output <= in_d;
        elsif sel = "100" then
                output <= in_e;
        elsif sel = "101" then
                output <= in_f;
        elsif sel = "110" then
                output <= in_g;
        else
                output <= in_h;
        end if;
    end process;
  
end behavior;
