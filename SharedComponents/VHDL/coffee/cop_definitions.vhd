-----------------------------------------------------------------------------------------------------------
--
--                                    MILK COPROCESSOR BASIC DEFINITIONS
--
-- This file contains basic parameters definitions.	
--
-- Created by Claudio Brunelli, 2006
--
-----------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- The contents of this file are subject to the LGPL License.
-- You may not use this file except in compliance with the LGPL License.
-- You may see a copy of the LGPL License in the LGPL_license.txt file, present
-- in the main directory, or on the internet at the URL:
-- http://www.gnu.org/copyleft/lesser.html
--
-- This VHDL code is distributed on an "AS IS" basis,
-- WITHOUT WARRANTY OF ANY KIND, either express or implied.
-- See the LGPL License for the specific language governing rights and 
-- limitations under the LGPL License.
--
-- This code was initially developed at "Department of Digital and Computer
-- Systems", Tampere University of Technology (TUT), Tampere, Finland.
--
-- Please direct any comments regarding this license to claudio.brunelli@tut.fi
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
LIBRARY components;
use components.sys_definitions.all;


package cop_definitions is 

-----------------------------------------------------------------------------------------------------------
--
-- bus width configuration
--
-----------------------------------------------------------------------------------------------------------

    constant core_rf_width        : positive := 5;   -- width of the address of the destination register (inside the RF of the core) for Milk instructions
--     constant word_width           : positive := 32;  -- data bus width
    constant sreg_width           : positive := 17;  -- status register width
    constant buffer_width         : positive := 32;  -- RF output tristate buffers width
    constant RF_width             : positive := 8;   -- number of general purpose registers                            
    constant instr_word_width     : positive := 24;  -- amount of significative bits loaded in control register
    constant exceptions_amount    : positive := 21;  -- overall number of "internal" exceptions;
 
    constant RF_exceptions_amount : positive := 1;   -- number of "internal" exceptions related to the register file
    constant flags_amount         : positive := 7;   -- number of status flag bits
    constant cop_opcode_width     : positive := 6;   -- amount of bits of the "opcode" field of the instruction word

-----------------------------------------------------------------------------------------------------------
--
-- ctrl_logic configuration
--
-----------------------------------------------------------------------------------------------------------

    constant wrbck_sgls_width     : positive := 8;   -- wrbck signals set in ctrl_logic
--     constant m                    : positive := 12;  -- amount of sub-buses in the register delay chain (ctrl_logic)
--     constant n                    : positive := core_rf_width;   -- width of sub-buses in the register delay chain (ctrl_logic)

    constant conv_clk_cycles      : positive := 2;   -- latency (in clk cycles) required by conv
    constant trunc_clk_cycles     : positive := 2;   -- latency (in clk cycles) required by trunc
    constant mul_clk_cycles       : positive := 3;   -- latency (in clk cycles) required by mul
    constant div_clk_cycles       : positive := 12;  -- latency (in clk cycles) required by div
    constant add_clk_cycles       : positive := 5;   -- latency (in clk cycles) required by add
    constant sqrt_clk_cycles      : positive := 8;   -- latency (in clk cycles) required by sqrt

-----------------------------------------------------------------------------------------------------------
--
-- main constants
--
-----------------------------------------------------------------------------------------------------------

  --  constant reset_active       : Std_logic := '1';  -- '1' -> positive logic 
--     constant reset_active       : Std_logic := '0'; -- active low (integration with coffee)
--     constant we_active          : Std_logic := '1';
--     constant oe_active          : Std_logic := '1';
     constant ovfw_active        : Std_logic := '1';
     constant underfw_active     : Std_logic := '1';

-----------------------------------------------------------------------------------------------------------
--
-- FUs insertion generics' boolean values
--
-----------------------------------------------------------------------------------------------------------

    constant conv_flag_value    : integer := 1;
    constant trunc_flag_value   : integer := 1;
    constant mul_flag_value     : integer := 1;
    constant div_flag_value     : integer := 1;
    constant add_flag_value     : integer := 1;
    constant sqrt_flag_value    : integer := 1;
    constant compare_flag_value : integer := 1;

