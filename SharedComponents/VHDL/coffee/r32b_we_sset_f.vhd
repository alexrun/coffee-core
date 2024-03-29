-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  r32b_we_sset_f.vhd
--
-- File		: r32b_we_sset_f.vhd
--
-- Date		: 23:46:27 01/19/07
--
-- Description	: 
--
-- ----------------------------------------------------------------------------
--
-- Author(s)	: Juha Kyllišinen
--
-- Status		: Pre-release, not fully tested
--
-- References 	: http://coffee.tut.fi/
--
-- ----------------------------------------------------------------------------
--
-- Limitations	: 
--
-- Known Errors 	: <no, only unknowns as it stands...>
--
-- ----------------------------------------------------------------------------
--
-- Revision list	: 
--
-- ----------------------------------------------------------------------------
--Copyright (c) 2004, Tampere University of Technology.
--All rights reserved.

--Redistribution and use in source and binary forms, with or without modification,
--are permitted provided that the following conditions are met:
--*	Redistributions of source code must retain the above copyright notice,
--	this list of conditions and the following disclaimer.
--*	Redistributions in binary form must reproduce the above copyright notice,
--	this list of conditions and the following disclaimer in the documentation
--	and/or other materials provided with the distribution.
--*	Neither the name of Tampere University of Technology nor the names of its
--	contributors may be used to endorse or promote products derived from this
--	software without specific prior written permission.

--THIS HARDWARE DESCRIPTION OR SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
--CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND NONINFRINGEMENT AND
--FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
--OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
--EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
--PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
--BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
--ARISING IN ANY WAY OUT OF THE USE OF THIS HARDWARE DESCRIPTION OR SOFTWARE, EVEN
--IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY r32b_we_sset_f IS
   PORT( 
      clk   : IN     std_logic;
      d     : IN     std_logic_vector (31 DOWNTO 0);
      rst_n : IN     std_logic;
      sset  : IN     std_logic;
      we    : IN     std_logic;
      q     : OUT    std_logic_vector (31 DOWNTO 0)
   );

-- Declarations

END r32b_we_sset_f ;
library coffee;
use coffee.core_constants_pkg.nop_pattern_c;

-- Offensive comment removed...
architecture r32b_we_sset_arch of r32b_we_sset_f is
begin
	process(clk, rst_n)
	begin
		if (rst_n = '0') then
			q <= nop_pattern_c;
		elsif clk'event and clk = '1' then
			if (we = '1') then
				if (sset = '1') then
					q <= nop_pattern_c;
				else
					q <= d;
				end if;
			end if;
		end if;
	end process;
end r32b_we_sset_arch;
