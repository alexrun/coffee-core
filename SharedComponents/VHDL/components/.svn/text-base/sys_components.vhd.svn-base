----------------------------------------------------------------------
-- Department of Computer Systems, Tampere University of Technology  --
----------------------------------------------------------------------
-- Project      : DMA_platform
-- Author       : Fabio Garzia
-- e-mail       : fabio.garzia@tut.fi
-- Date         : 10-Mar-2008 11:16:19
-- File         : sys_components.vhd
-- Design       : 
----------------------------------------------------------------------
-- Description : 
----------------------------------------------------------------------
--Copyright (c) 2008, Tampere University of Technology.
--All rights reserved.

--Redistribution and use in source and binary forms, with or without modification,
--are permitted provided that the following conditions are met:
--* Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--* Redistributions in binary form must reproduce the above copyright notice,
-- this list of conditions and the following disclaimer in the documentation
-- and/or other materials provided with the distribution.
--* Neither the name of Tampere University of Technology nor the names of its
-- contributors may be used to endorse or promote products derived from this
-- software without specific prior written permission.

--THIS HARDWARE DESCRIPTION OR SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
--CONTRIBUTORS << AS IS >> AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND NONINFRINGEMENT AND
--FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
--OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
--EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
--PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
--BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--ARISING IN ANY WAY OUT OF THE USE OF THIS HARDWARE DESCRIPTION OR SOFTWARE, EVEN
--IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
--------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------
--
-- PACKAGE HEADER
--
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY components;
USE components.sys_definitions.ALL;

PACKAGE sys_components IS

   COMPONENT clk_gate_register
      GENERIC (
         reg_width : POSITIVE);

      PORT (
         clk       : IN  STD_LOGIC;
         N_clk       : IN  STD_LOGIC;
         reset   : IN  STD_LOGIC;
         data_in   : IN  STD_LOGIC_VECTOR(reg_width - 1 DOWNTO 0);
         gated_clk : OUT STD_LOGIC_VECTOR(reg_width - 1 DOWNTO 0));
   END COMPONENT;


   COMPONENT WE_register
      GENERIC(reg_width   :     INTEGER := word_width;
              reset_value : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0')); 
      PORT( clk           : IN  STD_LOGIC;
            reset         : IN  STD_LOGIC;
            we            : IN  STD_LOGIC;
            data_in       : IN  STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);
            data_out      : OUT STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0) );
   END COMPONENT;




   COMPONENT data_register
      GENERIC(reg_width :     INTEGER := word_width);
      PORT( clk         : IN  STD_LOGIC;
            reset       : IN  STD_LOGIC;
            data_in     : IN  STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);
            data_out    : OUT STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0) );
   END COMPONENT;


   COMPONENT nop_register
      GENERIC(reg_width :     INTEGER := word_width);
      PORT(
         clk            : IN  STD_LOGIC;
         reset          : IN  STD_LOGIC;
         data_in        : IN  STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);
         data_out       : OUT STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0)
         );
   END COMPONENT;


   COMPONENT WEDFF
      PORT( clk   : IN  STD_LOGIC;
            reset : IN  STD_LOGIC;
            we    : IN  STD_LOGIC;
            d     : IN  STD_LOGIC;
            q     : OUT STD_LOGIC );
   END COMPONENT;


   COMPONENT data_ff
      PORT( clk   : IN  STD_LOGIC;
            reset : IN  STD_LOGIC;
            d     : IN  STD_LOGIC;
            q     : OUT STD_LOGIC );
   END COMPONENT;

