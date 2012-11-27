-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  alu_ctrl.vhd
--
-- File		: alu_ctrl.vhd
--
-- Date		: 23:46:10 01/19/07
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

ENTITY alu_ctrl IS
   PORT( 
      oper          : IN     std_logic_vector (4 DOWNTO 0);
      sel_ii        : OUT    std_logic;
      sel_i         : OUT    std_logic_vector (1 DOWNTO 0);
      control_bm    : OUT    std_logic_vector (1 DOWNTO 0);
      control_bo    : OUT    std_logic_vector (1 DOWNTO 0);
      control_shift : OUT    std_logic_vector (2 DOWNTO 0);
      bypass        : OUT    std_logic;
      sel_iii       : OUT    std_logic
   );

-- Declarations

END alu_ctrl ;

architecture alu_ctrl_arch of alu_ctrl is
	signal is_bm, is_bo, is_shift : std_logic;
begin
    -- Contolling byte_manip -unit.
	process(oper)
	begin
		case oper is
			when alu_conb      =>
				control_bm    <= alu_bm_conb;
				is_bm         <= '1';
			when alu_conh      =>
				control_bm    <= alu_bm_conh;
				is_bm         <= '1';
			when alu_exb       =>
				control_bm    <= alu_bm_exb;
				is_bm         <= '1';
			when alu_exh       =>
				control_bm    <= alu_bm_exh;
				is_bm         <= '1';
			when others        =>
				control_bm    <= "00";
				is_bm         <= '0';
		end case;
    end process;

    -- Contolling boolean_opr -unit.
	process(oper)
	begin
		case oper is
			when alu_and       =>
				control_bo    <= alu_bo_and;
				is_bo         <= '1';
			when alu_not       =>
				control_bo    <= alu_bo_not;
				is_bo         <= '1';
			when alu_or        =>
				control_bo    <= alu_bo_or;
				is_bo         <= '1';
			when alu_xor       =>
				control_bo    <= alu_bo_xor;
				is_bo         <= '1';
			when others        =>
				control_bo    <= "00";
				is_bo         <= '0';
		end case;
    end process;

    -- Contolling e_shift -unit.
	process(oper)
	begin
		case oper is
			when alu_exbf      =>
				control_shift <= alu_shift_exbf;
				is_shift      <= '1';
			when alu_sext      =>
				control_shift <= alu_shift_sext;
				is_shift      <= '1';
			when alu_sll       =>
				control_shift <= alu_shift_sll;
				is_shift      <= '1';
			when alu_sra       =>
				control_shift <= alu_shift_sra;
				is_shift      <= '1';
			when alu_srl       =>
				control_shift <= alu_shift_srl;
				is_shift      <= '1';
			when others        =>
				control_shift <= "000";
				is_shift      <= '0';
		end case;
    end process;

    -- Contolling multiplexers - data routing.
	process(oper, is_shift, is_bo, is_bm)
	begin
		-- bypass multiplexer
		if oper = alu_bypass_i then
			bypass <= '0';
		else
			bypass <= '1';
		end if;

		-- 2 to 1 multiplexer for result selection
--		if oper = alu_add or oper = alu_cmp or oper = alu_sub then
--			sel_ii <= '0';
--		else
--			sel_ii <= '1';
--		end if;

		if is_shift = '1' then
			sel_ii <= '1';
		else
			sel_ii <= '0';
		end if;

		-- 2 to 1 multiplexer for flag selection
		if oper = alu_sll then
			sel_iii <= '1';
		else
			sel_iii <= '0';
		end if;

		-- 4 to 1 multiplexer
--		if is_shift = '1' then
--			sel_i <= "11";
--		elsif is_bo = '1' then
--			sel_i <= "10";
--		elsif is_bm = '1' then
--			sel_i <= "01";
--		else
--			sel_i <= "00"; -- bypass (or not!)
--		end if;

		if oper = alu_add or oper = alu_cmp or oper = alu_sub then
			sel_i <= "11";
		elsif is_bo = '1' then
			sel_i <= "10";
		elsif is_bm = '1' then
			sel_i <= "01";
		else
			sel_i <= "00"; -- bypass (or not!)
		end if;

    end process;

end alu_ctrl_arch;









