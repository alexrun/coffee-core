-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_reset_logic.vhd
--
-- File		: core_reset_logic.vhd
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

ENTITY core_reset_logic IS
   PORT( 
      clk           : IN     std_logic;
      rst_n         : IN     std_logic;
      gated_reset_n : OUT    std_logic;
      ba_ext        : IN     std_logic;
      wdog0_rst_n   : IN     std_logic;
      wdog1_rst_n   : IN     std_logic;
      rst_n_s       : OUT    std_logic;
      reset_n_out   : OUT    std_logic
   );

-- Declarations

END core_reset_logic ;
architecture core_reset_logic_arch of core_reset_logic is
	signal reset_s_n        : std_logic;
	signal reset_ss_n       : std_logic;
	signal rst_n_s_internal : std_logic;
	signal wdog_rst_s_n     : std_logic;
begin

	
	process(clk)
	begin
		if clk'event and clk = '1' then
			-- Asyncronous reset is routed via two flip-flops...
			reset_s_n  <= rst_n;     -- reset_s is synchronized
			reset_ss_n <= reset_s_n; -- reset_ss is safely synchronized
			-- Watchdog resets from internal timers
			wdog_rst_s_n  <= wdog0_rst_n and wdog1_rst_n;
		end if;
	end process;

	-- this reset signal is routed to core registers
	rst_n_s_internal  <= wdog_rst_s_n and reset_ss_n;
	rst_n_s           <= rst_n_s_internal;
	-- reset signal is driven to boot address sampling registers
	-- if external boot address is disabled
	gated_reset_n <= ba_ext or reset_ss_n;
	-- signal for resetting external logic
	reset_n_out <= rst_n_s_internal;

end core_reset_logic_arch;

