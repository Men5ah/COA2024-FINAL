-- Instruction_Memory_VHDL.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity declaration for the Instruction Memory
entity InstructionMemory is
  port (
    inst_add: in std_logic_vector(31 downto 0);  -- 32-bit instruction address input
    instruction: out std_logic_vector(31 downto 0)  -- 32-bit instruction output
  );
end InstructionMemory;

architecture Behavioral of InstructionMemory is
  -- Internal signal for ROM address
  signal rom_addr: integer range 0 to 31; -- Adjusted range for larger memory

  -- Type declaration for ROM, an array of 32 locations each 32 bits wide
  type ROM_type is array (0 to 31) of std_logic_vector(31 downto 0);

  -- ROM data constant initialization - 32 bits instruction set architecture
  constant rom_data: ROM_type := (
    "00000000010000100001100000100000",  -- add operation: reg(1) = reg(2) + reg(3)
    "00000000001000110010000000100010",  -- sub operation: reg(4) = reg(1) - reg(3)
    "00000000101000100011000000100100",  -- and operation: reg(6) = reg(5) and reg(2)
    "00000000111000100011100000100101",  -- or operation: reg(7) = reg(7) or reg(2)
    "10001100101001000000000000001000",  -- lw operation: load word to reg(8) from memory address in reg(5) + 8
    "10101100101001100000000000010000",  -- sw operation: store word from reg(9) to memory address in reg(5) + 16
    "00010000011000010000000000001000",  -- beq operation: branch if reg(3) == reg(1) to address +8
    "00001000000000000000000000010100",  -- j operation: jump to address 20
    "00100000100010000000000000001010",  -- addi operation: reg(8) = reg(4) + 10
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    "00000000000000000000000000000000",  -- nop operation: no operation
    others => (others => '0') -- ensure all 32 elements are initialized
  );

begin
  -- Assign the least significant 5 bits of the input address to the internal ROM address signal
  rom_addr <= to_integer(unsigned(inst_add(4 downto 0)));  -- Adjusted to handle 32 locations

  -- Fetch the instruction from ROM using the address and assign it to the output
  instruction <= rom_data(rom_addr);

end Behavioral;