library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controlALU is
  port(
    ALU_Control: out std_logic_vector(2 downto 0);  -- 3-bit output for ALU control signal
    ALUOp : in std_logic_vector(2 downto 0);  -- 3-bit input signal from the main control unit
    ALU_Funct : in std_logic_vector(5 downto 0)  -- 6-bit function code from the instruction for 32-bit MIPS
  );
end controlALU;

architecture Behavioral of controlALU is
begin
  process(ALUOp, ALU_Funct)
  begin
    case ALUOp is
      when "000" =>
        case ALU_Funct is
          when "100000" => ALU_Control <= "010";  -- Perform addition
          when "100010" => ALU_Control <= "110";  -- Perform subtraction
          when "100100" => ALU_Control <= "000";  -- Perform AND operation
          when "100101" => ALU_Control <= "001";  -- Perform OR operation
          when "101010" => ALU_Control <= "111";  -- Set on less than
          when others   => ALU_Control <= "000";  -- Default to AND operation
        end case;
      when "001" => ALU_Control <= "001";  -- Specific operation example
      when "010" => ALU_Control <= "100";  -- Specific operation example
      when "011" => ALU_Control <= "000";  -- Specific operation example
      when "100" => ALU_Control <= "101";  -- Specific operation example
      when "101" => ALU_Control <= "110";  -- Specific operation example
      when others => ALU_Control <= "000"; -- Default case
    end case;
  end process;
end Behavioral;