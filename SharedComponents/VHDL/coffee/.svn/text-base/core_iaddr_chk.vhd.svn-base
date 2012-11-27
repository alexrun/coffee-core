-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_iaddr_chk.vhd
--
-- File		: core_iaddr_chk.vhd
--
-- Date		: 23:46:21 01/19/07
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

ENTITY core_iaddr_chk IS
   PORT( 
      addr_ovfl             : IN     std_logic;
      addr_viol             : IN     std_logic;
      clk                   : IN     std_logic;
      en_stage              : IN     std_logic_vector (5 DOWNTO 0);
      flush                 : IN     std_logic_vector (3 DOWNTO 0);
      miss_aligned_addr     : IN     std_logic;
      rst_x                 : IN     std_logic;
      sel_pc                : IN     std_logic_vector (2 DOWNTO 0);
      write_pc              : IN     std_logic;
      illegal_jump_q        : OUT    std_logic;
      inst_addr_violation_q : OUT    std_logic;
      jump_addr_overflow_q  : OUT    std_logic;
      miss_aligned_iaddr_q  : OUT    std_logic;
      miss_aligned_jump_q   : OUT    std_logic
   );

-- Declarations

END core_iaddr_chk ;
architecture core_iaddr_chk_arch of core_iaddr_chk is
	signal jumped, rel_jumped : std_logic;
	signal inst_addr_violation_s : std_logic;
	signal miss_aligned_iaddr_s  : std_logic;

begin
	-- saving the source of address. Each source could be
	-- handled separately, but what's the benefit?
	process(clk, rst_x)
	begin
		if rst_x = '0' then
			jumped    <= '0';
			rel_jumped <= '0';
		elsif clk'event and clk = '1' then
			if write_pc = '1' then
				-- absolute and PC relative jumps and scall
				if sel_pc = "001" or sel_pc = "010" or sel_pc = "101" then
					jumped <= '1';
				else
					jumped <= '0';
				end if;
				if sel_pc = "001"  then
					rel_jumped <= '1';
				else
					rel_jumped <= '0';
				end if;
			end if;
		end if;
	end process;

	process(clk, rst_x)
	begin
		if rst_x = '0' then
			illegal_jump_q        <= '0';
			jump_addr_overflow_q  <= '0';
			miss_aligned_jump_q   <= '0';
			inst_addr_violation_s <= '0';
			miss_aligned_iaddr_s  <= '0';
		elsif clk'event and clk = '1' then
			if en_stage(2) = '1' then
				illegal_jump_q       <= jumped and addr_viol and not flush(2);
				jump_addr_overflow_q <= rel_jumped and addr_ovfl and not flush(2);
				miss_aligned_jump_q  <= jumped and miss_aligned_addr and not flush(2);
			end if;
			if en_stage(1) = '1' then
				inst_addr_violation_s <= not jumped and addr_viol and not inst_addr_violation_s;
				miss_aligned_iaddr_s  <= not jumped and miss_aligned_addr and not miss_aligned_iaddr_s;
			end if;
		end if;
	end process;

	inst_addr_violation_q <= inst_addr_violation_s;
	miss_aligned_iaddr_q  <= miss_aligned_iaddr_s;
	
end core_iaddr_chk_arch;









