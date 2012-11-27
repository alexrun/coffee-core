-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project              : AVEC
--
-- Design               :  core.vhd
--
-- File         : core.vhd
--
-- Date         : 23:46:38 01/19/07
--
-- Description  : 
--
-- ----------------------------------------------------------------------------
--
-- Author(s)    : Juha Kylliäinen
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
--Copyright (c) 2004, Tampere University of Technology.
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
USE IEEE.std_logic_arith.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY coffee;
USE coffee.ALL;

LIBRARY milk;
USE milk.cop_definitions.ALL;

LIBRARY components;
USE components.sys_definitions.ALL;
USE components.sys_components.ALL;

ENTITY core IS
   PORT(
      reboot        : IN  STD_LOGIC;
      boot_sel      : IN  STD_LOGIC;
      bus_req       : IN  STD_LOGIC;
      clk           : IN  STD_LOGIC;
      cop0_exc      : IN  STD_LOGIC;
      cop1_exc      : IN  STD_LOGIC;
      cop2_exc      : IN  STD_LOGIC;
      cop3_exc      : IN  STD_LOGIC;
      d_cache_miss  : IN  STD_LOGIC;
      ext_handler   : IN  STD_LOGIC;
      ext_interrupt : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
      i_cache_miss  : IN  STD_LOGIC;
      i_word        : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      offset        : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
      rst_n         : IN  STD_LOGIC;
      stall         : IN  STD_LOGIC;
      bus_ack       : OUT STD_LOGIC;
      cop_id        : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      cop_rd        : OUT STD_LOGIC;
      cop_rgi       : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
      cop_wr        : OUT STD_LOGIC;
      i_addr        : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      int_ack       : OUT STD_LOGIC;
      int_done      : OUT STD_LOGIC;
      pcb_rd        : OUT STD_LOGIC;
      pcb_wr        : OUT STD_LOGIC;
      rd            : OUT STD_LOGIC;
      reset_n_out   : OUT STD_LOGIC;
      wr            : OUT STD_LOGIC;
      cop_data      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      cop_q         : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      d_addr        : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      data_in       : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      data_out      : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
      );

-- Declarations

END core;

