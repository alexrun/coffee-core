-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project              : AVEC
--
-- Design               :  core_plain.vhd
--
-- File         : core_plain.vhd
--
-- Date         : 23:46:28 01/19/07
--
-- Description  : 
--
-- ----------------------------------------------------------------------------
--
-- Author(s)    : Juha Kylliäinen, fabio Garzia
--
-- Status               : Pre-release, not fully tested
--
-- References   : http://coffee.tut.fi/
--
-- ----------------------------------------------------------------------------
--
-- Limitations  : 
--
-- Known Errors         : <no, only unknowns as it stands...>
--
-- ----------------------------------------------------------------------------
--
-- Revision list        : 
--
-- ----------------------------------------------------------------------------
--Copyright (c) 2007, Tampere University of Technology.
--All rights reserved.

--Redistribution and use in source and binary forms, with or without modification,
--are permitted provided that the following conditions are met:
--* Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--* Redistributions in binary form must reproduce the above copyright notice,
-- this list of conditions and the following disclaimer in the documentation
-- and/or other materials provided with the distribution.
--* Neither the name of Tampere University of Technology nor the names of its
-- contributors may be used to endorse or promote products derived from this
-- software without specific prior written permission.

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
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

LIBRARY coffee;
USE coffee.core_constants_pkg.ALL;

LIBRARY components;
USE components.sys_definitions.ALL;
USE components.sys_components.ALL;

LIBRARY milk;
USE milk.cop_definitions.ALL;

ENTITY core_plain IS
   GENERIC (
      FPU_FU                       :     BOOLEAN);
   PORT(
      reboot                       : IN  STD_LOGIC;
      restart                      : IN  STD_LOGIC;
      boot_sel                     : IN  STD_LOGIC;
      bus_req                      : IN  STD_LOGIC;
      clk                          : IN  STD_LOGIC;
      cop0_exc                     : IN  STD_LOGIC;
      cop1_exc                     : IN  STD_LOGIC;
      cop2_exc                     : IN  STD_LOGIC;
      cop3_exc                     : IN  STD_LOGIC;
      cop_flags                    : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
      d_cache_miss                 : IN  STD_LOGIC;
      ext_handler                  : IN  STD_LOGIC;
      ext_interrupt                : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
      fcop_1_clk_result            : IN  STD_LOGIC_VECTOR (word_width-1 DOWNTO 0);
      fcop_2_clk_result            : IN  STD_LOGIC_VECTOR (word_width-1 DOWNTO 0);
      fcop_add_result              : IN  STD_LOGIC_VECTOR (word_width-1 DOWNTO 0);
      fcop_addsub_completed        : IN  STD_LOGIC;
      fcop_dest_reg_1_clk_instr    : IN  STD_LOGIC_VECTOR (core_rf_width-1 DOWNTO 0);
      fcop_dest_reg_2_clk_instr    : IN  STD_LOGIC_VECTOR (core_rf_width-1 DOWNTO 0);
      fcop_dest_reg_addsub         : IN  STD_LOGIC_VECTOR (core_rf_width-1 DOWNTO 0);
      fcop_dest_reg_div            : IN  STD_LOGIC_VECTOR (core_rf_width-1 DOWNTO 0);
      fcop_dest_reg_mul            : IN  STD_LOGIC_VECTOR (core_rf_width-1 DOWNTO 0);
      fcop_dest_reg_sqrt           : IN  STD_LOGIC_VECTOR (core_rf_width-1 DOWNTO 0);
      fcop_div_completed           : IN  STD_LOGIC;
      fcop_div_result              : IN  STD_LOGIC_VECTOR (word_width-1 DOWNTO 0);
      fcop_mul_completed           : IN  STD_LOGIC;
      fcop_mul_result              : IN  STD_LOGIC_VECTOR (word_width-1 DOWNTO 0);
      fcop_one_clk_instr_completed : IN  STD_LOGIC;
      fcop_sqrt_completed          : IN  STD_LOGIC;
      fcop_sqrt_result             : IN  STD_LOGIC_VECTOR (word_width-1 DOWNTO 0);
      fcop_status                  : IN  STD_LOGIC_VECTOR (exceptions_amount-1 DOWNTO 0);
      fcop_two_clk_instr_completed : IN  STD_LOGIC;
      i_cache_miss                 : IN  STD_LOGIC;
      i_word                       : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      offset                       : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
      rst_n                        : IN  STD_LOGIC;
      stall                        : IN  STD_LOGIC;
      stall_n                      : IN  STD_LOGIC;
      bus_ack                      : OUT STD_LOGIC;
      cop_id                       : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      cop_rd                       : OUT STD_LOGIC;
      cop_rgi                      : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
      cop_wr                       : OUT STD_LOGIC;
      fcop_opc                     : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
      fcop_oprnd1                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      fcop_oprnd2                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      fpu_drg_indx                 : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
      i_addr                       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      int_ack                      : OUT STD_LOGIC;
      int_done                     : OUT STD_LOGIC;
      pcb_rd                       : OUT STD_LOGIC;
      pcb_wr                       : OUT STD_LOGIC;
      rd                           : OUT STD_LOGIC;
      reset_n_out                  : OUT STD_LOGIC;
      wr                           : OUT STD_LOGIC;
      cop_data                     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      cop_q                        : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      d_addr                       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      data_in                      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_out                     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );

-- Declarations

END core_plain;

