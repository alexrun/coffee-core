-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  m16b_opt_s1.vhd
--
-- File		: m16b_opt_s1.vhd
--
-- Date		: 23:46:10 01/19/07
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


ENTITY m16b_opt_s1 IS
   PORT( 
      clk          : IN     std_logic;
      enable1st    : IN     std_logic;
      op_i_type    : IN     std_logic;
      op_ii_type   : IN     std_logic;
      opa          : IN     std_logic_vector (15 DOWNTO 0);
      opb          : IN     std_logic_vector (15 DOWNTO 0);
      rst_x        : IN     std_logic;
      sel16or32    : IN     std_logic;
      isum_w0      : OUT    std_logic_vector (15 DOWNTO 0);
      isum_w16     : OUT    std_logic_vector (15 DOWNTO 0);
      isum_w16_uns : OUT    std_logic_vector (15 DOWNTO 0);
      isum_w8      : OUT    std_logic_vector (16 DOWNTO 0);
      uns          : OUT    std_logic
   );

-- Declarations

END m16b_opt_s1 ;
library ieee;
use ieee.std_logic_unsigned."*";
use ieee.std_logic_unsigned."+";

architecture m16b_opt_s1_arch of m16b_opt_s1 is
	signal alo, ahi, blo, bhi   : std_logic_vector(7 downto 0);
	signal intrm1, intrm2       : std_logic_vector(15 downto 0);
	signal intrm3, intrm4       : std_logic_vector(15 downto 0);
	signal typemaska, typemaskb : std_logic_vector(15 downto 0);
	signal signmaska, signmaskb : std_logic_vector(15 downto 0);
	signal term1, term2, cterm  : std_logic_vector(15 downto 0);
	signal term3                : std_logic_vector(1 downto 0);
begin
	alo <= opa(7 downto 0);
	ahi <= opa(15 downto 8);
	blo <= opb(7 downto 0);
	bhi <= opb(15 downto 8);
	intrm1 <= alo * blo;
	intrm2 <= alo * bhi;
	intrm3 <= ahi * blo;
	intrm4 <= ahi * bhi;

	typemaska <= (others => op_i_type);
	typemaskb <= (others => op_ii_type);
	signmaska <= (others => opa(15));
	signmaskb <= (others => opb(15));

	term1    <= not(opa) and typemaskb and signmaskb;
	term2    <= not(opb) and typemaska and signmaska;
	term3(1) <= op_i_type and op_ii_type and opa(15) and opb(15);
	term3(0) <= (op_i_type and opa(15)) xor (op_ii_type and opb(15));
	cterm    <= term1 + term2 + term3;

	-- no need for reset here, remove later
	process(clk, rst_x)
	begin
		if rst_x = '0' then
			isum_w0      <= (others => '0');
			isum_w8      <= (others => '0');
			isum_w16     <= (others => '0');
			isum_w16_uns <= (others => '0');
			uns          <= '0';
		elsif clk'event and clk = '1' then
			if enable1st = '1' then
				-- selector: unsigned - signed
				uns <= sel16or32;
				-- intermediate values
				isum_w0      <= intrm1;
				isum_w8      <= ('0' & intrm2) + ('0' & intrm3);
				isum_w16     <= intrm4 + cterm;
				isum_w16_uns <= intrm4;
			end if;
		end if;
	end process;

end m16b_opt_s1_arch;
