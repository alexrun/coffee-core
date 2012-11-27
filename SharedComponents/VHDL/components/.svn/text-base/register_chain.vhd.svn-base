

-----------------------------------------------------------------------------------------------------------
--
-- 					       REGISTER DELAY CHAIN (ctrl_logic)
--
-----------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;
LIBRARY components;
use components.sys_definitions.all;


entity register_chain is
    generic ( length : integer := m;
              width  : integer := n );
    port( clk           : in std_logic;
          reset         : in std_logic;
          enable        : in Std_logic;
          reg_chain_in  : in Std_logic_vector(width-1 downto 0);
          reg_chain_out : out bus_mxn );
end register_chain;



architecture rtl of register_chain is
    signal ctrl_internal_bus : bus_mxn;

    begin  

        ctrl_internal_bus(0) <= reg_chain_in;

        WRBCK_DELAY_CHAIN: for i in 0 to (length-1) generate   
            process(clk, reset)
            begin
		            if reset = reset_active then 
		                ctrl_internal_bus(i+1) <= conv_std_logic_vector(0, width);
		            elsif CLK'EVENT and CLK='1' then 
                    if enable = we_active then 
                          ctrl_internal_bus(i+1) <= ctrl_internal_bus(i);
                    end if;
                end if; 
            end process;  
        end generate WRBCK_DELAY_CHAIN;

        reg_chain_out <= ctrl_internal_bus;
  
end rtl;