ARCHITECTURE struct OF core_plain IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL abs_jmp_addr              : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL access_complete           : STD_LOGIC;
   SIGNAL ack                       : STD_LOGIC;
   SIGNAL addr_mask                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL addr_ovfl                 : STD_LOGIC;
   SIGNAL addr_viol                 : STD_LOGIC;
   SIGNAL alu_exception_of          : STD_LOGIC;
   SIGNAL alu_exception_uf          : STD_LOGIC;
   SIGNAL alu_of_check_en           : STD_LOGIC;
   SIGNAL alu_op_code               : STD_LOGIC_VECTOR(9 DOWNTO 0);
   SIGNAL alu_op_i_fwd              : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL alu_op_ii_fwd             : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL base_addr                 : array_12x32_stdl;
   SIGNAL boot_address              : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL buff_addr                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL carry_out                 : STD_LOGIC;
   SIGNAL ccb_access                : STD_LOGIC;
   SIGNAL ccb_base                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL ccb_data                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL ccb_we_exc                : STD_LOGIC;
   SIGNAL cexbit                    : STD_LOGIC;
   SIGNAL check_data_addr_ovfl      : STD_LOGIC;
   SIGNAL check_data_addr_usr       : STD_LOGIC;
   SIGNAL check_enable              : STD_LOGIC;
   SIGNAL condition                 : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL cop_data_int              : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL cop_exc                   : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL cop_flgs_we_n             : STD_LOGIC;
   SIGNAL cop_if_cop_indx           : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL cop_if_rd_cop             : STD_LOGIC;
   SIGNAL cop_if_reg_indx           : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL cop_if_wr_cop             : STD_LOGIC;
   SIGNAL cop_int_pri               : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL cpu_writes_rf             : STD_LOGIC;
   SIGNAL cr0_to_push               : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL cr_we                     : STD_LOGIC;
   SIGNAL cr_we_all                 : STD_LOGIC;
   SIGNAL cr_wr_reg                 : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL creg_indx                 : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL creg_indx_i_q             : STD_LOGIC_VECTOR(19 DOWNTO 0);
   SIGNAL current_psr               : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL d_cache_data_fwd          : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL d_cache_if_use_prev_data  : STD_LOGIC;
   SIGNAL data_addr_exception_of    : STD_LOGIC;
   SIGNAL data_addr_exception_usr   : STD_LOGIC;
   SIGNAL data_i                    : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL data_ii                   : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL data_iii                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL data_to_mem               : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL dc_mode                   : STD_LOGIC;
   SIGNAL decode_exception          : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL done                      : STD_LOGIC;
   SIGNAL en_stage                  : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL exc_psr                   : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL exception_addr_q          : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL exception_cause           : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL execute                   : STD_LOGIC;
   SIGNAL ext_imm                   : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL ext_int_pri               : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL first_operand             : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL flags                     : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL float                     : STD_LOGIC;
   SIGNAL flush                     : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL fpu_add_sub_complete      : STD_LOGIC;
   SIGNAL fpu_add_sub_dreg          : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL fpu_add_sub_result        : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL fpu_comparison            : STD_LOGIC;
   SIGNAL fpu_div_complete          : STD_LOGIC;
   SIGNAL fpu_div_dreg              : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL fpu_div_result            : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL fpu_drg_indx_s            : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL fpu_flags                 : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL fpu_mul_complete          : STD_LOGIC;
   SIGNAL fpu_mul_dreg              : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL fpu_mul_result            : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL fpu_opc                   : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL fpu_single_cycle_complete : STD_LOGIC;
   SIGNAL fpu_single_cycle_dreg     : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL fpu_single_cycle_result   : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL fpu_sqrt_complete         : STD_LOGIC;
   SIGNAL fpu_sqrt_dreg             : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL fpu_sqrt_result           : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL fpu_two_cycle_complete    : STD_LOGIC;
   SIGNAL fpu_two_cycle_dreg        : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL fpu_two_cycle_result      : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL gated_reset_n             : STD_LOGIC;
   SIGNAL i_addr_asynch             : STD_LOGIC_VECTOR(31 DOWNTO 0) := "11111111111111111111111111111111";
   SIGNAL i_addr_signal             : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL i_addr_temp               : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL i_word_sset               : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL il                        : STD_LOGIC;
   SIGNAL illegal_jump_q            : STD_LOGIC;
   SIGNAL inst_addr_violation_q     : STD_LOGIC;
   SIGNAL instruction               : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL int_addr                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL int_mask                  : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL int_mode_il               : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL int_mode_um               : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL int_pend                  : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL int_psr                   : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL int_serv                  : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL interrupt_req             : STD_LOGIC;
   SIGNAL jump_addr_overflow_q      : STD_LOGIC;
   SIGNAL jump_offset               : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL mdata_fwd_op_i            : STD_LOGIC;
   SIGNAL mdata_fwd_op_ii           : STD_LOGIC;
   SIGNAL mdata_fwd_st              : STD_LOGIC;
   SIGNAL mem_data                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL miss_aligned_addr         : STD_LOGIC;
   SIGNAL miss_aligned_iaddr_q      : STD_LOGIC;
   SIGNAL miss_aligned_jump_q       : STD_LOGIC;
   SIGNAL new_psr                   : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL new_tos_addr              : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL new_tos_cr0               : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL new_tos_psr               : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL next_addr                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL next_psr                  : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL o                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL o1                        : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL o3                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL o4                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL o6                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL one                       : STD_LOGIC;
   SIGNAL opc                       : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL operand_i                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL operand_ii                : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL pc_rel_jmp_addr           : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL pcb_access                : STD_LOGIC;
   SIGNAL pcb_end                   : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL pcb_start                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL pdas_end                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL pdas_start                : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL pias_end                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL pias_start                : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL pop                       : STD_LOGIC;
   SIGNAL popped_addr               : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL protect_mode_q            : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL psr                       : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL push                      : STD_LOGIC;
   SIGNAL q                         : STD_LOGIC;
   SIGNAL q1                        : STD_LOGIC;
   SIGNAL q10                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL q13                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL q14                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL q2                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL q3                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL q5                        : STD_LOGIC;
   SIGNAL q6                        : STD_LOGIC;
   SIGNAL q7                        : STD_LOGIC;
   SIGNAL q9                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL read_access               : STD_LOGIC;
   SIGNAL reg_indx                  : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL reg_jmp_fwd               : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL reg_lock                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL reg_op_i                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL reg_op_ii                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL result_2                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL result_3                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL result_4                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL result_q                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL result_qq                 : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL result_qqq                : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL rf_we_data                : STD_LOGIC;
   SIGNAL rf_we_spsr                : STD_LOGIC;
   SIGNAL rf_wr_reg                 : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL rf_wr_rs                  : STD_LOGIC;
   SIGNAL rs_to_read                : STD_LOGIC;
   SIGNAL rst_n_s                   : STD_LOGIC;
   SIGNAL saved_psr                 : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL second_operand            : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL sel_buff_entry            : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL sel_data3p                : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL sel_data4p                : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL sel_data5p                : STD_LOGIC;
   SIGNAL sel_data_from_cop         : STD_LOGIC;
   SIGNAL sel_data_to_cop           : STD_LOGIC;
   SIGNAL sel_op_i                  : STD_LOGIC;
   SIGNAL sel_op_ii                 : STD_LOGIC;
   SIGNAL sel_pc                    : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL sel_psr                   : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL sreg_indx1                : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL sreg_indx2                : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL start_core_pipe           : STD_LOGIC;
   SIGNAL start_dmem_access         : STD_LOGIC;
   SIGNAL start_fpu_add             : STD_LOGIC;
   SIGNAL start_fpu_div             : STD_LOGIC;
   SIGNAL start_fpu_mul             : STD_LOGIC;
   SIGNAL start_fpu_scycle          : STD_LOGIC;
   SIGNAL start_fpu_sqrt            : STD_LOGIC;
   SIGNAL start_fpu_tcycle          : STD_LOGIC;
   SIGNAL sys_addr_q                : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL tmr0_cnt_in               : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL tmr0_cnt_out              : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL tmr0_int                  : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL tmr0_max_cnt              : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL tmr0_wdog_rst_n           : STD_LOGIC;
   SIGNAL tmr1_cnt_in               : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL tmr1_cnt_out              : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL tmr1_int                  : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL tmr1_max_cnt              : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL tmr1_wdog_rst_n           : STD_LOGIC;
   SIGNAL tmr_conf                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL tos_addr                  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL tos_cr0                   : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL tos_psr                   : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL wait_states               : STD_LOGIC_VECTOR(11 DOWNTO 0);
   SIGNAL wr_en_psr                 : STD_LOGIC;
   SIGNAL write_access              : STD_LOGIC;
   SIGNAL write_pc                  : STD_LOGIC;
   SIGNAL zeros                     : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL znc_in                    : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL znc_o                     : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL znc_q                     : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ldra_fwd                  : STD_LOGIC;

   -- Component Declarations
   COMPONENT adder_32bit
      PORT (
         cin                          : IN  STD_LOGIC;
         opa                          : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         opb                          : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         cout                         : OUT STD_LOGIC;
         sum                          : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT cop_if_integrale
      PORT (
         clk                          : IN  STD_LOGIC;
         cop_flags                    : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         enable_decode                : IN  STD_LOGIC;
         enable_exe                   : IN  STD_LOGIC;
         fcop_1_clk_result            : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fcop_2_clk_result            : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fcop_add_result              : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fcop_addsub_completed        : IN  STD_LOGIC;
         fcop_dest_reg_1_clk_instr    : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fcop_dest_reg_2_clk_instr    : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fcop_dest_reg_addsub         : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fcop_dest_reg_div            : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fcop_dest_reg_mul            : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fcop_dest_reg_sqrt           : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fcop_div_completed           : IN  STD_LOGIC;
         fcop_div_result              : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fcop_mul_completed           : IN  STD_LOGIC;
         fcop_mul_result              : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fcop_one_clk_instr_completed : IN  STD_LOGIC;
         fcop_sqrt_completed          : IN  STD_LOGIC;
         fcop_sqrt_result             : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fcop_two_clk_instr_completed : IN  STD_LOGIC;
         first_operand                : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         flush_decode                 : IN  STD_LOGIC;
         flush_exe                    : IN  STD_LOGIC;
         fpu_comparison               : IN  STD_LOGIC;
         fpu_drg_indx_s               : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_opc                      : IN  STD_LOGIC_VECTOR (5 DOWNTO 0);
         rst_n                        : IN  STD_LOGIC;
         second_operand               : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         cop_flgs_we_n                : OUT STD_LOGIC;
         fcop_opc                     : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
         fcop_oprnd1                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         fcop_oprnd2                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_add_sub_complete         : OUT STD_LOGIC;
         fpu_add_sub_dreg             : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_add_sub_result           : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_div_complete             : OUT STD_LOGIC;
         fpu_div_dreg                 : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_div_result               : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_drg_indx                 : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_flags                    : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         fpu_mul_complete             : OUT STD_LOGIC;
         fpu_mul_dreg                 : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_mul_result               : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_single_cycle_complete    : OUT STD_LOGIC;
         fpu_single_cycle_dreg        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_single_cycle_result      : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_sqrt_complete            : OUT STD_LOGIC;
         fpu_sqrt_dreg                : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_sqrt_result              : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_two_cycle_complete       : OUT STD_LOGIC;
         fpu_two_cycle_dreg           : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_two_cycle_result         : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_addr_chk_align
      PORT (
         addr                         : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         il                           : IN  STD_LOGIC;  -- processor mode (16/32 bits)
         miss_aligned_addr            : OUT STD_LOGIC;
         check_enable                 : IN  STD_LOGIC
         );
   END COMPONENT;
   COMPONENT core_addr_chk_ovfl
      PORT (
         carry                        : IN  STD_LOGIC;
         base_msb                     : IN  STD_LOGIC;
         offset_msb                   : IN  STD_LOGIC;
         addr_msb                     : IN  STD_LOGIC;
         addr_ovfl                    : OUT STD_LOGIC;
         chk                          : IN  STD_LOGIC
         );
   END COMPONENT;
   COMPONENT core_addr_chk_pcb
      PORT (
         pcb_start                    : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);  -- -- Comes from PCB base register
         ccb_access                   : OUT STD_LOGIC;  -- -- Indicates an access TO PCB
         accessed_addr                : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);  -- -- Address TO be compared
         reg_indx                     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
         pcb_end                      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         pcb_access                   : OUT STD_LOGIC;
         ccb_base                     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_addr_chk_usr
      PORT (
         enable_check                 : IN  STD_LOGIC;  -- enables checking
         start_addr                   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);  -- -- Begining of the protected address space
         end_addr                     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);  -- -- End of the protected...
         accessed_addr                : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);  -- -- Address to be checked
         addr_viol                    : OUT STD_LOGIC;
         protect_mode                 : IN  STD_LOGIC
         );
   END COMPONENT;
   COMPONENT core_alu
      PORT (
         chk_of                       : IN  STD_LOGIC;
         clk                          : IN  STD_LOGIC;
         enable_i                     : IN  STD_LOGIC;
         enable_ii                    : IN  STD_LOGIC;
         enable_iii                   : IN  STD_LOGIC;
         flush                        : IN  STD_LOGIC;
         operand_i                    : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         operand_ii                   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         operation                    : IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
         rst_x                        : IN  STD_LOGIC;
         of_q                         : OUT STD_LOGIC;
         result_1                     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         result_2                     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         result_3                     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         result_4                     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         uf_q                         : OUT STD_LOGIC;
         znc_q                        : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_ccb
      GENERIC (
         exceptions_amnt              :     INTEGER
         );
      PORT (
         reg_indx                     : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         user_data_in                 : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         exception_cs_in              : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         exception_pc_in              : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         clk                          : IN  STD_LOGIC;
         rst_x                        : IN  STD_LOGIC;
         int_base                     : OUT array_12x32_stdl;
         int_mask_q                   : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
         dmem_bound_lo_q              : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         dmem_bound_hi_q              : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         imem_bound_lo_q              : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         imem_bound_hi_q              : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         write_access                 : IN  STD_LOGIC;
         pcb_start_q                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         exception                    : IN  STD_LOGIC;
         data_out                     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         sys_addr_q                   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         exception_addr_q             : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         exception_psr                : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         int_mode_il_q                : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
         int_mode_um_q                : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
         int_pend                     : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);
         int_serv                     : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);
         wait_states                  : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
         pcb_end_q                    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         creg_indx_i_q                : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
         enable                       : IN  STD_LOGIC;
         ext_int_pri                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         cop_int_pri                  : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
         flush                        : IN  STD_LOGIC;
         protect_mode_q               : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         tmr0_cnt_in                  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         tmr1_cnt_in                  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         tmr0_cnt_out                 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         tmr1_cnt_out                 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         tmr0_max_cnt                 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         tmr1_max_cnt                 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         tmr_conf                     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         ccb_access                   : IN  STD_LOGIC;
         tos_addr                     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         tos_psr                      : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         tos_cr0                      : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         new_tos_addr                 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         new_tos_psr                  : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
         new_tos_cr0                  : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         addr_mask                    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         ccb_base                     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_status                   : IN  STD_LOGIC_VECTOR (exceptions_amount-1 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_ccu_debug
      PORT (
         alu_exception_of             : IN  STD_LOGIC;
         alu_exception_uf             : IN  STD_LOGIC;
         bus_req                      : IN  STD_LOGIC;
         ccb_access                   : IN  STD_LOGIC;
         clk                          : IN  STD_LOGIC;
         creg_indx_i_q                : IN  STD_LOGIC_VECTOR (19 DOWNTO 0);
         current_psr                  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         d_cache_miss                 : IN  STD_LOGIC;
         data_addr_exception_of       : IN  STD_LOGIC;
         data_addr_exception_usr      : IN  STD_LOGIC;
         decode_exception             : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         execute                      : IN  STD_LOGIC;
         i_cache_miss                 : IN  STD_LOGIC;
         illegal_jump                 : IN  STD_LOGIC;
         inst_addr_violation          : IN  STD_LOGIC;
         instruction                  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         interrupt_req                : IN  STD_LOGIC;
         jump_addr_overflow           : IN  STD_ULOGIC;
         miss_aligned_iaddr           : IN  STD_LOGIC;
         miss_aligned_jump            : IN  STD_LOGIC;
         reg_lock                     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         rs_to_rd                     : IN  STD_LOGIC;
         rst_n                        : IN  STD_LOGIC;
         stall                        : IN  STD_LOGIC;
         stall_n                      : IN  STD_LOGIC;
         wait_cycles                  : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);
         access_complete              : OUT STD_LOGIC;
         ack                          : OUT STD_LOGIC;
         alu_of_check_en              : OUT STD_LOGIC;
         alu_op_code                  : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
         alu_op_i_fwd                 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         alu_op_ii_fwd                : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         bus_ack                      : OUT STD_LOGIC;
         ccb_we_exc                   : OUT STD_LOGIC;
         check_data_addr_ovfl         : OUT STD_LOGIC;
         check_data_addr_usr          : OUT STD_LOGIC;
         cop_if_cop_indx              : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         cop_if_rd_cop                : OUT STD_LOGIC;
         cop_if_reg_indx              : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         cop_if_wr_cop                : OUT STD_LOGIC;
         cpu_writes_rf                : OUT STD_LOGIC;
         cr_we                        : OUT STD_LOGIC;
         cr_we_all                    : OUT STD_LOGIC;
         cr_wr_reg                    : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         d_cache_data_fwd             : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         d_cache_if_use_prev_data     : OUT STD_LOGIC;
         done                         : OUT STD_LOGIC;
         en_stage                     : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
         exception_cause              : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
         float                        : OUT STD_LOGIC;
         flush                        : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
         fpu_comparison               : OUT STD_LOGIC;
         mdata_fwd_op_i               : OUT STD_LOGIC;
         mdata_fwd_op_ii              : OUT STD_LOGIC;
         mdata_fwd_st                 : OUT STD_LOGIC;
         pop                          : OUT STD_LOGIC;
         push                         : OUT STD_LOGIC;
         read_access                  : OUT STD_LOGIC;
         reg_jmp_fwd                  : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         rf_we_data                   : OUT STD_LOGIC;
         rf_we_spsr                   : OUT STD_LOGIC;
         rf_wr_reg                    : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         rf_wr_rs                     : OUT STD_LOGIC;
         sel_buff_entry               : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         sel_data3p                   : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         sel_data4p                   : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         sel_data5p                   : OUT STD_LOGIC;
         sel_data_from_cop            : OUT STD_LOGIC;
         sel_data_to_cop              : OUT STD_LOGIC;
         sel_pc                       : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         sel_psr                      : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         start_dmem_access            : OUT STD_LOGIC;
         wr_en_psr                    : OUT STD_LOGIC;
         write_access                 : OUT STD_LOGIC;
         ldra_fwd                     : OUT STD_LOGIC;
         write_pc                     : OUT STD_LOGIC
         );
   END COMPONENT;
   COMPONENT core_ccu
      PORT(
         alu_exception_of             : IN  STD_LOGIC;
         alu_exception_uf             : IN  STD_LOGIC;
         bus_req                      : IN  STD_LOGIC;
         ccb_access                   : IN  STD_LOGIC;
         clk                          : IN  STD_LOGIC;
         creg_indx_i_q                : IN  STD_LOGIC_VECTOR (19 DOWNTO 0);
         current_psr                  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         d_cache_miss                 : IN  STD_LOGIC;
         data_addr_exception_of       : IN  STD_LOGIC;
         data_addr_exception_usr      : IN  STD_LOGIC;
         decode_exception             : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         execute                      : IN  STD_LOGIC;
         i_cache_miss                 : IN  STD_LOGIC;
         illegal_jump                 : IN  STD_LOGIC;
         inst_addr_violation          : IN  STD_LOGIC;
         instruction                  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         interrupt_req                : IN  STD_LOGIC;
         jump_addr_overflow           : IN  STD_ULOGIC;
         miss_aligned_iaddr           : IN  STD_LOGIC;
         miss_aligned_jump            : IN  STD_LOGIC;
         reg_lock                     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         rs_to_rd                     : IN  STD_LOGIC;
         rst_n                        : IN  STD_LOGIC;
         stall                        : IN  STD_LOGIC;
         stall_n                      : IN  STD_LOGIC;
         wait_cycles                  : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);
         access_complete              : OUT STD_LOGIC;
         ack                          : OUT STD_LOGIC;
         alu_of_check_en              : OUT STD_LOGIC;
         alu_op_code                  : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
         alu_op_i_fwd                 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         alu_op_ii_fwd                : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         bus_ack                      : OUT STD_LOGIC;
         ccb_we_exc                   : OUT STD_LOGIC;
         check_data_addr_ovfl         : OUT STD_LOGIC;
         check_data_addr_usr          : OUT STD_LOGIC;
         cop_if_cop_indx              : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         cop_if_rd_cop                : OUT STD_LOGIC;
         cop_if_reg_indx              : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         cop_if_wr_cop                : OUT STD_LOGIC;
         cpu_writes_rf                : OUT STD_LOGIC;
         cr_we                        : OUT STD_LOGIC;
         cr_we_all                    : OUT STD_LOGIC;
         cr_wr_reg                    : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         d_cache_data_fwd             : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         d_cache_if_use_prev_data     : OUT STD_LOGIC;
         done                         : OUT STD_LOGIC;
         en_stage                     : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
         exception_cause              : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
         float                        : OUT STD_LOGIC;
         flush                        : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
         fpu_comparison               : OUT STD_LOGIC;
         mdata_fwd_op_i               : OUT STD_LOGIC;
         mdata_fwd_op_ii              : OUT STD_LOGIC;
         mdata_fwd_st                 : OUT STD_LOGIC;
         pop                          : OUT STD_LOGIC;
         push                         : OUT STD_LOGIC;
         read_access                  : OUT STD_LOGIC;
         reg_jmp_fwd                  : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         rf_we_data                   : OUT STD_LOGIC;
         rf_we_spsr                   : OUT STD_LOGIC;
         rf_wr_reg                    : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         rf_wr_rs                     : OUT STD_LOGIC;
         sel_buff_entry               : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         sel_data3p                   : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         sel_data4p                   : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         sel_data5p                   : OUT STD_LOGIC;
         sel_data_from_cop            : OUT STD_LOGIC;
         sel_data_to_cop              : OUT STD_LOGIC;
         sel_pc                       : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         sel_psr                      : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         start_dmem_access            : OUT STD_LOGIC;
         wr_en_psr                    : OUT STD_LOGIC;
         write_access                 : OUT STD_LOGIC;
         ldra_fwd                     : OUT STD_LOGIC;
         write_pc                     : OUT STD_LOGIC
         );

   END COMPONENT;



   COMPONENT core_cntxt_buff
      PORT (
         clk                       : IN  STD_LOGIC;
         enable                    : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
         rst_x                     : IN  STD_LOGIC;
         pc_in                     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         sel_entry                 : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
         psr_in                    : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         psr                       : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
         addr                      : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_cntxt_stack
      PORT (
         rst_x                     : IN  STD_LOGIC;
         push                      : IN  STD_LOGIC;
         pop                       : IN  STD_LOGIC;
         clk                       : IN  STD_LOGIC;
         psr_in                    : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         pc_in                     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         psr_o                     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
         pc_out                    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         cr0_in                    : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         cr0_out                   : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         flush                     : IN  STD_LOGIC;
         new_tos_addr              : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         new_tos_psr               : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         new_tos_cr0               : IN  STD_LOGIC_VECTOR (2 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_cond_chk
      PORT (
         cond                      : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         cex                       : IN  STD_LOGIC;  -- enables condition check
         znc                       : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         execute                   : OUT STD_LOGIC;
         opcode                    : IN  STD_LOGIC_VECTOR (5 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_cop_if
      PORT (
         clk                       : IN  STD_LOGIC;
         cop_indx                  : IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
         data_in                   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         enable                    : IN  STD_LOGIC;
         flush                     : IN  STD_LOGIC;
         rd_cop                    : IN  STD_LOGIC;
         reg_indx                  : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         rst_x                     : IN  STD_LOGIC;
         wr_cop                    : IN  STD_LOGIC;
         cop_id                    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
         cop_rd                    : OUT STD_LOGIC;
         cop_rgi                   : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         cop_wr                    : OUT STD_LOGIC;
         data_out                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         cop_data                  : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         cop_q                     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_cr
      PORT (
         rst_x                     : IN  STD_LOGIC;
         creg_wr                   : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         wrcr                      : IN  STD_LOGIC;
         clk                       : IN  STD_LOGIC;
         creg_rd                   : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         wr_all                    : IN  STD_LOGIC;
         znc_in                    : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         all_in                    : IN  STD_LOGIC_VECTOR (23 DOWNTO 0);
         znc_o                     : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         flush                     : IN  STD_LOGIC;
         cr0_out                   : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         all_out                   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_dbif
      PORT (
         reboot                    : IN  STD_LOGIC;
         restart                   : IN  STD_LOGIC;
         access_complete           : IN  STD_LOGIC;
         addr_in                   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         addr_mask                 : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         ccb_access                : IN  STD_LOGIC;
         clk                       : IN  STD_LOGIC;
         data_in                   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         data_internal             : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         float_bus                 : IN  STD_LOGIC;
         gated_reset_n             : IN  STD_LOGIC;
         pcb_access                : IN  STD_LOGIC;
         read_access               : IN  STD_LOGIC;
         rst_n                     : IN  STD_LOGIC;
         start_access              : IN  STD_LOGIC;
         use_prev_data             : IN  STD_LOGIC;
         write_access              : IN  STD_LOGIC;
         boot_address              : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         mem_data_q                : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         read_mem_q                : OUT STD_LOGIC;
         read_pcb_q                : OUT STD_LOGIC;
         write_mem_q               : OUT STD_LOGIC;
         write_pcb_q               : OUT STD_LOGIC;
         d_addr                    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         data_out                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_decode
      GENERIC (
         FPU_FU                    :     BOOLEAN);
      PORT (
         rst_x                     : IN  STD_LOGIC;
         i_word                    : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         current_psr               : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         clk                       : IN  STD_LOGIC;
         new_psr                   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
         extended_imm              : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         exception_q               : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         en                        : IN  STD_LOGIC;
         sel_op_i                  : OUT STD_LOGIC;
         sel_op_ii                 : OUT STD_LOGIC;
         flush                     : IN  STD_LOGIC;
         rs_to_read                : OUT STD_LOGIC;
         sreg_indx1                : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         sreg_indx2                : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         jmp_offset                : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         creg_indx                 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         opc                       : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
         cexbit                    : OUT STD_LOGIC;
         condition                 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
         fpu_opc                   : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
         trgt_indx                 : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
         start_fpu_mul             : OUT STD_LOGIC;
         start_fpu_add             : OUT STD_LOGIC;
         start_fpu_div             : OUT STD_LOGIC;
         start_fpu_sqrt            : OUT STD_LOGIC;
         start_fpu_scycle          : OUT STD_LOGIC;
         start_fpu_tcycle          : OUT STD_LOGIC;
         start_core_pipe           : OUT STD_LOGIC;
         cpu_writes_rf             : IN  STD_LOGIC
         );
   END COMPONENT;
   COMPONENT core_iaddr_chk
      PORT (
         addr_ovfl                 : IN  STD_LOGIC;
         addr_viol                 : IN  STD_LOGIC;
         clk                       : IN  STD_LOGIC;
         en_stage                  : IN  STD_LOGIC_VECTOR (5 DOWNTO 0);
         flush                     : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
         miss_aligned_addr         : IN  STD_LOGIC;
         rst_x                     : IN  STD_LOGIC;
         sel_pc                    : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);
         write_pc                  : IN  STD_LOGIC;
         illegal_jump_q            : OUT STD_LOGIC;
         inst_addr_violation_q     : OUT STD_LOGIC;
         jump_addr_overflow_q      : OUT STD_LOGIC;
         miss_aligned_iaddr_q      : OUT STD_LOGIC;
         miss_aligned_jump_q       : OUT STD_LOGIC
         );
   END COMPONENT;
   COMPONENT core_inth
      PORT (
         ack                       : IN  STD_LOGIC;  -- CCU acknoledges a request just before service
         clk                       : IN  STD_LOGIC;
         cop_exc                   : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);  -- requests from coprocessors
         cop_int_pri               : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);  -- -- priorities for coprocessor interrupts
         done                      : IN  STD_LOGIC;  -- reti causes done TO go high
         ext_handler               : IN  STD_LOGIC;  -- high if external handler used
         ext_int_pri               : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);  -- -- priorities for external interrupts
         ext_interrupt             : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);  -- -- active high signals from external sources
         int_base                  : IN  array_12x32_stdl;  -- -- base addresses of a handler routines
         int_mode_il               : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);  -- --  what IL mode to switch into
         int_mode_um               : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);  -- --  what UM mode TO switch into
         mask                      : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);  -- -- Individual mask bits for each source.
         offset                    : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);  -- this is scaled and added to base
         rst_x                     : IN  STD_LOGIC;
         tmr_inta                  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);  -- -- timer interrupt a
         tmr_intb                  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);  -- -- timer interrupt b
         int_ack                   : OUT STD_LOGIC;
         int_addr                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);  -- -- entry address of an ISR
         int_done                  : OUT STD_LOGIC;
         int_pend                  : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
         int_psr                   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
         int_serv                  : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
         req_q                     : OUT STD_LOGIC  -- request TO CCU for service
         );
   END COMPONENT;
   COMPONENT core_reset_logic
      PORT (
         clk                       : IN  STD_LOGIC;
         rst_n                     : IN  STD_LOGIC;
         gated_reset_n             : OUT STD_LOGIC;
         ba_ext                    : IN  STD_LOGIC;
         wdog0_rst_n               : IN  STD_LOGIC;
         wdog1_rst_n               : IN  STD_LOGIC;
         rst_n_s                   : OUT STD_LOGIC;
         reset_n_out               : OUT STD_LOGIC
         );
   END COMPONENT;
   COMPONENT core_rf
      PORT (
         clk                       : IN  STD_LOGIC;
         rst_x                     : IN  STD_LOGIC;
         rs_to_read                : IN  STD_LOGIC;  -- -- Which register set TO read from
         rs_to_write               : IN  STD_LOGIC;  -- -- Which register set TO write to
         wr_en_spsr                : IN  STD_LOGIC;
         wr_en_data                : IN  STD_LOGIC;
         reg_indx1                 : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);  -- -- index to register operand1
         reg_indx2                 : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);  -- -- index to register operand2
         reg_indx3                 : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);  -- -- index to result register
         psr_data_in               : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
         core_wb_data              : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);  -- -- Data to be written to result register if enabled
         psr_o_q                   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);  -- -- Processor status flag output
         spsr_o_q                  : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);  -- -- Output of saved status flags
         data_out1                 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         data_out2                 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         wr_en_psr                 : IN  STD_LOGIC;
         reg_lock                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_add_sub_complete      : IN  STD_LOGIC;
         fpu_div_complete          : IN  STD_LOGIC;
         fpu_mul_complete          : IN  STD_LOGIC;
         fpu_single_cycle_complete : IN  STD_LOGIC;
         fpu_two_cycle_complete    : IN  STD_LOGIC;
         fpu_sqrt_complete         : IN  STD_LOGIC;
         fpu_single_cycle_result   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_two_cycle_result      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_add_sub_result        : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_div_result            : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_mul_result            : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_sqrt_result           : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         fpu_single_cycle_dreg     : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_two_cycle_dreg        : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_add_sub_dreg          : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_div_dreg              : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_mul_dreg              : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         fpu_sqrt_dreg             : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
         start_fpu_mul             : IN  STD_LOGIC;
         start_fpu_add             : IN  STD_LOGIC;
         start_fpu_div             : IN  STD_LOGIC;
         start_fpu_sqrt            : IN  STD_LOGIC;
         start_fpu_scycle          : IN  STD_LOGIC;
         start_fpu_tcycle          : IN  STD_LOGIC;
         start_core_pipe           : IN  STD_LOGIC;
         target_reg                : IN  STD_LOGIC_VECTOR (4 DOWNTO 0)
         );
   END COMPONENT;
   COMPONENT core_tmr
      PORT (
         clk                       : IN  STD_LOGIC;
         rst_x                     : IN  STD_LOGIC;
         tmr_cnt_in                : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         tmr_conf                  : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
         tmr_max_cnt               : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         tmr_cnt_out               : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         tmr_int                   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
         wdog_rst_x                : OUT STD_LOGIC
         );
   END COMPONENT;
   COMPONENT incrementer_32bit_a
      PORT (
         data_in                   : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         inc_amount                : IN  STD_LOGIC;  -- 0 : increment by two, 1: incr by four.
         data_out                  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
         );
   END COMPONENT;
