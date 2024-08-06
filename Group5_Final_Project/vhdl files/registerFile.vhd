----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/05/2024 05:22:01 PM
-- Design Name: 
-- Module Name: registerFile_32bits - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- VHDL code for the register file of the MIPS Processor
entity registerFile is
  port (
    clk, rst: in std_logic;  -- Clock and reset inputs
    reg_write_en: in std_logic;  -- Register write enable signal
    reg_write_dest: in std_logic_vector(4 downto 0);  -- 5-bit register write destination address
    reg_write_data: in std_logic_vector(31 downto 0);  -- 32-bit data to be written to the register
    reg_read_addr_1: in std_logic_vector(4 downto 0);  -- 5-bit register read address 1
    reg_read_data_1: out std_logic_vector(31 downto 0);  -- 32-bit data read from register address 1
    reg_read_addr_2: in std_logic_vector(4 downto 0);  -- 5-bit register read address 2
    reg_read_data_2: out std_logic_vector(31 downto 0)  -- 32-bit data read from register address 2
  );
end registerFile;

architecture Behavioral of registerFile is
  -- Type declaration for an array of 32 registers, each 32 bits wide
  type reg_type is array (0 to 31) of std_logic_vector (31 downto 0);
  -- Signal declaration for the register array
  signal reg_array: reg_type := (
    "00000000000000000000000000000000",  -- $zero
    "00000000000000000000000000000001",  -- $at
    "00000000000000000000000000000010",  -- $v0
    "00000000000000000000000000000011",  -- $v1
    "00000000000000000000000000000100",  -- $a0
    "00000000000000000000000000000101",  -- $a1
    "00000000000000000000000000000110",  -- $a2
    "00000000000000000000000000000111",  -- $a3
    "00000000000000000000000000001000",  -- $t0
    "00000000000000000000000000001001",  -- $t1
    "00000000000000000000000000001010",  -- $t2
    "00000000000000000000000000001011",  -- $t3
    "00000000000000000000000000001100",  -- $t4
    "00000000000000000000000000001101",  -- $t5
    "00000000000000000000000000001110",  -- $t6
    "00000000000000000000000000001111",  -- $t7
    "00000000000000000000000000010000",  -- $s0
    "00000000000000000000000000010001",  -- $s1
    "00000000000000000000000000010010",  -- $s2
    "00000000000000000000000000010011",  -- $s3
    "00000000000000000000000000010100",  -- $s4
    "00000000000000000000000000010101",  -- $s5
    "00000000000000000000000000010110",  -- $s6
    "00000000000000000000000000010111",  -- $s7
    "00000000000000000000000000011000",  -- $t8
    "00000000000000000000000000011001",  -- $t9
    "00000000000000000000000000011010",  -- $k0
    "00000000000000000000000000011011",  -- $k1
    "00000000000000000000000000011100",  -- $gp
    "00000000000000000000000000011101",  -- $sp
    "00000000000000000000000000011110",  -- $fp
    "00000000000000000000000000011111"   -- $ra
  );

begin
  -- Process to handle register reset and write operations
  process(clk, rst) 
  begin
    if (rst = '1') then
      -- Initialize registers on reset
      reg_array(0)  <= x"00000000";
      reg_array(1)  <= x"00000001";
      reg_array(2)  <= x"00000002";
      reg_array(3)  <= x"00000003";
      reg_array(4)  <= x"00000004";
      reg_array(5)  <= x"00000005";
      reg_array(6)  <= x"00000006";
      reg_array(7)  <= x"00000007";
      reg_array(8)  <= x"00000008";
      reg_array(9)  <= x"00000009";
      reg_array(10) <= x"0000000A";
      reg_array(11) <= x"0000000B";
      reg_array(12) <= x"0000000C";
      reg_array(13) <= x"0000000D";
      reg_array(14) <= x"0000000E";
      reg_array(15) <= x"0000000F";
      reg_array(16) <= x"00000010";
      reg_array(17) <= x"00000011";
      reg_array(18) <= x"00000012";
      reg_array(19) <= x"00000013";
      reg_array(20) <= x"00000014";
      reg_array(21) <= x"00000015";
      reg_array(22) <= x"00000016";
      reg_array(23) <= x"00000017";
      reg_array(24) <= x"00000018";
      reg_array(25) <= x"00000019";
      reg_array(26) <= x"0000001A";
      reg_array(27) <= x"0000001B";
      reg_array(28) <= x"0000001C";
      reg_array(29) <= x"0000001D";
      reg_array(30) <= x"0000001E";
      reg_array(31) <= x"0000001F";
    elsif (rising_edge(clk)) then
      if (reg_write_en = '1') then
        -- Write data to the specified register on rising clock edge if write enable is asserted
        reg_array(to_integer(unsigned(reg_write_dest))) <= reg_write_data;
      end if;
    end if;
  end process;

  -- Read data from registers
  reg_read_data_1 <= reg_array(to_integer(unsigned(reg_read_addr_1)));
  reg_read_data_2 <= reg_array(to_integer(unsigned(reg_read_addr_2)));

end Behavioral;