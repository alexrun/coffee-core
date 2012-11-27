

----------------------------------------------------------------------
-- Department of Computer Systems, Tampere University of Technology  --
----------------------------------------------------------------------
-- Project      : DMA_platform
-- Author       : Fabio Garzia
-- e-mail       : fabio.garzia@tut.fi
-- Date         : 29-Jan-2008 17:51:13
-- File         : data_ff.vhd
-- Design       : 
----------------------------------------------------------------------
-- Description : 
----------------------------------------------------------------------
--Copyright (c) 2007, Tampere University of Technology.
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
USE IEEE.std_logic_arith.ALL;
LIBRARY components;
USE components.sys_definitions.ALL;


ENTITY data_ff IS

   PORT( clk   : IN  STD_LOGIC;
         reset : IN  STD_LOGIC;
         d     : IN  STD_LOGIC;
         q     : OUT STD_LOGIC );

END data_ff;



ARCHITECTURE rtl OF data_ff IS

BEGIN

   PROCESS(clk, reset)
   BEGIN
      IF reset = reset_active THEN
         q <= '0';
      ELSIF CLK'EVENT AND CLK = '1' THEN
         q <= d;
      END IF;
   END PROCESS;

END rtl;
