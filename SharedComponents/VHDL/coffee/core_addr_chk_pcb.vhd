-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_addr_chk_pcb.vhd
--
-- File		: core_addr_chk_pcb.vhd
--
-- Date		: 23:46:17 01/19/07
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

ENTITY core_addr_chk_pcb IS
   PORT( 
      pcb_start     : IN     std_logic_vector (31 DOWNTO 0);  -- -- Comes from PCB base register
      ccb_access    : OUT    std_logic;                       -- -- Indicates an access to PCB
      accessed_addr : IN     std_logic_vector (31 DOWNTO 0);  -- -- Address to be compared
      reg_indx      : OUT    std_logic_vector (7 DOWNTO 0);
      pcb_end       : IN     std_logic_vector (31 DOWNTO 0);
      pcb_access    : OUT    std_logic;
      ccb_base      : IN     std_logic_vector (31 DOWNTO 0)
   );

-- Declarations

END core_addr_chk_pcb ;

architecture core_addr_chk_pcb_arch of core_addr_chk_pcb is

	signal in_range          : std_logic;
	signal ccb_access_signal : std_logic;

	component range_checker_32bit
	PORT( 
		value     : IN     std_logic_vector (31 DOWNTO 0);    
		hi_bound  : IN     std_logic_vector (31 DOWNTO 0);    
		low_bound : IN     std_logic_vector (31 DOWNTO 0);    
		inside    : OUT    std_logic                          
	);
	end component;



begin
	-- PCB address bounds are compared against accessed address
	-- If in range, access is to internal or external PCB.
    comparator : range_checker_32bit
	port map(
		value     => accessed_addr,
		hi_bound  => pcb_end,
		low_bound => pcb_start,
		inside    => in_range
	);

	-- Memory access points to internal core control block if
	-- bits 31 downto 8 are the same in accessed_addr and ccb_start.
	-- This follows from alignment requirements of ccb_start.

	process(ccb_base, accessed_addr)
	begin
		if ccb_base(31 downto 8) = accessed_addr(31 downto 8) then
			ccb_access_signal <= '1';
		else
			ccb_access_signal <= '0';
		end if;
	end process;

	pcb_access <= in_range and not ccb_access_signal;
	reg_indx   <= accessed_addr(7 downto 0);
	ccb_access <= ccb_access_signal;

end core_addr_chk_pcb_arch;



