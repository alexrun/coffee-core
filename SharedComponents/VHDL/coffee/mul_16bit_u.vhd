-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  mul_16bit_u.vhd
--
-- File		: mul_16bit_u.vhd
--
-- Date		: 23:46:11 01/19/07
--
-- Description	: 
--
-- ----------------------------------------------------------------------------
--
-- Author(s)	: Juha Kyllišinen
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

ENTITY mul_16bit_u IS
   PORT( 
      clk       : IN     std_logic;
      enable1st : IN     std_logic;
      opa       : IN     std_logic_vector (15 DOWNTO 0);
      opb       : IN     std_logic_vector (15 DOWNTO 0);
      rst_x     : IN     std_logic;
      uprod_hi  : OUT    std_logic_vector (15 DOWNTO 0);  -- lower halfword of the unsigned product
      uprod_lo  : OUT    std_logic_vector (15 DOWNTO 0)   -- upper halfword of the unsigned product
   );

-- Declarations

END mul_16bit_u ;
-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  mul_16bit_u.vhd
--
-- File		: mul_16bit_u.vhd
--
-- Date		: 23:46:11 01/19/07
--
-- Description	: 
--
-- ----------------------------------------------------------------------------
--
-- Author(s)	: Juha Kyllišinen
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

ARCHITECTURE struct_opt OF mul_16bit_u IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL isum_w0  : std_logic_vector(15 DOWNTO 0);
   SIGNAL isum_w16 : std_logic_vector(15 DOWNTO 0);
   SIGNAL isum_w8  : std_logic_vector(16 DOWNTO 0);


   -- Component Declarations
   COMPONENT m16b_uns_s1
   PORT (
      clk       : IN     std_logic ;
      enable1st : IN     std_logic ;
      opa       : IN     std_logic_vector (15 DOWNTO 0);
      opb       : IN     std_logic_vector (15 DOWNTO 0);
      rst_x     : IN     std_logic ;
      isum_w0   : OUT    std_logic_vector (15 DOWNTO 0);
      isum_w16  : OUT    std_logic_vector (15 DOWNTO 0);
      isum_w8   : OUT    std_logic_vector (16 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT m16b_uns_s2
   PORT (
      isum_w0  : IN     std_logic_vector (15 DOWNTO 0);
      isum_w16 : IN     std_logic_vector (15 DOWNTO 0);
      isum_w8  : IN     std_logic_vector (16 DOWNTO 0);
      uprod_hi : OUT    std_logic_vector (15 DOWNTO 0);
      uprod_lo : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;


BEGIN
   -- Instance port mappings.
   I0 : m16b_uns_s1
      PORT MAP (
         clk       => clk,
         enable1st => enable1st,
         opa       => opa,
         opb       => opb,
         rst_x     => rst_x,
         isum_w0   => isum_w0,
         isum_w16  => isum_w16,
         isum_w8   => isum_w8
      );
   I3 : m16b_uns_s2
      PORT MAP (
         isum_w0  => isum_w0,
         isum_w16 => isum_w16,
         isum_w8  => isum_w8,
         uprod_hi => uprod_hi,
         uprod_lo => uprod_lo
      );

END struct_opt;
