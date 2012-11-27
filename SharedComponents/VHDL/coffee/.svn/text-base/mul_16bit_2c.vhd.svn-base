-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  mul_16bit_2c.vhd
--
-- File		: mul_16bit_2c.vhd
--
-- Date		: 23:46:10 01/19/07
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
USE ieee.std_logic_arith.all;

ENTITY mul_16bit_2c IS
   PORT( 
      clk        : IN     std_logic;
      enable1st  : IN     std_logic;                       -- Enable step 1
      op_i_type  : IN     std_logic;
      op_ii_type : IN     std_logic;
      opa        : IN     std_logic_vector (15 DOWNTO 0);
      opb        : IN     std_logic_vector (15 DOWNTO 0);
      rst_x      : IN     std_logic;
      sel16or32  : IN     std_logic;
      prod_full  : OUT    std_logic_vector (31 DOWNTO 0);  -- 32 bit product
      prod_hi    : OUT    std_logic_vector (15 DOWNTO 0);  -- Upper halfword of the product
      prod_lo    : OUT    std_logic_vector (15 DOWNTO 0)   -- Lower halfword of the product
   );

-- Declarations

END mul_16bit_2c ;
-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  mul_16bit_2c.vhd
--
-- File		: mul_16bit_2c.vhd
--
-- Date		: 23:46:10 01/19/07
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


ARCHITECTURE struct_opt OF mul_16bit_2c IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL isum_w0      : std_logic_vector(15 DOWNTO 0);
   SIGNAL isum_w16     : std_logic_vector(15 DOWNTO 0);
   SIGNAL isum_w16_uns : std_logic_vector(15 DOWNTO 0);
   SIGNAL isum_w8      : std_logic_vector(16 DOWNTO 0);
   SIGNAL uns          : std_logic;


   -- Component Declarations
   COMPONENT m16b_opt_s1
   PORT (
      clk          : IN     std_logic ;
      enable1st    : IN     std_logic ;
      op_i_type    : IN     std_logic ;
      op_ii_type   : IN     std_logic ;
      opa          : IN     std_logic_vector (15 DOWNTO 0);
      opb          : IN     std_logic_vector (15 DOWNTO 0);
      rst_x        : IN     std_logic ;
      sel16or32    : IN     std_logic ;
      isum_w0      : OUT    std_logic_vector (15 DOWNTO 0);
      isum_w16     : OUT    std_logic_vector (15 DOWNTO 0);
      isum_w16_uns : OUT    std_logic_vector (15 DOWNTO 0);
      isum_w8      : OUT    std_logic_vector (16 DOWNTO 0);
      uns          : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT m16b_opt_s2
   PORT (
      isum_w0      : IN     std_logic_vector (15 DOWNTO 0);
      isum_w16     : IN     std_logic_vector (15 DOWNTO 0);
      isum_w16_uns : IN     std_logic_vector (15 DOWNTO 0);
      isum_w8      : IN     std_logic_vector (16 DOWNTO 0);
      uns          : IN     std_logic ;
      prod_full    : OUT    std_logic_vector (31 DOWNTO 0);
      prod_hi      : OUT    std_logic_vector (15 DOWNTO 0);
      prod_lo      : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;


BEGIN
   -- Instance port mappings.
   I0 : m16b_opt_s1
      PORT MAP (
         clk          => clk,
         enable1st    => enable1st,
         op_i_type    => op_i_type,
         op_ii_type   => op_ii_type,
         opa          => opa,
         opb          => opb,
         rst_x        => rst_x,
         sel16or32    => sel16or32,
         isum_w0      => isum_w0,
         isum_w16     => isum_w16,
         isum_w16_uns => isum_w16_uns,
         isum_w8      => isum_w8,
         uns          => uns
      );
   I1 : m16b_opt_s2
      PORT MAP (
         isum_w0      => isum_w0,
         isum_w16     => isum_w16,
         isum_w16_uns => isum_w16_uns,
         isum_w8      => isum_w8,
         uns          => uns,
         prod_full    => prod_full,
         prod_hi      => prod_hi,
         prod_lo      => prod_lo
      );

END struct_opt;