-- COMPONENT r32b_we_sset_f
-- PORT (
-- clk : IN STD_LOGIC;
-- d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
-- rst_n : IN STD_LOGIC;
-- sset : IN STD_LOGIC;
-- we : IN STD_LOGIC;
-- q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
-- );
-- END COMPONENT;


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   i_addr <= i_addr_signal;

   -- HDL Embedded Text Block 2 eb2
   cop_exc(0) <= cop0_exc;
   cop_exc(1) <= cop1_exc;
   cop_exc(2) <= cop2_exc;
   cop_exc(3) <= cop3_exc;

   -- HDL Embedded Text Block 4 eb4
   --check_enable <= '1' when current_psr(3) = dc_mode else '0';
   check_enable <= '1';
   il           <= current_psr(3);

   -- HDL Embedded Text Block 5 eb5
   exc_psr <= EXCEPTION_PSR;
   one     <= '1';
   zeros   <= (OTHERS => '0');

   -- Instance port mappings.
   REL_JMP_ADD : adder_32bit
      PORT MAP (
         cin                          => zeros(0),
         opa                          => jump_offset,
         opb                          => i_addr_signal,
         cout                         => carry_out,
         sum                          => pc_rel_jmp_addr
         );
   I2          : cop_if_integrale
      PORT MAP (
         clk                          => clk,
         cop_flags                    => cop_flags,
         enable_decode                => en_stage(1),
         enable_exe                   => en_stage(2),
         fcop_1_clk_result            => fcop_1_clk_result,
         fcop_2_clk_result            => fcop_2_clk_result,
         fcop_add_result              => fcop_add_result,
         fcop_addsub_completed        => fcop_addsub_completed,
         fcop_dest_reg_1_clk_instr    => fcop_dest_reg_1_clk_instr,
         fcop_dest_reg_2_clk_instr    => fcop_dest_reg_2_clk_instr,
         fcop_dest_reg_addsub         => fcop_dest_reg_addsub,
         fcop_dest_reg_div            => fcop_dest_reg_div,
         fcop_dest_reg_mul            => fcop_dest_reg_mul,
         fcop_dest_reg_sqrt           => fcop_dest_reg_sqrt,
         fcop_div_completed           => fcop_div_completed,
         fcop_div_result              => fcop_div_result,
         fcop_mul_completed           => fcop_mul_completed,
         fcop_mul_result              => fcop_mul_result,
         fcop_one_clk_instr_completed => fcop_one_clk_instr_completed,
         fcop_sqrt_completed          => fcop_sqrt_completed,
         fcop_sqrt_result             => fcop_sqrt_result,
         fcop_two_clk_instr_completed => fcop_two_clk_instr_completed,
         first_operand                => operand_i,
         flush_decode                 => flush(1),
         flush_exe                    => flush(2),
         fpu_comparison               => fpu_comparison,
         fpu_drg_indx_s               => fpu_drg_indx_s,
         fpu_opc                      => fpu_opc,
         rst_n                        => rst_n_s,
         second_operand               => operand_ii,
         cop_flgs_we_n                => cop_flgs_we_n,
         fcop_opc                     => fcop_opc,
         fcop_oprnd1                  => fcop_oprnd1,
         fcop_oprnd2                  => fcop_oprnd2,
         fpu_add_sub_complete         => fpu_add_sub_complete,
         fpu_add_sub_dreg             => fpu_add_sub_dreg,
         fpu_add_sub_result           => fpu_add_sub_result,
         fpu_div_complete             => fpu_div_complete,
         fpu_div_dreg                 => fpu_div_dreg,
         fpu_div_result               => fpu_div_result,
         fpu_drg_indx                 => fpu_drg_indx,
         fpu_flags                    => fpu_flags,
         fpu_mul_complete             => fpu_mul_complete,
         fpu_mul_dreg                 => fpu_mul_dreg,
         fpu_mul_result               => fpu_mul_result,
         fpu_single_cycle_complete    => fpu_single_cycle_complete,
         fpu_single_cycle_dreg        => fpu_single_cycle_dreg,
         fpu_single_cycle_result      => fpu_single_cycle_result,
         fpu_sqrt_complete            => fpu_sqrt_complete,
         fpu_sqrt_dreg                => fpu_sqrt_dreg,
         fpu_sqrt_result              => fpu_sqrt_result,
         fpu_two_cycle_complete       => fpu_two_cycle_complete,
         fpu_two_cycle_dreg           => fpu_two_cycle_dreg,
         fpu_two_cycle_result         => fpu_two_cycle_result
         );
   I43         : core_addr_chk_align
      PORT MAP (
         addr                         => i_addr_signal,
         il                           => il,
         miss_aligned_addr            => miss_aligned_addr,
         check_enable                 => check_enable
         );
   I54         : core_addr_chk_ovfl
      PORT MAP (
         carry                        => q5,
         base_msb                     => q7,
         offset_msb                   => q6,
         addr_msb                     => i_addr_signal(31),
         addr_ovfl                    => addr_ovfl,
         chk                          => one
         );
   I10         : core_addr_chk_ovfl
      PORT MAP (
         carry                        => znc_q(0),
         base_msb                     => q1,
         offset_msb                   => q,
         addr_msb                     => result_q(31),
         addr_ovfl                    => data_addr_exception_of,
         chk                          => check_data_addr_ovfl
         );
   I24         : core_addr_chk_pcb
      PORT MAP (
         pcb_start                    => pcb_start,
         ccb_access                   => ccb_access,
         accessed_addr                => result_q,
         reg_indx                     => reg_indx,
         pcb_end                      => pcb_end,
         pcb_access                   => pcb_access,
         ccb_base                     => ccb_base
         );
   I42         : core_addr_chk_usr
      PORT MAP (
         enable_check                 => current_psr(0),
         start_addr                   => pias_start,
         end_addr                     => pias_end,
         accessed_addr                => i_addr_signal,
         addr_viol                    => addr_viol,
         protect_mode                 => protect_mode_q(0)
         );
   I7          : core_addr_chk_usr
      PORT MAP (
         enable_check                 => check_data_addr_usr,
         start_addr                   => pdas_start,
         end_addr                     => pdas_end,
         accessed_addr                => result_q,
         addr_viol                    => data_addr_exception_usr,
         protect_mode                 => protect_mode_q(1)
         );
   COFFEE_ALU  : core_alu
      PORT MAP (
         chk_of                       => alu_of_check_en,
         clk                          => clk,
         enable_i                     => en_stage(2),
         enable_ii                    => en_stage(3),
         enable_iii                   => en_stage(4),
         flush                        => flush(2),
         operand_i                    => operand_i,
         operand_ii                   => operand_ii,
         operation                    => alu_op_code,
         rst_x                        => rst_n_s,
         of_q                         => alu_exception_of,
         result_1                     => data_i,
         result_2                     => result_2,
         result_3                     => result_3,
         result_4                     => result_4,
         uf_q                         => alu_exception_uf,
         znc_q                        => znc_q
         );
   I28         : core_ccb
      GENERIC MAP (
         exceptions_amnt              => exceptions_amount
         )
      PORT MAP (
         reg_indx                     => reg_indx,
         user_data_in                 => data_to_mem,
         exception_cs_in              => exception_cause(7 DOWNTO 0),
         exception_pc_in              => buff_addr,
         clk                          => clk,
         rst_x                        => rst_n_s,
         int_base                     => base_addr,
         int_mask_q                   => int_mask,
         dmem_bound_lo_q              => pdas_start,
         dmem_bound_hi_q              => pdas_end,
         imem_bound_lo_q              => pias_start,
         imem_bound_hi_q              => pias_end,
         write_access                 => write_access,
         pcb_start_q                  => pcb_start,
         exception                    => ccb_we_exc,
         data_out                     => ccb_data,
         sys_addr_q                   => sys_addr_q,
         exception_addr_q             => exception_addr_q,
         exception_psr                => psr,
         int_mode_il_q                => int_mode_il,
         int_mode_um_q                => int_mode_um,
         int_pend                     => int_pend,
         int_serv                     => int_serv,
         wait_states                  => wait_states,
         pcb_end_q                    => pcb_end,
         creg_indx_i_q                => creg_indx_i_q,
         enable                       => en_stage(3),
         ext_int_pri                  => ext_int_pri,
         cop_int_pri                  => cop_int_pri,
         flush                        => flush(3),
         protect_mode_q               => protect_mode_q,
         tmr0_cnt_in                  => tmr0_cnt_in,
         tmr1_cnt_in                  => tmr1_cnt_in,
         tmr0_cnt_out                 => tmr0_cnt_out,
         tmr1_cnt_out                 => tmr1_cnt_out,
         tmr0_max_cnt                 => tmr0_max_cnt,
         tmr1_max_cnt                 => tmr1_max_cnt,
         tmr_conf                     => tmr_conf,
         ccb_access                   => ccb_access,
         tos_addr                     => tos_addr,
         tos_psr                      => tos_psr,
         tos_cr0                      => tos_cr0,
         new_tos_addr                 => new_tos_addr,
         new_tos_psr                  => new_tos_psr,
         new_tos_cr0                  => new_tos_cr0,
         addr_mask                    => addr_mask,
         ccb_base                     => ccb_base,
         fpu_status                   => fcop_status
         );

   CTRL_UNIT_DEBUG_GENERATION : IF (SYNTHESIZABLE = FALSE) GENERATE
      COFFEE_CTRU             : core_ccu_debug
         PORT MAP (
            alu_exception_of         => alu_exception_of,
            alu_exception_uf         => alu_exception_uf,
            bus_req                  => bus_req,
            ccb_access               => ccb_access,
            clk                      => clk,
            creg_indx_i_q            => creg_indx_i_q,
            current_psr              => current_psr,
            d_cache_miss             => d_cache_miss,
            data_addr_exception_of   => data_addr_exception_of,
            data_addr_exception_usr  => data_addr_exception_usr,
            decode_exception         => decode_exception,
            execute                  => execute,
            i_cache_miss             => i_cache_miss,
            illegal_jump             => illegal_jump_q,
            inst_addr_violation      => inst_addr_violation_q,
            instruction              => instruction,
            interrupt_req            => interrupt_req,
            jump_addr_overflow       => jump_addr_overflow_q,
            miss_aligned_iaddr       => miss_aligned_iaddr_q,
            miss_aligned_jump        => miss_aligned_jump_q,
            reg_lock                 => reg_lock,
            rs_to_rd                 => rs_to_read,
            rst_n                    => rst_n_s,
            stall                    => stall,
            stall_n                  => stall_n,
            wait_cycles              => wait_states,
            access_complete          => access_complete,
            ack                      => ack,
            alu_of_check_en          => alu_of_check_en,
            alu_op_code              => alu_op_code,
            alu_op_i_fwd             => alu_op_i_fwd,
            alu_op_ii_fwd            => alu_op_ii_fwd,
            bus_ack                  => bus_ack,
            ccb_we_exc               => ccb_we_exc,
            check_data_addr_ovfl     => check_data_addr_ovfl,
            check_data_addr_usr      => check_data_addr_usr,
            cop_if_cop_indx          => cop_if_cop_indx,
            cop_if_rd_cop            => cop_if_rd_cop,
            cop_if_reg_indx          => cop_if_reg_indx,
            cop_if_wr_cop            => cop_if_wr_cop,
            cpu_writes_rf            => cpu_writes_rf,
            cr_we                    => cr_we,
            cr_we_all                => cr_we_all,
            cr_wr_reg                => cr_wr_reg,
            d_cache_data_fwd         => d_cache_data_fwd,
            d_cache_if_use_prev_data => d_cache_if_use_prev_data,
            done                     => done,
            en_stage                 => en_stage,
            exception_cause          => exception_cause,
            float                    => float,
            flush                    => flush,
            fpu_comparison           => fpu_comparison,
            mdata_fwd_op_i           => mdata_fwd_op_i,
            mdata_fwd_op_ii          => mdata_fwd_op_ii,
            mdata_fwd_st             => mdata_fwd_st,
            pop                      => pop,
            push                     => push,
            read_access              => read_access,
            reg_jmp_fwd              => reg_jmp_fwd,
            rf_we_data               => rf_we_data,
            rf_we_spsr               => rf_we_spsr,
            rf_wr_reg                => rf_wr_reg,
            rf_wr_rs                 => rf_wr_rs,
            sel_buff_entry           => sel_buff_entry,
            sel_data3p               => sel_data3p,
            sel_data4p               => sel_data4p,
            sel_data5p               => sel_data5p,
            sel_data_from_cop        => sel_data_from_cop,
            sel_data_to_cop          => sel_data_to_cop,
            sel_pc                   => sel_pc,
            sel_psr                  => sel_psr,
            start_dmem_access        => start_dmem_access,
            wr_en_psr                => wr_en_psr,
            write_access             => write_access,
            ldra_fwd                 => ldra_fwd,
            write_pc                 => write_pc
            );

   END GENERATE CTRL_UNIT_DEBUG_GENERATION;

   CTRL_UNIT_SYNTH_GENERATION : IF (SYNTHESIZABLE = TRUE) GENERATE
      COFFEE_CTRU             : core_ccu
         PORT MAP (
            alu_exception_of         => alu_exception_of,
            alu_exception_uf         => alu_exception_uf,
            bus_req                  => bus_req,
            ccb_access               => ccb_access,
            clk                      => clk,
            creg_indx_i_q            => creg_indx_i_q,
            current_psr              => current_psr,
            d_cache_miss             => d_cache_miss,
            data_addr_exception_of   => data_addr_exception_of,
            data_addr_exception_usr  => data_addr_exception_usr,
            decode_exception         => decode_exception,
            execute                  => execute,
            i_cache_miss             => i_cache_miss,
            illegal_jump             => illegal_jump_q,
            inst_addr_violation      => inst_addr_violation_q,
            instruction              => instruction,
            interrupt_req            => interrupt_req,
            jump_addr_overflow       => jump_addr_overflow_q,
            miss_aligned_iaddr       => miss_aligned_iaddr_q,
            miss_aligned_jump        => miss_aligned_jump_q,
            reg_lock                 => reg_lock,
            rs_to_rd                 => rs_to_read,
            rst_n                    => rst_n_s,
            stall                    => stall,
            stall_n                  => stall_n,
            wait_cycles              => wait_states,
            access_complete          => access_complete,
            ack                      => ack,
            alu_of_check_en          => alu_of_check_en,
            alu_op_code              => alu_op_code,
            alu_op_i_fwd             => alu_op_i_fwd,
            alu_op_ii_fwd            => alu_op_ii_fwd,
            bus_ack                  => bus_ack,
            ccb_we_exc               => ccb_we_exc,
            check_data_addr_ovfl     => check_data_addr_ovfl,
            check_data_addr_usr      => check_data_addr_usr,
            cop_if_cop_indx          => cop_if_cop_indx,
            cop_if_rd_cop            => cop_if_rd_cop,
            cop_if_reg_indx          => cop_if_reg_indx,
            cop_if_wr_cop            => cop_if_wr_cop,
            cpu_writes_rf            => cpu_writes_rf,
            cr_we                    => cr_we,
            cr_we_all                => cr_we_all,
            cr_wr_reg                => cr_wr_reg,
            d_cache_data_fwd         => d_cache_data_fwd,
            d_cache_if_use_prev_data => d_cache_if_use_prev_data,
            done                     => done,
            en_stage                 => en_stage,
            exception_cause          => exception_cause,
            float                    => float,
            flush                    => flush,
            fpu_comparison           => fpu_comparison,
            mdata_fwd_op_i           => mdata_fwd_op_i,
            mdata_fwd_op_ii          => mdata_fwd_op_ii,
            mdata_fwd_st             => mdata_fwd_st,
            pop                      => pop,
            push                     => push,
            read_access              => read_access,
            reg_jmp_fwd              => reg_jmp_fwd,
            rf_we_data               => rf_we_data,
            rf_we_spsr               => rf_we_spsr,
            rf_wr_reg                => rf_wr_reg,
            rf_wr_rs                 => rf_wr_rs,
            sel_buff_entry           => sel_buff_entry,
            sel_data3p               => sel_data3p,
            sel_data4p               => sel_data4p,
            sel_data5p               => sel_data5p,
            sel_data_from_cop        => sel_data_from_cop,
            sel_data_to_cop          => sel_data_to_cop,
            sel_pc                   => sel_pc,
            sel_psr                  => sel_psr,
            start_dmem_access        => start_dmem_access,
            wr_en_psr                => wr_en_psr,
            write_access             => write_access,
            ldra_fwd                 => ldra_fwd,
            write_pc                 => write_pc
            );

   END GENERATE CTRL_UNIT_SYNTH_GENERATION;

   I44            : core_cntxt_buff
      PORT MAP (
         clk                       => clk,
         enable                    => en_stage(3 DOWNTO 0),
         rst_x                     => rst_n_s,
         pc_in                     => i_addr_signal,
         sel_entry                 => sel_buff_entry,
         psr_in                    => next_psr,
         psr                       => psr,
         addr                      => buff_addr
         );
   I45            : core_cntxt_stack
      PORT MAP (
         rst_x                     => rst_n_s,
         push                      => push,
         pop                       => pop,
         clk                       => clk,
         psr_in                    => current_psr,
         pc_in                     => i_addr_signal,
         psr_o                     => tos_psr,
         pc_out                    => tos_addr,
         cr0_in                    => cr0_to_push(2 DOWNTO 0),
         cr0_out                   => tos_cr0,
         flush                     => flush(3),
         new_tos_addr              => new_tos_addr,
         new_tos_psr               => new_tos_psr,
         new_tos_cr0               => new_tos_cr0
         );
   I9             : core_cond_chk
      PORT MAP (
         cond                      => condition,
         cex                       => cexbit,
         znc                       => znc_o,
         execute                   => execute,
         opcode                    => opc
         );
   COP_IF         : core_cop_if
      PORT MAP (
         clk                       => clk,
         cop_indx                  => cop_if_cop_indx,
         data_in                   => o6,
         enable                    => en_stage(2),
         flush                     => flush(2),
         rd_cop                    => cop_if_rd_cop,
         reg_indx                  => cop_if_reg_indx,
         rst_x                     => rst_n_s,
         wr_cop                    => cop_if_wr_cop,
         cop_id                    => cop_id,
         cop_rd                    => cop_rd,
         cop_rgi                   => cop_rgi,
         cop_wr                    => cop_wr,
         data_out                  => cop_data_int,
         cop_data                  => cop_data,
         cop_q                     => cop_q
         );
   I5             : core_cr
      PORT MAP (
         rst_x                     => rst_n_s,
         creg_wr                   => cr_wr_reg,
         wrcr                      => cr_we,
         clk                       => clk,
         creg_rd                   => creg_indx,
         wr_all                    => cr_we_all,
         znc_in                    => znc_in,
         all_in                    => result_q(23 DOWNTO 0),
         znc_o                     => znc_o,
         flush                     => flush(3),
         cr0_out                   => cr0_to_push,
         all_out                   => flags
         );
   I11            : core_dbif
      PORT MAP (
         reboot                    => reboot,
         restart                   => restart,
         access_complete           => access_complete,
         addr_in                   => result_q,
         addr_mask                 => addr_mask,
         ccb_access                => ccb_access,
         clk                       => clk,
         data_internal             => data_to_mem,
         data_in                   => data_in,
         float_bus                 => float,
         gated_reset_n             => gated_reset_n,
         pcb_access                => pcb_access,
         read_access               => read_access,
         rst_n                     => rst_n,
         start_access              => start_dmem_access,
         use_prev_data             => d_cache_if_use_prev_data,
         write_access              => write_access,
         boot_address              => boot_address,
         mem_data_q                => mem_data,
         read_mem_q                => rd,
         read_pcb_q                => pcb_rd,
         write_mem_q               => wr,
         write_pcb_q               => pcb_wr,
         d_addr                    => d_addr,
         data_out                  => data_out
         );
   COFFEE_DEC     : core_decode
      GENERIC MAP (
         FPU_FU                    => FPU_FU)
      PORT MAP (
         rst_x                     => rst_n_s,
         i_word                    => instruction,
         current_psr               => current_psr,
         clk                       => clk,
         new_psr                   => new_psr,
         extended_imm              => ext_imm,
         exception_q               => decode_exception,
         en                        => en_stage(1),
         sel_op_i                  => sel_op_i,
         sel_op_ii                 => sel_op_ii,
         flush                     => flush(1),
         rs_to_read                => rs_to_read,
         sreg_indx1                => sreg_indx1,
         sreg_indx2                => sreg_indx2,
         jmp_offset                => jump_offset,
         creg_indx                 => creg_indx,
         opc                       => opc,
         cexbit                    => cexbit,
         condition                 => condition,
         fpu_opc                   => fpu_opc,
         trgt_indx                 => fpu_drg_indx_s,
         start_fpu_mul             => start_fpu_mul,
         start_fpu_add             => start_fpu_add,
         start_fpu_div             => start_fpu_div,
         start_fpu_sqrt            => start_fpu_sqrt,
         start_fpu_scycle          => start_fpu_scycle,
         start_fpu_tcycle          => start_fpu_tcycle,
         start_core_pipe           => start_core_pipe,
         cpu_writes_rf             => cpu_writes_rf
         );
   I51            : core_iaddr_chk
      PORT MAP (
         addr_ovfl                 => addr_ovfl,
         addr_viol                 => addr_viol,
         clk                       => clk,
         en_stage                  => en_stage,
         flush                     => flush,
         miss_aligned_addr         => miss_aligned_addr,
         rst_x                     => rst_n_s,
         sel_pc                    => sel_pc,
         write_pc                  => write_pc,
         illegal_jump_q            => illegal_jump_q,
         inst_addr_violation_q     => inst_addr_violation_q,
         jump_addr_overflow_q      => jump_addr_overflow_q,
         miss_aligned_iaddr_q      => miss_aligned_iaddr_q,
         miss_aligned_jump_q       => miss_aligned_jump_q
         );
   I41            : core_inth
      PORT MAP (
         ack                       => ack,
         clk                       => clk,
         cop_exc                   => cop_exc,
         cop_int_pri               => cop_int_pri,
         done                      => done,
         ext_handler               => ext_handler,
         ext_int_pri               => ext_int_pri,
         ext_interrupt             => ext_interrupt,
         int_base                  => base_addr,
         int_mode_il               => int_mode_il,
         int_mode_um               => int_mode_um,
         mask                      => int_mask,
         offset                    => offset,
         rst_x                     => rst_n_s,
         tmr_inta                  => tmr0_int,
         tmr_intb                  => tmr1_int,
         int_ack                   => int_ack,
         int_addr                  => int_addr,
         int_done                  => int_done,
         int_pend                  => int_pend,
         int_psr                   => int_psr,
         int_serv                  => int_serv,
         req_q                     => interrupt_req
         );
   I23            : core_reset_logic
      PORT MAP (
         clk                       => clk,
         rst_n                     => rst_n,
         gated_reset_n             => gated_reset_n,
         ba_ext                    => boot_sel,
         wdog0_rst_n               => tmr0_wdog_rst_n,
         wdog1_rst_n               => tmr1_wdog_rst_n,
         rst_n_s                   => rst_n_s,
         reset_n_out               => reset_n_out
         );
   COFFEE_REGFILE : core_rf
      PORT MAP (
         clk                       => clk,
         rst_x                     => rst_n_s,
         rs_to_read                => rs_to_read,
         rs_to_write               => rf_wr_rs,
         wr_en_spsr                => rf_we_spsr,
         wr_en_data                => rf_we_data,
         reg_indx1                 => sreg_indx1,
         reg_indx2                 => sreg_indx2,
         reg_indx3                 => rf_wr_reg,
         psr_data_in               => next_psr,
         core_wb_data              => result_qqq,
         psr_o_q                   => current_psr,
         spsr_o_q                  => saved_psr,
         data_out1                 => reg_op_i,
         data_out2                 => reg_op_ii,
         wr_en_psr                 => wr_en_psr,
         reg_lock                  => reg_lock,
         fpu_add_sub_complete      => fpu_add_sub_complete,
         fpu_div_complete          => fpu_div_complete,
         fpu_mul_complete          => fpu_mul_complete,
         fpu_single_cycle_complete => fpu_single_cycle_complete,
         fpu_two_cycle_complete    => fpu_two_cycle_complete,
         fpu_sqrt_complete         => fpu_sqrt_complete,
         fpu_single_cycle_result   => fpu_single_cycle_result,
         fpu_two_cycle_result      => fpu_two_cycle_result,
         fpu_add_sub_result        => fpu_add_sub_result,
         fpu_div_result            => fpu_div_result,
         fpu_mul_result            => fpu_mul_result,
         fpu_sqrt_result           => fpu_sqrt_result,
         fpu_single_cycle_dreg     => fpu_single_cycle_dreg,
         fpu_two_cycle_dreg        => fpu_two_cycle_dreg,
         fpu_add_sub_dreg          => fpu_add_sub_dreg,
         fpu_div_dreg              => fpu_div_dreg,
         fpu_mul_dreg              => fpu_mul_dreg,
         fpu_sqrt_dreg             => fpu_sqrt_dreg,
         start_fpu_mul             => start_fpu_mul,
         start_fpu_add             => start_fpu_add,
         start_fpu_div             => start_fpu_div,
         start_fpu_sqrt            => start_fpu_sqrt,
         start_fpu_scycle          => start_fpu_scycle,
         start_fpu_tcycle          => start_fpu_tcycle,
         start_core_pipe           => start_core_pipe,
         target_reg                => fpu_drg_indx_s
         );
   TIMER0         : core_tmr
      PORT MAP (
         clk                       => clk,
         rst_x                     => rst_n_s,
         tmr_cnt_in                => tmr1_cnt_out,
         tmr_conf                  => tmr_conf(31 DOWNTO 16),
         tmr_max_cnt               => tmr1_max_cnt,
         tmr_cnt_out               => tmr1_cnt_in,
         tmr_int                   => tmr1_int,
         wdog_rst_x                => tmr1_wdog_rst_n
         );
   TIMER1         : core_tmr
      PORT MAP (
         clk                       => clk,
         rst_x                     => rst_n_s,
         tmr_cnt_in                => tmr0_cnt_out,
         tmr_conf                  => tmr_conf(15 DOWNTO 0),
         tmr_max_cnt               => tmr0_max_cnt,
         tmr_cnt_out               => tmr0_cnt_in,
         tmr_int                   => tmr0_int,
         wdog_rst_x                => tmr0_wdog_rst_n
         );
   I71            : WEDFF
      PORT MAP (
         d                         => i_addr_signal(31),
         clk                       => clk,
         we                        => write_pc,
         q                         => q7,
         reset                     => rst_n_s
         );
   I66            : WEDFF
      PORT MAP (
         d                         => operand_i(31),
         clk                       => clk,
         we                        => en_stage(2),
         q                         => q1,
         reset                     => rst_n_s
         );
   I67            : WEDFF
      PORT MAP (
         d                         => operand_ii(31),
         clk                       => clk,
         we                        => en_stage(2),
         q                         => q,
         reset                     => rst_n_s
         );
   I72            : WEDFF
      PORT MAP (
         d                         => jump_offset(31),
         clk                       => clk,
         we                        => write_pc,
         q                         => q6,
         reset                     => rst_n_s
         );
   I73            : WEDFF
      PORT MAP (
         d                         => carry_out,
         clk                       => clk,
         we                        => write_pc,
         q                         => q5,
         reset                     => rst_n_s
         );
   I0             : incrementer_32bit_a
      PORT MAP (
         data_in                   => i_addr_signal,
         inc_amount                => current_psr(3),
         data_out                  => next_addr
         );
   ADDR_FR_OP1    : MUX2to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => reg_op_i,
         in_b                      => next_addr,
         output                    => o3,
         sel                       => sel_op_i
         );
   I19            : MUX2to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => q2,
         in_b                      => mem_data,
         output                    => operand_i,
         sel                       => mdata_fwd_op_i
         );
   I34            : MUX2to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => buff_addr,
         in_b                      => tos_addr,
         output                    => popped_addr,
         sel                       => pop
         );
   I35            : MUX2to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => cop_data_int,
         in_b                      => q9,
         output                    => result_qq,
         sel                       => sel_data_from_cop
         );
   I25            : MUX2to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => q13,
         in_b                      => operand_i,
         output                    => o6,
         sel                       => sel_data_to_cop
         );
   I33            : MUX2to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => q10,
         in_b                      => mem_data,
         output                    => result_qqq,
         sel                       => sel_data5p
         );
   I55            : MUX2to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => q13,
         in_b                      => mem_data,
         output                    => operand_ii,
         sel                       => mdata_fwd_op_ii
         );
   I57            : MUX2to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => q14,
         in_b                      => mem_data,
         output                    => o4,
         sel                       => mdata_fwd_st
         );
   FWD_ADDR_JR    : MUX2to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => i_addr_asynch,
         in_b                      => data_i,
         output                    => i_addr_temp,
         sel                       => ldra_fwd
         );
   I15            : MUX2to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => o,
         in_b                      => ext_imm,
         output                    => second_operand,
         sel                       => sel_op_ii
         );
   I22            : MUX2to1
      GENERIC MAP (
         width                     => 3)
      PORT MAP (
         in_a                      => fpu_flags,
         in_b                      => znc_q,
         output                    => o1,
         sel                       => cop_flgs_we_n
         );
   I16            : MUX2to1
      GENERIC MAP (
         width                     => 3)
      PORT MAP (
         in_a                      => o1,
         in_b                      => tos_cr0,
         output                    => znc_in,
         sel                       => pop
         );
   I12            : MUX4to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => q3,
         in_b                      => data_iii,
         in_c                      => result_qqq,
         in_d                      => "00000000000000000000000000000000",
         output                    => data_to_mem,
         sel                       => d_cache_data_fwd
         );
   I27            : MUX4to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => zeros,
         in_b                      => result_q,
         in_c                      => result_2,
         in_d                      => flags,
         output                    => data_ii,
         sel                       => sel_data3p
         );
   I61            : MUX4to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => reg_op_ii,
         in_b                      => data_i,
         in_c                      => data_ii,
         in_d                      => data_iii,
         output                    => o,
         sel                       => alu_op_ii_fwd
         );
   I18            : MUX4to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => reg_op_i,
         in_b                      => result_q,
         in_c                      => result_qq,
         in_d                      => result_qqq,
         output                    => abs_jmp_addr,
         sel                       => reg_jmp_fwd
         );
   I60            : MUX4to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => o3,
         in_b                      => data_i,
         in_c                      => data_ii,
         in_d                      => data_iii,
         output                    => first_operand,
         sel                       => alu_op_i_fwd
         );
   I31            : MUX4to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => result_qq,
         in_b                      => result_3,
         in_c                      => result_4,
         in_d                      => ccb_data,
         output                    => data_iii,
         sel                       => sel_data4p
         );
   PSR_SEL        : MUX8to1
      GENERIC MAP (
         width                     => 8)
      PORT MAP (
         in_a                      => current_psr,
         in_b                      => new_psr,
         in_c                      => int_psr,
         in_d                      => tos_psr,
         in_e                      => exc_psr,
         in_f                      => saved_psr,
         in_g                      => "00000000",
         in_h                      => "00000000",
         sel                       => sel_psr,
         output                    => next_psr
         );
   IADDR_SEL      : MUX8to1
      GENERIC MAP (
         width                     => 32)
      PORT MAP (
         in_a                      => next_addr,
         in_b                      => pc_rel_jmp_addr,
         in_c                      => abs_jmp_addr,
         in_d                      => int_addr,
         in_e                      => exception_addr_q,
         in_f                      => sys_addr_q,
         in_g                      => boot_address,
         in_h                      => popped_addr,
         output                    => i_addr_asynch,
         sel                       => sel_pc
         );
   I69            : WE_register
      GENERIC MAP (
         reg_width                 => 32)
      PORT MAP (
         data_in                   => data_iii,
         clk                       => clk,
         we                        => en_stage(4),
         reset                     => rst_n_s,
         data_out                  => q10
         );
   I56            : WE_register
      GENERIC MAP (
         reg_width                 => 32)
      PORT MAP (
         data_in                   => second_operand,
         clk                       => clk,
         we                        => en_stage(1),
         reset                     => rst_n_s,
         data_out                  => q13
         );
   I63            : WE_register
      GENERIC MAP (
         reg_width                 => 32)
      PORT MAP (
         data_in                   => o,
         clk                       => clk,
         we                        => en_stage(1),
         reset                     => rst_n_s,
         data_out                  => q14
         );
   IADDR_TMP      : WE_register
      GENERIC MAP (
         reg_width                 => 32)
      PORT MAP (
         data_in                   => i_addr_temp,
         clk                       => clk,
         we                        => write_pc,
         reset                     => reboot,
         data_out                  => i_addr_signal
         );
   I65            : WE_register
      GENERIC MAP (
         reg_width                 => 32)
      PORT MAP (
         data_in                   => data_i,
         clk                       => clk,
         we                        => en_stage(2),
         reset                     => rst_n_s,
         data_out                  => result_q
         );
   I53            : WE_register
      GENERIC MAP (
         reg_width                 => 32)
      PORT MAP (
         data_in                   => first_operand,
         clk                       => clk,
         we                        => en_stage(1),
         reset                     => rst_n_s,
         data_out                  => q2
         );
   I68            : WE_register
      GENERIC MAP (
         reg_width                 => 32)
      PORT MAP (
         data_in                   => data_ii,
         clk                       => clk,
         we                        => en_stage(3),
         reset                     => rst_n_s,
         data_out                  => q9
         );
   I64            : WE_register
      GENERIC MAP (
         reg_width                 => 32)
      PORT MAP (
         data_in                   => o4,
         clk                       => clk,
         we                        => en_stage(2),
         reset                     => rst_n_s,
         data_out                  => q3
         );
-- I21 : r32b_we_sset_f
-- PORT MAP (
-- clk => clk,
-- d => i_word,
-- rst_n => rst_n_s,
-- sset => flush(0),
-- we => en_stage(0),
-- q => instruction
-- );
-- REPLACED BY:

   SSET_MUX : MUX2TO1
      GENERIC MAP (
         width   => 32)
      PORT MAP (
         in_a   => i_word,
         in_b   => nop_pattern_c,
         sel    => flush(0),
         output => i_word_sset);

   SSET_REG : WE_register
      GENERIC MAP (
         reg_width   => 32,
         reset_value => nop_pattern_c_64)

      PORT MAP (
         clk     => clk,
         data_in => i_word_sset,
         reset   => rst_n_s,
         we      => en_stage(0),
         data_out       => instruction
         );


END struct;
