-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project              : AVEC
--
-- Design               :  core_dbif.vhd
--
-- File         : core_dbif.vhd
--
-- Date         : 23:46:19 01/19/07
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

LIBRARY components;
USE components.sys_definitions.ALL;
USE components.sys_components.ALL;

ENTITY core_dbif IS
   PORT(
      reboot          : IN    STD_LOGIC;
      restart         : IN    STD_LOGIC;
      access_complete : IN    STD_LOGIC;
      addr_in         : IN    STD_LOGIC_VECTOR (31 DOWNTO 0);
      addr_mask       : IN    STD_LOGIC_VECTOR (31 DOWNTO 0);
      ccb_access      : IN    STD_LOGIC;
      clk             : IN    STD_LOGIC;
      data_in         : IN    STD_LOGIC_VECTOR (31 DOWNTO 0);
      data_internal   : IN    STD_LOGIC_VECTOR (31 DOWNTO 0);
      float_bus       : IN    STD_LOGIC;
      gated_reset_n   : IN    STD_LOGIC;
      pcb_access      : IN    STD_LOGIC;
      read_access     : IN    STD_LOGIC;
      rst_n           : IN    STD_LOGIC;
      start_access    : IN    STD_LOGIC;
      use_prev_data   : IN    STD_LOGIC;
      write_access    : IN    STD_LOGIC;
      boot_address    : OUT   STD_LOGIC_VECTOR (31 DOWNTO 0);
      mem_data_q      : OUT   STD_LOGIC_VECTOR (31 DOWNTO 0);
      read_mem_q      : OUT   STD_LOGIC;
      read_pcb_q      : OUT   STD_LOGIC;
      write_mem_q     : OUT   STD_LOGIC;
      write_pcb_q     : OUT   STD_LOGIC;
      d_addr          : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      data_out        : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
      );

-- Declarations

END core_dbif;

