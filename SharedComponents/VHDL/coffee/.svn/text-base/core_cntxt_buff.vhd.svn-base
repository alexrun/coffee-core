-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_cntxt_buff.vhd
--
-- File		: core_cntxt_buff.vhd
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

ENTITY core_cntxt_buff IS
   PORT( 
      clk       : IN     std_logic;
      enable    : IN     std_logic_vector (3 DOWNTO 0);
      rst_x     : IN     std_logic;
      pc_in     : IN     std_logic_vector (31 DOWNTO 0);
      sel_entry : IN     std_logic_vector (1 DOWNTO 0);
      psr_in    : IN     std_logic_vector (7 DOWNTO 0);
      psr       : OUT    std_logic_vector (7 DOWNTO 0);
      addr      : OUT    std_logic_vector (31 DOWNTO 0)
   );

-- Declarations

END core_cntxt_buff ;

architecture core_cntxt_buff_arch of core_cntxt_buff is
    type a_regs is array (0 to 3) of std_logic_vector(31 downto 0);
    type p_regs is array (0 to 3) of std_logic_vector(7 downto 0);
    signal addr_bff : a_regs;
    signal psr_bff  : p_regs;
begin
    process(clk, rst_x)
    begin
        if rst_x = '0' then
            addr_bff(0)     <= (others => '0');
            addr_bff(1)     <= (others => '0');
            addr_bff(2)     <= (others => '0');
            addr_bff(3)     <= (others => '0');
            psr_bff(0)      <= (others => '0');
            psr_bff(1)      <= (others => '0');
            psr_bff(2)      <= (others => '0');
            psr_bff(3)      <= (others => '0');
        elsif clk'event and clk = '1' then
            if enable(0) = '1' then
                addr_bff(0) <= pc_in;
                psr_bff(0)  <= psr_in;
			end if;
            if enable(1) = '1' then
                addr_bff(1) <= addr_bff(0);
                psr_bff(1)  <= psr_bff(0);
			end if;
            if enable(2) = '1' then
                addr_bff(2) <= addr_bff(1);
                psr_bff(2)  <= psr_bff(1);
			end if;
            if enable(3) = '1' then
                addr_bff(3) <= addr_bff(2);
                psr_bff(3)  <= psr_bff(2);
			end if;
        end if;
    end process;

    -- selecting the outputs
    process(sel_entry, addr_bff, psr_bff)
    begin
        case sel_entry is
            when "00" =>  -- in stage 1
                psr         <= psr_bff(0);
                addr        <= addr_bff(0);
            when "01" =>  -- in stage 2
                psr         <= psr_bff(1);
                addr        <= addr_bff(1);
            when "10" =>  -- in stage 3
                psr         <= psr_bff(2);
                addr        <= addr_bff(2);
            when "11" =>  -- in stage 4
                psr         <= psr_bff(3);
                addr        <= addr_bff(3);
            when others =>  --
                psr         <= psr_bff(3);
                addr        <= addr_bff(3);
        end case;
    end process;

end core_cntxt_buff_arch;















