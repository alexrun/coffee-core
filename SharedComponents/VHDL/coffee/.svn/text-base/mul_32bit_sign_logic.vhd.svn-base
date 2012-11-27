-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project		: AVEC
--
-- Design		:  mul_32bit_sign_logic.vhd
--
-- File		: mul_32bit_sign_logic.vhd
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

ENTITY mul_32bit_sign_logic IS
   PORT( 
      op_i_type  : IN     std_logic;
      op_ii_type : IN     std_logic;
      corr_term  : OUT    std_logic_vector (31 DOWNTO 0);
      operand_i  : IN     std_logic_vector (31 DOWNTO 0);
      operand_ii : IN     std_logic_vector (31 DOWNTO 0);
      enable     : IN     std_logic;
      clk        : IN     std_logic;
      rst_x      : IN     std_logic
   );

-- Declarations

END mul_32bit_sign_logic ;

architecture mul_32bit_sign_logic_arch of mul_32bit_sign_logic is

	component adder_32bit
		PORT(
		cin  : IN     std_logic;
		opa  : IN     std_logic_vector (31 DOWNTO 0);    
		opb  : IN     std_logic_vector (31 DOWNTO 0);    
		cout : OUT    std_logic;                         
		sum  : OUT    std_logic_vector (31 DOWNTO 0)     
		);
	end component;



	signal opa, opb    : std_logic_vector(31 downto 0);
	signal opc         : std_logic;
	signal cin_a,cin_b : std_logic;

	signal type_mask_a : std_logic_vector(31 downto 0);
	signal type_mask_b : std_logic_vector(31 downto 0);
	signal sign_mask_a : std_logic_vector(31 downto 0);
	signal sign_mask_b : std_logic_vector(31 downto 0);

	signal s, c      : std_logic_vector(31 downto 0);


begin
--------------------------------------------------------------------------
-- For correction term logic, see documentation of the multiplier unit
--------------------------------------------------------------------------
-- if operand_i < 0 and operand_ii < 0 
-- => correction term = not(operand_i) + not(operand_ii) + 2
-- if operand_i > 0 and operand_ii < 0 
-- => correction term = not(operand_i) + 1
-- if operand_i < 0 and operand_ii > 0 
-- => correction term = not(operand_ii) + 1
-- if operand_i > 0 and operand_ii > 0 
-- => correction term = 0
--------------------------------------------------------------------------
	type_mask_a <= (others => op_i_type);
	type_mask_b <= (others => op_ii_type);
	sign_mask_a <= (others => operand_i(31));
	sign_mask_b <= (others => operand_ii(31));

	opa    <= not(operand_i)  and type_mask_b and sign_mask_b;
	opb    <= not(operand_ii) and type_mask_a and sign_mask_a;

	cin_b  <= op_i_type and operand_i(31);
	opc    <= cin_b;


	-- Reducing terms with carry save adding
	-- s - sum and c - carry
	process(clk, rst_x)
	begin
		if rst_x = '0' then
			s <= (others => '0');
			c <= (others => '0');
			cin_a <= '0';
		elsif clk'event and clk = '1' then
			if enable = '1' then
				s(0) <= opa(0) xor opb(0) xor opc;
				c(0) <= '0';
				c(1) <= (opa(0) and opb(0)) or (opa(0) and opc) or (opb(0) and opc);
		
				for i in 1 to 30 loop
					s(i)   <= opa(i) xor opb(i);
					c(i+1) <= opa(i) and opb(i);
				end loop;

				s(31) <= opa(31) xor opb(31);

				cin_a  <= op_ii_type and operand_ii(31);
			end if;
		end if;
	end process;

	-- Final correction term is obtained using 32 bit adder
	adder : adder_32bit
	port map(
		cin		=> cin_a,
		opa		=> s,
		opb		=> c,
		cout    => open,
		sum		=> corr_term
		);

end mul_32bit_sign_logic_arch;

