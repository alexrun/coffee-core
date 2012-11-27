-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  instruction_pipeline2.vhd
--
-- File		: instruction_pipeline2.vhd
--
-- Date		: 23:46:25 01/19/07
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
USE ieee.std_logic_unsigned.all;
LIBRARY coffee;
USE coffee.core_constants_pkg.all;

ENTITY instruction_pipeline2 IS
   PORT( 
      alu_stall_i_debug  : IN     std_logic;
      alu_stall_ii_debug : IN     std_logic;
      atomic_stall_debug : IN     std_logic;
      bus_stall_debug    : IN     std_logic;
      clk                : IN     std_logic;
      cond_stall_debug   : IN     std_logic;
      cop_stall_debug    : IN     std_logic;
      current_psr        : IN     std_logic_vector (7 DOWNTO 0);
      d_cache_miss_debug : IN     std_logic;
      dmem_stall_debug   : IN     std_logic;
      en_stage           : IN     std_logic_vector (5 DOWNTO 0);
      ext_stall_debug    : IN     std_logic;
      extended_iw        : IN     std_logic_vector (31 DOWNTO 0);
      flush              : IN     std_logic_vector (4 DOWNTO 0);
      i_cache_miss_debug : IN     std_logic;
      imem_stall_debug   : IN     std_logic;
      jmp_stall_debug    : IN     std_logic;
      retu               : IN     std_logic;
      rst_x_s            : IN     std_logic;
      sel_pc             : IN     std_logic_vector (2 DOWNTO 0);
      what_int           : IN     std_logic_vector (11 DOWNTO 0);
      write_pc           : IN     std_logic;
      ip1                : OUT    string (35 DOWNTO 1);
      ip2                : OUT    string (35 DOWNTO 1);
      ip3                : OUT    string (35 DOWNTO 1);
      ip4                : OUT    string (35 DOWNTO 1);
      ip5                : OUT    string (35 DOWNTO 1)
   );

-- Declarations

END instruction_pipeline2 ;
-- Sometimes I wish I was a software guy with proper tools...
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

