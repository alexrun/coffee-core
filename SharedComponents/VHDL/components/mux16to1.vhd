-----------------------------------------------------------------------------------------------------------
--
-- 					   16_INPUTS MULTIPLEXER
--
-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
LIBRARY components;
use components.sys_definitions.all;

entity MUX16to1 is
    generic (width : integer);
    port( in_a   : in Std_logic_vector(width-1 downto 0);
          in_b   : in Std_logic_vector(width-1 downto 0);
          in_c   : in Std_logic_vector(width-1 downto 0);
          in_d   : in Std_logic_vector(width-1 downto 0);
          in_e   : in Std_logic_vector(width-1 downto 0);
          in_f   : in Std_logic_vector(width-1 downto 0);
          in_g   : in Std_logic_vector(width-1 downto 0);
          in_h   : in Std_logic_vector(width-1 downto 0);
          in_i   : in Std_logic_vector(width-1 downto 0);
          in_l   : in Std_logic_vector(width-1 downto 0);
          in_m   : in Std_logic_vector(width-1 downto 0);
          in_n   : in Std_logic_vector(width-1 downto 0);
          in_o   : in Std_logic_vector(width-1 downto 0);
          in_p   : in Std_logic_vector(width-1 downto 0);
          in_q   : in Std_logic_vector(width-1 downto 0);
          in_r   : in Std_logic_vector(width-1 downto 0);
          sel    : in Std_logic_vector(3 downto 0);
          output : out Std_logic_vector(width-1 downto 0) 
        );
end MUX16to1;


architecture rtl of MUX16to1 is

    begin  

        process(in_a,in_b,in_c,in_d,in_e,in_f,in_g,in_h,in_i,in_l,in_m,in_n,in_o,in_p,in_q,in_r,sel)

        begin

            if sel = "0000" then
                    output <= in_a;
            elsif sel = "0001" then
                    output <= in_b;
            elsif sel = "0010" then
                    output <= in_c;
            elsif sel = "0011" then
                    output <= in_d;
            elsif sel = "0100" then
                    output <= in_e;
            elsif sel = "0101" then
                    output <= in_f;
            elsif sel = "0110" then
                    output <= in_g;
            elsif sel = "0111" then
                    output <= in_h;
            elsif sel = "1000" then
                    output <= in_i;
            elsif sel = "1001" then
                    output <= in_l;
            elsif sel = "1010" then
                    output <= in_m;
            elsif sel = "1011" then
                    output <= in_n;
            elsif sel = "1100" then
                    output <= in_o;
            elsif sel = "1101" then
                    output <= in_p;
            elsif sel = "1110" then
                    output <= in_q;
            else
                    output <= in_r;
            end if;

    end process;
  
end rtl;
