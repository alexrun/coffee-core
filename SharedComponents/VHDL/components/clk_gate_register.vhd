----------------------------------------------------------------------
-- Department of Computer Systems, Tampere University of Technology --
----------------------------------------------------------------------
-- Project	: DMA_platform
-- Author 	: Fabio Garzia
-- e-mail       : fabio.garzia@tut.fi
-- Date 	: 07-Aug-2008 18:18:53
-- File 	: clk_gate_register.vhd
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
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY components;
USE components.sys_definitions.ALL;
USE components.sys_components.ALL;

ENTITY clk_gate_register IS
   
   GENERIC (
      reg_width : POSITIVE);

   PORT (
      clk       : IN  STD_LOGIC;
      N_clk       : IN  STD_LOGIC;
      reset :  IN  STD_LOGIC;
      data_in   : IN  STD_LOGIC_VECTOR(reg_width - 1 DOWNTO 0);
      gated_clk : OUT STD_LOGIC_VECTOR(reg_width - 1 DOWNTO 0));

END clk_gate_register;

ARCHITECTURE structural OF clk_gate_register IS

   SIGNAL reg_out : STD_LOGIC_VECTOR(reg_width - 1 DOWNTO 0);

BEGIN  -- structural

   CLK_REG : WE_register
      GENERIC MAP (
         reg_width => reg_width,
         reset_value => (OTHERS => '1'))
      PORT MAP (
         clk      => N_clk,
         we    => '1',
         reset => reset,
         data_in  => data_in,
         data_out => reg_out);

   AND_GATING: FOR i IN 0 TO reg_width - 1 GENERATE

      gated_clk(i) <= clk AND reg_out(i);
      
   END GENERATE AND_GATING;

      

END structural;
