-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_cop_if.vhd
--
-- File		: core_cop_if.vhd
--
-- Date		: 23:46:07 01/19/07
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

LIBRARY components;
USE components.sys_definitions.ALL;
USE components.sys_components.ALL;

ENTITY core_cop_if IS
   PORT( 
      clk        : IN     std_logic;
      cop_indx   : IN     std_logic_vector (1 DOWNTO 0);
      data_in    : IN     std_logic_vector (31 DOWNTO 0);
      enable     : IN     std_logic;
      flush      : IN     std_logic;
      rd_cop     : IN     std_logic;
      reg_indx   : IN     std_logic_vector (4 DOWNTO 0);
      rst_x      : IN     std_logic;
      wr_cop     : IN     std_logic;
      cop_id     : OUT    std_logic_vector (1 DOWNTO 0);
      cop_rd     : OUT    std_logic;
      cop_rgi    : OUT    std_logic_vector (4 DOWNTO 0);
      cop_wr     : OUT    std_logic;
      data_out   : OUT    std_logic_vector (31 DOWNTO 0);
      cop_data   : IN     std_logic_vector (31 DOWNTO 0);
      cop_q      : OUT    std_logic_vector (31 DOWNTO 0)
   );


END core_cop_if ;


ARCHITECTURE struct OF core_cop_if IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL cop_indx_q              : std_logic_vector(1 DOWNTO 0);
   SIGNAL keep_old_data           : std_logic;
   SIGNAL latch_data_from_bus     : std_logic;
   SIGNAL latch_data_from_core    : std_logic;
   SIGNAL old_data_out            : std_logic_vector(31 DOWNTO 0);
   SIGNAL out_z                   : std_logic_vector(31 DOWNTO 0);
   SIGNAL pull_high               : std_logic;
   SIGNAL ltchd                   : std_logic_vector(31 DOWNTO 0);
   SIGNAL rd_cop_q                : std_logic;
   SIGNAL reg_indx_q              : std_logic_vector(4 DOWNTO 0);
   SIGNAL wr_cop_q                : std_logic;

   -- Implicit buffer signal declarations
   SIGNAL data_out_internal : std_logic_vector (31 DOWNTO 0);


   -- Component Declarations
   COMPONENT cop_if_cntrl
   PORT (
      clk                     : IN     std_logic ;
      cop_indx                : IN     std_logic_vector (1 DOWNTO 0);
      enable                  : IN     std_logic ;
      flush                   : IN     std_logic ;
      rd_cop                  : IN     std_logic ;
      reg_indx                : IN     std_logic_vector (4 DOWNTO 0);
      rst_x                   : IN     std_logic ;
      wr_cop                  : IN     std_logic ;
      cop_indx_q              : OUT    std_logic_vector (1 DOWNTO 0);
      keep_old_data           : OUT    std_logic ;
      latch_data_from_bus     : OUT    std_logic ;
      latch_data_from_core    : OUT    std_logic ;
      not_keep_old_data       : OUT    std_logic ;
      not_latch_data_from_bus : OUT    std_logic ;
      rd_cop_q                : OUT    std_logic ;
      reg_indx_q              : OUT    std_logic_vector (4 DOWNTO 0);
      wr_cop_q                : OUT    std_logic 
   );
   END COMPONENT;


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   cop_wr <= wr_cop_q;
   cop_rd <= rd_cop_q;
   cop_id <= cop_indx_q;
   cop_rgi <= reg_indx_q;

   -- HDL Embedded Text Block 2 eb2
   pull_high <= '1';

   -- Instance port mappings.
   I12 : cop_if_cntrl
      PORT MAP (
         clk                     => clk,
         cop_indx                => cop_indx,
         enable                  => enable,
         flush                   => flush,
         rd_cop                  => rd_cop,
         reg_indx                => reg_indx,
         rst_x                   => rst_x,
         wr_cop                  => wr_cop,
         cop_indx_q              => cop_indx_q,
         keep_old_data           => keep_old_data,
         latch_data_from_bus     => latch_data_from_bus,
         latch_data_from_core    => latch_data_from_core,
         not_keep_old_data       => OPEN,
         not_latch_data_from_bus => OPEN,
         rd_cop_q                => rd_cop_q,
         reg_indx_q              => reg_indx_q,
         wr_cop_q                => wr_cop_q
      );
   I10 : WE_register
      GENERIC MAP (
         reg_width => 32)
      PORT MAP (
         data_in    => data_in,
         clk   => clk,
         we    => latch_data_from_core,
         reset => rst_x,
         data_out    => ltchd
      );
   I16 : WE_register
      GENERIC MAP (
         reg_width => 32)
      PORT MAP (
         data_in     => cop_data,
         clk   => clk,
         we    => pull_high,
         reset => rst_x,
         data_out    => old_data_out
      );
   I11 : WE_register
      GENERIC MAP (
         reg_width => 32)
      PORT MAP (
         data_in     => out_z,
         clk   => clk,
         we    => pull_high,
         reset => rst_x,
         data_out     => data_out_internal
      );
   
   TRISTATE_BUF_DATA: PROCESS (ltchd, old_data_out, keep_old_data)

   BEGIN  -- PROCESS TRISTATE_BUF_DATA

		IF  keep_old_data = '1' THEN
                   cop_q <= old_data_out;
		ELSE
                   cop_q <= ltchd;
		END IF;
  

   END PROCESS TRISTATE_BUF_DATA;

   TRISTATE_BUF_BUS: PROCESS (data_out_internal, latch_data_from_bus, cop_data)

   BEGIN  -- PROCESS TRISTATE_BUF_BUS

		IF (latch_data_from_bus  = '1') THEN
                   out_z <= cop_data;
		ELSE
                   out_z <= data_out_internal;
		END IF;
  

   END PROCESS TRISTATE_BUF_BUS;


   data_out <= data_out_internal;

END struct;
