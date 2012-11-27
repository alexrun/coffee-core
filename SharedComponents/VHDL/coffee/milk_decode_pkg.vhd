-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  milk_decode_pkg.vhd
--
-- File		: milk_decode_pkg.vhd
--
-- Date		: 11:39:24 07/04/06
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
library ieee;
use ieee.std_logic_1164.all;
library coffee;
use coffee.core_constants_pkg.cop_opc;
library milk;
use milk.cop_definitions.all;

package milk_decode_pkg is
	-- Milk comparisons (not defined in cop_definitions.vhd)
	constant milk_opc_cmp_f : std_logic_vector(5 downto 0) := "110000";
	constant milk_opc_cmp_un : std_logic_vector(5 downto 0) := "110001";
	constant milk_opc_cmp_eq : std_logic_vector(5 downto 0) := "110010";
	constant milk_opc_cmp_ueq : std_logic_vector(5 downto 0) := "110011";
	constant milk_opc_cmp_olt : std_logic_vector(5 downto 0) := "110100";
	constant milk_opc_cmp_ult : std_logic_vector(5 downto 0) := "110101";
	constant milk_opc_cmp_ole : std_logic_vector(5 downto 0) := "110110";
	constant milk_opc_cmp_ule : std_logic_vector(5 downto 0) := "110111";
	constant milk_opc_cmp_sf : std_logic_vector(5 downto 0) := "111000";
	constant milk_opc_cmp_ngle : std_logic_vector(5 downto 0) := "111001";
	constant milk_opc_cmp_seq : std_logic_vector(5 downto 0) := "111010";
	constant milk_opc_cmp_ngl : std_logic_vector(5 downto 0) := "111011";
	constant milk_opc_cmp_lt : std_logic_vector(5 downto 0) := "111100";
	constant milk_opc_cmp_nge : std_logic_vector(5 downto 0) := "111101";
	constant milk_opc_cmp_le : std_logic_vector(5 downto 0) := "111110";
	constant milk_opc_cmp_ngt : std_logic_vector(5 downto 0) := "111111";

	function milk_updates_cr(instruction: std_logic_vector) return std_logic;
	function milk_needs_oprnd1(instruction: std_logic_vector) return std_logic;
	function milk_needs_oprnd2(instruction: std_logic_vector) return std_logic;
	function milk_is_mul(instruction: std_logic_vector) return std_logic;
	function milk_is_add_sub(instruction: std_logic_vector) return std_logic;
	function milk_is_div(instruction: std_logic_vector) return std_logic;
	function milk_is_sqrt(instruction: std_logic_vector) return std_logic;
	function milk_is_scycle_data(instruction: std_logic_vector) return std_logic;
	function milk_is_tcycle_data(instruction: std_logic_vector) return std_logic;

