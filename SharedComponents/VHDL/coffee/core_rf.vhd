-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_rf.vhd
--
-- File		: core_rf.vhd
--
-- Date		: 23:46:09 01/19/07
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

ENTITY core_rf IS
   PORT( 
      clk                       : IN     std_logic;
      rst_x                     : IN     std_logic;
      rs_to_read                : IN     std_logic;                       -- -- Which register set to read from
      rs_to_write               : IN     std_logic;                       -- -- Which register set to write to
      wr_en_spsr                : IN     std_logic;
      wr_en_data                : IN     std_logic;
      reg_indx1                 : IN     std_logic_vector (4 DOWNTO 0);   -- -- index to register operand1
      reg_indx2                 : IN     std_logic_vector (4 DOWNTO 0);   -- -- index to register operand2
      reg_indx3                 : IN     std_logic_vector (4 DOWNTO 0);   -- -- index to result register
      psr_data_in               : IN     std_logic_vector (7 DOWNTO 0);
      core_wb_data              : IN     std_logic_vector (31 DOWNTO 0);  -- -- Data to be written to result register if enabled
      psr_o_q                   : OUT    std_logic_vector  (7 DOWNTO 0);  -- -- Processor status flag output
      spsr_o_q                  : OUT    std_logic_vector  (7 DOWNTO 0);  -- -- Output of saved status flags
      data_out1                 : OUT    std_logic_vector (31 DOWNTO 0);
      data_out2                 : OUT    std_logic_vector (31 DOWNTO 0);
      wr_en_psr                 : IN     std_logic;
      reg_lock                  : OUT    std_logic_vector (31 DOWNTO 0);
      fpu_add_sub_complete      : IN     std_logic;
      fpu_div_complete          : IN     std_logic;
      fpu_mul_complete          : IN     std_logic;
      fpu_single_cycle_complete : IN     std_logic;
      fpu_two_cycle_complete    : IN     std_logic;
      fpu_sqrt_complete         : IN     std_logic;
      fpu_single_cycle_result   : IN     std_logic_vector (31 DOWNTO 0);
      fpu_two_cycle_result      : IN     std_logic_vector (31 DOWNTO 0);
      fpu_add_sub_result        : IN     std_logic_vector (31 DOWNTO 0);
      fpu_div_result            : IN     std_logic_vector (31 DOWNTO 0);
      fpu_mul_result            : IN     std_logic_vector (31 DOWNTO 0);
      fpu_sqrt_result           : IN     std_logic_vector (31 DOWNTO 0);
      fpu_single_cycle_dreg     : IN     std_logic_vector (4 DOWNTO 0);
      fpu_two_cycle_dreg        : IN     std_logic_vector (4 DOWNTO 0);
      fpu_add_sub_dreg          : IN     std_logic_vector (4 DOWNTO 0);
      fpu_div_dreg              : IN     std_logic_vector (4 DOWNTO 0);
      fpu_mul_dreg              : IN     std_logic_vector (4 DOWNTO 0);
      fpu_sqrt_dreg             : IN     std_logic_vector (4 DOWNTO 0);
      start_fpu_mul             : IN     std_logic;
      start_fpu_add             : IN     std_logic;
      start_fpu_div             : IN     std_logic;
      start_fpu_sqrt            : IN     std_logic;
      start_fpu_scycle          : IN     std_logic;
      start_fpu_tcycle          : IN     std_logic;
      start_core_pipe           : IN     std_logic;
      target_reg                : IN     std_logic_vector (4 DOWNTO 0)
   );

-- Declarations

END core_rf ;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER;

library coffee;
--"core_rf.vhd",line 116: Error, 'psr_rswr' is not declared in 'core_constants_pkg'.
-- I'm sorry but I have to disagree...
--use coffee.core_constants_pkg.PSR_RSWR;
use coffee.core_constants_pkg.all;

architecture core_rf_opt of core_rf is
	constant PSR_RSWR : integer := 2; -- 
    type reg_bank_t is array (0 to 31) of std_logic_vector(31 downto 0);

    -- set one, the user set reserves registers 0 to 31
    -- set two, the priviledged user set reserves registers 32 to 63
	signal bank1_reg_out : reg_bank_t;
	signal bank2_reg_out : reg_bank_t;
	signal bank1_reg_in  : reg_bank_t;
	signal bank2_reg_in  : reg_bank_t;

	signal bank1_we : std_logic_vector(31 downto 0);
	signal bank2_we : std_logic_vector(31 downto 0);

	constant PSR  : integer := 29;
	constant SPSR : integer := 30;

	constant FPU_MUL     : natural := 0;
	constant FPU_DIV     : natural := 1;
	constant FPU_SQRT    : natural := 2;
	constant FPU_SCYCLE  : natural := 3;
	constant FPU_TCYCLE  : natural := 4;
	constant FPU_ADD_SUB : natural := 5;
	constant CORE_EP     : natural := 6;
	constant timeout_value_c : natural := 31;

	type array_32xnatural_3bit is array (0 to 31) of natural range 0 to 7;
	type array_6xnatural_4bit  is array (0 to 5)  of natural range 0 to 15;
	type array_6xnatural_5bit  is array (0 to 5)  of natural range 0 to 31;
	type array_6boolean        is array (0 to 5)  of boolean;

	signal reg_owners     : array_32xnatural_3bit;
	signal pipe_cnt       : array_6xnatural_4bit;
	signal timeout        : array_6xnatural_5bit;
	signal timeout_enable : array_6boolean;
	signal last_in_pipe   : std_logic_vector(5 downto 0);
	signal pipeline_empty : std_logic_vector(5 downto 0);
	signal fpu_start      : std_logic_vector(5 downto 0);
	signal fpu_complete   : std_logic_vector(5 downto 0);

