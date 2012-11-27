-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  m16b_opt_s2.vhd
--
-- File		: m16b_opt_s2.vhd
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


ENTITY m16b_opt_s2 IS
   PORT( 
      isum_w0      : IN     std_logic_vector (15 DOWNTO 0);
      isum_w16     : IN     std_logic_vector (15 DOWNTO 0);
      isum_w16_uns : IN     std_logic_vector (15 DOWNTO 0);
      isum_w8      : IN     std_logic_vector (16 DOWNTO 0);
      uns          : IN     std_logic;
      prod_full    : OUT    std_logic_vector (31 DOWNTO 0);
      prod_hi      : OUT    std_logic_vector (15 DOWNTO 0);
      prod_lo      : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END m16b_opt_s2 ;
library ieee;
use ieee.std_logic_unsigned."+";

architecture m16b_opt_s2_arch of m16b_opt_s2 is
	signal hi_term : std_logic_vector(15 downto 0);
	signal sum     : std_logic_vector(31 downto 0);
begin
	hi_term <= isum_w16_uns when uns = '1' else isum_w16;
	sum <= (hi_term & "0000000000000000") + 
	       ("0000000" & isum_w8 & "00000000") + 
	       isum_w0;
	prod_full <= sum;
	prod_lo   <= sum(15 downto 0);
	prod_hi   <= sum(31 downto 16);

end m16b_opt_s2_arch;
