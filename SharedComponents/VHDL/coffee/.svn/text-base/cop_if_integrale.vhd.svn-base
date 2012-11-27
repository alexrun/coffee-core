-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  cop_if_integrale.vhd
--
-- File		: cop_if_integrale.vhd
--
-- Date		: 23:46:28 01/19/07
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

ENTITY cop_if_integrale IS
   PORT( 
      clk                          : IN     std_logic;
      cop_flags                    : IN     std_logic_vector (2 DOWNTO 0);
      enable_decode                : IN     std_logic;
      enable_exe                   : IN     std_logic;
      fcop_1_clk_result            : IN     std_logic_vector (31 DOWNTO 0);
      fcop_2_clk_result            : IN     std_logic_vector (31 DOWNTO 0);
      fcop_add_result              : IN     std_logic_vector (31 DOWNTO 0);
      fcop_addsub_completed        : IN     std_logic;
      fcop_dest_reg_1_clk_instr    : IN     std_logic_vector (4 DOWNTO 0);
      fcop_dest_reg_2_clk_instr    : IN     std_logic_vector (4 DOWNTO 0);
      fcop_dest_reg_addsub         : IN     std_logic_vector (4 DOWNTO 0);
      fcop_dest_reg_div            : IN     std_logic_vector (4 DOWNTO 0);
      fcop_dest_reg_mul            : IN     std_logic_vector (4 DOWNTO 0);
      fcop_dest_reg_sqrt           : IN     std_logic_vector (4 DOWNTO 0);
      fcop_div_completed           : IN     std_logic;
      fcop_div_result              : IN     std_logic_vector (31 DOWNTO 0);
      fcop_mul_completed           : IN     std_logic;
      fcop_mul_result              : IN     std_logic_vector (31 DOWNTO 0);
      fcop_one_clk_instr_completed : IN     std_logic;
      fcop_sqrt_completed          : IN     std_logic;
      fcop_sqrt_result             : IN     std_logic_vector (31 DOWNTO 0);
      fcop_two_clk_instr_completed : IN     std_logic;
      first_operand                : IN     std_logic_vector (31 DOWNTO 0);
      flush_decode                 : IN     std_logic;
      flush_exe                    : IN     std_logic;
      fpu_comparison               : IN     std_logic;
      fpu_drg_indx_s               : IN     std_logic_vector (4 DOWNTO 0);
      fpu_opc                      : IN     std_logic_vector (5 DOWNTO 0);
      rst_n                        : IN     std_logic;
      second_operand               : IN     std_logic_vector (31 DOWNTO 0);
      cop_flgs_we_n                : OUT    std_logic;
      fcop_opc                     : OUT    std_logic_vector (5 DOWNTO 0);
      fcop_oprnd1                  : OUT    std_logic_vector (31 DOWNTO 0);
      fcop_oprnd2                  : OUT    std_logic_vector (31 DOWNTO 0);
      fpu_add_sub_complete         : OUT    std_logic;
      fpu_add_sub_dreg             : OUT    std_logic_vector (4 DOWNTO 0);
      fpu_add_sub_result           : OUT    std_logic_vector (31 DOWNTO 0);
      fpu_div_complete             : OUT    std_logic;
      fpu_div_dreg                 : OUT    std_logic_vector (4 DOWNTO 0);
      fpu_div_result               : OUT    std_logic_vector (31 DOWNTO 0);
      fpu_drg_indx                 : OUT    std_logic_vector (4 DOWNTO 0);
      fpu_flags                    : OUT    std_logic_vector (2 DOWNTO 0);
      fpu_mul_complete             : OUT    std_logic;
      fpu_mul_dreg                 : OUT    std_logic_vector (4 DOWNTO 0);
      fpu_mul_result               : OUT    std_logic_vector (31 DOWNTO 0);
      fpu_single_cycle_complete    : OUT    std_logic;
      fpu_single_cycle_dreg        : OUT    std_logic_vector (4 DOWNTO 0);
      fpu_single_cycle_result      : OUT    std_logic_vector (31 DOWNTO 0);
      fpu_sqrt_complete            : OUT    std_logic;
      fpu_sqrt_dreg                : OUT    std_logic_vector (4 DOWNTO 0);
      fpu_sqrt_result              : OUT    std_logic_vector (31 DOWNTO 0);
      fpu_two_cycle_complete       : OUT    std_logic;
      fpu_two_cycle_dreg           : OUT    std_logic_vector (4 DOWNTO 0);
      fpu_two_cycle_result         : OUT    std_logic_vector (31 DOWNTO 0)
   );

-- Declarations

END cop_if_integrale ;
library milk;
use milk.cop_definitions.cop_nop;

architecture cop_if_integrale_arch of cop_if_integrale is

	signal comparison : std_logic;
	signal cop_flgs_we : std_logic;