end milk_decode_pkg;
-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  milk_decode_pkg.vhd
--
-- File		: milk_decode_pkg.vhd
--
-- Date		: 11:40:21 07/04/06
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
package body milk_decode_pkg is

	function milk_updates_cr(instruction: std_logic_vector) return std_logic is
		variable coffee_oc, oc : std_logic_vector(5 downto 0);
		variable milk_comparison : boolean;
	begin

		assert instruction'length = 32
		report "Invalid call to cop_updates_cr(instruction: std_logic_vector)" & LF & CR
		severity error;

		coffee_oc := instruction(31 downto 26);
		oc        := instruction(5 downto 0);
		milk_comparison := coffee_oc = cop_opc and 
		                   (oc = milk_opc_cmp_f  or oc = milk_opc_cmp_un  or 
		                   oc = milk_opc_cmp_eq  or oc = milk_opc_cmp_ueq  or 
		                   oc = milk_opc_cmp_olt  or oc = milk_opc_cmp_ult  or 
		                   oc = milk_opc_cmp_ole  or oc = milk_opc_cmp_ule  or 
		                   oc = milk_opc_cmp_sf  or oc = milk_opc_cmp_ngle  or 
		                   oc = milk_opc_cmp_seq  or oc = milk_opc_cmp_ngl  or 
		                   oc = milk_opc_cmp_lt  or oc = milk_opc_cmp_nge  or 
		                   oc = milk_opc_cmp_le  or oc = milk_opc_cmp_ngt);
		if milk_comparison then
			return '1';
		else
			return '0';
		end if;
	end milk_updates_cr;

	function milk_needs_oprnd1(instruction: std_logic_vector) return std_logic is
		variable coffee_oc, oc : std_logic_vector(5 downto 0);
	begin
		oc := instruction(5 downto 0);
		coffee_oc := instruction(31 downto 26);
		if oc = cop_nop or coffee_oc /= cop_opc then
			return '0';
		else
			return '1';
		end if;
	end milk_needs_oprnd1;

	function milk_needs_oprnd2(instruction: std_logic_vector) return std_logic is
		variable coffee_oc, oc : std_logic_vector(5 downto 0);
		variable single_source : boolean;
	begin
		oc := instruction(5 downto 0);
		coffee_oc := instruction(31 downto 26);
		single_source := oc = cop_sqrt_s or oc = cop_abs_s or oc = cop_mov_s or oc = cop_neg_s or oc = cop_cvt_s or oc = cop_cvt_w;
		if single_source or oc = cop_nop or coffee_oc /= cop_opc then
			return '0';
		else
			return '1';
		end if;
	end milk_needs_oprnd2;

	function milk_is_mul(instruction: std_logic_vector) return std_logic is
		variable coffee_oc, oc : std_logic_vector(5 downto 0);
	begin
		oc := instruction(5 downto 0);
		coffee_oc := instruction(31 downto 26);
		if oc = cop_mul_s and coffee_oc = cop_opc then
			return '1';
		else
			return '0';
		end if;
	end milk_is_mul;

	function milk_is_add_sub(instruction: std_logic_vector) return std_logic is
		variable coffee_oc, oc : std_logic_vector(5 downto 0);
	begin
		oc := instruction(5 downto 0);
		coffee_oc := instruction(31 downto 26);
		if (oc = cop_add_s or oc = cop_sub_s) and coffee_oc = cop_opc then
			return '1';
		else
			return '0';
		end if;
	end milk_is_add_sub;

	function milk_is_div(instruction: std_logic_vector) return std_logic is
		variable coffee_oc, oc : std_logic_vector(5 downto 0);
	begin
		oc := instruction(5 downto 0);
		coffee_oc := instruction(31 downto 26);
		if oc = cop_div_s and coffee_oc = cop_opc then
			return '1';
		else
			return '0';
		end if;
	end milk_is_div;

	function milk_is_sqrt(instruction: std_logic_vector) return std_logic is
		variable coffee_oc, oc : std_logic_vector(5 downto 0);
	begin
		oc := instruction(5 downto 0);
		coffee_oc := instruction(31 downto 26);
		if oc = cop_sqrt_s and coffee_oc = cop_opc then
			return '1';
		else
			return '0';
		end if;
	end milk_is_sqrt;

	function milk_is_scycle_data(instruction: std_logic_vector) return std_logic is
		variable coffee_oc, oc : std_logic_vector(5 downto 0);
	begin
		oc := instruction(5 downto 0);
		coffee_oc := instruction(31 downto 26);
		if (oc = cop_abs_s or oc = cop_mov_s or oc = cop_neg_s) and coffee_oc = cop_opc then
			return '1';
		else
			return '0';
		end if;
	end milk_is_scycle_data;

	function milk_is_tcycle_data(instruction: std_logic_vector) return std_logic is
		variable coffee_oc, oc : std_logic_vector(5 downto 0);
	begin
		oc := instruction(5 downto 0);
		coffee_oc := instruction(31 downto 26);
		if (oc = cop_cvt_s or oc = cop_cvt_w) and coffee_oc = cop_opc then
			return '1';
		else
			return '0';
		end if;
	end milk_is_tcycle_data;

end milk_decode_pkg;
