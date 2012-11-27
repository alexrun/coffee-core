-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  core_addr_chk_ovfl.vhd
--
-- File		: core_addr_chk_ovfl.vhd
--
-- Date		: 23:46:17 01/19/07
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

ENTITY core_addr_chk_ovfl IS
   PORT( 
      carry      : IN     std_logic;
      base_msb   : IN     std_logic;
      offset_msb : IN     std_logic;
      addr_msb   : IN     std_logic;
      addr_ovfl  : OUT    std_logic;
      chk        : IN     std_logic
   );

-- Declarations

END core_addr_chk_ovfl ;

architecture core_addr_chk_ovfl_arch of core_addr_chk_ovfl is

    signal overflow_i, overflow_ii      : std_logic;

begin
-- Two cases of address overflow can be detected:
-- case 1: Carry out generated when MSB of the base is one
-- and the offset is positive(msb of the offset is 0) that
-- is indexing forward from end of the memory
-- case 2: msb of the result address is one when msb
-- of the base is zero before adding and the offset is negative.
-- that means indexing backward from the beginning of the memory

    overflow_i  <= carry and base_msb and not(offset_msb) and chk;
    overflow_ii <= addr_msb and not(base_msb) and offset_msb and chk;

    addr_ovfl   <= overflow_i or overflow_ii;

end core_addr_chk_ovfl_arch;
