-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project              : AVEC
--
-- Design               :  dbif_control.vhd
--
-- File         : dbif_control.vhd
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

ENTITY dbif_control IS
   PORT(
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

-- Declarations

END dbif_control;
ARCHITECTURE dbif_control_arch OF dbif_control IS

   SIGNAL end_read_access       : STD_LOGIC;
   SIGNAL read_mem_s            : STD_LOGIC;
   SIGNAL read_pcb_s            : STD_LOGIC;
   SIGNAL read_access           : STD_LOGIC;
   SIGNAL get_boot_address      : STD_LOGIC;
   SIGNAL latch_data_from_bus_i : STD_LOGIC;

BEGIN
   read_access                <= rd_en_dmem OR rd_en_pcb;
   --------------------------------------------
   -- Controlling state according to bus status
   --------------------------------------------
   PROCESS(clk, rst_n)
   BEGIN
      IF rst_n = '0' THEN
         read_mem_s           <= '0';
         read_pcb_s           <= '0';
         write_mem_q          <= '0';
         write_pcb_q          <= '0';
         -- data bus floats
         not_keep_old_data    <= '0';
         not_keep_old_addr    <= '0';
      ELSIF clk'EVENT AND clk = '1' THEN
         IF float_bus = '1' THEN
            read_mem_s        <= '0';
            read_pcb_s        <= '0';
            write_mem_q       <= '0';
            write_pcb_q       <= '0';
            not_keep_old_data <= '0';
            not_keep_old_addr <= '0';
         ELSIF start_access = '1' THEN
            read_mem_s        <= rd_en_dmem;
            read_pcb_s        <= rd_en_pcb;
            write_mem_q       <= wr_en_dmem;
            write_pcb_q       <= wr_en_pcb;
            not_keep_old_data <= NOT(use_prev_data) AND NOT read_access;
            not_keep_old_addr <= '1';
         ELSIF access_complete = '1' THEN
            read_mem_s        <= '0';
            read_pcb_s        <= '0';
            write_mem_q       <= '0';
            write_pcb_q       <= '0';
            not_keep_old_data <= '0';
            not_keep_old_addr <= '0';
--          ELSE                        --commented away; the wr signal
--          wasn't kept high during a dcache miss
--             read_mem_s        <= '0';
--             read_pcb_s        <= '0';
--             write_mem_q       <= '0';
--             write_pcb_q       <= '0';
--             -- data bus floats
--             not_keep_old_data <= '0';
--             not_keep_old_addr <= '0';

         END IF;
      END IF;
   END PROCESS;
   
   read_mem_q <= read_mem_s;
   read_pcb_q <= read_pcb_s;

   ---------------------------------------------------------
   -- Controlling the moment when data should be clocked in
   ---------------------------------------------------------

   -- end_read_access is high during the last cycle of the read access.
   end_read_access         <= (read_mem_s OR read_pcb_s) AND access_complete;
   -- reset is expected to be synchronized
   get_boot_address        <= NOT rst_n;
   latch_data_from_bus_i   <= end_read_access OR get_boot_address;
   latch_data_from_bus     <= latch_data_from_bus_i;

   -- Sampling registers, which are used to save power by means of driving
   -- last values on bus when idling, must be disabled when they are
   -- used to forward data between consecutive ld and st instructions
   -- having a data dependency. Note active low signal...
   disable_sampling_n <= NOT(use_prev_data AND NOT latch_data_from_bus_i);

   ---------------------------------------------------------
   -- Controlling the moment when data should latched
   ---------------------------------------------------------
   -- the latched value is not driven to bus until new access starts
   latch_data_from_core <= start_access;

   ---------------------------------------------------------
   -- Applying address mask if needed
   ---------------------------------------------------------
   masked_addr <= addr and mask when use_mask = '1' else addr;

end dbif_control_arch;
