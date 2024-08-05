library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

-- Entity declaration for the ALU
entity ALU is
  Port (
    inp_a : in STD_LOGIC_VECTOR(31 downto 0);  -- 32-bit input A
    inp_b : in STD_LOGIC_VECTOR(31 downto 0);  -- 32-bit input B
    alu_control : in STD_LOGIC_VECTOR(2 downto 0);  -- 3-bit control signal to determine ALU operation
    alu_result : out STD_LOGIC_VECTOR(31 downto 0);  -- 32-bit output result
    zero_flag, sign_flag : out std_logic  -- Output flags: zero flag and sign flag
  );
end ALU;

-- Architecture definition for the ALU
architecture Behavioral of ALU is
  signal out_alu : std_logic_vector(31 downto 0);  -- Internal signal for ALU output
begin
  -- Process to perform ALU operations based on control signal
  process(inp_a, inp_b, alu_control)
  begin
    case alu_control is
      when "000" =>
        -- Addition operation
        out_alu <= std_logic_vector(signed(inp_a) + signed(inp_b));
      when "001" =>
        -- Subtraction operation
        out_alu <= std_logic_vector(signed(inp_a) - signed(inp_b));
      when "010" =>
        -- Multiplication operation
        out_alu <= std_logic_vector(to_unsigned((to_integer(signed(inp_a)) * to_integer(signed(inp_b))), 32));
      when "011" =>
        -- Division operation
        if inp_b /= "00000000000000000000000000000000" then
          out_alu <= std_logic_vector(to_unsigned((to_integer(signed(inp_a)) / to_integer(signed(inp_b))), 32));
        else
          out_alu <= (others => '0');  -- Handle division by zero
        end if;
      when "100" =>
        -- AND operation
        out_alu <= inp_a and inp_b;
      when "101" =>
        -- OR operation
        out_alu <= inp_a or inp_b;
      when "110" =>
        -- XOR operation
        out_alu <= inp_a xor inp_b;
      when "111" =>
        -- NOT operation
        out_alu <= not inp_a;
      when others =>
        out_alu <= (others => '0');  -- Default case
    end case;
  end process;

  -- Set zero flag if the result is zero
  zero_flag <= '1' when out_alu = "00000000000000000000000000000000" else '0';

  -- Set sign flag if the result is negative (sign bit is 1)
  sign_flag <= out_alu(31);

  --  ALU result  is assigned to the output
  alu_result <= out_alu;

end Behavioral;