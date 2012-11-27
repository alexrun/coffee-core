-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_alu.vhd
--
-- File		: core_alu.vhd
--
-- Date		: 23:46:15 01/19/07
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
USE components.sys_components.ALL;

ENTITY core_alu IS
   PORT( 
      chk_of     : IN     std_logic;
      clk        : IN     std_logic;
      enable_i   : IN     std_logic;
      enable_ii  : IN     std_logic;
      enable_iii : IN     std_logic;
      flush      : IN     std_logic;
      operand_i  : IN     std_logic_vector (31 DOWNTO 0);
      operand_ii : IN     std_logic_vector (31 DOWNTO 0);
      operation  : IN     std_logic_vector (9 DOWNTO 0);
      rst_x      : IN     std_logic;
      of_q       : OUT    std_logic;
      result_1   : OUT    std_logic_vector (31 DOWNTO 0);
      result_2   : OUT    std_logic_vector (31 DOWNTO 0);
      result_3   : OUT    std_logic_vector (31 DOWNTO 0);
      result_4   : OUT    std_logic_vector (31 DOWNTO 0);
      uf_q       : OUT    std_logic;
      znc_q      : OUT    std_logic_vector (2 DOWNTO 0)
   );

-- Declarations

END core_alu ;

ARCHITECTURE struct OF core_alu IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL add_sub_unit_result : std_logic_vector(31 DOWNTO 0);
   SIGNAL bypass              : std_logic;
   SIGNAL bypassed            : std_logic_vector(31 DOWNTO 0);
   SIGNAL control_bm          : std_logic_vector(1 DOWNTO 0);
   SIGNAL control_bo          : std_logic_vector(1 DOWNTO 0);
   SIGNAL control_shift       : std_logic_vector(2 DOWNTO 0);
   SIGNAL o                   : std_logic_vector(31 DOWNTO 0);
   SIGNAL o1                  : std_logic_vector(2 DOWNTO 0);
   SIGNAL result              : std_logic_vector(31 DOWNTO 0);
   SIGNAL result1             : std_logic_vector(31 DOWNTO 0);
   SIGNAL rslt                : std_logic_vector(31 DOWNTO 0);
   SIGNAL sel_i               : std_logic_vector(1 DOWNTO 0);
   SIGNAL sel_ii              : std_logic;
   SIGNAL sel_iii             : std_logic;
   SIGNAL znc                 : std_logic_vector(2 DOWNTO 0);
   SIGNAL znc1                : std_logic_vector(2 DOWNTO 0);


   -- Component Declarations
   COMPONENT alu_add_sub_unit
   PORT (
      rst_x       : IN     std_logic ;
      opa         : IN     std_logic_vector (31 DOWNTO 0);
      opb         : IN     std_logic_vector (31 DOWNTO 0);
      add_sub_cmp : IN     std_logic_vector (1 DOWNTO 0); -- 01 = add, 11 = sub, cmp = 10
      chk_ovfl    : IN     std_logic ;
      clk         : IN     std_logic ;
      enable      : IN     std_logic ;
      uf_q        : OUT    std_logic ;
      of_q        : OUT    std_logic ;
      znc         : OUT    std_logic_vector (2 DOWNTO 0);
      result      : OUT    std_logic_vector (31 DOWNTO 0);
      flush       : IN     std_logic 
   );
   END COMPONENT;
   COMPONENT alu_bool_opr
   PORT (
      opa    : IN     std_logic_vector (31 DOWNTO 0);
      opb    : IN     std_logic_vector (31 DOWNTO 0);
      oper   : IN     std_logic_vector (1 DOWNTO 0);
      result : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT alu_bytem
   PORT (
      opa  : IN     std_logic_vector (31 DOWNTO 0);
      opb  : IN     std_logic_vector (15 DOWNTO 0);
      oper : IN     std_logic_vector (1 DOWNTO 0);
      rslt : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT alu_ctrl
   PORT (
      oper          : IN     std_logic_vector (4 DOWNTO 0);
      sel_ii        : OUT    std_logic ;
      sel_i         : OUT    std_logic_vector (1 DOWNTO 0);
      control_bm    : OUT    std_logic_vector (1 DOWNTO 0);
      control_bo    : OUT    std_logic_vector (1 DOWNTO 0);
      control_shift : OUT    std_logic_vector (2 DOWNTO 0);
      bypass        : OUT    std_logic ;
      sel_iii       : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT alu_shifter
   PORT (
      operation : IN     std_logic_vector (2 DOWNTO 0);
      operand   : IN     std_logic_vector (31 DOWNTO 0);
      control   : IN     std_logic_vector (10 DOWNTO 0);
      result    : OUT    std_logic_vector (31 DOWNTO 0);
      znc       : OUT    std_logic_vector (2 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT core_mu
   PORT (
      clk             : IN     std_logic ;
      enable1st       : IN     std_logic ;
      enable2nd       : IN     std_logic ;
      enable3rd       : IN     std_logic ;
      op_i_type       : IN     std_logic ;
      op_ii_type      : IN     std_logic ;
      operand_i       : IN     std_logic_vector (31 DOWNTO 0);
      operand_ii      : IN     std_logic_vector (31 DOWNTO 0);
      rst_x           : IN     std_logic ;
      sel16or32       : IN     std_logic ;
      result16x16full : OUT    std_logic_vector (31 DOWNTO 0);
      result32x32hi   : OUT    std_logic_vector (31 DOWNTO 0);
      result32x32lo   : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
--    COMPONENT mux2to1_32b
--    PORT (
--       d0 : IN     std_logic_vector (31 DOWNTO 0);
--       d1 : IN     std_logic_vector (31 DOWNTO 0);
--       o  : OUT    std_logic_vector (31 DOWNTO 0);
--       s  : IN     std_logic 
--    );
--    END COMPONENT;
--    COMPONENT mux2to1_3b
--    PORT (
--       d0 : IN     std_logic_vector (2 DOWNTO 0);
--       d1 : IN     std_logic_vector (2 DOWNTO 0);
--       o  : OUT    std_logic_vector (2 DOWNTO 0);
--       s  : IN     std_logic 
--    );
--    END COMPONENT;
--    COMPONENT mux4to1_32b
--    PORT (
--       d0  : IN     std_logic_vector (31 DOWNTO 0);
--       d1  : IN     std_logic_vector (31 DOWNTO 0);
--       d2  : IN     std_logic_vector (31 DOWNTO 0);
--       d3  : IN     std_logic_vector (31 DOWNTO 0);
--       o   : OUT    std_logic_vector (31 DOWNTO 0);
--       sel : IN     std_logic_vector (1 DOWNTO 0)
--    );
--    END COMPONENT;
--    COMPONENT r3b_we
--    PORT (
--       d     : IN     std_logic_vector (2 DOWNTO 0);
--       clk   : IN     std_logic ;
--       en    : IN     std_logic ;
--       q     : OUT    std_logic_vector (2 DOWNTO 0);
--       rst_x : IN     std_logic 
--    );
--    END COMPONENT;


BEGIN
   -- Instance port mappings.
   I1 : alu_add_sub_unit
      PORT MAP (
         rst_x       => rst_x,
         opa         => operand_i,
         opb         => operand_ii,
         add_sub_cmp => operation(6 DOWNTO 5),
         chk_ovfl    => chk_of,
         clk         => clk,
         enable      => enable_i,
         uf_q        => uf_q,
         of_q        => of_q,
         znc         => znc,
         result      => add_sub_unit_result,
         flush       => flush
      );
   I3 : alu_bool_opr
      PORT MAP (
         opa    => operand_i,
         opb    => operand_ii,
         oper   => control_bo,
         result => result
      );
   I2 : alu_bytem
      PORT MAP (
         opa  => operand_i,
         opb  => operand_ii(15 DOWNTO 0),
         oper => control_bm,
         rslt => rslt
      );
   I7 : alu_ctrl
      PORT MAP (
         oper          => operation(4 DOWNTO 0),
         sel_ii        => sel_ii,
         sel_i         => sel_i,
         control_bm    => control_bm,
         control_bo    => control_bo,
         control_shift => control_shift,
         bypass        => bypass,
         sel_iii       => sel_iii
      );
   I4 : alu_shifter
      PORT MAP (
         operation => control_shift,
         operand   => operand_i,
         control   => operand_ii(10 DOWNTO 0),
         result    => result1,
         znc       => znc1
      );
   I11 : core_mu
      PORT MAP (
         clk             => clk,
         enable1st       => enable_i,
         enable2nd       => enable_ii,
         enable3rd       => enable_iii,
         op_i_type       => operation(8),
         op_ii_type      => operation(7),
         operand_i       => operand_i,
         operand_ii      => operand_ii,
         rst_x           => rst_x,
         sel16or32       => operation(9),
         result16x16full => result_2,
         result32x32hi   => result_4,
         result32x32lo   => result_3
      );
   I5 : MUX2to1
      GENERIC MAP (
         width => 32)
      PORT MAP (
         in_a => o,
         in_b => result1,
         output  => result_1,
         sel  => sel_ii
      );
   I8 : MUX2to1
      GENERIC MAP (
         width => 32)
      PORT MAP (
         in_a => operand_i,
         in_b => operand_ii,
         output  => bypassed,
         sel  => bypass
      );
   I0 : MUX2to1
      GENERIC MAP (
         width => 3)
      PORT MAP (
         in_a => znc,
         in_b => znc1,
         output  => o1,
         sel  => sel_iii
      );
   I6 : MUX4to1
      GENERIC MAP (
         width => 32)
      PORT MAP (
         in_a  => bypassed,
         in_b  => rslt,
         in_c => result,
         in_d  => add_sub_unit_result,
         output   => o,
         sel => sel_i
      );
   I9 : WE_register
      GENERIC MAP (
         reg_width => 3)
      PORT MAP (
         data_in     => o1,
         clk   => clk,
         we    => enable_i,
         data_out     => znc_q,
         reset => rst_x
      );

END struct;