ARCHITECTURE struct OF core IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL addsub_completed        : STD_LOGIC;
   SIGNAL c_index                 : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL compare_result          : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL cop_1_clk_result        : STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
   SIGNAL cop_2_clk_result        : STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
   SIGNAL cop_add_result          : STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
   SIGNAL cop_div_result          : STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
   SIGNAL cop_exc                 : STD_LOGIC;
   SIGNAL cop_mul_result          : STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
   SIGNAL cop_sqrt_result         : STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
   SIGNAL dest_reg_1_clk_instr    : STD_LOGIC_VECTOR(core_rf_width-1 DOWNTO 0);
   SIGNAL dest_reg_2_clk_instr    : STD_LOGIC_VECTOR(core_rf_width-1 DOWNTO 0);
   SIGNAL dest_reg_addsub         : STD_LOGIC_VECTOR(core_rf_width-1 DOWNTO 0);
   SIGNAL dest_reg_div            : STD_LOGIC_VECTOR(core_rf_width-1 DOWNTO 0);
   SIGNAL dest_reg_mul            : STD_LOGIC_VECTOR(core_rf_width-1 DOWNTO 0);
   SIGNAL dest_reg_sqrt           : STD_LOGIC_VECTOR(core_rf_width-1 DOWNTO 0);
   SIGNAL div_completed           : STD_LOGIC;
   SIGNAL fcop_opc                : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL fcop_oprnd1             : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL fcop_oprnd2             : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL fpu_drg_indx            : STD_LOGIC_VECTOR(4 DOWNTO 0);
   SIGNAL milk_status             : STD_LOGIC_VECTOR(exceptions_amount-1 DOWNTO 0);
   SIGNAL mul_completed           : STD_LOGIC;
   SIGNAL one_clk_instr_completed : STD_LOGIC;
   SIGNAL sqrt_completed          : STD_LOGIC;
   SIGNAL stall_n                 : STD_LOGIC;
   SIGNAL two_clk_instr_completed : STD_LOGIC;



   COMPONENT core_plain
      GENERIC (
         FPU_FU : BOOLEAN);

      PORT (
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
         data_in                      : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         data_out                     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
         );
   END COMPONENT;


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   c_index <= "01";

   stall_n <= '1';


      addsub_completed        <= '0';
      compare_result          <= (OTHERS => '0');
      cop_1_clk_result        <= (OTHERS => '0');
      cop_2_clk_result        <= (OTHERS => '0');
      cop_add_result          <= (OTHERS => '0');
      cop_div_result          <= (OTHERS => '0');
      cop_mul_result          <= (OTHERS => '0');
      cop_sqrt_result         <= (OTHERS => '0');
      dest_reg_1_clk_instr    <= (OTHERS => '0');
      dest_reg_2_clk_instr    <= (OTHERS => '0');
      dest_reg_addsub         <= (OTHERS => '0');
      dest_reg_div            <= (OTHERS => '0');
      dest_reg_mul            <= (OTHERS => '0');
      dest_reg_sqrt           <= (OTHERS => '0');
      div_completed           <= '0';
      milk_status             <= (OTHERS => '0');
      mul_completed           <= '0';
      one_clk_instr_completed <= '0';
      sqrt_completed          <= '0';
      two_clk_instr_completed <= '0';

   RISC_CORE : core_plain
      GENERIC MAP (
         FPU_FU                       => FALSE)
      PORT MAP (
         reboot                       => reboot,
         restart                      => '1',
         boot_sel                     => boot_sel,
         bus_req                      => bus_req,
         clk                          => clk,
         cop0_exc                     => cop0_exc,
         cop1_exc                     => cop1_exc,
         cop2_exc                     => cop2_exc,
         cop3_exc                     => cop3_exc,
         cop_flags                    => compare_result,
         d_cache_miss                 => d_cache_miss,
         ext_handler                  => ext_handler,
         ext_interrupt                => ext_interrupt,
         fcop_1_clk_result            => cop_1_clk_result,
         fcop_2_clk_result            => cop_2_clk_result,
         fcop_add_result              => cop_add_result,
         fcop_addsub_completed        => addsub_completed,
         fcop_dest_reg_1_clk_instr    => dest_reg_1_clk_instr,
         fcop_dest_reg_2_clk_instr    => dest_reg_2_clk_instr,
         fcop_dest_reg_addsub         => dest_reg_addsub,
         fcop_dest_reg_div            => dest_reg_div,
         fcop_dest_reg_mul            => dest_reg_mul,
         fcop_dest_reg_sqrt           => dest_reg_sqrt,
         fcop_div_completed           => div_completed,
         fcop_div_result              => cop_div_result,
         fcop_mul_completed           => mul_completed,
         fcop_mul_result              => cop_mul_result,
         fcop_one_clk_instr_completed => one_clk_instr_completed,
         fcop_sqrt_completed          => sqrt_completed,
         fcop_sqrt_result             => cop_sqrt_result,
         fcop_status                  => milk_status,
         fcop_two_clk_instr_completed => two_clk_instr_completed,
         i_cache_miss                 => i_cache_miss,
         i_word                       => i_word,
         offset                       => offset,
         rst_n                        => rst_n,
         stall                        => stall,
         stall_n                      => stall_n,
         bus_ack                      => bus_ack,
         cop_id                       => cop_id,
         cop_rd                       => cop_rd,
         cop_rgi                      => cop_rgi,
         cop_wr                       => cop_wr,
         fcop_opc                     => fcop_opc,
         fcop_oprnd1                  => fcop_oprnd1,
         fcop_oprnd2                  => fcop_oprnd2,
         fpu_drg_indx                 => fpu_drg_indx,
         i_addr                       => i_addr,
         int_ack                      => int_ack,
         int_done                     => int_done,
         pcb_rd                       => pcb_rd,
         pcb_wr                       => pcb_wr,
         rd                           => rd,
         reset_n_out                  => reset_n_out,
         wr                           => wr,
         cop_data                     => cop_data,
         cop_q                        => cop_q,
         d_addr                       => d_addr,
         data_in                      => data_in,
         data_out                     => data_out
         );

END struct;
