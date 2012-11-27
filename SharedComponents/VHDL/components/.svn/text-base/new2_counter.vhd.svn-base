-------------------------------------------------------------------------------
-- NEW2_Counter.vhd
-------------------------------------------------------------------------------
-- Created 2007 by C. Giliberto
-------------------------------------------------------------------------------
-- New2
-- Counter(for offset)
-------------------------------------------------------------------------------
--It's possible to load the start value count 
--and also the value to increment; 
--With enable you start count;
--With load you store the start value;
--With load_ofset you can use also a start offset
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library components;
use components.sys_definitions.all;   
use components.sys_components.all;

entity new2_counter is
  generic (
    counter_width : integer := 32);
  
    port (
        clk                :   in std_logic; 
        en                 :   in std_logic;   
        load               :   in std_logic;
		load_offset        :   in std_logic;   -- to load an offset at the beginning of dma transation
        reset              :   in std_logic;   -- active high
        increment_value    :   in std_logic_vector(counter_width - 1 downto 0);
		offset_value       :   in std_logic_vector(counter_width - 1 downto 0);
        output             :   out std_logic_vector(counter_width - 1 downto 0);
        start_value        :   in std_logic_vector(counter_width - 1 downto 0) 
        );                                                  
   
end new2_counter;

architecture behavioral of new2_counter is
    
    signal current_val,
           n_current_val,
           n_current_val_offset		    : integer;
           
    signal incr_val,off_val             : integer;
    signal start_val                    : integer;
    signal real_n_current_val,
           real_n_current_val_offset	: integer;
    
    signal temp_n_current_val,
           temp_n_current_val_offset	: std_logic_vector(31 downto 0);
    signal out_mux,
           out_mux_offset    	        : std_logic_vector(31 downto 0);
    
                             
    
begin        
    
    start_val                 <= conv_integer(unsigned(start_value));
    incr_val                  <= conv_integer(unsigned(increment_value));
	off_val                   <= conv_integer(unsigned(offset_value));
    real_n_current_val        <= conv_integer(unsigned(out_mux));
	real_n_current_val_offset <= conv_integer(unsigned(out_mux_offset));
    temp_n_current_val        <= conv_std_logic_vector(n_current_val,counter_width);
    temp_n_current_val_offset <= conv_std_logic_vector(n_current_val_offset,counter_width);
	
    MUX_INPUT : mux2to1
         generic map(width => counter_width)
         port map(in_a   => temp_n_current_val(counter_width-1 downto 0),
                  in_b   => start_value(counter_width-1 downto 0),
                  sel    => load,
                  output => out_mux(counter_width-1 downto 0) 
                  );
    MUX_INPUT_OFFSET : mux2to1
         generic map(width => counter_width)
         port map(in_a   => temp_n_current_val_offset(counter_width-1 downto 0),
                  in_b   => start_value(counter_width-1 downto 0),
                  sel    => load_offset,
                  output => out_mux_offset(counter_width-1 downto 0) 
                  );
    
    FSM_MACHINE:
            process(current_val, incr_val)
            begin
                n_current_val <= current_val + incr_val;
            end process FSM_MACHINE;
			
    FSM_MACHINE_OFFSET:
            process(current_val, off_val)
            begin
                n_current_val_offset <= current_val + off_val;
            end process FSM_MACHINE_OFFSET;
    
    SYNCH:  
       process(clk,reset)
        begin
            if reset = '1' then
                  current_val <= 0;    
            elsif clk'event and clk = '1' then
                if en = '1' or load = '1' then
                  current_val <= real_n_current_val;
				elsif en = '1' or load_offset = '1' then
				  current_val <= real_n_current_val_offset;
                end if;
            end if;
        end process SYNCH;   
      
      
    output <= conv_std_logic_vector(current_val,counter_width);
    

end behavioral; 