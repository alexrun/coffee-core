-- ----------------------------------------------------------------------------
-- Institute of Digital and Computer Systems, Tampere University of Technology
-- ----------------------------------------------------------------------------
--
-- Project              : AVEC
--
-- Design               :  core_decode.vhd
--
-- File         : core_decode.vhd
--
-- Date         : 23:46:09 01/19/07
--
-- Description  : 
--
-- ----------------------------------------------------------------------------
--
-- Author(s)    : Juha Kylliäinen
--
-- Status               : Pre-release, not fully tested
--
-- References   : http://coffee.tut.fi/
--
-- ----------------------------------------------------------------------------
--
-- Limitations  : 
--
-- Known Errors         : <no, only unknowns as it stands...>
--
-- ----------------------------------------------------------------------------
--
-- Revision list        : 
--
-- ----------------------------------------------------------------------------
--Copyright (c) 2004, Tampere University of Technology.
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
USE ieee.std_logic_1164.ALL;

LIBRARY coffee;
USE coffee.core_constants_pkg.ALL;

 LIBRARY coffee;
 USE coffee.milk_decode_pkg.ALL;

ENTITY core_decode IS
   GENERIC (
      FPU_FU          :     BOOLEAN );
   PORT(
      rst_x            : IN  STD_LOGIC;
      i_word           : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
      current_psr      : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
      clk              : IN  STD_LOGIC;
      new_psr          : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      extended_imm     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      exception_q      : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
      en               : IN  STD_LOGIC;
      sel_op_i         : OUT STD_LOGIC;
      sel_op_ii        : OUT STD_LOGIC;
      flush            : IN  STD_LOGIC;
      rs_to_read       : OUT STD_LOGIC;
      sreg_indx1       : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
      sreg_indx2       : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
      jmp_offset       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      creg_indx        : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
      opc              : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
      cexbit           : OUT STD_LOGIC;
      condition        : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
      fpu_opc          : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
      trgt_indx        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
      start_fpu_mul    : OUT STD_LOGIC;
      start_fpu_add    : OUT STD_LOGIC;
      start_fpu_div    : OUT STD_LOGIC;
      start_fpu_sqrt   : OUT STD_LOGIC;
      start_fpu_scycle : OUT STD_LOGIC;
      start_fpu_tcycle : OUT STD_LOGIC;
      start_core_pipe  : OUT STD_LOGIC;
      cpu_writes_rf    : IN  STD_LOGIC
      );

-- Declarations

END core_decode;
-- Extend immediate operands
-- Check for instruction violations
-- Calculate new status flags
-- drive operand select multiplexers
------------------------------------------------------------------------------

ARCHITECTURE core_decode_arch OF core_decode IS

   -- Info extracted from instruction word
   SIGNAL opcode : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL cex    : STD_LOGIC;           -- conditional execution bit
   SIGNAL ishift : STD_LOGIC;           -- bit to differentiate imm shift

   -- status flags
   SIGNAL IE   : STD_LOGIC;             -- bit to enable interrupts
   SIGNAL IL   : STD_LOGIC;             -- instruction length (encoding mode) bit
   SIGNAL RSWR : STD_LOGIC;             -- select bit for register set to write
   SIGNAL RSRD : STD_LOGIC;             -- select bit for register set to read from
   SIGNAL UM   : STD_LOGIC;             -- mode bit

   SIGNAL scall : STD_LOGIC;
   SIGNAL swm   : STD_LOGIC;
   SIGNAL di    : STD_LOGIC;
   SIGNAL ei    : STD_LOGIC;
   SIGNAL trap  : STD_LOGIC;
   SIGNAL chrs  : STD_LOGIC;
   SIGNAL retu  : STD_LOGIC;
   SIGNAL lli   : STD_LOGIC;
   SIGNAL lui   : STD_LOGIC;
   SIGNAL exbfi : STD_LOGIC;
   SIGNAL addi  : STD_LOGIC;
   SIGNAL ld    : STD_LOGIC;            -- Fabio: it might include lb and lh
   SIGNAL muli  : STD_LOGIC;
   SIGNAL addiu : STD_LOGIC;
   SIGNAL andi  : STD_LOGIC;
   SIGNAL ori   : STD_LOGIC;
   SIGNAL cmpi  : STD_LOGIC;
   SIGNAL cop   : STD_LOGIC;
   SIGNAL st    : STD_LOGIC;
   SIGNAL exb   : STD_LOGIC;
   SIGNAL exh   : STD_LOGIC;
   SIGNAL sexti : STD_LOGIC;
   SIGNAL slli  : STD_LOGIC;
   SIGNAL srai  : STD_LOGIC;
   SIGNAL srli  : STD_LOGIC;
   SIGNAL jal   : STD_LOGIC;
   SIGNAL jalr  : STD_LOGIC;

   SIGNAL fpu_not_supp : STD_LOGIC;

   SIGNAL fpu_operation_initiate : STD_LOGIC;
   SIGNAL cpu_operation_initiate : STD_LOGIC;

   ALIAS lui_imm_msb : STD_LOGIC IS i_word(9);