begin
	------------------------------------------------------------------------
	-- Floating point instructions can be completed independent of 
	-- coffee pipeline stalls, meaning, that instructions already propagating inside
	-- Milk may write their result back to coffee at any cycle. Instruction which
	-- is just ready to be issued (latched in this interface), but not sampled
	-- by Milk yet may continue if it is not one the comparison instructions.
	-- This follows from the requirement to preserve order of execution
	-- among instructions which update condition flags. Freezing output
	-- register of this interface causes the same instruction to be sampled
	-- by Milk more than once (in case of multicycle stalls). With comparisons
	-- this does not matter since Milk comparator does not have intermediate
	-- registers (asynchronous single cycle operation), so the instruction
	-- is not replicated.
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	 -- sampling results and delaying signals (from MILK)
	------------------------------------------------------------------------
	process(clk, rst_n)
	begin
		if rst_n = '0' then
			fpu_add_sub_result        <= (others => '0');
			fpu_div_result            <= (others => '0');
			fpu_mul_result            <= (others => '0');
			fpu_single_cycle_result   <= (others => '0');
			fpu_two_cycle_result      <= (others => '0');
			fpu_sqrt_result           <= (others => '0');
			fpu_add_sub_complete      <= '0';
			fpu_div_complete          <= '0';
			fpu_mul_complete          <= '0';
			fpu_single_cycle_complete <= '0';
			fpu_sqrt_complete         <= '0';
			fpu_two_cycle_complete    <= '0';
			fpu_add_sub_dreg          <= (others => '0');
			fpu_div_dreg              <= (others => '0');
			fpu_mul_dreg              <= (others => '0');
			fpu_single_cycle_dreg     <= (others => '0');
			fpu_sqrt_dreg             <= (others => '0');
			fpu_two_cycle_dreg        <= (others => '0');
		elsif clk'event and clk = '1' then
			fpu_add_sub_result        <= fcop_add_result;
			fpu_div_result            <= fcop_div_result;
			fpu_mul_result            <= fcop_mul_result;
			fpu_single_cycle_result   <= fcop_1_clk_result;
			fpu_two_cycle_result      <= fcop_2_clk_result;
			fpu_sqrt_result           <= fcop_sqrt_result;
			fpu_add_sub_complete      <= fcop_addsub_completed;
			fpu_div_complete          <= fcop_div_completed;
			fpu_mul_complete          <= fcop_mul_completed;
			if not comparison = '1' then
				fpu_single_cycle_complete <= fcop_one_clk_instr_completed;
			else
				fpu_single_cycle_complete <= '0';
			end if;
			fpu_sqrt_complete         <= fcop_sqrt_completed;
			fpu_two_cycle_complete    <= fcop_two_clk_instr_completed;
			fpu_add_sub_dreg          <= fcop_dest_reg_addsub;
			fpu_div_dreg              <= fcop_dest_reg_div;
			fpu_mul_dreg              <= fcop_dest_reg_mul;
			fpu_single_cycle_dreg     <= fcop_dest_reg_1_clk_instr;
			fpu_sqrt_dreg             <= fcop_dest_reg_sqrt;
			fpu_two_cycle_dreg        <= fcop_dest_reg_2_clk_instr;
		end if;
	end process;


	------------------------------------------------------------------------
	-- passing floating point instructions to Milk
	------------------------------------------------------------------------
	process(clk, rst_n)
	begin
		if rst_n = '0' then
			comparison   <= '0';
			fpu_drg_indx <= (others => '0');
			fcop_opc     <= cop_nop;
		elsif clk'event and clk = '1' then
			if enable_decode = '1' then
				comparison   <= fpu_comparison and not flush_decode;
				fpu_drg_indx <= fpu_drg_indx_s;
				if flush_decode = '1' then
					fcop_opc <= cop_nop;
				else
					fcop_opc <= fpu_opc;
				end if;
			else -- prevent replication => feed nops (except comparisons)
				if comparison = '0' then
					fcop_opc <= cop_nop;
				end if;
			end if;
		end if;
	end process;

	fcop_oprnd1  <= first_operand;
	fcop_oprnd2  <= second_operand;

	------------------------------------------------------------------------
	-- sampling flags from Milk
	------------------------------------------------------------------------
	process(clk, rst_n)
	begin
		if rst_n = '0' then
			cop_flgs_we <= '0';
			fpu_flags   <= "000";
		elsif clk'event and clk = '1' then
			if enable_exe = '1' then
				cop_flgs_we <= comparison and not flush_exe;
				fpu_flags   <= cop_flags;
			end if;
		end if;
	end process;

	cop_flgs_we_n <= not cop_flgs_we;
end cop_if_integrale_arch;