ARCHITECTURE struct OF core_dbif IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL disable_sampling_n        : STD_LOGIC;
   SIGNAL latch_data_from_bus       : STD_LOGIC;
   SIGNAL latch_data_from_core      : STD_LOGIC;
   SIGNAL masked_addr               : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL not_keep_old_addr         : STD_LOGIC;
   SIGNAL not_keep_old_data         : STD_LOGIC;
   SIGNAL out_z                     : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL pull_high                 : STD_LOGIC;
   SIGNAL d_addr_int                : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL q                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL q1                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL q2                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL q3                        : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL rd_en_dmem                : STD_LOGIC;
   SIGNAL rd_en_pcb                 : STD_LOGIC;
   SIGNAL use_mask                  : STD_LOGIC;
   SIGNAL wr_en_dmem                : STD_LOGIC;
   SIGNAL wr_en_pcb                 : STD_LOGIC;
   SIGNAL or_out                    : STD_LOGIC;
   SIGNAL set_reset                 : STD_LOGIC;
   SIGNAL address_boot, address_res : STD_LOGIC_VECTOR (31 DOWNTO 0);

   -- Implicit buffer signal declarations
   SIGNAL mem_data_q_internal : STD_LOGIC_VECTOR (31 DOWNTO 0);


   -- Component Declarations
   COMPONENT dbif_control
      PORT (
         access_complete         : IN  STD_LOGIC;
         addr                    : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         clk                     : IN  STD_LOGIC;
         float_bus               : IN  STD_LOGIC;
         mask                    : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         rd_en_dmem              : IN  STD_LOGIC;
         rd_en_pcb               : IN  STD_LOGIC;
         rst_n                   : IN  STD_LOGIC;
         start_access            : IN  STD_LOGIC;
         use_mask                : IN  STD_LOGIC;
         use_prev_data           : IN  STD_LOGIC;
         wr_en_dmem              : IN  STD_LOGIC;
         wr_en_pcb               : IN  STD_LOGIC;
         disable_sampling_n      : OUT STD_LOGIC;
         latch_data_from_bus     : OUT STD_LOGIC;
         latch_data_from_core    : OUT STD_LOGIC;
         masked_addr             : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         not_keep_old_addr       : OUT STD_LOGIC;
         not_keep_old_data       : OUT STD_LOGIC;
         read_mem_q              : OUT STD_LOGIC;
         read_pcb_q              : OUT STD_LOGIC;
         write_mem_q             : OUT STD_LOGIC;
         write_pcb_q             : OUT STD_LOGIC
         );
   END COMPONENT;


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   pull_high <= '1';

   -- HDL Embedded Text Block 2 eb2
   wr_en_dmem <= write_access AND NOT pcb_access AND NOT ccb_access;
   rd_en_dmem <= read_access AND NOT pcb_access AND NOT ccb_access;
   wr_en_pcb  <= write_access AND pcb_access;
   rd_en_pcb  <= read_access AND pcb_access;
   use_mask   <= pcb_access;

   -- Instance port mappings.
   I4          : dbif_control
      PORT MAP (
         access_complete         => access_complete,
         addr                    => addr_in,
         clk                     => clk,
         float_bus               => float_bus,
         mask                    => addr_mask,
         rd_en_dmem              => rd_en_dmem,
         rd_en_pcb               => rd_en_pcb,
         rst_n                   => rst_n,
         start_access            => start_access,
         use_mask                => use_mask,
         use_prev_data           => use_prev_data,
         wr_en_dmem              => wr_en_dmem,
         wr_en_pcb               => wr_en_pcb,
         disable_sampling_n      => disable_sampling_n,
         latch_data_from_bus     => latch_data_from_bus,
         latch_data_from_core    => latch_data_from_core,
         masked_addr             => masked_addr,
         not_keep_old_addr       => not_keep_old_addr,
         not_keep_old_data       => not_keep_old_data,
         read_mem_q              => read_mem_q,
         read_pcb_q              => read_pcb_q,
         write_mem_q             => write_mem_q,
         write_pcb_q             => write_pcb_q
         );
   LTCHDFC     : WE_register
      GENERIC MAP (
         reg_width               => 32)
      PORT MAP (
         data_in                 => data_internal,
         clk                     => clk,
         we                      => latch_data_from_core,
         reset                   => rst_n,
         data_out                => q
         );
   DIS_SMP     : WE_register
      GENERIC MAP (
         reg_width               => 32)
      PORT MAP (
         data_in                 => data_in,
         clk                     => clk,
         we                      => disable_sampling_n,
         reset                   => rst_n,
         data_out                => q1
         );
   I15         : WE_register
      GENERIC MAP (
         reg_width               => 32)
      PORT MAP (
         data_in                 => out_z,
         clk                     => clk,
         we                      => pull_high,
         reset                   => gated_reset_n,
         data_out                => mem_data_q_internal
         );
   BOOT_REG    : WE_register
      GENERIC MAP (
         reg_width               => 32)
      PORT MAP (
         data_in                 => mem_data_q_internal,
         clk                     => clk,
         we                      => pull_high,
         reset                   => gated_reset_n,
         data_out                => address_boot
         );
   RESTART_REG : WE_register
      GENERIC MAP (
         reg_width               => 32,
         reset_value             => "0000000000000000000000000000000000000000000100000000000000000000")
      PORT MAP (
         data_in                 => mem_data_q_internal,
         clk                     => clk,
         we                      => pull_high,
         reset                   => gated_reset_n,
         data_out                => address_res
         );

   BOOT_ADDR_SEL : MUX2to1
      GENERIC MAP (
         width => 32
         )
      PORT MAP (
         in_a => address_boot,
         in_b => address_res,
         output => boot_address,
         sel  => set_reset);


      SR_FF : data_ff
      PORT MAP (
         clk   => clk,
         reset => reboot,
         d     => or_out,
         q     => set_reset);

      or_out <= (NOT restart) OR set_reset;

   I7 : WE_register
      GENERIC MAP (
         reg_width => 32
         )
      PORT MAP (
         clk       => clk,
         data_in   => masked_addr,
         we        => latch_data_from_core,
         reset     => rst_n,
         data_out  => q3
         );
   I9 : WE_register
      GENERIC MAP (
         reg_width => 32
         )
      PORT MAP (
         clk       => clk,
         data_in   => d_addr_int,
         we        => pull_high,
         reset     => rst_n,
         data_out  => q2
         );

   BUF_DATA : PROCESS (q, q1, not_keep_old_data)

   BEGIN  -- PROCESS BUF_DATA

      IF not_keep_old_data = '1' THEN
         data_out <= q;
      ELSE
         data_out <= q1;
      END IF;


   END PROCESS BUF_DATA;

   BUF_ADDR : PROCESS (q2, q3, not_keep_old_addr)

   BEGIN  -- PROCESS BUF_ADDR

      IF not_keep_old_addr = '1' THEN
         d_addr_int <= q3;
      ELSE
         d_addr_int <= q2;
      END IF;


   END PROCESS BUF_ADDR;


   BUF_BUS : PROCESS (data_in, mem_data_q_internal, latch_data_from_bus)

   BEGIN  -- PROCESS BUF_BUS

      IF (latch_data_from_bus = '1') THEN
         out_z <= data_in;
      ELSE
         out_z <= mem_data_q_internal;
      END IF;


   END PROCESS BUF_BUS;


   -- Implicit buffered output assignments
   mem_data_q <= mem_data_q_internal;

   d_addr <= d_addr_int;

END struct;
