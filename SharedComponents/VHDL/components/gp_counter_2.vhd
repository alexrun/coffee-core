-------------------------------------------------------------------------------
-- GP_Counter_2.vhd
-------------------------------------------------------------------------------
-- Created 2004 by F. Garzia
--------------------------------------------------------------------------

-- Counter
-------------------------------------------------------------------------------
--Counter; it's possible to indicate the max number of count states; 
--it automatically resets when he reaches it and generates a terminal count 
--signal during the last clock cycle; it can be resetted and enabled by the
--correspondent signals
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity gp_counter_2 is
  generic (
    counter_width : integer := 4);
  
    port (
        clk         :   in std_logic; 
        en          :   in std_logic;   -- active high
        reset       :   in std_logic;   -- active high
        tc          :   out std_logic;
        output      :   out std_logic_vector(counter_width - 1 downto 0);
        max_value   :   in std_logic_vector(counter_width - 1 downto 0) -- it needs to be always driven to a coherent value
        
   );                                                  
   
end gp_counter_2;

architecture behavioral of gp_counter_2 is
    
                           
    signal max : integer;
    signal cs, ns : integer;    
    
begin        
    
    max <= conv_integer(unsigned(max_value));
    
    FSM_MACHINE:
            process(cs, max)
            begin
                if cs = max then
                    ns <= 0;
                    tc <= '1';                
                else             
                    ns <= cs + 1;
                    tc <= '0';
                end if;
            end process FSM_MACHINE;
    
    SYNCH:  
        process(clk,reset)
        begin
            if reset = '1' then
                cs <= 0;
            elsif clk'event and clk = '1' then
              if en = '1' then
                cs <= ns;
              end if;
            end if;
        end process SYNCH;   
      
      
    output <= conv_std_logic_vector(cs,counter_width);
    

end behavioral;        
                
            
            
        
    
    
   
                                                       
                                                       
        
            
