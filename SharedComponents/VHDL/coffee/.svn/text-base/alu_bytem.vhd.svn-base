-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  alu_bytem.vhd
--
-- File		: alu_bytem.vhd
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

LIBRARY coffee;
USE coffee.core_constants_pkg.all;

ENTITY alu_bytem IS
   PORT( 
      opa  : IN     std_logic_vector (31 DOWNTO 0);
      opb  : IN     std_logic_vector (15 DOWNTO 0);
      oper : IN     std_logic_vector (1 DOWNTO 0);
      rslt : OUT    std_logic_vector (31 DOWNTO 0)
   );

-- Declarations

END alu_bytem ;

architecture alu_bytem_arch of alu_bytem is
begin
process(opa, opb, oper)
begin
    case oper is
    when alu_bm_exb =>	-- exb
        case opb(1 downto 0) is
	    when "00" => 	-- byte 0
	        rslt <= "000000000000000000000000" & opa(7 downto 0);
	    when "01" => 	-- byte 1
		    rslt <= "000000000000000000000000" & opa(15 downto 8);
	    when "10" => 	-- byte 2
	        rslt <= "000000000000000000000000" & opa(23 downto 16);
	    when "11" => 	-- byte 3
		    rslt <= "000000000000000000000000" & opa(31 downto 24);
	    when others =>	-- just for simulation
	        rslt <= (others => '1');
	    end case;
	when alu_bm_exh =>	-- exh
	    if opb(0) = '0' then	-- halfword 0
	        rslt <= "0000000000000000" & opa(15 downto 0);
	    else					-- halfword 1
		    rslt <= "0000000000000000" & opa(31 downto 16);
	    end if;
	when alu_bm_conb =>	-- conb
	    rslt <= "0000000000000000" & opa(7 downto 0) & opb(7 downto 0);
	when alu_bm_conh =>	-- conh
	    rslt <= opb(15 downto 0) & opa(15 downto 0);
	when others =>	-- just for simulation
	    rslt <= (others => '1');
    end case;
end process;		
end alu_bytem_arch;
