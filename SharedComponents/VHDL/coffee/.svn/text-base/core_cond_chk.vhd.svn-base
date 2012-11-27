-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_cond_chk.vhd
--
-- File		: core_cond_chk.vhd
--
-- Date		: 23:46:18 01/19/07
--
-- Description	: 
--
-- ----------------------------------------------------------------------------
--
-- Author(s)	: Juha Kylliäinen
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
LIBRARY coffee;
USE coffee.core_constants_pkg.all;

ENTITY core_cond_chk IS
   PORT( 
      cond    : IN     std_logic_vector (2 DOWNTO 0);
      cex     : IN     std_logic;                      -- enables condition check
      znc     : IN     std_logic_vector (2 DOWNTO 0);
      execute : OUT    std_logic;
      opcode  : IN     std_logic_vector (5 DOWNTO 0)
   );

-- Declarations

END core_cond_chk ;
library ieee;
use ieee.std_logic_unsigned.CONV_INTEGER;

architecture core_cond_chk_opt of core_cond_chk is

    signal c, z, n         : std_logic;
    signal condition       : std_logic_vector(7 downto 0);
	signal cond_code       : std_logic_vector(2 downto 0);
    signal ok_to_execute   : std_logic;
	signal is_cop          : std_logic;

begin

    z <= znc(2);
    n <= znc(1);
    c <= znc(0);

	-- Interpreting flags
    condition(0) <= c;                   -- carry
    condition(1) <= z or not(n);         -- equal or greater than
    condition(2) <= z or n;              -- equal or less than                                           
    condition(3) <= z;                   -- equal
    condition(4) <= not(z) and not(n);   -- greater than
    condition(5) <= n;                   -- less than
    condition(6) <= not(z);              -- not equal
    condition(7) <= not(c);              -- no carry

	-- extracting condition code from instruction word.
	-- cop -instruction does not have conditional execution flag =>
	-- Must be dealt with separately.
	process(opcode, cond)
	begin
		-- branches: condition code inside opcode
		if opcode(5 downto 3) = "100" then
			cond_code <= opcode(2 downto 0);
		else
			cond_code <= cond; -- directly from input
		end if;
		if opcode = cop_opc then
			is_cop <= '1';
		else
			is_cop <= '0';
		end if;
	end process;

	ok_to_execute <= condition(CONV_INTEGER(cond_code));
		
    -- instruction discarded if execution condition is false.
	-- cop -instruction does not have a valid cex -bit.
    execute <= ok_to_execute or not cex or is_cop;

end core_cond_chk_opt;