-- component data_ff_1
-- port( clk : in Std_logic;
-- reset : in Std_logic;
-- d : in Std_logic;
-- q : out Std_logic );
-- end component;

   COMPONENT decoder3_8
      PORT( dec_addr : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
            dec_out  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );
   END COMPONENT;
   
   COMPONENT decoder5_32
      PORT( dec_addr : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            dec_out  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
   END COMPONENT;

   COMPONENT decoder4_16
      PORT
         (
            data : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
            eq0  : OUT STD_LOGIC;
            eq1  : OUT STD_LOGIC;
            eq10 : OUT STD_LOGIC;
            eq11 : OUT STD_LOGIC;
            eq12 : OUT STD_LOGIC;
            eq13 : OUT STD_LOGIC;
            eq14 : OUT STD_LOGIC;
            eq15 : OUT STD_LOGIC;
            eq2  : OUT STD_LOGIC;
            eq3  : OUT STD_LOGIC;
            eq4  : OUT STD_LOGIC;
            eq5  : OUT STD_LOGIC;
            eq6  : OUT STD_LOGIC;
            eq7  : OUT STD_LOGIC;
            eq8  : OUT STD_LOGIC;
            eq9  : OUT STD_LOGIC
            );
   END COMPONENT;

   COMPONENT gp_counter
      GENERIC (
         counter_width : INTEGER := 4);

      PORT (
         clk       : IN  STD_LOGIC;
         en        : IN  STD_LOGIC;     -- active low
         reset     : IN  STD_LOGIC;     -- active low
         tc        : OUT STD_LOGIC;
         output    : OUT STD_LOGIC_VECTOR(counter_width - 1 DOWNTO 0);
         max_value : IN  STD_LOGIC_VECTOR(counter_width - 1 DOWNTO 0)  -- it needs to be always driven to a coherent value

         );

   END COMPONENT;

-- component tristate_buffer
-- generic(width : integer);
-- port( tristate_buffer_oe : in std_logic;
-- tristate_buffer_data_in : in std_logic_vector(buffer_width-1 downto 0);
-- tristate_buffer_data_out : out std_logic_vector(buffer_width-1 downto 0) );
-- end component;


-- component MY_8IN_MUX
-- generic (width : integer);
-- port( in_a : in Std_logic_vector(width-1 downto 0);
-- in_b : in Std_logic_vector(width-1 downto 0);
-- in_c : in Std_logic_vector(width-1 downto 0);
-- in_d : in Std_logic_vector(width-1 downto 0);
-- in_e : in Std_logic_vector(width-1 downto 0);
-- in_f : in Std_logic_vector(width-1 downto 0);
-- in_g : in Std_logic_vector(width-1 downto 0);
-- in_h : in Std_logic_vector(width-1 downto 0);
-- sel : in Std_logic_vector(2 downto 0);
-- output : out Std_logic_vector(width-1 downto 0) );
-- end component;



-- component DELAY_SELECT_MUX
-- generic (width : integer := 8);
-- port( in_a : in Std_logic_vector(width-1 downto 0);
-- in_b : in Std_logic_vector(width-1 downto 0);
-- in_c : in Std_logic_vector(width-1 downto 0);
-- in_d : in Std_logic_vector(width-1 downto 0);
-- in_e : in Std_logic_vector(width-1 downto 0);
-- in_f : in Std_logic_vector(width-1 downto 0);
-- in_g : in Std_logic_vector(width-1 downto 0);
-- in_h : in Std_logic_vector(width-1 downto 0);
-- sel : in Std_logic_vector(6 downto 0);
-- output : out Std_logic_vector(width-1 downto 0)
-- );
-- end component;

   COMPONENT MUX2to1
      GENERIC ( width :     INTEGER);
      PORT(in_a       : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
           in_b       : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
           sel        : IN  STD_LOGIC;
           output     : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0) );
   END COMPONENT;


   COMPONENT MUX4to1
      GENERIC (width :     INTEGER);
      PORT( in_a     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_b     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_c     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_d     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            sel      : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            output   : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0) );
   END COMPONENT;

   COMPONENT MUX8to1
      GENERIC (width :     INTEGER);
      PORT( in_a     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_b     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_c     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_d     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_e     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_f     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_g     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_h     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            sel      : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
            output   : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0) );
   END COMPONENT;

   COMPONENT MUX16to1
      GENERIC (width :     INTEGER);
      PORT( in_a     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_b     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_c     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_d     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_e     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_f     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_g     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_h     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_i     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_l     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_m     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_n     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_o     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_p     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_q     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            in_r     : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            sel      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            output   : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0)
            );
   END COMPONENT;
-- COMPONENT SIMPLE_MUX_2
-- PORT( in_a : IN STD_LOGIC;
-- in_b : IN STD_LOGIC;
-- sel : IN STD_LOGIC;
-- output : OUT STD_LOGIC );
-- END COMPONENT;

   COMPONENT register_chain
      GENERIC ( length    :     INTEGER;
                width     :     INTEGER);
      PORT( clk           : IN  STD_LOGIC;
            reset         : IN  STD_LOGIC;
            enable        : IN  STD_LOGIC;
            reg_chain_in  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            reg_chain_out : OUT bus_mxn );
   END COMPONENT;

   COMPONENT simple_register_chain
      GENERIC ( length    :     INTEGER;
                width     :     INTEGER);
      PORT( clk           : IN  STD_LOGIC;
            reset         : IN  STD_LOGIC;
            enable        : IN  STD_LOGIC;
            reg_chain_in  : IN  STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            reg_chain_out : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0) );
   END COMPONENT;

-- component ff_variable_chain
-- generic ( length : integer);
-- port( clk : in std_logic;
-- reset : in std_logic;
-- enable : in Std_logic;
-- ff_chain_in : in Std_logic;
-- ff_chain_out : out Std_logic_vector(length downto 0) );
-- end component;

   COMPONENT ff_chain
      GENERIC ( length   :     INTEGER);
      PORT( clk          : IN  STD_LOGIC;
            reset        : IN  STD_LOGIC;
            enable       : IN  STD_LOGIC;
            ff_chain_in  : IN  STD_LOGIC;
            ff_chain_out : OUT STD_LOGIC );
   END COMPONENT;


END sys_components;



PACKAGE BODY sys_components IS
END sys_components;



