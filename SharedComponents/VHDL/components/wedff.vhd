

----------------------------------------------------------------------------------------------------------
--
--					D-type Flip-Flop  provided with Write Enable command
--
-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
LIBRARY components;
use components.sys_definitions.all;


entity WEDFF is
	port( clk   : in    Std_logic;
        reset : in    Std_logic;
        we    : in    Std_logic;
        d     : in    Std_logic;
        q     : out   Std_logic );
end WEDFF;

 

architecture rtl of WEDFF is

    begin

    process(clk, reset)
    begin
        if reset = reset_active then 
	          q <= '0';
        elsif CLK'EVENT and CLK='1' then 
            if we = we_active then 
                 q <= d;
            end if;
        end if; 
    end process;  

end rtl;
