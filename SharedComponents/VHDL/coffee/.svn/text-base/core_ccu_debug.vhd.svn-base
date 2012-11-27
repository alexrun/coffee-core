-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_ccu.vhd
--
-- File		: core_ccu.vhd
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

LIBRARY coffee;
USE coffee.core_constants_pkg.all;

ENTITY core_ccu_debug IS
   PORT( 
      alu_exception_of         : IN     std_logic;
      alu_exception_uf         : IN     std_logic;
      bus_req                  : IN     std_logic;
      ccb_access               : IN     std_logic;
      clk                      : IN     std_logic;
      creg_indx_i_q            : IN     std_logic_vector (19 DOWNTO 0);
      current_psr              : IN     std_logic_vector (7 DOWNTO 0);
      d_cache_miss             : IN     std_logic;
      data_addr_exception_of   : IN     std_logic;
      data_addr_exception_usr  : IN     std_logic;
      decode_exception         : IN     std_logic_vector (2 DOWNTO 0);
      execute                  : IN     std_logic;
      i_cache_miss             : IN     std_logic;
      illegal_jump             : IN     std_logic;
      inst_addr_violation      : IN     std_logic;
      instruction              : IN     std_logic_vector (31 DOWNTO 0);
      interrupt_req            : IN     std_logic;
      jump_addr_overflow       : IN     std_ulogic;
      miss_aligned_iaddr       : IN     std_logic;
      miss_aligned_jump        : IN     std_logic;
      reg_lock                 : IN     std_logic_vector (31 DOWNTO 0);
      rs_to_rd                 : IN     std_logic;
      rst_n                    : IN     std_logic;
      stall                    : IN     std_logic;
      stall_n                  : IN     std_logic;
      wait_cycles              : IN     std_logic_vector (11 DOWNTO 0);
      access_complete          : OUT    std_logic;
      ack                      : OUT    std_logic;
      alu_of_check_en          : OUT    std_logic;
      alu_op_code              : OUT    std_logic_vector (9 DOWNTO 0);
      alu_op_i_fwd             : OUT    std_logic_vector (1 DOWNTO 0);
      alu_op_ii_fwd            : OUT    std_logic_vector (1 DOWNTO 0);
      bus_ack                  : OUT    std_logic;
      ccb_we_exc               : OUT    std_logic;
      check_data_addr_ovfl     : OUT    std_logic;
      check_data_addr_usr      : OUT    std_logic;
      cop_if_cop_indx          : OUT    std_logic_vector (1 DOWNTO 0);
      cop_if_rd_cop            : OUT    std_logic;
      cop_if_reg_indx          : OUT    std_logic_vector (4 DOWNTO 0);
      cop_if_wr_cop            : OUT    std_logic;
      cpu_writes_rf            : OUT    std_logic;
      cr_we                    : OUT    std_logic;
      cr_we_all                : OUT    std_logic;
      cr_wr_reg                : OUT    std_logic_vector (2 DOWNTO 0);
      d_cache_data_fwd         : OUT    std_logic_vector (1 DOWNTO 0);
      d_cache_if_use_prev_data : OUT    std_logic;
      done                     : OUT    std_logic;
      en_stage                 : OUT    std_logic_vector (5 DOWNTO 0);
      exception_cause          : OUT    std_logic_vector (7 DOWNTO 0);
      float                    : OUT    std_logic;
      flush                    : OUT    std_logic_vector (3 DOWNTO 0);
      fpu_comparison           : OUT    std_logic;
      mdata_fwd_op_i           : OUT    std_logic;
      mdata_fwd_op_ii          : OUT    std_logic;
      mdata_fwd_st             : OUT    std_logic;
      pop                      : OUT    std_logic;
      push                     : OUT    std_logic;
      read_access              : OUT    std_logic;
      reg_jmp_fwd              : OUT    std_logic_vector (1 DOWNTO 0);
      rf_we_data               : OUT    std_logic;
      rf_we_spsr               : OUT    std_logic;
      rf_wr_reg                : OUT    std_logic_vector (4 DOWNTO 0);
      rf_wr_rs                 : OUT    std_logic;
      sel_buff_entry           : OUT    std_logic_vector (1 DOWNTO 0);
      sel_data3p               : OUT    std_logic_vector (1 DOWNTO 0);
      sel_data4p               : OUT    std_logic_vector (1 DOWNTO 0);
      sel_data5p               : OUT    std_logic;
      sel_data_from_cop        : OUT    std_logic;
      sel_data_to_cop          : OUT    std_logic;
      sel_pc                   : OUT    std_logic_vector (2 DOWNTO 0);
      sel_psr                  : OUT    std_logic_vector (2 DOWNTO 0);
      start_dmem_access        : OUT    std_logic;
      wr_en_psr                : OUT    std_logic;
      write_access             : OUT    std_logic;
      ldra_fwd                 : OUT    std_logic;
      write_pc                 : OUT    std_logic
   );

