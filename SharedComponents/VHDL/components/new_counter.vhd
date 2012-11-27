-------------------------------------------------------------------------------
-- NEW_Counter.vhd
-------------------------------------------------------------------------------
-- Created 2007 by C. Giliberto
-------------------------------------------------------------------------------
-- New
-- Counter
-------------------------------------------------------------------------------
--It's possible to load the start value count 
--and also the value to increment; 
--With enable you start count;
--With load you store the start value;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library components;
use components.sys_definitions.all;   
use components.sys_components.all;

entity new_counter is
  generic (
    counter_width : integer := 32);
  
    port (
        clk                :   in std_logic; 
        en                 :   in std_logic;   
        load               :   in std_logic;
        reset              :   in std_logic;   -- active high
        increment_value    :   in std_logic_vector(counter_width - 1 downto 0);
        output             :   out std_logic_vector(counter_width - 1 downto 0);
        start_value        :   in std_logic_vector(counter_width - 1 downto 0) 
        );                                                  
   
end new_counter;

architecture behavioral of new_counter is
    
    signal current_val,
           n_current_val        : integer;
           
    signal incr_val             : integer;
    signal real_n_current_val   : integer;
    
    signal temp_n_current_val   : std_logic_vector(31 downto 0);
    signal out_mux              : std_logic_vector(31 downto 0);
    
                             
    
begin        
    
    incr_val           <= conv_integer(unsigned(increment_value));
    real_n_current_val <= conv_integer(unsigned(out_mux));
    temp_n_current_val <= conv_std_logic_vector(n_current_val,counter_width);
    
    MUX_INPUT : mux2to1
         generic map(width => 32)
         port map(in_a   => temp_n_current_val(counter_width-1 downto 0),
                  in_b   => start_value(counter_width-1 downto 0),
                  sel    => load,
                  output => out_mux(counter_width-1 downto 0) 
                  );
    
    FSM_MACHINE:
            process(current_val, incr_val)
            begin
                n_current_val <= current_val + incr_val;
            end process FSM_MACHINE;
    
    SYNCH:  
       process(clk,reset)
        begin
            if reset = '1' then
                  current_val <= 0;    
            elsif clk'event and clk = '1' then
                if en = '1' or load = '1' then
                  current_val <= real_n_current_val;
                end if;
            end if;
        end process SYNCH;   
      
      
    output <= conv_std_logic_vector(current_val,counter_width);
    

end behavioral; 
