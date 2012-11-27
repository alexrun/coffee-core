----------------------------------------------------------------------
-- Department of Computer Systems, Tampere University of Technology --
----------------------------------------------------------------------
-- Project	: DMA_platform
-- Author 	: Fabio Garzia
-- e-mail       : fabio.garzia@tut.fi
-- Date 	: 29-Sep-2008 10:37:40
-- File 	: gp_counter.vhd
-- Design 	: 
----------------------------------------------------------------------
-- Description : 
----------------------------------------------------------------------
--Copyright (c) 2008, Tampere University of Technology.
--All rights reserved.

--Redistribution and use in source and binary forms, with or without modification,
--are permitted provided that the following conditions are met:
--* Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--* Redistributions in binary form must reproduce the above copyright notice,
-- this list of conditions and the following disclaimer in the documentation
-- and/or other materials provided with the distribution.
--* Neither the name of Tampere University of Technology nor the names of its
-- contributors may be used to endorse or promote products derived from this
-- software without specific prior written permission.

--THIS HARDWARE DESCRIPTION OR SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
--CONTRIBUTORS << AS IS >> AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND NONINFRINGEMENT AND
--FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
--OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
--EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
--PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
--BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--ARISING IN ANY WAY OUT OF THE USE OF THIS HARDWARE DESCRIPTION OR SOFTWARE, EVEN
--IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- 
--------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity gp_counter is
  generic (
    counter_width : integer := 4);
  
    port (
        clk         :   in std_logic; 
        en          :   in std_logic;   -- active low
        reset       :   in std_logic;   -- active low
        tc          :   out std_logic;
        output      :   out std_logic_vector(counter_width - 1 downto 0);
        max_value   :   in std_logic_vector(counter_width - 1 downto 0) -- it needs to be always driven to a coherent value
        
   );                                                  
   
end gp_counter;

architecture behavioral of gp_counter is
    
                           
    signal max : integer;
    signal cs, ns : integer;
    SIGNAL tc_int : std_logic;
    
begin        
    
    max <= conv_integer(unsigned(max_value));
    
    FSM_MACHINE:
            process(cs, max)
            begin
                if cs = max then
                    ns <= 0;
                    tc_int <= '1';                
                else             
                    ns <= cs + 1;
                    tc_int <= '0';
                end if;
            end process FSM_MACHINE;
    
    SYNCH:  
        process(clk,reset)
        begin
            if reset = '0' then
                cs <= 0;
            elsif clk'event and clk = '1' then
              if en = '0' then
                cs <= ns;
              end if;
            end if;
        end process SYNCH;   
      
      
    output <= conv_std_logic_vector(cs,counter_width);
    tc <= tc_int AND (NOT en);

end behavioral;        
                
            
            
        
    
    
   
                                                       
                                                       
        
            
