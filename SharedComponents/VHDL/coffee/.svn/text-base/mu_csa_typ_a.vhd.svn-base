-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  mu_csa_typ_a.vhd
--
-- File		: mu_csa_typ_a.vhd
--
-- Date		: 23:46:11 01/19/07
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

ENTITY mu_csa_typ_a IS
   PORT( 
      opa_lo : IN     std_logic_vector (15 DOWNTO 0);
      opa_hi : IN     std_logic_vector (15 DOWNTO 0);
      opb_lo : IN     std_logic_vector (15 DOWNTO 0);
      opb_hi : IN     std_logic_vector (15 DOWNTO 0);
      opc_lo : IN     std_logic_vector (15 DOWNTO 0);
      opc_hi : IN     std_logic_vector (15 DOWNTO 0);
      s      : OUT    std_logic_vector (31 DOWNTO 0);
      c      : OUT    std_logic_vector (32 DOWNTO 0)
   );

-- Declarations

END mu_csa_typ_a ;

architecture mu_csa_typ_a_arch of mu_csa_typ_a is
    signal a, b, d : std_logic_vector(31 downto 0);
begin
    a <= opa_hi & opa_lo;
    b <= opb_hi & opb_lo;
    d <= opc_hi & opc_lo;
    process(a, b, d)
    begin
        for i in 31 downto 1 loop
            s(i) <= a(i) xor b(i) xor d(i);
	        c(i) <= (a(i-1) and b(i-1)) or (a(i-1) and d(i-1)) or (b(i-1) and d(i-1));
        end loop;
        c(0) <= '0';
        s(0) <= a(0) xor b(0) xor d(0);
        c(32) <= (a(31) and b(31)) or (a(31) and d(31)) or (b(31) and d(31));
    end process;
end mu_csa_typ_a_arch;
