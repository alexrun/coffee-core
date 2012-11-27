-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_tmr.vhd
--
-- File		: core_tmr.vhd
--
-- Date		: 23:46:20 01/19/07
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

ENTITY core_tmr IS
   PORT( 
      clk         : IN     std_logic;
      rst_x       : IN     std_logic;
      tmr_cnt_in  : IN     std_logic_vector (31 DOWNTO 0);
      tmr_conf    : IN     std_logic_vector (15 DOWNTO 0);
      tmr_max_cnt : IN     std_logic_vector (31 DOWNTO 0);
      tmr_cnt_out : OUT    std_logic_vector (31 DOWNTO 0);
      tmr_int     : OUT    std_logic_vector (7 DOWNTO 0);
      wdog_rst_x  : OUT    std_logic
   );

-- Declarations

END core_tmr ;
-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_tmr.vhd
--
-- File		: core_tmr.vhd
--
-- Date		: 23:46:21 01/19/07
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





ARCHITECTURE struct OF core_tmr IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL cont_mode  : std_logic;
   SIGNAL divisor    : std_logic_vector(7 DOWNTO 0);
   SIGNAL enable     : std_logic;
   SIGNAL increment  : std_logic;
   SIGNAL terminated : std_logic;


   -- Component Declarations
   COMPONENT tmr_control
   PORT (
      clk        : IN     std_logic ;
      rst_x      : IN     std_logic ;
      terminated : IN     std_logic ;
      tmr_conf   : IN     std_logic_vector (15 DOWNTO 0);
      cont_mode  : OUT    std_logic ;
      divisor    : OUT    std_logic_vector (7 DOWNTO 0);
      enable     : OUT    std_logic ;
      tmr_int    : OUT    std_logic_vector (7 DOWNTO 0);
      wdog_rst_x : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT tmr_counter
   PORT (
      cont_mode   : IN     std_logic ;
      enable      : IN     std_logic ;
      increment   : IN     std_logic ;
      tmr_cnt_in  : IN     std_logic_vector (31 DOWNTO 0);
      tmr_max_cnt : IN     std_logic_vector (31 DOWNTO 0);
      terminated  : OUT    std_logic ;
      tmr_cnt_out : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT tmr_divider
   PORT (
      clk       : IN     std_logic ;
      divisor   : IN     std_logic_vector (7 DOWNTO 0);
      enable    : IN     std_logic ;
      rst_x     : IN     std_logic ;
      increment : OUT    std_logic 
   );
   END COMPONENT;


BEGIN
   -- Instance port mappings.
   I0 : tmr_control
      PORT MAP (
         clk        => clk,
         rst_x      => rst_x,
         terminated => terminated,
         tmr_conf   => tmr_conf,
         cont_mode  => cont_mode,
         divisor    => divisor,
         enable     => enable,
         tmr_int    => tmr_int,
         wdog_rst_x => wdog_rst_x
      );
   I2 : tmr_counter
      PORT MAP (
         cont_mode   => cont_mode,
         enable      => enable,
         increment   => increment,
         tmr_cnt_in  => tmr_cnt_in,
         tmr_max_cnt => tmr_max_cnt,
         terminated  => terminated,
         tmr_cnt_out => tmr_cnt_out
      );
   I1 : tmr_divider
      PORT MAP (
         clk       => clk,
         divisor   => divisor,
         enable    => enable,
         rst_x     => rst_x,
         increment => increment
      );

END struct;
