-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  ccu_decode_ii.vhd
--
-- File		: ccu_decode_ii.vhd
--
-- Date		: 23:46:24 01/19/07
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

ENTITY ccu_decode_ii IS
   PORT( 
      alu_of_check_en_a : IN     std_logic;
      alu_op_code_a     : IN     std_logic_vector (9 DOWNTO 0);
      clk               : IN     std_logic;
      creg_indx_i       : IN     std_logic_vector (19 DOWNTO 0);
      enable            : IN     std_logic;
      flush             : IN     std_logic;
      instructionn      : IN     std_logic_vector (31 DOWNTO 0);
      rd_cop            : IN     std_logic;
      rst_x             : IN     std_logic;
      sel_data_to_cop_a : IN     std_logic;
      user_mode_in      : IN     std_logic;
      wr_cop            : IN     std_logic;
      alu_of_check_en   : OUT    std_logic;
      alu_op_code       : OUT    std_logic_vector (9 DOWNTO 0);
      cop_if_cop_indx   : OUT    std_logic_vector (1 DOWNTO 0);
      cop_if_rd_cop     : OUT    std_logic;
      cop_if_reg_indx   : OUT    std_logic_vector (4 DOWNTO 0);
      cop_if_wr_cop     : OUT    std_logic;
      opcode_out        : OUT    std_logic_vector (5 DOWNTO 0);
      sel_data_to_cop   : OUT    std_logic;
      trap_code_out     : OUT    std_logic_vector (4 DOWNTO 0);
      user_mode_out     : OUT    std_logic
   );

-- Declarations

END ccu_decode_ii ;

architecture ccu_decode_ii_arch of ccu_decode_ii is
	type cop_access_t is (INSTRUCTION,DATA);

	signal cop_access_type : cop_access_t;
	signal cop_reg_indx_s  : std_logic_vector(4 downto 0);
	signal cop_id          : std_logic_vector(1 downto 0);

	alias trap_code_in     : std_logic_vector(4 downto 0) is instructionn(14 downto 10);
	alias opcode_in        : std_logic_vector(5 downto 0) is instructionn(31 downto 26);
	alias cop_indx_data    : std_logic_vector(1 downto 0) is instructionn(11 downto 10);
	alias cop_indx_instr   : std_logic_vector(1 downto 0) is instructionn(25 downto 24);
	alias cop_reg_field    : std_logic_vector(4 downto 0) is instructionn(16 downto 12);

begin
	process(clk, rst_x)
	begin
		if rst_x = '0' then
			alu_of_check_en <= '0';
			cop_if_rd_cop   <= '0';
			cop_if_wr_cop   <= '0';
			user_mode_out   <= '0';
			alu_op_code     <= (others => '0');
			opcode_out      <= nop_opc;
			sel_data_to_cop <= '0';
			trap_code_out   <= (others => '0');
			cop_access_type <= INSTRUCTION;
			cop_id          <= "00";
			cop_reg_indx_s  <= (others => '0');
		elsif clk'event and clk = '1' then
			if enable = '1' then
				alu_of_check_en <= alu_of_check_en_a and not flush;
				cop_if_rd_cop   <= rd_cop and not flush;
				cop_if_wr_cop   <= wr_cop and not flush;
				user_mode_out   <= user_mode_in and not flush;
				alu_op_code     <= alu_op_code_a;
				sel_data_to_cop <= sel_data_to_cop_a;
				trap_code_out   <= trap_code_in;
				cop_reg_indx_s  <= cop_reg_field;

				if flush = '1' then
					opcode_out  <= nop_opc;
				else
					opcode_out  <= opcode_in;
				end if;

				if opcode_in = cop_opc then -- instruction transfer
					cop_access_type <= INSTRUCTION;
					cop_id <= cop_indx_instr; -- bits 25 downto 24 of instruction word
				else -- data transfer
					cop_access_type <= DATA;
					cop_id <= cop_indx_data;
				end if;

			end if;
		end if;
	end process;

	-- coprocessor instructions can be mapped to any register index of the
	-- coprocessor. Default index for instructions is zero.

	process(cop_id, cop_access_type, creg_indx_i, cop_reg_indx_s)
	begin
		case cop_id is
			when "00" =>
				if cop_access_type = INSTRUCTION then
					cop_if_reg_indx <= creg_indx_i(4 downto 0);
				else -- DATA, no mapping
					cop_if_reg_indx <= cop_reg_indx_s;
				end if;
			when "01" =>
				if cop_access_type = INSTRUCTION then
					cop_if_reg_indx <= creg_indx_i(9 downto 5);
				else -- DATA, no mapping
					cop_if_reg_indx <= cop_reg_indx_s;
				end if;
			when "10" =>
				if cop_access_type = INSTRUCTION then
					cop_if_reg_indx <= creg_indx_i(14 downto 10);
				else -- DATA, no mapping
					cop_if_reg_indx <= cop_reg_indx_s;
				end if;
			when "11" =>
				if cop_access_type = INSTRUCTION then
					cop_if_reg_indx <= creg_indx_i(19 downto 15);
				else -- DATA, no mapping
					cop_if_reg_indx <= cop_reg_indx_s;
				end if;
			when others =>
				cop_if_reg_indx <= (others => '0');
		end case;
	end process;

	cop_if_cop_indx <= cop_id;

end ccu_decode_ii_arch;