begin

----------------------------------------------------
-- connections
----------------------------------------------------
    
    -- Direct outputs
    psr_o_q   <= bank2_reg_out(29)(7 downto 0);
    spsr_o_q  <= bank2_reg_out(30)(7 downto 0);

------------------------------------------------------
    -- Registers
-------------------------------------------------------

	process(clk, rst_x)
	begin
		if rst_x = '0' then
			for i in reg_bank_t'range loop
				bank2_reg_out(i) <=(others => '0');
				bank1_reg_out(i) <=(others => '0');
			end loop;
			bank2_reg_out(PSR)(31 downto 8) <=(others => '0'); -- PSR unused
			bank2_reg_out(PSR)(7 downto 0)  <= PSR_R; -- PSR
			bank2_reg_out(SPSR)             <= SPSR_R; -- SPSR
		elsif clk'event and clk = '1' then
			for i in reg_bank_t'range loop
				if bank1_we(i) = '1' then
					bank1_reg_out(i) <= bank1_reg_in(i);
				end if;
				if bank2_we(i) = '1' then
					bank2_reg_out(i) <= bank2_reg_in(i);
				end if;
			end loop;
		end if;
	end process;

------------------------------------------------------
-- Output select logic with forward control
-- NOTE: data from FPU is never forwarded (see control)
-------------------------------------------------------

    
    -- outputting data to source port data_out1
	process(wr_en_data, reg_indx3, reg_indx1, rs_to_write, rs_to_read, 
	        bank1_reg_in, bank1_reg_out, bank2_reg_in, bank2_reg_out)
		variable forward : boolean;
		variable indx : integer range 0 to 31;
	begin
		indx := CONV_INTEGER(reg_indx1);
		forward := rs_to_read = rs_to_write and reg_indx3 = reg_indx1 and wr_en_data = '1';
		if rs_to_read = '0' then
			if forward then
				data_out1 <= bank1_reg_in(indx);
			else
				data_out1 <= bank1_reg_out(indx);
			end if;
		else
			if forward then
				data_out1 <= bank2_reg_in(indx);
			else
				data_out1 <= bank2_reg_out(indx);
			end if;
		end if;
	end process;

    -- outputting data to source port data_out2
	process(wr_en_data, reg_indx3, reg_indx2, rs_to_write, rs_to_read, 
	        bank1_reg_in, bank1_reg_out, bank2_reg_in, bank2_reg_out)
		variable forward : boolean;
		variable indx : integer range 0 to 31;
	begin
		indx := CONV_INTEGER(reg_indx2);
		forward := rs_to_read = rs_to_write and reg_indx3 = reg_indx2 and wr_en_data = '1';
		if rs_to_read = '0' then
			if forward then
				data_out2 <= bank1_reg_in(indx);
			else
				data_out2 <= bank1_reg_out(indx);
			end if;
		else
			if forward then
				data_out2 <= bank2_reg_in(indx);
			else
				data_out2 <= bank2_reg_out(indx);
			end if;
		end if;
	end process;


	----------------------------------------------------------------------
	-- write enables and input selection for the both register banks
	-- (7 write ports)
	----------------------------------------------------------------------
	process(last_in_pipe, fpu_add_sub_result, fpu_add_sub_dreg, fpu_add_sub_complete,
			fpu_mul_result, fpu_mul_dreg, fpu_mul_complete, fpu_div_result,
			fpu_div_dreg, fpu_div_complete, fpu_sqrt_result, fpu_sqrt_dreg,
			fpu_sqrt_complete, fpu_single_cycle_result, fpu_single_cycle_dreg,
			fpu_single_cycle_complete, fpu_two_cycle_result, fpu_two_cycle_dreg,
			fpu_two_cycle_complete, core_wb_data, reg_indx3, wr_en_data,
			rs_to_write, bank2_reg_out, psr_data_in, wr_en_spsr, wr_en_psr, reg_owners)
	begin
		for i in reg_bank_t'range loop
			case reg_owners(i) is
			when FPU_ADD_SUB =>
				bank1_reg_in(i) <= fpu_add_sub_result;
				bank2_reg_in(i) <= fpu_add_sub_result;
				if CONV_INTEGER(fpu_add_sub_dreg) = i then
					bank1_we(i) <= last_in_pipe(FPU_ADD_SUB) and fpu_add_sub_complete and not bank2_reg_out(PSR)(PSR_RSWR);
					bank2_we(i) <= last_in_pipe(FPU_ADD_SUB) and fpu_add_sub_complete and bank2_reg_out(PSR)(PSR_RSWR);
				else
					bank1_we(i) <= '0';
					bank2_we(i) <= '0';
				end if;
			when FPU_MUL =>
				bank1_reg_in(i) <= fpu_mul_result;
				bank2_reg_in(i) <= fpu_mul_result;
				if CONV_INTEGER(fpu_mul_dreg) = i then
					bank1_we(i) <= last_in_pipe(FPU_MUL) and fpu_mul_complete and not bank2_reg_out(PSR)(PSR_RSWR);
					bank2_we(i) <= last_in_pipe(FPU_MUL) and fpu_mul_complete and bank2_reg_out(PSR)(PSR_RSWR);
				else
					bank1_we(i) <= '0';
					bank2_we(i) <= '0';
				end if;
			when FPU_DIV =>
				bank1_reg_in(i) <= fpu_div_result;
				bank2_reg_in(i) <= fpu_div_result;
				if CONV_INTEGER(fpu_div_dreg) = i then
					bank1_we(i) <= last_in_pipe(FPU_DIV) and fpu_div_complete and not bank2_reg_out(PSR)(PSR_RSWR);
					bank2_we(i) <= last_in_pipe(FPU_DIV) and fpu_div_complete and bank2_reg_out(PSR)(PSR_RSWR);
				else
					bank1_we(i) <= '0';
					bank2_we(i) <= '0';
				end if;
			when FPU_SQRT =>
				bank1_reg_in(i) <= fpu_sqrt_result;
				bank2_reg_in(i) <= fpu_sqrt_result;
				if CONV_INTEGER(fpu_sqrt_dreg) = i then
					bank1_we(i) <= last_in_pipe(FPU_SQRT) and fpu_sqrt_complete and not bank2_reg_out(PSR)(PSR_RSWR);
					bank2_we(i) <= last_in_pipe(FPU_SQRT) and fpu_sqrt_complete and bank2_reg_out(PSR)(PSR_RSWR);
				else
					bank1_we(i) <= '0';
					bank2_we(i) <= '0';
				end if;
			when FPU_SCYCLE =>
				bank1_reg_in(i) <= fpu_single_cycle_result;
				bank2_reg_in(i) <= fpu_single_cycle_result;
				if CONV_INTEGER(fpu_single_cycle_dreg) = i then
					bank1_we(i) <= last_in_pipe(FPU_SCYCLE) and fpu_single_cycle_complete and not bank2_reg_out(PSR)(PSR_RSWR);
					bank2_we(i) <= last_in_pipe(FPU_SCYCLE) and fpu_single_cycle_complete and bank2_reg_out(PSR)(PSR_RSWR);
				else
					bank1_we(i) <= '0';
					bank2_we(i) <= '0';
				end if;
			when FPU_TCYCLE =>
				bank1_reg_in(i) <= fpu_two_cycle_result;
				bank2_reg_in(i) <= fpu_two_cycle_result;
				if CONV_INTEGER(fpu_two_cycle_dreg) = i then
					bank1_we(i) <= last_in_pipe(FPU_TCYCLE) and fpu_two_cycle_complete and not bank2_reg_out(PSR)(PSR_RSWR);
					bank2_we(i) <= last_in_pipe(FPU_TCYCLE) and fpu_two_cycle_complete and bank2_reg_out(PSR)(PSR_RSWR);
				else
					bank1_we(i) <= '0';
					bank2_we(i) <= '0';
				end if;
			when others => -- CORE_EP
				bank1_reg_in(i) <= core_wb_data;
				bank2_reg_in(i) <= core_wb_data;
				if CONV_INTEGER(reg_indx3) = i then
					bank1_we(i) <= wr_en_data and not rs_to_write;
					bank2_we(i) <= wr_en_data and rs_to_write;
				else
					bank1_we(i) <= '0';
					bank2_we(i) <= '0';
				end if;
			end case;
		end loop;
		-- special registers with limited accessibility
		-- processor status register PSR
		bank2_reg_in(PSR) <= "000000000000000000000000" & psr_data_in;
		bank2_we(PSR)     <= wr_en_psr;

		-- copy of the PSR (saved PSR - SPSR), cannot be accessed by FPU directly
		if wr_en_spsr = '1' then
        	bank2_reg_in(SPSR) <= bank2_reg_out(PSR);
			bank2_we(SPSR)     <= '1';
		else
			bank2_reg_in(SPSR) <= core_wb_data;
			if CONV_INTEGER(reg_indx3) = SPSR then
				bank2_we(SPSR)     <= rs_to_write and wr_en_data;
			else
				bank2_we(SPSR)     <= '0';
			end if;
		end if;
		
	end process;

	----------------------------------------------------------------------
	-- register locking for solving data hazards caused by FPU pipelines
	----------------------------------------------------------------------
	process(reg_owners, pipeline_empty)
	begin
		for i in reg_lock'range loop
			if reg_owners(i) = CORE_EP then
				reg_lock(i) <= '0';
			else
				reg_lock(i) <= not pipeline_empty(reg_owners(i));
			end if;
		end loop;
	end process;

	----------------------------------------------------------------------
	-- keeping track of data flow in all pipelines (except core pipeline...)
	----------------------------------------------------------------------
	fpu_start(FPU_MUL)     <= start_fpu_mul;
	fpu_start(FPU_DIV)     <= start_fpu_div;
	fpu_start(FPU_SQRT)    <= start_fpu_sqrt;
	fpu_start(FPU_ADD_SUB) <= start_fpu_add;
	fpu_start(FPU_SCYCLE)  <= start_fpu_scycle;
	fpu_start(FPU_TCYCLE)  <= start_fpu_tcycle;

	fpu_complete(FPU_MUL)     <= fpu_mul_complete;
	fpu_complete(FPU_DIV)     <= fpu_div_complete;
	fpu_complete(FPU_SQRT)    <= fpu_sqrt_complete;
	fpu_complete(FPU_ADD_SUB) <= fpu_add_sub_complete;
	fpu_complete(FPU_SCYCLE)  <= fpu_single_cycle_complete;
	fpu_complete(FPU_TCYCLE)  <= fpu_two_cycle_complete;

	-- execution counters
	process(clk, rst_x)
	begin
		if rst_x = '0' then
			pipe_cnt <= (others => 0);
		elsif clk'event and clk = '1' then
			for i in pipe_cnt'range loop
				if fpu_start(i) = '1' then -- launch new operation
					if fpu_complete(i) = '1' then
						pipe_cnt(i) <= pipe_cnt(i);
					else
						pipe_cnt(i) <= pipe_cnt(i) + 1;
					end if;
				elsif fpu_complete(i) = '1' then
					pipe_cnt(i) <= pipe_cnt(i) - 1;
				elsif timeout(i) = 0 then 
					pipe_cnt(i) <= 0;
				end if;
			end loop;
			if start_fpu_mul = '1' then
				reg_owners(CONV_INTEGER(target_reg)) <= FPU_MUL;
			elsif start_fpu_div = '1' then
				reg_owners(CONV_INTEGER(target_reg)) <= FPU_DIV;
			elsif start_fpu_sqrt = '1' then
				reg_owners(CONV_INTEGER(target_reg)) <= FPU_SQRT;
			elsif start_fpu_add = '1' then
				reg_owners(CONV_INTEGER(target_reg)) <= FPU_ADD_SUB;
			elsif start_fpu_scycle = '1' then
				reg_owners(CONV_INTEGER(target_reg)) <= FPU_SCYCLE;
			elsif start_fpu_tcycle = '1' then
				reg_owners(CONV_INTEGER(target_reg)) <= FPU_TCYCLE;
			elsif start_core_pipe = '1' then
				reg_owners(CONV_INTEGER(target_reg)) <= CORE_EP;
			end if;
		end if;
	end process;

	-- derived signals
label_xyz: for i in pipe_cnt'range generate
-- 		last_in_pipe(i)   <= '1' when pipe_cnt(i) = 1 else '0';--ORIG
                last_in_pipe(i)   <= '0' when pipe_cnt(i) = 0 else '1';--
                --FABIO: it seems ok now
		pipeline_empty(i) <= '1' when pipe_cnt(i) = 0 else '0';
	end generate;

	-- timeout counters (a way to release locking in case completion of an operation
	--	is never signalled, possibly caused by exception in FPU)
	process(clk, rst_x)
	begin
		if rst_x = '0' then
			timeout <= (others => timeout_value_c);
			timeout_enable <= (others => false);
		elsif clk'event and clk = '1' then
			for i in timeout'range loop
				if fpu_start(i) = '1' then
					timeout(i)        <= timeout_value_c;
					timeout_enable(i) <= true;
				elsif fpu_complete(i) = '1' then
					timeout_enable(i) <= false;
				elsif timeout_enable(i) then
					timeout(i) <= timeout(i) - 1;
				end if;
			end loop;
		end if;
	end process;

end core_rf_opt;

