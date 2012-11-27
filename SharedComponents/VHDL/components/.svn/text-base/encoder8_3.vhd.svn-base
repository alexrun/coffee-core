----------------------------------------------------------------------
-- Department of Computer Systems, Tampere University of Technology  --
----------------------------------------------------------------------
-- Project      : DMA_platform
-- Author       : Fabio Garzia
-- e-mail       : fabio.garzia@tut.fi
-- Date         : 14-Mar-2008 19:17:20
-- File         : encoder8_3.vhd
-- Design       : 
----------------------------------------------------------------------
-- Description : encoder 3 inputs, 8 outputs
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
USE IEEE.std_logic_arith.ALL;
LIBRARY components;
USE components.sys_definitions.ALL;

ENTITY encoder8_3 IS
   PORT( enc_in   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
         enc_addr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) );
END encoder8_3;

ARCHITECTURE behavioral OF encoder8_3 IS

BEGIN  -- behavioral

   PROCESS(enc_in)
   BEGIN
      CASE enc_in IS
         WHEN "10000000" => enc_addr <= "111";
         WHEN "01000000" => enc_addr <= "110";
         WHEN "00100000" => enc_addr <= "101";
         WHEN "00010000" => enc_addr <= "100";
         WHEN "00001000" => enc_addr <= "011";
         WHEN "00000100" => enc_addr <= "010";
         WHEN "00000010" => enc_addr <= "001";
         WHEN "00000001" => enc_addr <= "000";
         WHEN OTHERS     => enc_addr <= "000";
      END CASE;
   END PROCESS;

END behavioral;