-- Declarations

END core_ccu_debug ;

ARCHITECTURE structural OF core_ccu_debug IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL alu_of_check_en_a       : std_logic;
   SIGNAL alu_op_code_a           : std_logic_vector(9 DOWNTO 0);
   SIGNAL alu_stall_i_debug       : std_logic                     := '0';
   SIGNAL alu_stall_ii_debug      : std_logic                     := '0';
   SIGNAL atomic_stall_debug      : std_logic                     := '0';
   SIGNAL bus_stall_debug         : std_logic                     := '0';
   SIGNAL cond_execute            : std_logic;
   SIGNAL cond_reg_src            : std_logic_vector(2 DOWNTO 0);
   SIGNAL cond_reg_trgt           : std_logic_vector(2 DOWNTO 0);
   SIGNAL cond_stall_debug        : std_logic                     := '0';
   SIGNAL cop_inst                : std_logic;
   SIGNAL cop_stall_debug         : std_logic                     := '0';
   SIGNAL d_cache_miss_debug      : std_logic                     := '0';
   SIGNAL data_ready              : std_logic_vector(1 DOWNTO 0);
   SIGNAL dmem_stall_debug        : std_logic                     := '0';
   SIGNAL ext_stall_debug         : std_logic                     := '0';
   SIGNAL first_source_reg_indx   : std_logic_vector(4 DOWNTO 0);
   SIGNAL flush_s                 : std_logic_vector(4 DOWNTO 0);
   SIGNAL flush_stage             : std_logic_vector(4 DOWNTO 0);
   SIGNAL freeze_pc_override      : std_logic;
   SIGNAL i_cache_miss_debug      : std_logic                     := '0';
   SIGNAL imem_stall_debug        : std_logic                     := '0';
   SIGNAL insert_nops             : std_logic;
   SIGNAL instruction_updates_psr : std_logic;
   SIGNAL int_req                 : std_logic;
   SIGNAL invalid_pc              : std_logic;
   SIGNAL ip1                     : string(35 DOWNTO 1);
   SIGNAL ip2                     : string(35 DOWNTO 1);
   SIGNAL ip3                     : string(35 DOWNTO 1);
   SIGNAL ip4                     : string(35 DOWNTO 1);
   SIGNAL ip5                     : string(35 DOWNTO 1);
   SIGNAL is_reg_jump             : std_logic;
   SIGNAL is_rel_jump             : std_logic;
   SIGNAL jmp_stall_debug         : std_logic                     := '0';
   SIGNAL jumped                  : std_logic;
   SIGNAL load                    : std_logic;
   SIGNAL mem_load                : std_logic;
   SIGNAL mul32bit                : std_logic;
   SIGNAL need_reg_operand1       : std_logic;
   SIGNAL need_reg_operand2       : std_logic;
   SIGNAL opcode_stg_ii           : std_logic_vector(5 DOWNTO 0);
   SIGNAL opcode_stg_iii          : std_logic_vector(5 DOWNTO 0);
   SIGNAL rcon                    : std_logic;
   SIGNAL rd_cop                  : std_logic;
   SIGNAL reti                    : std_logic;
   SIGNAL retu                    : std_logic;
   SIGNAL safe_state              : std_logic_vector(2 DOWNTO 0);
   SIGNAL safe_to_switch_cntxt    : std_logic;
   SIGNAL scall                   : std_logic;
   SIGNAL second_source_reg_indx  : std_logic_vector(4 DOWNTO 0);
   SIGNAL sel_data_to_cop_a       : std_logic;
   SIGNAL sel_pc_override         : std_logic_vector(2 DOWNTO 0);
   SIGNAL sel_psr_override        : std_logic_vector(2 DOWNTO 0);
   SIGNAL stall_comb              : std_logic;
   SIGNAL status_override         : std_logic;
   SIGNAL store                   : std_logic;
   SIGNAL swm                     : std_logic;
   SIGNAL trap_code               : std_logic_vector(4 DOWNTO 0);
   SIGNAL trgt_reg_indx           : std_logic_vector(4 DOWNTO 0);
   SIGNAL update_flags            : std_logic;
   SIGNAL user_mode_out           : std_logic;
   SIGNAL what_int                : std_logic_vector(11 DOWNTO 0) := (OTHERS => '0');
   SIGNAL wr_cop                  : std_logic;

   -- Implicit buffer signal declarations
   SIGNAL flush_internal         : std_logic_vector (3 DOWNTO 0);
   SIGNAL write_pc_internal      : std_logic;
   SIGNAL sel_pc_internal        : std_logic_vector (2 DOWNTO 0);
   SIGNAL en_stage_internal      : std_logic_vector (5 DOWNTO 0);
   SIGNAL cpu_writes_rf_internal : std_logic;


   -- Component Declarations
   COMPONENT ccu_decode_i
   PORT (
      instruction             : IN     std_logic_vector (31 DOWNTO 0);
      alu_of_check_en_a       : OUT    std_logic ;
      alu_op_code_a           : OUT    std_logic_vector (9 DOWNTO 0);
      cond_execute            : OUT    std_logic ;
      cond_reg_src            : OUT    std_logic_vector (2 DOWNTO 0);
      cond_reg_trgt           : OUT    std_logic_vector (2 DOWNTO 0);
      cop_inst                : OUT    std_logic ;
      data_ready              : OUT    std_logic_vector (1 DOWNTO 0);
      first_source_reg_indx   : OUT    std_logic_vector (4 DOWNTO 0);
      fpu_comparison          : OUT    std_logic ;
      instruction_updates_psr : OUT    std_logic ;
      is_reg_jump             : OUT    std_logic ;
      is_rel_jump             : OUT    std_logic ;
      load                    : OUT    std_logic ;
      mul32bit                : OUT    std_logic ;
      need_reg_operand1       : OUT    std_logic ;
      need_reg_operand2       : OUT    std_logic ;
      rcon                    : OUT    std_logic ;
      rd_cop                  : OUT    std_logic ;
      reti                    : OUT    std_logic ;
      retu                    : OUT    std_logic ;
      safe_state              : OUT    std_logic_vector (2 DOWNTO 0);
      scall                   : OUT    std_logic ;
      second_source_reg_indx  : OUT    std_logic_vector (4 DOWNTO 0);
      sel_data_to_cop_a       : OUT    std_logic ;
      store                   : OUT    std_logic ;
      swm                     : OUT    std_logic ;
      trgt_reg_indx           : OUT    std_logic_vector (4 DOWNTO 0);
      update_flags            : OUT    std_logic ;
      wr_cop                  : OUT    std_logic ;
      write_reg_file          : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT ccu_decode_ii
   PORT (
      alu_of_check_en_a : IN     std_logic ;
      alu_op_code_a     : IN     std_logic_vector (9 DOWNTO 0);
      clk               : IN     std_logic ;
      creg_indx_i       : IN     std_logic_vector (19 DOWNTO 0);
      enable            : IN     std_logic ;
      flush             : IN     std_logic ;
      instructionn      : IN     std_logic_vector (31 DOWNTO 0);
      rd_cop            : IN     std_logic ;
      rst_x             : IN     std_logic ;
      sel_data_to_cop_a : IN     std_logic ;
      user_mode_in      : IN     std_logic ;
      wr_cop            : IN     std_logic ;
      alu_of_check_en   : OUT    std_logic ;
      alu_op_code       : OUT    std_logic_vector (9 DOWNTO 0);
      cop_if_cop_indx   : OUT    std_logic_vector (1 DOWNTO 0);
      cop_if_rd_cop     : OUT    std_logic ;
      cop_if_reg_indx   : OUT    std_logic_vector (4 DOWNTO 0);
      cop_if_wr_cop     : OUT    std_logic ;
      opcode_out        : OUT    std_logic_vector (5 DOWNTO 0);
      sel_data_to_cop   : OUT    std_logic ;
      trap_code_out     : OUT    std_logic_vector (4 DOWNTO 0);
      user_mode_out     : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT ccu_decode_iii
   PORT (
      clk                  : IN     std_logic ;
      enable               : IN     std_logic ;
      flush                : IN     std_logic ;
      opcode_in            : IN     std_logic_vector (5 DOWNTO 0);
      rst_x                : IN     std_logic ;
      user_mode            : IN     std_logic ;
      check_data_addr_ovfl : OUT    std_logic ;
      check_data_addr_usr  : OUT    std_logic ;
      opcode_out           : OUT    std_logic_vector (5 DOWNTO 0);
      read_access          : OUT    std_logic ;
      sel_data3p           : OUT    std_logic_vector (1 DOWNTO 0);
      write_access         : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT ccu_decode_iv
   PORT (
      ccb_access        : IN     std_logic ;
      clk               : IN     std_logic ;
      enable            : IN     std_logic ;
      opcode            : IN     std_logic_vector (5 DOWNTO 0);
      rst_x             : IN     std_logic ;
      mem_load          : OUT    std_logic ;
      sel_data4p        : OUT    std_logic_vector (1 DOWNTO 0);
      sel_data_from_cop : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT ccu_decode_v
   PORT (
      clk        : IN     std_logic ;
      enable     : IN     std_logic ;
      mem_load   : IN     std_logic ;
      rst_x      : IN     std_logic ;
      sel_data5p : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT ccu_flow_control
   PORT (
      bus_req                  : IN     std_logic ;
      ccb_access               : IN     std_logic ;
      clk                      : IN     std_logic ;
      cond_execute             : IN     std_logic ;
      cond_reg_src             : IN     std_logic_vector (2 DOWNTO 0);
      cond_reg_trgt            : IN     std_logic_vector (2 DOWNTO 0);
      cop_inst                 : IN     std_logic ;
      d_cache_miss             : IN     std_logic ;
      data_ready               : IN     std_logic_vector (1 DOWNTO 0);
      execute                  : IN     std_logic ;
      first_source_reg_indx    : IN     std_logic_vector (4 DOWNTO 0);
      flush_stage              : IN     std_logic_vector (4 DOWNTO 0);
      freeze_pc                : IN     std_logic ;
      i_cache_miss             : IN     std_logic ;
      insert_nops              : IN     std_logic ;
      instruction_updates_psr  : IN     std_logic ;
      int_req                  : IN     std_logic ;
      is_32b_mul               : IN     std_logic ;
      is_reg_jump              : IN     std_logic ;
      is_rel_jump              : IN     std_logic ;
      load                     : IN     std_logic ;
      need_reg_operand1        : IN     std_logic ;
      need_reg_operand2        : IN     std_logic ;
      rcon                     : IN     std_logic ;
      reg_lock                 : IN     std_logic_vector (31 DOWNTO 0);
      reg_set_to_read          : IN     std_logic ;
      reg_set_to_write         : IN     std_logic ;
      reti                     : IN     std_logic ;
      retu                     : IN     std_logic ;
      rst_n                    : IN     std_logic ;
      safe_state               : IN     std_logic_vector (2 DOWNTO 0);
      scall                    : IN     std_logic ;
      second_source_reg_indx   : IN     std_logic_vector (4 DOWNTO 0);
      sel_pc_override          : IN     std_logic_vector (2 DOWNTO 0);
      sel_psr_override         : IN     std_logic_vector (2 DOWNTO 0);
      stall                    : IN     std_logic ;
      status_override          : IN     std_logic ;
      store                    : IN     std_logic ;
      swm                      : IN     std_logic ;
      trgt_reg_indx            : IN     std_logic_vector (4 DOWNTO 0);
      update_flags             : IN     std_logic ;
      wait_cycles              : IN     std_logic_vector (11 DOWNTO 0);
      write_reg_file           : IN     std_logic ;
      access_complete          : OUT    std_logic ;
      alu_op_i_fwd             : OUT    std_logic_vector (1 DOWNTO 0);
      alu_op_ii_fwd            : OUT    std_logic_vector (1 DOWNTO 0);
      bus_ack                  : OUT    std_logic ;
      cr_we                    : OUT    std_logic ;
      cr_we_all                : OUT    std_logic ;
      cr_wr_reg                : OUT    std_logic_vector (2 DOWNTO 0);
      d_cache_data_fwd         : OUT    std_logic_vector (1 DOWNTO 0);
      d_cache_if_use_prev_data : OUT    std_logic ;
      done                     : OUT    std_logic ;
      enable                   : OUT    std_logic_vector (5 DOWNTO 0);
      float                    : OUT    std_logic ;
      flush                    : OUT    std_logic_vector (3 DOWNTO 0);
      int_ack                  : OUT    std_logic ;
      invalid_pc               : OUT    std_logic ;
      jumped_q                 : OUT    std_logic ;
      mdata_fwd_op_i           : OUT    std_logic ;
      mdata_fwd_op_ii          : OUT    std_logic ;
      mdata_fwd_st             : OUT    std_logic ;
      pop                      : OUT    std_logic ;
      push                     : OUT    std_logic ;
      reg_jmp_fwd              : OUT    std_logic_vector (1 DOWNTO 0);
      rf_we_data               : OUT    std_logic ;
      rf_we_spsr               : OUT    std_logic ;
      rf_wr_reg                : OUT    std_logic_vector (4 DOWNTO 0);
      rf_wr_rs                 : OUT    std_logic ;
      safe_to_switch_cntxt     : OUT    std_logic ;
      sel_pc                   : OUT    std_logic_vector (2 DOWNTO 0);
      sel_psr                  : OUT    std_logic_vector (2 DOWNTO 0);
      start_dmem_access        : OUT    std_logic ;
      wr_en_psr                : OUT    std_logic ;
      ldra_fwd                 : OUT    std_logic;
      write_pc                 : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT ccu_master_control
   PORT (
      alu_exception_of        : IN     std_logic ;
      alu_exception_uf        : IN     std_logic ;
      clk                     : IN     std_logic ;
      current_psr             : IN     std_logic_vector (7 DOWNTO 0);
      data_addr_exception_of  : IN     std_logic ;
      data_addr_exception_usr : IN     std_logic ;
      decode_exception        : IN     std_logic_vector (2 DOWNTO 0);
      enable_3rd_stage        : IN     std_logic ;
      illegal_jump            : IN     std_logic ;
      inst_addr_violation     : IN     std_logic ;
      interrupt_req           : IN     std_logic ;
      invalid_pc              : IN     std_logic ;
      is_reg_jump             : IN     std_logic ;
      is_rel_jump             : IN     std_logic ;
      jump_addr_overflow      : IN     std_logic ;
      jumped                  : IN     std_logic ;
      miss_aligned_iaddr      : IN     std_logic ;
      miss_aligned_jump       : IN     std_logic ;
      mul32bit                : IN     std_logic ;
      rst_n                   : IN     std_logic ;
      safe_to_switch_cntxt    : IN     std_logic ;
      scall                   : IN     std_logic ;
      trap_code               : IN     std_logic_vector (4 DOWNTO 0);
      ccb_we_exc              : OUT    std_logic ;
      exception_cause         : OUT    std_logic_vector (7 DOWNTO 0);
      flush_stage             : OUT    std_logic_vector (4 DOWNTO 0);
      freeze_pc_override      : OUT    std_logic ;
      insert_nops             : OUT    std_logic ;
      int_req                 : OUT    std_logic ;
      sel_buff_entry          : OUT    std_logic_vector (1 DOWNTO 0);
      sel_pc_override         : OUT    std_logic_vector (2 DOWNTO 0);
      sel_psr_override        : OUT    std_logic_vector (2 DOWNTO 0);
      status_override         : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT instruction_pipeline2
   PORT (
      alu_stall_i_debug  : IN     std_logic ;
      alu_stall_ii_debug : IN     std_logic ;
      atomic_stall_debug : IN     std_logic ;
      bus_stall_debug    : IN     std_logic ;
      clk                : IN     std_logic ;
      cond_stall_debug   : IN     std_logic ;
      cop_stall_debug    : IN     std_logic ;
      current_psr        : IN     std_logic_vector (7 DOWNTO 0);
      d_cache_miss_debug : IN     std_logic ;
      dmem_stall_debug   : IN     std_logic ;
      en_stage           : IN     std_logic_vector (5 DOWNTO 0);
      ext_stall_debug    : IN     std_logic ;
      extended_iw        : IN     std_logic_vector (31 DOWNTO 0);
      flush              : IN     std_logic_vector (4 DOWNTO 0);
      i_cache_miss_debug : IN     std_logic ;
      imem_stall_debug   : IN     std_logic ;
      jmp_stall_debug    : IN     std_logic ;
      retu               : IN     std_logic ;
      rst_x_s            : IN     std_logic ;
      sel_pc             : IN     std_logic_vector (2 DOWNTO 0);
      what_int           : IN     std_logic_vector (11 DOWNTO 0);
      write_pc           : IN     std_logic ;
      ip1                : OUT    string (35 DOWNTO 1);
      ip2                : OUT    string (35 DOWNTO 1);
      ip3                : OUT    string (35 DOWNTO 1);
      ip4                : OUT    string (35 DOWNTO 1);
      ip5                : OUT    string (35 DOWNTO 1)
   );
   END COMPONENT;


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   stall_comb <= stall or not stall_n;

   -- HDL Embedded Text Block 2 eb2
   flush_s(4) <= '0';
   flush_s(3 downto 0) <= flush_internal;

   -- Instance port mappings.
   I9 : ccu_decode_i
      PORT MAP (
         instruction             => instruction,
         alu_of_check_en_a       => alu_of_check_en_a,
         alu_op_code_a           => alu_op_code_a,
         cond_execute            => cond_execute,
         cond_reg_src            => cond_reg_src,
         cond_reg_trgt           => cond_reg_trgt,
         cop_inst                => cop_inst,
         data_ready              => data_ready,
         first_source_reg_indx   => first_source_reg_indx,
         fpu_comparison          => fpu_comparison,
         instruction_updates_psr => instruction_updates_psr,
         is_reg_jump             => is_reg_jump,
         is_rel_jump             => is_rel_jump,
         load                    => load,
         mul32bit                => mul32bit,
         need_reg_operand1       => need_reg_operand1,
         need_reg_operand2       => need_reg_operand2,
         rcon                    => rcon,
         rd_cop                  => rd_cop,
         reti                    => reti,
         retu                    => retu,
         safe_state              => safe_state,
         scall                   => scall,
         second_source_reg_indx  => second_source_reg_indx,
         sel_data_to_cop_a       => sel_data_to_cop_a,
         store                   => store,
         swm                     => swm,
         trgt_reg_indx           => trgt_reg_indx,
         update_flags            => update_flags,
         wr_cop                  => wr_cop,
         write_reg_file          => cpu_writes_rf_internal
      );
   I10 : ccu_decode_ii
      PORT MAP (
         alu_of_check_en_a => alu_of_check_en_a,
         alu_op_code_a     => alu_op_code_a,
         clk               => clk,
         creg_indx_i       => creg_indx_i_q,
         enable            => en_stage_internal(1),
         flush             => flush_internal(1),
         instructionn      => instruction,
         rd_cop            => rd_cop,
         rst_x             => rst_n,
         sel_data_to_cop_a => sel_data_to_cop_a,
         user_mode_in      => current_psr(0),
         wr_cop            => wr_cop,
         alu_of_check_en   => alu_of_check_en,
         alu_op_code       => alu_op_code,
         cop_if_cop_indx   => cop_if_cop_indx,
         cop_if_rd_cop     => cop_if_rd_cop,
         cop_if_reg_indx   => cop_if_reg_indx,
         cop_if_wr_cop     => cop_if_wr_cop,
         opcode_out        => opcode_stg_ii,
         sel_data_to_cop   => sel_data_to_cop,
         trap_code_out     => trap_code,
         user_mode_out     => user_mode_out
      );
   I6 : ccu_decode_iii
      PORT MAP (
         clk                  => clk,
         enable               => en_stage_internal(2),
         flush                => flush_internal(2),
         opcode_in            => opcode_stg_ii,
         rst_x                => rst_n,
         user_mode            => user_mode_out,
         check_data_addr_ovfl => check_data_addr_ovfl,
         check_data_addr_usr  => check_data_addr_usr,
         opcode_out           => opcode_stg_iii,
         read_access          => read_access,
         sel_data3p           => sel_data3p,
         write_access         => write_access
      );
   I3 : ccu_decode_iv
      PORT MAP (
         ccb_access        => ccb_access,
         clk               => clk,
         enable            => en_stage_internal(3),
         opcode            => opcode_stg_iii,
         rst_x             => rst_n,
         mem_load          => mem_load,
         sel_data4p        => sel_data4p,
         sel_data_from_cop => sel_data_from_cop
      );
   I5 : ccu_decode_v
      PORT MAP (
         clk        => clk,
         enable     => en_stage_internal(4),
         mem_load   => mem_load,
         rst_x      => rst_n,
         sel_data5p => sel_data5p
      );
   CU_FLOWCTR : ccu_flow_control
      PORT MAP (
         bus_req                  => bus_req,
         ccb_access               => ccb_access,
         clk                      => clk,
         cond_execute             => cond_execute,
         cond_reg_src             => cond_reg_src,
         cond_reg_trgt            => cond_reg_trgt,
         cop_inst                 => cop_inst,
         d_cache_miss             => d_cache_miss,
         data_ready               => data_ready,
         execute                  => execute,
         first_source_reg_indx    => first_source_reg_indx,
         flush_stage              => flush_stage,
         freeze_pc                => freeze_pc_override,
         i_cache_miss             => i_cache_miss,
         insert_nops              => insert_nops,
         instruction_updates_psr  => instruction_updates_psr,
         int_req                  => int_req,
         is_32b_mul               => mul32bit,
         is_reg_jump              => is_reg_jump,
         is_rel_jump              => is_rel_jump,
         load                     => load,
         need_reg_operand1        => need_reg_operand1,
         need_reg_operand2        => need_reg_operand2,
         rcon                     => rcon,
         reg_lock                 => reg_lock,
         reg_set_to_read          => rs_to_rd,
         reg_set_to_write         => current_psr(2),
         reti                     => reti,
         retu                     => retu,
         rst_n                    => rst_n,
         safe_state               => safe_state,
         scall                    => scall,
         second_source_reg_indx   => second_source_reg_indx,
         sel_pc_override          => sel_pc_override,
         sel_psr_override         => sel_psr_override,
         stall                    => stall_comb,
         status_override          => status_override,
         store                    => store,
         swm                      => swm,
         trgt_reg_indx            => trgt_reg_indx,
         update_flags             => update_flags,
         wait_cycles              => wait_cycles,
         write_reg_file           => cpu_writes_rf_internal,
         access_complete          => access_complete,
         alu_op_i_fwd             => alu_op_i_fwd,
         alu_op_ii_fwd            => alu_op_ii_fwd,
         bus_ack                  => bus_ack,
         cr_we                    => cr_we,
         cr_we_all                => cr_we_all,
         cr_wr_reg                => cr_wr_reg,
         d_cache_data_fwd         => d_cache_data_fwd,
         d_cache_if_use_prev_data => d_cache_if_use_prev_data,
         done                     => done,
         enable                   => en_stage_internal,
         float                    => float,
         flush                    => flush_internal,
         int_ack                  => ack,
         invalid_pc               => invalid_pc,
         jumped_q                 => jumped,
         mdata_fwd_op_i           => mdata_fwd_op_i,
         mdata_fwd_op_ii          => mdata_fwd_op_ii,
         mdata_fwd_st             => mdata_fwd_st,
         pop                      => pop,
         push                     => push,
         reg_jmp_fwd              => reg_jmp_fwd,
         rf_we_data               => rf_we_data,
         rf_we_spsr               => rf_we_spsr,
         rf_wr_reg                => rf_wr_reg,
         rf_wr_rs                 => rf_wr_rs,
         safe_to_switch_cntxt     => safe_to_switch_cntxt,
         sel_pc                   => sel_pc_internal,
         sel_psr                  => sel_psr,
         start_dmem_access        => start_dmem_access,
         wr_en_psr                => wr_en_psr,
         ldra_fwd                 => ldra_fwd,
         write_pc                 => write_pc_internal
      );
   I8 : ccu_master_control
      PORT MAP (
         alu_exception_of        => alu_exception_of,
         alu_exception_uf        => alu_exception_uf,
         clk                     => clk,
         current_psr             => current_psr,
         data_addr_exception_of  => data_addr_exception_of,
         data_addr_exception_usr => data_addr_exception_usr,
         decode_exception        => decode_exception,
         enable_3rd_stage        => en_stage_internal(3),
         illegal_jump            => illegal_jump,
         inst_addr_violation     => inst_addr_violation,
         interrupt_req           => interrupt_req,
         invalid_pc              => invalid_pc,
         is_reg_jump             => is_reg_jump,
         is_rel_jump             => is_rel_jump,
         jump_addr_overflow      => jump_addr_overflow,
         jumped                  => jumped,
         miss_aligned_iaddr      => miss_aligned_iaddr,
         miss_aligned_jump       => miss_aligned_jump,
         mul32bit                => mul32bit,
         rst_n                   => rst_n,
         safe_to_switch_cntxt    => safe_to_switch_cntxt,
         scall                   => scall,
         trap_code               => trap_code,
         ccb_we_exc              => ccb_we_exc,
         exception_cause         => exception_cause,
         flush_stage             => flush_stage,
         freeze_pc_override      => freeze_pc_override,
         insert_nops             => insert_nops,
         int_req                 => int_req,
         sel_buff_entry          => sel_buff_entry,
         sel_pc_override         => sel_pc_override,
         sel_psr_override        => sel_psr_override,
         status_override         => status_override
      );
   I0 : instruction_pipeline2
      PORT MAP (
         alu_stall_i_debug  => alu_stall_i_debug,
         alu_stall_ii_debug => alu_stall_ii_debug,
         atomic_stall_debug => atomic_stall_debug,
         bus_stall_debug    => bus_stall_debug,
         clk                => clk,
         cond_stall_debug   => cond_stall_debug,
         cop_stall_debug    => cop_stall_debug,
         current_psr        => current_psr,
         d_cache_miss_debug => d_cache_miss_debug,
         dmem_stall_debug   => dmem_stall_debug,
         en_stage           => en_stage_internal,
         ext_stall_debug    => ext_stall_debug,
         extended_iw        => instruction,
         flush              => flush_s,
         i_cache_miss_debug => i_cache_miss_debug,
         imem_stall_debug   => imem_stall_debug,
         jmp_stall_debug    => jmp_stall_debug,
         retu               => retu,
         rst_x_s            => rst_n,
         sel_pc             => sel_pc_internal,
         what_int           => what_int,
         write_pc           => write_pc_internal,
         ip1                => ip1,
         ip2                => ip2,
         ip3                => ip3,
         ip4                => ip4,
         ip5                => ip5
      );

   -- Implicit buffered output assignments
   flush         <= flush_internal;
   write_pc      <= write_pc_internal;
   sel_pc        <= sel_pc_internal;
   en_stage      <= en_stage_internal;
   cpu_writes_rf <= cpu_writes_rf_internal;

END structural;
