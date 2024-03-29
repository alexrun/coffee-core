-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  tmr_counter.vhd
--
-- File		: tmr_counter.vhd
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

ENTITY tmr_counter IS
   PORT( 
      cont_mode   : IN     std_logic;
      enable      : IN     std_logic;
      increment   : IN     std_logic;
      tmr_cnt_in  : IN     std_logic_vector (31 DOWNTO 0);
      tmr_max_cnt : IN     std_logic_vector (31 DOWNTO 0);
      terminated  : OUT    std_logic;
      tmr_cnt_out : OUT    std_logic_vector (31 DOWNTO 0)
   );

-- Declarations

END tmr_counter ;
architecture tmr_counter_arch of tmr_counter is

	signal incr, clear, terminated_s : std_logic;

begin

	-- counter process
	process(tmr_cnt_in, incr, clear)
		-- c -current value, t - toggle bit
		variable c, t : std_logic_vector(31 downto 0);
	begin
		c := tmr_cnt_in;
		t(0)  := '1';
		t(1)  := c(0);
		t(2)  := c(0) and c(1);
		t(3)  := c(0) and c(1) and c(2);
		t(4)  := c(0) and c(1) and c(2) and c(3);
		t(5)  := c(0) and c(1) and c(2) and c(3) and c(4);
		t(6)  := c(0) and c(1) and c(2) and c(3) and c(4) and c(5);
		t(7)  := c(0) and c(1) and c(2) and c(3) and c(4) and c(5) and c(6);

		t(8)  := t(7) and c(7);
		t(9)  := t(7) and c(7) and c(8);
		t(10) := t(7) and c(7) and c(8) and c(9);
		t(11) := t(7) and c(7) and c(8) and c(9) and c(10);
		t(12) := t(7) and c(7) and c(8) and c(9) and c(10) and c(11);
		t(13) := t(7) and c(7) and c(8) and c(9) and c(10) and c(11) and c(12);

		t(14) := t(13) and c(13);
		t(15) := t(13) and c(13) and c(14);
		t(16) := t(13) and c(13) and c(14) and c(15);
		t(17) := t(13) and c(13) and c(14) and c(15) and c(16);
		t(18) := t(13) and c(13) and c(14) and c(15) and c(16) and c(17);

		t(19) := t(18) and c(18);
		t(20) := t(18) and c(18) and c(19);
		t(21) := t(18) and c(18) and c(19) and c(20);
		t(22) := t(18) and c(18) and c(19) and c(20) and c(21);
		t(23) := t(18) and c(18) and c(19) and c(20) and c(21) and c(22);
		t(24) := t(18) and c(18) and c(19) and c(20) and c(21) and c(22) and c(23);

		t(25) := t(24) and c(24);
		t(26) := t(24) and c(24) and c(25);
		t(27) := t(24) and c(24) and c(25) and c(26);
		t(28) := t(24) and c(24) and c(25) and c(26) and c(27);
		t(29) := t(24) and c(24) and c(25) and c(26) and c(27) and c(28);
		t(30) := t(24) and c(24) and c(25) and c(26) and c(27) and c(28) and c(29);

		t(31) := t(30) and c(30);
		if incr = '1' then -- increment counter
			tmr_cnt_out <= c xor t;
		elsif clear = '1' then -- load zero to counter
			tmr_cnt_out <= (others => '0');
		else
			tmr_cnt_out <= c; -- keep old value
		end if;
	end process;
	
	-- status output
	process(tmr_cnt_in, tmr_max_cnt)
	begin
		if tmr_cnt_in = tmr_max_cnt then
			terminated_s <= '1';
		else
			terminated_s <= '0';
		end if;
	end process;

	terminated <= terminated_s;

	-- counter control (incr and clear)
	process(cont_mode, increment, enable, terminated_s)
	begin
		-- counter enabled and value is other than maximum => increment
		incr  <= increment and enable and not terminated_s;
		-- counter enabled and value equals maximum:
		-- zero counter and continue if in continuous mode,
		-- otherwise hold old value.
		clear <= increment and enable and terminated_s and cont_mode;
	end process;

end tmr_counter_arch;
