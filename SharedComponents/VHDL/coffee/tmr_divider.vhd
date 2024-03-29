-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  tmr_divider.vhd
--
-- File		: tmr_divider.vhd
--
-- Date		: 23:46:20 01/19/07
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

ENTITY tmr_divider IS
   PORT( 
      clk       : IN     std_logic;
      divisor   : IN     std_logic_vector (7 DOWNTO 0);
      enable    : IN     std_logic;
      rst_x     : IN     std_logic;
      increment : OUT    std_logic
   );

-- Declarations

END tmr_divider ;
architecture tmr_divider_arch of tmr_divider is
	signal count : std_logic_vector(7 downto 0);
	signal max_count, load_zero : std_logic;
begin
	-- back to zero if maximum reached or enable pulled low
	-- Timer should be started by writing a high bit in the enable
	-- bit position after configuring tmr_max_cnt register.
	load_zero <= max_count or not enable;

	-- frequency divider process - counting clock cycles
	process(clk, rst_x)
		variable c,t : std_logic_vector(7 downto 0); -- t - toggle, c - count
	begin
		if rst_x = '0' then
			count <= (others => '0');
		elsif clk'event and clk = '1' then
			if load_zero = '1' then
				count <= (others => '0');
			else
				c := count;
				t(0) := '1'; -- lsb toggles every cycle
				t(1) := c(0);
				t(2) := c(0) and c(1);
				t(3) := c(0) and c(1) and c(2);
				t(4) := c(0) and c(1) and c(2) and c(3);
				t(5) := c(0) and c(1) and c(2) and c(3) and c(4);
				t(6) := c(0) and c(1) and c(2) and c(3) and c(4) and c(5);
				t(7) := c(0) and c(1) and c(2) and c(3) and c(4) and c(5) and c(6);

				count <= c xor t;
			end if;
		end if;
	end process;

	-- Frequency divider runs up to divisor
	process(count, divisor)
	begin
		if count = divisor then
			increment <= '1';
			max_count <= '1';
		else
			increment <= '0';
			max_count <= '0';
		end if;
	end process;

end tmr_divider_arch;

