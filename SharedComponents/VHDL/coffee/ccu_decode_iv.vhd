-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  ccu_decode_iv.vhd
--
-- File		: ccu_decode_iv.vhd
--
-- Date		: 23:46:25 01/19/07
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

ENTITY ccu_decode_iv IS
   PORT( 
      ccb_access        : IN     std_logic;
      clk               : IN     std_logic;
      enable            : IN     std_logic;
      opcode            : IN     std_logic_vector (5 DOWNTO 0);
      rst_x             : IN     std_logic;
      mem_load          : OUT    std_logic;
      sel_data4p        : OUT    std_logic_vector (1 DOWNTO 0);
      sel_data_from_cop : OUT    std_logic
   );

-- Declarations

END ccu_decode_iv ;

architecture ccu_decode_iv_arch of ccu_decode_iv is
begin

	process(clk, rst_x)
	begin
		if rst_x = '0' then
			sel_data4p <= "00";
			mem_load   <= '0';
			sel_data_from_cop <= '0';
		elsif clk'event and clk = '1' then
			if enable = '1' then
				case opcode is
					when muli_opc =>
						sel_data4p <= "01";
					when muls_opc =>
						sel_data4p <= "01";
					when mulu_opc =>
						sel_data4p <= "01";
					when mulus_opc =>
						sel_data4p <= "01";
					when mulhi_opc =>
						sel_data4p <= "10";
					when ld_opc =>
						sel_data4p <= "11";
					when others =>
						sel_data4p <= "00";
				end case;
				if opcode = ld_opc then
					mem_load <= not ccb_access;
				else
					mem_load <= '0';
				end if;
				if opcode = movfc_opc then
					sel_data_from_cop <= '0';
				else
					sel_data_from_cop <= '1';
				end if;
			end if;
		end if;
	end process;

end ccu_decode_iv_arch;

