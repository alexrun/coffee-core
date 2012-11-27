-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  mu_csa_typ_f.vhd
--
-- File		: mu_csa_typ_f.vhd
--
-- Date		: 23:46:12 01/19/07
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

ENTITY mu_csa_typ_f IS
   PORT( 
      opa : IN     std_logic_vector (31 DOWNTO 0);
      opb : IN     std_logic_vector (31 DOWNTO 0);
      opc : IN     std_logic_vector (1 DOWNTO 0);   -- lsb position 16
      s   : OUT    std_logic_vector (31 DOWNTO 0);
      c   : OUT    std_logic_vector (31 DOWNTO 0)
   );

-- Declarations

END mu_csa_typ_f ;
architecture mu_csa_typ_f_arch of mu_csa_typ_f is
begin

	process(opa, opb, opc)
	begin

		c(0) <= '0';

		for i in 0 to 15 loop
			s(i)   <= opa(i) xor opb(i);
			c(i+1) <= opa(i) and opb(i);
		end loop;

		s(16)   <= opa(16) xor opb(16) xor opc(0);
		s(17)   <= opa(17) xor opb(17) xor opc(1);
		c(17)   <= (opa(16) and opb(16)) or (opa(16) and opc(0)) or
		           (opb(16) and opc(0));
		c(18)   <= (opa(17) and opb(17)) or (opa(17) and opc(1)) or
		           (opb(17) and opc(1));

		for i in 18 to 30 loop
			s(i)   <= opa(i) xor opb(i);
			c(i+1) <= opa(i) and opb(i);
		end loop;

		s(31) <= opa(31) xor opb(31);

	end process;

end mu_csa_typ_f_arch;