architecture instruction_pipeline2_arch of instruction_pipeline2 is

	type array4x35_string is array (2 to 5) of string(1 to 35);
	type array9x3_string is array (0 to 8) of string(1 to 3);
	type array32x3_string is array (0 to 31) of string(1 to 3);
	type array64x9_string is array (0 to 63) of string(1 to 9);
	type array64x35_string is array (0 to 63) of string(1 to 35);
	type array13x9_string is array (1 to 13) of string(1 to 9);

	signal cex_bit          : std_logic;
	signal instruction      : array4x35_string;
	signal instruction_i    : string(1 to 35);
	signal instruction_word : std_logic_vector(31 downto 0);
	signal opcode           : std_logic_vector(5 downto 0);
	signal cond_code        : std_logic_vector(3 downto 0);
	signal cond_reg         : std_logic_vector(3 downto 0);
	signal dest_reg         : std_logic_vector(4 downto 0);
	signal src1_reg         : std_logic_vector(4 downto 0);
	signal src2_reg         : std_logic_vector(4 downto 0);

	signal sll_s    : string(1 to 5);
	signal sra_s    : string(1 to 5);
	signal srl_s    : string(1 to 5);
	signal opr2   : string(1 to 9);
	signal cop_iw : string(1 to 15);
	signal imm2   : string(1 to 9);

	signal cond  : string(1 to 3);
	signal creg  : string(1 to 3);
	signal dreg  : string(1 to 3);
	signal sreg1 : string(1 to 3);
	signal sreg2 : string(1 to 3);
	signal imm1  : string(1 to 9);
	signal cp_reg : string(1 to 4);

	signal conversion_table_cond_codes :  array9x3_string;
	signal conversion_table_cond_regs  :  array9x3_string;
	signal conversion_table_registers  :  array32x3_string;
	signal conversion_table_immediates :  array64x9_string; -- mostly unused
	signal inst_text                   :  array64x35_string;

	signal imm_addi   : std_logic_vector(15 downto 0);
	signal imm_addiu  : std_logic_vector(15 downto 0);
	signal imm_andi   : std_logic_vector(15 downto 0);
	signal imm_ld     : std_logic_vector(15 downto 0);
	signal imm_muli   : std_logic_vector(15 downto 0);
	signal imm_ori    : std_logic_vector(15 downto 0);
	signal imm_st     : std_logic_vector(15 downto 0);

	signal imm_bc     : std_logic_vector(22 downto 0);
	signal imm_bnc    : std_logic_vector(22 downto 0);
	signal imm_begt   : std_logic_vector(22 downto 0);
	signal imm_belt   : std_logic_vector(22 downto 0);
	signal imm_beq    : std_logic_vector(22 downto 0);
	signal imm_bgt    : std_logic_vector(22 downto 0);
	signal imm_blt    : std_logic_vector(22 downto 0);
	signal imm_bne    : std_logic_vector(22 downto 0);
	signal imm_chrs   : std_logic_vector(2 downto 0);
	signal imm_cmpi   : std_logic_vector(17 downto 0);

	signal imm_cop    : std_logic_vector(2 downto 0);
	signal imm_exb    : std_logic_vector(2 downto 0);
	signal imm1_exbfi : std_logic_vector(6 downto 0);
	signal imm2_exbfi : std_logic_vector(5 downto 0);
	signal imm_exh    : std_logic_vector(1 downto 0);
	signal imm_jal    : std_logic_vector(25 downto 0);
	signal imm_jmp    : std_logic_vector(25 downto 0);
	signal imm_lli    : std_logic_vector(16 downto 0);
	signal imm_lui    : std_logic_vector(16 downto 0);

	signal imm_movfc : std_logic_vector(2 downto 0);
	signal imm_movtc : std_logic_vector(2 downto 0);
	signal imm_trap   : std_logic_vector(5 downto 0);
	signal imm_sexti  : std_logic_vector(5 downto 0);
	signal imm_sll    : std_logic_vector(6 downto 0);
	signal imm_sra    : std_logic_vector(6 downto 0);
	signal imm_srl    : std_logic_vector(6 downto 0);
	signal imm_swm    : std_logic_vector(6 downto 0);

	signal Register_set_to_write : std_logic_vector(2 to 5);
	signal Register_set_to_read  : std_logic_vector(2 to 5);


	-- Not an elegant way to provide spaces...
	constant space2  : string(1 to 2) := "  ";
	constant space4  : string(1 to 4) := "    ";
	constant space11 : string(1 to 11) := "           ";
	constant space13 : string(1 to 13) := "             ";
	constant space16 : string(1 to 16) := "                ";
	constant space17 : string(1 to 17) := "                 ";
	constant space18 : string(1 to 18) := "                  ";
	constant space19 : string(1 to 19) := "                   ";
	constant space20 : string(1 to 20) := "                    ";
	constant space21 : string(1 to 21) := "                     ";
	constant space22 : string(1 to 22) := "                      ";
	constant space27 : string(1 to 27) := "                           ";
	constant space3  : string(1 to 3) := "   ";
	constant space5  : string(1 to 5) := "     ";
	constant space6  : string(1 to 6) := "      ";
	constant space7  : string(1 to 7) := "       ";
	constant space8  : string(1 to 8) := "        ";
	constant space9  : string(1 to 9) := "         ";

	-- Tailored conversion function. I hereby prohibit the use
    -- of this function elsewhere.
	-- Note that, even though the argument is unsigned, it is 
	-- used to pass signed values in 2C representation.
    function to_hex(arg: std_logic_vector) return string is

		variable value      : std_logic_vector(27 downto 0);
		variable sign       : std_logic;
		variable char       : std_logic_vector(3 downto 0);
		variable hex_string : string(1 to 9);
		variable str_indx   : integer range 1 to 9;
		constant hex_conversion_table : string(1 to 16) :=
		"0123456789ABCDEF";
	begin
		assert arg'length <= 26
		report "Operand too long!"
		severity failure;

		sign := arg(arg'length - 1);
		value((arg'length - 1) downto 0) := arg;
		value(27 downto (arg'length))    := (others => sign);

		if sign = '1' then -- invert
			value := not(value) + 1;
		end if;

		str_indx := 8;
		hex_string(str_indx) := '0';

		while value /= "0000000000000000000000000000" loop
			char := value(3 downto 0);
			hex_string(str_indx) := hex_conversion_table(CONV_INTEGER(char)+1);
			str_indx := str_indx - 1;
--			value := value srl 4; Okay, shifts do not work...
			value := "0000" & value(27 downto 4);
		end loop;

		-- finally the sign character
		if sign = '1' and str_indx /= 8 then 
			hex_string(str_indx) := '-';
		elsif sign = '0' and str_indx /= 8 then
			hex_string(str_indx) := ' ';
		end if;
		hex_string(9) := 'h'; -- hex identifier

		-- Getting rid of extra leading space
		while str_indx /= 1 loop
			hex_string := hex_string(2 to 9) & ' ';
			str_indx := str_indx - 1;
		end loop;

		return hex_string;

	end to_hex;


begin

	instruction_word <= extended_iw;
	opcode           <= instruction_word(31 downto 26);
	cex_bit          <= instruction_word(25);

	-- Special cases in encoding
	process(cex_bit, instruction_word, opcode, sreg2, imm1)
		variable cop_reg : std_logic_vector(4 downto 0);
	begin
		if (cex_bit = '0' or opcode = cop_opc)and not(opcode = cmp_opc or opcode = cmpi_opc) then
			cond_code <= "1000";
			cond_reg  <= "1000";
		else
			cond_code <= '0' & instruction_word(21 downto 19);
			cond_reg  <= '0' & instruction_word(24 downto 22);
		end if;

		cop_reg := instruction_word(16 downto 12);
		cp_reg <= 'C' & conversion_table_registers(CONV_INTEGER(cop_reg));
		if instruction_word(18) = '1' then
			sll_s  <= "sll  ";
			sra_s  <= "sra  ";
			srl_s  <= "srl  ";
			opr2 <= sreg2 & "      ";
		else -- immediate shifts
			sll_s  <= "slli ";
			sra_s  <= "srai ";
			srl_s  <= "srli ";
			opr2 <= imm1;
		end if;		

	end process;

	cop_iw <= "cop_instruction";
	imm2   <= to_hex(imm2_exbfi); -- exbfi only!

	-- Fixed fields
	dest_reg <= instruction_word(4 downto 0);
	src1_reg <= instruction_word(9 downto 5);
	src2_reg <= instruction_word(14 downto 10);

	cond   <= conversion_table_cond_codes(CONV_INTEGER(cond_code));
	creg   <= conversion_table_cond_regs (CONV_INTEGER(cond_reg));
	dreg   <= conversion_table_registers (CONV_INTEGER(dest_reg));
	sreg1  <= conversion_table_registers (CONV_INTEGER(src1_reg));
	sreg2  <= conversion_table_registers (CONV_INTEGER(src2_reg));
	imm1   <= conversion_table_immediates(CONV_INTEGER(opcode));

	-- 
	-- Instruction syntax		   
	inst_text(add_opc_i)      <= '(' & cond & ", " & creg & ')' & "add "      & dreg & ", "  & sreg1 & ", " & sreg2 & space8;
	inst_text(addi_opc_i)     <= '(' & cond & ", " & creg & ')' & "addi "     & dreg & ", "  & sreg1 & ", " & imm1  & ' ';
	inst_text(addiu_opc_i)    <= '(' & cond & ", " & creg & ')' & "addiu "    & dreg & ", "  & sreg1 & ", " & imm1;
	inst_text(addu_opc_i)     <= '(' & cond & ", " & creg & ')' & "addu "     & dreg & ", "  & sreg1 & ", " & sreg2 & space7;
	inst_text(and_opc_i)      <= '(' & cond & ", " & creg & ')' & "and "      & dreg & ", "  & sreg1 & ", " & sreg2 & space8;
	inst_text(andi_opc_i)     <= '(' & cond & ", " & creg & ')' & "andi "     & dreg & ", "  & sreg1 & ", " & imm1  & ' ';
	inst_text(conb_opc_i)     <= '(' & cond & ", " & creg & ')' & "conb "     & dreg & ", "  & sreg1 & ", " & sreg2 & space7;
	inst_text(conh_opc_i)     <= '(' & cond & ", " & creg & ')' & "conh "     & dreg & ", "  & sreg2 & ", " & sreg1 & space7;
	inst_text(exb_opc_i)      <= '(' & cond & ", " & creg & ')' & "exb "      & dreg & ", "  & sreg1 & ", " & imm1  & space2;
	inst_text(exbf_opc_i)     <= '(' & cond & ", " & creg & ')' & "exbf "     & dreg & ", "  & sreg1 & ", " & sreg2 & space7;
	inst_text(exh_opc_i)      <= '(' & cond & ", " & creg & ')' & "exh "      & dreg & ", "  & sreg1 & ", " & imm1  & space2;
	inst_text(jalr_opc_i)     <= '(' & cond & ", " & creg & ')' & "jalr "                    & sreg1                & space17;
	inst_text(jmpr_opc_i)     <= '(' & cond & ", " & creg & ')' & "jmpr "                    & sreg1                & space17;
	inst_text(ld_opc_i)       <= '(' & cond & ", " & creg & ')' & "ld "       & dreg & ", "  & sreg1 & ", " & imm1  & space3;
	inst_text(mov_opc_i)      <= '(' & cond & ", " & creg & ')' & "mov "      & dreg & ", "  & sreg1                & space13;
	inst_text(mulhi_opc_i)    <= '(' & cond & ", " & creg & ')' & "mulhi "    & dreg                                & space16;
	inst_text(muli_opc_i)     <= '(' & cond & ", " & creg & ')' & "muli "     & dreg & ", "  & sreg1 & ", " & imm1  & ' ';
	inst_text(muls_opc_i)     <= '(' & cond & ", " & creg & ')' & "muls "     & dreg & ", "  & sreg1 & ", " & sreg2 & space7;
	inst_text(muls_16_opc_i)  <= '(' & cond & ", " & creg & ')' & "muls_16 "  & dreg & ", "  & sreg1 & ", " & sreg2 & space4;
	inst_text(mulu_opc_i)     <= '(' & cond & ", " & creg & ')' & "mulu "     & dreg & ", "  & sreg1 & ", " & sreg2 & space7;
	inst_text(mulu_16_opc_i)  <= '(' & cond & ", " & creg & ')' & "mulu_16 "  & dreg & ", "  & sreg1 & ", " & sreg2 & space4;
	inst_text(mulus_opc_i)    <= '(' & cond & ", " & creg & ')' & "mulus "    & dreg & ", "  & sreg1 & ", " & sreg2 & space6;
	inst_text(mulus_16_opc_i) <= '(' & cond & ", " & creg & ')' & "mulus_16 " & dreg & ", "  & sreg1 & ", " & sreg2 & space3;
	inst_text(not_opc_i)      <= '(' & cond & ", " & creg & ')' & "not "      & dreg & ", "  & sreg1                & space13;
	inst_text(or_opc_i)       <= '(' & cond & ", " & creg & ')' & "or "       & dreg & ", "  & sreg1 & ", " & sreg2 & space9;
	inst_text(ori_opc_i)      <= '(' & cond & ", " & creg & ')' & "ori "      & dreg & ", "  & sreg1 & ", " & imm1  & space2;
	inst_text(scall_opc_i)    <= '(' & cond & ", " & creg & ')' & "scall "                                          & space19;
	inst_text(sext_opc_i)     <= '(' & cond & ", " & creg & ')' & "sext "     & dreg & ", "  & sreg1 & ", " & sreg2 & space7;
	inst_text(sexti_opc_i)    <= '(' & cond & ", " & creg & ')' & "sexti "    & dreg & ", "  & sreg1 & ", " & imm1;
	inst_text(st_opc_i)       <= '(' & cond & ", " & creg & ')' & "st "       & sreg2 & ", " & sreg1 & ", " & imm1  & space3;
	inst_text(sub_opc_i)      <= '(' & cond & ", " & creg & ')' & "sub "      & dreg & ", "  & sreg1 & ", " & sreg2 & space8;
	inst_text(subu_opc_i)     <= '(' & cond & ", " & creg & ')' & "subu "     & dreg & ", "  & sreg1 & ", " & sreg2 & space7;
	inst_text(sll_opc_i)      <= '(' & cond & ", " & creg & ')' &  sll_s      & dreg & ", "  & sreg1 & ", " & opr2  & ' ';
	inst_text(sra_opc_i)      <= '(' & cond & ", " & creg & ')' &  sra_s      & dreg & ", "  & sreg1 & ", " & opr2  & ' ';
	inst_text(srl_opc_i)      <= '(' & cond & ", " & creg & ')' &  srl_s      & dreg & ", "  & sreg1 & ", " & opr2  & ' ';
	inst_text(xor_opc_i)      <= '(' & cond & ", " & creg & ')' & "xor "      & dreg & ", "  & sreg1 & ", " & sreg2 & space8;

	inst_text(bc_opc_i)    <= "bc "    & creg & ", " & imm1                   & space18;
	inst_text(bnc_opc_i)   <= "bnc "   & creg & ", " & imm1                   & space17;
	inst_text(begt_opc_i)  <= "begt "  & creg & ", " & imm1                   & space16;
	inst_text(belt_opc_i)  <= "belt "  & creg & ", " & imm1                   & space16;
	inst_text(beq_opc_i)   <= "beq "   & creg & ", " & imm1                   & space17;
	inst_text(bgt_opc_i)   <= "bgt "   & creg & ", " & imm1                   & space17;
	inst_text(blt_opc_i)   <= "blt "   & creg & ", " & imm1                   & space17;
	inst_text(bne_opc_i)   <= "bne "   & creg & ", " & imm1                   & space17;
	inst_text(chrs_opc_i)  <= "chrs "               & imm1                    & space21;
	inst_text(cmp_opc_i)   <= "cmp "   & creg & ", " & sreg1 & ", " & sreg2   & space18;
	inst_text(cmpi_opc_i)  <= "cmpi "  & creg & ", " & sreg1 & ", " & imm1    & space11;
	inst_text(cop_opc_i)   <= "cop "                 & imm1  & ", " & cop_iw  & space5;
	inst_text(di_opc_i)    <= "di                                 ";
	inst_text(ei_opc_i)    <= "ei                                 ";
	inst_text(exbfi_opc_i) <= "exbfi " & dreg & ", " & sreg1 & ", " & imm1 & "," & imm2;
	inst_text(jal_opc_i)   <= "jal "   & imm1                                 & space22;
	inst_text(jmp_opc_i)   <= "jmp "   & imm1                                 & space22;
	inst_text(lli_opc_i)   <= "lli "   & dreg & ", "                & imm1    & space17;
	inst_text(lui_opc_i)   <= "lui "   & dreg & ", "                & imm1    & space17;
	inst_text(nop_opc_i)   <= "nop                                ";
	inst_text(rcon_opc_i)  <= "rcon "                & sreg1                  & space27;
	inst_text(reti_opc_i)  <= "reti                               ";
	inst_text(retu_opc_i)  <= "retu                               ";
	inst_text(scon_opc_i)  <= "scon "  & dreg                                 & space27;
	inst_text(swm_opc_i)   <= "swm "   & imm1                                 & space22;
	inst_text(trap_opc_i)  <= "trap "  & imm1                                 & space21;
	inst_text(movfc_opc_i) <= '(' & cond & ", " & creg & ')' & "movfc " & imm1 & "," & dreg & "," & cp_reg & ' ';
	inst_text(movtc_opc_i) <= '(' & cond & ", " & creg & ')' & "movtc " & imm1 & "," & cp_reg & "," & sreg1 & ' ';

	instruction_i <= inst_text(CONV_INTEGER(opcode));

	ip1 <= instruction_i;
	ip2 <= instruction(2);
	ip3 <= instruction(3);
	ip4 <= instruction(4);
	ip5 <= instruction(5);

	-- Evaluating immediates. These vary most between instructions
	process(instruction_word, cex_bit)
		variable sign : std_logic;
	begin
		if cex_bit = '0' then
			sign       := instruction_word(24);
			imm_addi   <= sign & instruction_word(24 downto 10); -- signed
			imm_addiu  <= '0'  & instruction_word(24 downto 10); -- unsigned
			imm_andi   <= '0'  & instruction_word(24 downto 10); -- unsigned
			imm_ld     <= sign & instruction_word(24 downto 10); -- signed
			imm_muli   <= sign & instruction_word(24 downto 10); -- signed
			imm_ori    <= '0'  & instruction_word(24 downto 10); -- unsigned

			sign       := instruction_word(4);
			imm_st     <= sign & instruction_word(4 downto 0) &
			              instruction_word(24 downto 15); -- signed;
		else
			sign                    := instruction_word(18);
			imm_addi(8 downto 0)    <= instruction_word(18 downto 10); -- signed
			imm_addiu(8 downto 0)   <= instruction_word(18 downto 10); -- unsigned
			imm_andi(8 downto 0)    <= instruction_word(18 downto 10); -- unsigned
			imm_ld(8 downto 0)      <= instruction_word(18 downto 10); -- signed
			imm_muli(8 downto 0)    <= instruction_word(18 downto 10); -- signed
			imm_ori(8 downto 0)     <= instruction_word(18 downto 10); -- unsigned
			imm_addi(15 downto 9)   <= (others => sign); -- signed
			imm_addiu(15 downto 9)  <= (others => '0'); -- unsigned
			imm_andi(15 downto 9)   <= (others => '0'); -- unsigned
			imm_ld(15 downto 9)     <= (others => sign); -- signed
			imm_muli(15 downto 9)   <= (others => sign); -- signed
			imm_ori(15 downto 9)    <= (others => '0'); -- unsigned

			sign                    := instruction_word(4);
			imm_st(8 downto 0)     <= instruction_word(4 downto 0) &
			                          instruction_word(18 downto 15); -- signed;
			imm_st(15 downto 9)     <= (others => sign); -- signed
		end if;

		sign       := instruction_word(21);
		imm_bc     <= sign & instruction_word(21 downto 0); -- signed
		imm_bnc    <= sign & instruction_word(21 downto 0); -- signed
		imm_begt   <= sign & instruction_word(21 downto 0); -- signed
		imm_belt   <= sign & instruction_word(21 downto 0); -- signed
		imm_beq    <= sign & instruction_word(21 downto 0); -- signed
		imm_bgt    <= sign & instruction_word(21 downto 0); -- signed
		imm_blt    <= sign & instruction_word(21 downto 0); -- signed
		imm_bne    <= sign & instruction_word(21 downto 0); -- signed
		imm_chrs   <= '0'  & instruction_word(11 downto 10); -- unsigned

		sign       := instruction_word(4);
		imm_cmpi   <= sign & instruction_word(4 downto 0) & 
		              instruction_word(21 downto 10); -- signed
		imm_cop    <= '0'  & instruction_word(25 downto 24); -- unsigned
		imm_exb    <= '0'  & instruction_word(11 downto 10); -- unsigned
		imm1_exbfi <= '0'  & instruction_word(20 downto 15); -- unsigned
		imm2_exbfi <= '0'  & instruction_word(14 downto 10); -- unsigned
		imm_exh    <= '0'  & instruction_word(10); -- unsigned

		sign       := instruction_word(24);
		imm_jal    <= sign & instruction_word(24 downto 0); -- signed
		imm_jmp    <= sign & instruction_word(24 downto 0); -- signed
		imm_lli    <= '0'  & instruction_word(9) & 
		              instruction_word(24 downto 10); -- unsigned
		imm_lui    <= '0'  & instruction_word(9) & 
		              instruction_word(24 downto 10); -- unsigned
		imm_movfc <= '0'  & instruction_word(11 downto 10); -- unsigned
		imm_movtc <= '0'  & instruction_word(11 downto 10); -- unsigned
		imm_sexti  <= '0'  & instruction_word(14 downto 10); -- unsigned
		imm_sll    <= '0'  & instruction_word(15 downto 10); -- unsigned
		imm_sra    <= '0'  & instruction_word(15 downto 10); -- unsigned
		imm_srl    <= '0'  & instruction_word(15 downto 10); -- unsigned
		imm_swm    <= '0'  & instruction_word(15 downto 10); -- unsigned
		imm_trap   <= '0'  & instruction_word(14 downto 10); -- unsigned

	end process;

	-- 'Executing' instruction currently on pipeline
	process(clk, rst_x_s)
	begin
		if rst_x_s = '0' then
			instruction(2) <= inst_text(nop_opc_i);
			instruction(3) <= inst_text(nop_opc_i);
			instruction(4) <= inst_text(nop_opc_i);
			instruction(5) <= inst_text(nop_opc_i);
		elsif clk'event and clk = '1' then
			if en_stage(1) = '1' then
				if flush(1) = '1' then
					instruction(2) <= inst_text(nop_opc_i);
				else
					instruction(2) <= instruction_i;
				end if;
				Register_set_to_write(2) <= current_psr(2);
				Register_set_to_read(2)  <= current_psr(1);
			end if;
			if en_stage(2) = '1' then
				if flush(2) = '1' then
					instruction(3) <= inst_text(nop_opc_i);
				else
					instruction(3) <= instruction(2);
				end if;
				Register_set_to_write(3) <= Register_set_to_write(2);
				Register_set_to_read(3)  <= Register_set_to_read(2);
			end if;
			if en_stage(3) = '1' then
				if flush(3) = '1' then
					instruction(4) <= inst_text(nop_opc_i);
				else
					instruction(4) <= instruction(3);
				end if;
			end if;
				Register_set_to_write(4) <= Register_set_to_write(3);
				Register_set_to_read(4)  <= Register_set_to_read(3);
			if en_stage(4) = '1' then
				if flush(4) = '1' then
					instruction(5) <= inst_text(nop_opc_i);
				else
					instruction(5) <= instruction(4);
				end if;
				Register_set_to_write(5) <= Register_set_to_write(4);
				Register_set_to_read(5)  <= Register_set_to_read(4);
			end if;
		end if;
	end process;

	-- Conversion tables for mapping binary to text
	conversion_table_cond_codes(cc_c_i)   <= "C  ";
	conversion_table_cond_codes(cc_eq_i)  <= "EQ ";
	conversion_table_cond_codes(cc_gt_i)  <= "GT ";
	conversion_table_cond_codes(cc_lt_i)  <= "LT ";
	conversion_table_cond_codes(cc_ne_i)  <= "NE ";
	conversion_table_cond_codes(cc_elt_i) <= "ELT";
	conversion_table_cond_codes(cc_egt_i) <= "EGT";
	conversion_table_cond_codes(cc_nc_i)  <= "NC ";
	conversion_table_cond_codes(8)      <= "   ";

	conversion_table_cond_regs(0)  <= "CR0";
	conversion_table_cond_regs(1)  <= "CR1";
	conversion_table_cond_regs(2)  <= "CR2";
	conversion_table_cond_regs(3)  <= "CR3";
	conversion_table_cond_regs(4)  <= "CR4";
	conversion_table_cond_regs(5)  <= "CR5";
	conversion_table_cond_regs(6)  <= "CR6";
	conversion_table_cond_regs(7)  <= "CR7";
	conversion_table_cond_regs(8)  <= "   ";

	conversion_table_registers(0)   <= "R0 ";
	conversion_table_registers(1)   <= "R1 ";
	conversion_table_registers(2)   <= "R2 ";
	conversion_table_registers(3)   <= "R3 ";
	conversion_table_registers(4)   <= "R4 ";
	conversion_table_registers(5)   <= "R5 ";
	conversion_table_registers(6)   <= "R6 ";
	conversion_table_registers(7)   <= "R7 ";
	conversion_table_registers(8)   <= "R8 ";
	conversion_table_registers(9)   <= "R9 ";
	conversion_table_registers(10)  <= "R10";
	conversion_table_registers(11)  <= "R11";
	conversion_table_registers(12)  <= "R12";
	conversion_table_registers(13)  <= "R13";
	conversion_table_registers(14)  <= "R14";
	conversion_table_registers(15)  <= "R15";
	conversion_table_registers(16)  <= "R16";
	conversion_table_registers(17)  <= "R17";
	conversion_table_registers(18)  <= "R18";
	conversion_table_registers(19)  <= "R19";
	conversion_table_registers(20)  <= "R20";
	conversion_table_registers(21)  <= "R21";
	conversion_table_registers(22)  <= "R22";
	conversion_table_registers(23)  <= "R23";
	conversion_table_registers(24)  <= "R24";
	conversion_table_registers(25)  <= "R25";
	conversion_table_registers(26)  <= "R26";
	conversion_table_registers(27)  <= "R27";
	conversion_table_registers(28)  <= "R28";
	conversion_table_registers(29)  <= "R29";
	conversion_table_registers(30)  <= "R30";
	conversion_table_registers(31)  <= "R31";

	-- length of immediate 1 is nine characters including hex
	-- identifier h and sign "-" or " "
	conversion_table_immediates(add_opc_i)      <= (others => ' ');
	conversion_table_immediates(addi_opc_i)     <= to_hex(imm_addi);
	conversion_table_immediates(addiu_opc_i)    <= to_hex(imm_addiu);
	conversion_table_immediates(addu_opc_i)     <= (others => ' ');
	conversion_table_immediates(and_opc_i)      <= (others => ' ');
	conversion_table_immediates(andi_opc_i)     <= to_hex(imm_andi);
	conversion_table_immediates(bc_opc_i)       <= to_hex(imm_bc);
	conversion_table_immediates(bnc_opc_i)      <= to_hex(imm_bnc);
	conversion_table_immediates(begt_opc_i)     <= to_hex(imm_begt);
	conversion_table_immediates(belt_opc_i)     <= to_hex(imm_belt);
	conversion_table_immediates(beq_opc_i)      <= to_hex(imm_beq);
	conversion_table_immediates(bgt_opc_i)      <= to_hex(imm_bgt);
	conversion_table_immediates(blt_opc_i)      <= to_hex(imm_blt);
	conversion_table_immediates(bne_opc_i)      <= to_hex(imm_bne);
	conversion_table_immediates(chrs_opc_i)     <= to_hex(imm_chrs);
	conversion_table_immediates(cmp_opc_i)      <= (others => ' ');
	conversion_table_immediates(cmpi_opc_i)     <= to_hex(imm_cmpi);
	conversion_table_immediates(conb_opc_i)     <= (others => ' ');
	conversion_table_immediates(conh_opc_i)     <= (others => ' ');
	conversion_table_immediates(cop_opc_i)      <= to_hex(imm_cop);
	conversion_table_immediates(di_opc_i)       <= (others => ' ');
	conversion_table_immediates(ei_opc_i)       <= (others => ' ');
	conversion_table_immediates(exb_opc_i)      <= to_hex(imm_exb);
	conversion_table_immediates(exbf_opc_i)     <= (others => ' ');
	conversion_table_immediates(exbfi_opc_i)    <= to_hex(imm1_exbfi);
	conversion_table_immediates(exh_opc_i)      <= to_hex(imm_exh);
	conversion_table_immediates(jal_opc_i)      <= to_hex(imm_jal);
	conversion_table_immediates(jalr_opc_i)     <= (others => ' ');
	conversion_table_immediates(jmp_opc_i)      <= to_hex(imm_jmp);
	conversion_table_immediates(jmpr_opc_i)     <= (others => ' ');
	conversion_table_immediates(ld_opc_i)       <= to_hex(imm_ld);
	conversion_table_immediates(lli_opc_i)      <= to_hex(imm_lli);
	conversion_table_immediates(lui_opc_i)      <= to_hex(imm_lui);
	conversion_table_immediates(mov_opc_i)      <= (others => ' ');
	conversion_table_immediates(movfc_opc_i)   <= to_hex(imm_movfc);
	conversion_table_immediates(movtc_opc_i)   <= to_hex(imm_movtc);
	conversion_table_immediates(mulhi_opc_i)    <= (others => ' ');
	conversion_table_immediates(muli_opc_i)     <= to_hex(imm_muli);
	conversion_table_immediates(muls_opc_i)     <= (others => ' ');
	conversion_table_immediates(muls_16_opc_i)  <= (others => ' ');
	conversion_table_immediates(mulu_opc_i)     <= (others => ' ');
	conversion_table_immediates(mulu_16_opc_i)  <= (others => ' ');
	conversion_table_immediates(mulus_opc_i)    <= (others => ' ');
	conversion_table_immediates(mulus_16_opc_i) <= (others => ' ');
	conversion_table_immediates(nop_opc_i)      <= (others => ' ');
	conversion_table_immediates(not_opc_i)      <= (others => ' ');
	conversion_table_immediates(or_opc_i)       <= (others => ' ');
	conversion_table_immediates(ori_opc_i)      <= to_hex(imm_ori);
	conversion_table_immediates(rcon_opc_i)     <= (others => ' ');
	conversion_table_immediates(reti_opc_i)     <= (others => ' ');
	conversion_table_immediates(retu_opc_i)     <= (others => ' ');
	conversion_table_immediates(scall_opc_i)    <= (others => ' ');
	conversion_table_immediates(scon_opc_i)     <= (others => ' ');
	conversion_table_immediates(sext_opc_i)     <= (others => ' ');
	conversion_table_immediates(sexti_opc_i)    <= to_hex(imm_sexti);
	conversion_table_immediates(sll_opc_i)      <= to_hex(imm_sll);
	conversion_table_immediates(sra_opc_i)      <= to_hex(imm_sra);
	conversion_table_immediates(srl_opc_i)      <= to_hex(imm_srl);
	conversion_table_immediates(st_opc_i)       <= to_hex(imm_st);
	conversion_table_immediates(sub_opc_i)      <= (others => ' ');
	conversion_table_immediates(subu_opc_i)     <= (others => ' ');
	conversion_table_immediates(swm_opc_i)      <= to_hex(imm_swm);
	conversion_table_immediates(trap_opc_i)     <= to_hex(imm_trap);
	conversion_table_immediates(xor_opc_i)      <= (others => ' ');

end instruction_pipeline2_arch;












