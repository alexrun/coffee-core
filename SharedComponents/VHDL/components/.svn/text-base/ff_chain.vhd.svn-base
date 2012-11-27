


-----------------------------------------------------------------------------------------------------------
--
-- 					      SIMPLE FF DELAY CHAIN
--
-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;
LIBRARY components;
use components.sys_definitions.all;

entity ff_chain is
    generic ( length : integer := m );
    port( clk          : in std_logic;
          reset        : in std_logic;
          enable       : in Std_logic;
          ff_chain_in  : in Std_logic;
          ff_chain_out : out std_logic );
end ff_chain;



architecture rtl of ff_chain is
    signal ff_chain_internal_signals : std_logic_vector(length downto 0);

    begin  

        ff_chain_internal_signals(0) <= ff_chain_in;

        WRBCK_DELAY_CHAIN: for i in 0 to (length-1) generate   
            process(clk, reset)
            begin
		            if reset = reset_active then 
		                ff_chain_internal_signals(i+1) <= '0';
		            elsif CLK'EVENT and CLK='1' then 
                    if enable = we_active then 
                            ff_chain_internal_signals(i+1) <= ff_chain_internal_signals(i);
                    end if;
                end if; 
            end process;  
        end generate WRBCK_DELAY_CHAIN;

        ff_chain_out <= ff_chain_internal_signals(length);
  
end rtl;
