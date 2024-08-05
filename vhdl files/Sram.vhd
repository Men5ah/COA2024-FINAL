 -- sRAM.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Entity definition for the SRAM module
entity Sram is
  generic(
    width: integer := 32;  -- Set to 32-bit word width
    depth: integer := 16;  -- Increase depth if required
    dataaddr: integer := 4  -- Define address width (log2(depth))
  );
  port(
    clk: in std_logic;  -- Clock signal
    Read: in std_logic;  -- Read enable signal
    Write: in std_logic;  -- Write enable signal
    Addr: in std_logic_vector(dataaddr-1 downto 0);  -- Address input (4 bits for 16 locations)
    Data_in: in std_logic_vector(width-1 downto 0);  -- Data input (32 bits)
    Data_out: out std_logic_vector(width-1 downto 0)  -- Data output (32 bits)
  );
end Sram;

architecture behav of Sram is
  -- Type definition for RAM, an array of depth locations each 32 bits wide
  type ram_type is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
  -- Signal definition for the internal RAM storage
  signal tmp_ram: ram_type;
begin  
  -- Process for handling read and write operations
  process(clk)
  begin
    if (rising_edge(clk)) then
      if (Write = '1') then
        -- Write data to RAM at the specified address
        tmp_ram(conv_integer(Addr)) <= Data_in;
      elsif (Read = '1') then
        -- Read data from RAM at the specified address
        Data_out <= tmp_ram(conv_integer(Addr)); 
      else
        -- If neither read nor write is enabled, set Data_out to high-impedance
        Data_out <= (Data_out'range => 'Z');
      end if;
    end if;
  end process;
end behav;