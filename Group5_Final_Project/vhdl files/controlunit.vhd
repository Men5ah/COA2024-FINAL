-- control_unit_VHDL.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controlunit is
  port (
    opcode: in std_logic_vector(5 downto 0);  -- 6-bit opcode input
    reset: in std_logic;  -- Reset signal
    alu_op: out std_logic_vector(2 downto 0);  -- ALU operation code output
    reg_dst, mem_to_reg, jump, branch, branch_g, branch_l, mem_read, mem_write, alu_src, reg_write : out std_logic  -- Control signals
  );
end controlunit;

architecture Behavioral of controlunit is
begin
  process(reset, opcode)
  begin
    if (reset = '1' or opcode = "000000") then
      -- Reset or No Operation (NOP) state
      reg_dst <= '0';
      mem_to_reg <= '0';
      alu_op <= "000";
      jump <= '0';
      branch_g <= '0';
      branch_l <= '0';
      branch <= '0';
      mem_read <= '0';
      mem_write <= '0';
      alu_src <= '0';  -- Default: Second operand from register
      reg_write <= '0';
    else
      case opcode is
        when "000000" => -- Arithmetic and Logic (R-type)
          reg_dst <= '1';
          mem_to_reg <= '0';
          alu_op <= "010";  -- Example for ADD operation
          jump <= '0';
          branch_g <= '0';
          branch_l <= '0';
          branch <= '0';
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '0';  -- Second operand from register
          reg_write <= '1';

        when "001000" => -- ADDI (I-type)
          reg_dst <= '0';
          mem_to_reg <= '0';
          alu_op <= "010";
          jump <= '0';
          branch_g <= '0';
          branch_l <= '0';
          branch <= '0';
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '1';  -- Immediate value as the second operand
          reg_write <= '1';

        when "001100" => -- ANDI (I-type)
          reg_dst <= '0';
          mem_to_reg <= '0';
          alu_op <= "100";
          jump <= '0';
          branch_g <= '0';
          branch_l <= '0';
          branch <= '0';
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '1';  -- Immediate value as the second operand
          reg_write <= '1';

        when "100011" => -- LW (I-type)
          reg_dst <= '0';
          mem_to_reg <= '1';
          alu_op <= "010";
          jump <= '0';
          branch_g <= '0';
          branch_l <= '0';
          branch <= '0';
          mem_read <= '1';
          mem_write <= '0';
          alu_src <= '1';  -- Immediate value as the second operand
          reg_write <= '1';

        when "101011" => -- SW (I-type)
          reg_dst <= '0';
          mem_to_reg <= '0';
          alu_op <= "010";
          jump <= '0';
          branch_g <= '0';
          branch_l <= '0';
          branch <= '0';
          mem_read <= '0';
          mem_write <= '1';
          alu_src <= '1';  -- Immediate value as the second operand
          reg_write <= '0';

        when "000100" => -- BEQ (I-type)
          reg_dst <= '0';
          mem_to_reg <= '0';
          alu_op <= "110";
          jump <= '0';
          branch_g <= '0';
          branch_l <= '0';
          branch <= '1';
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '0';
          reg_write <= '0';

        when "000010" => -- J (J-type)
          reg_dst <= '0';
          mem_to_reg <= '0';
          alu_op <= "000";
          jump <= '1';
          branch_g <= '0';
          branch_l <= '0';
          branch <= '0';
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '0';
          reg_write <= '0';

        when others =>
          -- Default case: Set default values
          reg_dst <= '0';
          mem_to_reg <= '0';
          alu_op <= "000";
          jump <= '0';
          branch <= '0';
          branch_g <= '0';
          branch_l <= '0';
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '0';  -- Default: Second operand from register
          reg_write <= '0';
      end case;
    end if;
  end process;

end Behavioral;