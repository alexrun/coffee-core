-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  inth_sync.vhd
--
-- File		: inth_sync.vhd
--
-- Date		: 23:46:22 01/19/07
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

ENTITY inth_sync IS
   PORT( 
      clk            : IN     std_logic;
      cop_exc        : IN     std_logic_vector (3 DOWNTO 0);
      ext_handler    : IN     std_logic;
      ext_interrupt  : IN     std_logic_vector (7 DOWNTO 0);
      rst_n          : IN     std_logic;
      tmr_inta       : IN     std_logic_vector (7 DOWNTO 0);
      tmr_intb       : IN     std_logic_vector (7 DOWNTO 0);
      cop_request    : OUT    std_logic_vector (3 DOWNTO 0);
      ext_request    : OUT    std_logic_vector (7 DOWNTO 0);
      intrnl_request : OUT    std_logic_vector (7 DOWNTO 0);
      read_offset    : OUT    std_logic_vector (7 DOWNTO 0)
   );

-- Declarations

END inth_sync ;
architecture inth_sync_arch of inth_sync is

	type array3x8_stdl is array (0 to 2) of std_logic_vector(7 downto 0);
	type array3x4_stdl is array (0 to 2) of std_logic_vector(3 downto 0);
	type array2x8_stdl is array (0 to 1) of std_logic_vector(7 downto 0);


	signal offset_enabled : std_logic_vector(7 downto 0);
	signal ext_request_i  : std_logic_vector(7 downto 0);
	signal ext_irq        : array3x8_stdl;
	signal tmr_irq        : array2x8_stdl;
	signal cop_irq        : array3x4_stdl;

begin


	-- Synchronizing interrupt and exception lines
	process(clk, rst_n)
	begin
		if rst_n = '0' then
			ext_irq  <= (others => (others => '0'));
			tmr_irq  <= (others => (others => '0'));
			cop_irq  <= (others => (others => '0'));
		elsif clk'event and clk = '1' then
			tmr_irq(0)  <= tmr_inta or tmr_intb;
			tmr_irq(1)  <= tmr_irq(0);
			ext_irq(0) <= ext_interrupt;
			ext_irq(1) <= ext_irq(0);
			ext_irq(2) <= ext_irq(1);
			cop_irq(0) <= cop_exc;
			cop_irq(1) <= cop_irq(0);
			cop_irq(2) <= cop_irq(1);
		end if;
	end process;

	offset_enabled <= (others => ext_handler);
	ext_request_i  <= ext_irq(1) and not ext_irq(2);
	ext_request    <= ext_request_i;
	intrnl_request <= tmr_irq(0) and not tmr_irq(1);
	cop_request    <= cop_irq(1) and not cop_irq(2);

	-- Offset should be read only once after rising edge on
	-- one or more of the extrenal interrupt inputs
	-- (if enabled)

	read_offset <= offset_enabled and ext_request_i;

end inth_sync_arch;
