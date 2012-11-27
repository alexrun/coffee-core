
-----------------------------------------------------------------------------------------------------------
--
--							  SIMPLE DATA REGISTER
--
-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
LIBRARY components;
use components.sys_definitions.all;

entity data_register is
    generic(reg_width: integer :=8);
    port( 
             clk      : in    Std_logic;
             reset    : in    Std_logic;
 	           data_in  : in    Std_logic_vector(reg_width-1 downto 0);
             data_out : out   Std_logic_vector(reg_width-1 downto 0)
        );
end data_register;

 

architecture rtl of data_register is

    begin

        process(clk, reset)
        begin
	          if reset = reset_active then 
		            data_out <= Conv_std_logic_vector(0,reg_width);
		        elsif CLK'EVENT and CLK='1' then 
                data_out <= data_in;
		        end if; 
        end process;  

end rtl;