BEGIN
   opcode <= i_word(31 DOWNTO 26);
   cex    <= i_word(25);
   ishift <= NOT i_word(18);

   new_psr <= "000" & IE & IL & RSWR & RSRD & UM;

   ---------------------------------------------------
   -- A few signals to make code readable (for whom?)
   ---------------------------------------------------
   scall <= '1' WHEN opcode = scall_opc                 ELSE '0';
   swm   <= '1' WHEN opcode = swm_opc                   ELSE '0';
   di    <= '1' WHEN opcode = di_opc                    ELSE '0';
   ei    <= '1' WHEN opcode = ei_opc                    ELSE '0';
   trap  <= '1' WHEN opcode = trap_opc                  ELSE '0';
   chrs  <= '1' WHEN opcode = chrs_opc                  ELSE '0';
   retu  <= '1' WHEN opcode = retu_opc                  ELSE '0';
   lli   <= '1' WHEN opcode = lli_opc                   ELSE '0';
   lui   <= '1' WHEN opcode = lui_opc                   ELSE '0';
   exbfi <= '1' WHEN opcode = exbfi_opc                 ELSE '0';
   cop   <= '1' WHEN opcode = cop_opc                   ELSE '0';
   addi  <= '1' WHEN opcode = addi_opc                  ELSE '0';
   ld    <= '1' WHEN opcode = ld_opc                    ELSE '0';
   muli  <= '1' WHEN opcode = muli_opc                  ELSE '0';
   addiu <= '1' WHEN opcode = addiu_opc                 ELSE '0';
   andi  <= '1' WHEN opcode = andi_opc                  ELSE '0';
   ori   <= '1' WHEN opcode = ori_opc                   ELSE '0';
   cmpi  <= '1' WHEN opcode = cmpi_opc                  ELSE '0';
   st    <= '1' WHEN opcode = st_opc                    ELSE '0';
   exb   <= '1' WHEN opcode = exb_opc                   ELSE '0';
   exh   <= '1' WHEN opcode = exh_opc                   ELSE '0';
   sexti <= '1' WHEN opcode = sexti_opc                 ELSE '0';
   slli  <= '1' WHEN opcode = slli_opc AND ishift = '1' ELSE '0';
   srai  <= '1' WHEN opcode = srai_opc AND ishift = '1' ELSE '0';
   srli  <= '1' WHEN opcode = srli_opc AND ishift = '1' ELSE '0';
   jal   <= '1' WHEN opcode = jal_opc                   ELSE '0';
   jalr  <= '1' WHEN opcode = jalr_opc                  ELSE '0';

   -------------------------------------------------------------
   -- Calculating new status (PSR)
   -------------------------------------------------------------
   PROCESS(scall, swm, di, ei, chrs, current_psr, i_word)
   BEGIN

      -- Note, that di and ei are allowed in superuser mode only
      IF (di = '1' AND current_psr(0) = '0') OR scall = '1' THEN
         IE <= '0';
      ELSIF ei = '1' AND current_psr(0) = '0' THEN
         IE <= '1';
      ELSE
         IE <= current_psr(4);          -- preserve old value
      END IF;

      IF swm = '1' THEN
         IL <= i_word(15);              -- using the msb of immediate
      ELSIF scall = '1' THEN
         IL <= '1';                     -- default is 32 bit mode
      ELSE
         IL <= current_psr(3);          -- preserve old value
      END IF;

      -- Note, that chrs is allowed only in superuser mode
      IF chrs = '1' AND current_psr(0) = '0' THEN
         RSWR <= i_word(11);
         RSRD <= i_word(10);
      ELSIF scall = '1' THEN
         RSWR <= '1';
         RSRD <= '1';
      ELSE
         RSWR <= current_psr(2);        -- preserve old values
         RSRD <= current_psr(1);
      END IF;

      IF scall = '1' THEN               -- default super user mode
         UM <= '0';
      ELSE
         UM <= current_psr(0);
      END IF;

   END PROCESS;

   -------------------------------------------------------------
   -- Exception logic
   -------------------------------------------------------------
   PROCESS(rst_x, clk)
      VARIABLE il_violation, um_violation, unknown_opcode : STD_LOGIC;
   BEGIN
      IF rst_x = '0' THEN
         exception_q <= "000";
      ELSIF clk'EVENT AND clk = '1' THEN
         IF en = '1' THEN
            -- While in 16 bit mode, an opcode valid only in 32 bit mode,
            -- is encountered.
            il_violation := (lui OR lli OR exbfi OR cop) AND NOT(current_psr(3));

            -- Trying to execute an instruction not allowed in user mode
            um_violation := (chrs OR retu OR di OR ei) AND current_psr(0);

            -- If there is no FPU and a floating-point instruction is issued
            unknown_opcode := fpu_not_supp AND cop;

            exception_q(2) <= trap AND NOT(flush);
            exception_q(1) <= (il_violation OR um_violation) AND NOT(flush);
            exception_q(0) <= unknown_opcode AND NOT(flush);

         END IF;
      END IF;
   END PROCESS;

   -------------------------------------------------------------
   -- Extending immediates. Should not be so time critical...
   -------------------------------------------------------------

   PROCESS(i_word, addiu, andi, ori, cex, addi, ld, muli, cmpi, lui, lli,
           cop, st, lui_imm_msb)

   BEGIN
      IF addiu = '1' OR andi = '1' OR ori = '1' THEN
         -- zero extending
         IF cex = '1' THEN
            extended_imm(31 DOWNTO 9)  <= (OTHERS => '0');
            extended_imm(8 DOWNTO 0)   <= i_word(18 DOWNTO 10);
         ELSE
            extended_imm(31 DOWNTO 15) <= (OTHERS => '0');
            extended_imm(14 DOWNTO 0)  <= i_word(24 DOWNTO 10);
         END IF;
      ELSIF addi = '1' OR ld = '1' OR muli = '1' THEN
         -- sign extending
         IF cex = '1' THEN
            extended_imm(31 DOWNTO 9)  <= (OTHERS => i_word(18));
            extended_imm(8 DOWNTO 0)   <= i_word(18 DOWNTO 10);
         ELSE
            extended_imm(31 DOWNTO 15) <= (OTHERS => i_word(24));
            extended_imm(14 DOWNTO 0)  <= i_word(24 DOWNTO 10);
         END IF;
      ELSIF cmpi = '1' THEN
         -- special case 1
         extended_imm(31 DOWNTO 17)    <= (OTHERS => i_word(4));
         extended_imm(16 DOWNTO 0)     <= i_word(4 DOWNTO 0) & i_word(21 DOWNTO 10);
      ELSIF lui = '1' OR lli = '1' THEN
         -- special case 2
         extended_imm(31 DOWNTO 16)    <= (OTHERS => '0');  -- don't care
         extended_imm(15 DOWNTO 0)     <= lui_imm_msb & i_word(24 DOWNTO 10);
      ELSIF st = '1' THEN
         -- special case 3
         IF cex = '1' THEN
            extended_imm(31 DOWNTO 9)  <= (OTHERS => i_word(4));
            extended_imm(8 DOWNTO 0)   <= i_word(4 DOWNTO 0) & i_word(18 DOWNTO 15);
         ELSE
            extended_imm(31 DOWNTO 15) <= (OTHERS => i_word(4));
            extended_imm(14 DOWNTO 0)  <= i_word(4 DOWNTO 0) & i_word(24 DOWNTO 15);
         END IF;
      ELSIF cop = '1' THEN
         -- special case 4
         extended_imm                  <= "00000000" & i_word(23 DOWNTO 0);
      ELSE                              -- all the others (exbfi has the longest immediate of 11 bits)
         extended_imm(10 DOWNTO 0)     <= i_word(20 DOWNTO 10);
         extended_imm(31 DOWNTO 11)    <= (OTHERS => '0');  -- don't care
      END IF;

   END PROCESS;

   PROCESS(i_word)
      VARIABLE opc : STD_LOGIC_VECTOR(5 DOWNTO 0);
   BEGIN
      opc := i_word(31 DOWNTO 26);
      IF opc(5 DOWNTO 3) = "100" THEN
         -- conditional branch, sign extend and shift one bit
         jmp_offset(31 DOWNTO 23) <= (OTHERS => i_word(21));
         jmp_offset(22 DOWNTO 0)  <= i_word(21 DOWNTO 0) & '0';
      ELSE
         -- jal or jmp (or don't care), sign extend and shift one bit
         jmp_offset(31 DOWNTO 26) <= (OTHERS => i_word(24));
         jmp_offset(25 DOWNTO 0)  <= i_word(24 DOWNTO 0) & '0';
      END IF;
   END PROCESS;

   -------------------------------------------------------------
   -- Selecting the right operands to ALU or cop interface
   -------------------------------------------------------------

   PROCESS(addi, addiu, andi, cmpi, cop, exb,
           exbfi, exh, ld, lli, lui, muli,
           ori, sexti, slli, srai, srli, st,
           scall, jal, jalr, current_psr, retu)

      VARIABLE immediate_operand : STD_LOGIC;
   BEGIN
      immediate_operand := addi OR addiu OR andi OR cmpi OR exb OR
                           exbfi OR exh OR ld OR lli OR lui OR muli OR
                           ori OR sexti OR slli OR srai OR srli OR st;

      -- Multiplexer for 2nd operand
      IF immediate_operand = '1' THEN
         sel_op_ii <= '1';
      ELSE
         sel_op_ii <= '0';
      END IF;

      -- Multiplexer for 1st operand (route link address or not)
      IF scall = '1' OR jal = '1' OR jalr = '1' THEN
         sel_op_i <= '1';
      ELSE
         sel_op_i <= '0';
      END IF;

      -- lui must read it's implicit source register from the register set
      -- which is selected as the target!. retu must read PR31 instead of
      -- R31
      IF lui = '1' THEN
         rs_to_read <= current_psr(2);
      ELSIF retu = '1' THEN
         rs_to_read <= '1';
      ELSE
         rs_to_read <= current_psr(1);
      END IF;

   END PROCESS;

   -------------------------------------------------------------
   -- signals for integrated version 
   -------------------------------------------------------------

   fpu_operation_initiate <= cop AND en AND NOT flush AND NOT fpu_not_supp;
   cpu_operation_initiate <= NOT cop AND en AND NOT flush;

   sreg_indx1 <= i_word(4 DOWNTO 0)   WHEN lui = '1'                     ELSE i_word(15 DOWNTO 11) WHEN cop = '1' ELSE i_word(9 DOWNTO 5);
   sreg_indx2 <= i_word(20 DOWNTO 16) WHEN cop = '1'                     ELSE i_word(14 DOWNTO 10);
   trgt_indx  <= i_word(10 DOWNTO 6)  WHEN cop = '1'                     ELSE "11111" WHEN jal = '1' ELSE i_word(4 DOWNTO 0);
   --fpu_opc    <= i_word(5 DOWNTO 0)   WHEN cop = '1'                     ELSE cop_nop;
   creg_indx  <= i_word(24 DOWNTO 22);
   opc        <= i_word(31 DOWNTO 26);
   cexbit     <= i_word(25);
   condition  <= i_word(21 DOWNTO 19) WHEN i_word(31 DOWNTO 29) /= "100" ELSE i_word(28 DOWNTO 26);  -- document please!

   start_fpu_mul    <= fpu_operation_initiate AND milk_is_mul(i_word);
   start_fpu_add    <= fpu_operation_initiate AND milk_is_add_sub(i_word);
   start_fpu_div    <= fpu_operation_initiate AND milk_is_div(i_word);
   start_fpu_sqrt   <= fpu_operation_initiate AND milk_is_sqrt(i_word);
   start_fpu_scycle <= fpu_operation_initiate AND milk_is_scycle_data(i_word);
   start_fpu_tcycle <= fpu_operation_initiate AND milk_is_tcycle_data(i_word);
   start_core_pipe  <= cpu_operation_initiate AND cpu_writes_rf;

      fpu_not_supp <= '1';

END core_decode_arch;
