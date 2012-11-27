-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  comparator_4bit.vhd
--
-- File		: comparator_4bit.vhd
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

ENTITY comparator_4bit IS
   PORT( 
      a       : IN     std_logic_vector (3 DOWNTO 0);
      b       : IN     std_logic_vector (3 DOWNTO 0);
      equal   : OUT    std_logic;
      greater : OUT    std_logic
   );

-- Declarations

END comparator_4bit ;
-- Tests if a is greater or equal to b
architecture comparator_4bit_arch of comparator_4bit is
	 signal grt : std_logic_vector(3 downto 0); -- bitwise greater than
	 signal eq  : std_logic_vector(3 downto 0); -- bitwise equality
begin
	-- bitwise comparison
	process(a, b)
	begin
		for i in 0 to 3 loop
			grt(i) <= a(i) and not(b(i));
			eq(i)  <= not(a(i) xor b(i));
		end loop;
	end process;

	-- chaining bitwise comparison results to 4 bit comparison
	greater <= grt(3) or (eq(3) and grt(2)) or (eq(3) and eq(2) and grt(1))
	           or (eq(3) and eq(2) and eq(1) and grt(0));
	equal   <= eq(3) and eq(2) and eq(1) and eq(0);

end comparator_4bit_arch;