-----------------------------------------------------------------------------------------------------------
--
-- "integer_sqrt" block configuration constants
--
-----------------------------------------------------------------------------------------------------------

    constant radicand_width : positive := 52;  -- operand width
    constant sqrt_width     : positive := 26;  -- result width
    constant rem_width      : positive := 28;  -- remainder width
    constant k_max          : positive := 26;  -- number of "iterations" in the algorithm
    
-----------------------------------------------------------------------------------------------------------
--
-- "integer_divider" block configuration constants
--
-----------------------------------------------------------------------------------------------------------

    constant dividend_width     : positive := 24;  -- operand width
    constant divisor_width      : positive := 24;  -- operand width
    constant quotient_width     : positive := 25;  -- result width
    constant division_rem_width : positive := 25;  -- remainder width
    constant div_k_max          : positive := 25;  -- number of "iterations" in the algorithm

    type bus_8Xd is array (8 downto 0) of std_logic_vector(divisor_width+1 downto 0);

-----------------------------------------------------------------------------------------------------------
--
-- user defined types
--
-----------------------------------------------------------------------------------------------------------

    type bus8X32 is array (RF_width-1 downto 0) of std_logic_vector(word_width-1 downto 0);

--     type bus_mXn is array (m downto 0) of std_logic_vector(n-1 downto 0);
      
    subtype rf_addr is std_logic_vector(2 downto 0);  --  RF registers' address bits

    subtype wb_code is std_logic_vector(3 downto 0);  --  result writeback logic's "indexing" bits

    subtype cop_opcode is std_logic_vector(cop_opcode_width-1 downto 0);  --  opcode specification bits

-----------------------------------------------------------------------------------------------------------
--
-- instruction set mnemonics
--
-----------------------------------------------------------------------------------------------------------
-- opcodes are the same as those in the MIPS' coprocessor instruction set
    
    constant cop_add_s   : cop_opcode := "000000";  -- adds two FP single precision numbers                        : ADD.S
    constant cop_sub_s   : cop_opcode := "000001";  -- subtracts two FP single precision numbers                   : SUB.S
    constant cop_mul_s   : cop_opcode := "000010";  -- multiplies two FP single precision numbers                  : MUL.S 
    constant cop_div_s   : cop_opcode := "000011";  -- divides two FP single precision numbers                     : DIV.S
    constant cop_sqrt_s  : cop_opcode := "000100";  -- extracts the square root of a FP single precision number    : SQRT.S
    constant cop_abs_s   : cop_opcode := "000101";  -- extracts the absolute value of a FP single precision number : ABS.S
    constant cop_mov_s   : cop_opcode := "000110";  -- moves a value from a register to another                    : MOV.S
    constant cop_neg_s   : cop_opcode := "000111";  -- inverts the sign of a single precision FP number            : NEG.S
    constant cop_nop     : cop_opcode := "001000";  -- no operation executed                                       : NOP.S
    constant nop         : cop_opcode := "001000";  -- no operation executed                                       : NOP.S
    constant cop_trunc_w : cop_opcode := "001101"; 
    constant cop_cvt_s   : cop_opcode := "100000";  -- converts an integer into a single precision FP              : CVT.S  
    constant cop_cvt_w   : cop_opcode := "100100";  -- converts a single precision FP into an integer              : CVT.W

-- Note: with QRISC processor, the comparison is obtained through a set of 16 sub-instructions whose opcodes are charaterized by the two
-- most-significant bits set. With Coffee RISC the operands are compared, and their relationship is encoded using 3 "flag" bits (LT, EQ, UNORDERED)

------------------------------------------------------------------------------------------------------------
--
-- result writeback selection signals
--
------------------------------------------------------------------------------------------------------------
   
    constant wb_cvt_s     : wb_code := "0000";
    constant wb_trunc_w   : wb_code := "0001";
    constant wb_mul_s     : wb_code := "0010";
    constant wb_div_s     : wb_code := "0011";
    constant wb_addsub_s  : wb_code := "0100";  
    constant wb_sqrt_s    : wb_code := "0101";
    constant wb_abs_s     : wb_code := "0110";
    constant wb_mov_s     : wb_code := "0111";
    constant wb_neg_s     : wb_code := "1000";
    constant wb_compare_s : wb_code := "1001";

end cop_definitions ;



package body cop_definitions is
end cop_definitions;











