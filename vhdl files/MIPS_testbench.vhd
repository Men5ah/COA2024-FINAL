----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/05/2024 10:16:08 PM
-- Design Name: 
-- Module Name: MIPS_testbench - Behavioral
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

ENTITY MIPS_testbench IS
END MIPS_testbench;
ARCHITECTURE behavior OF MIPS_testbench IS 
    -- Component Declaration for the single-cycle MIPS Processor in VHDL
    COMPONENT MIPS
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         pc_out : OUT  std_logic_vector(31 downto 0); -- Update to 32 bits
         alu_result : OUT  std_logic_vector(31 downto 0) -- Update to 32 bits
        );
    END COMPONENT;
   -- Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   -- Outputs
   signal pc_out : std_logic_vector(31 downto 0); -- Update to 32 bits
   signal alu_result : std_logic_vector(31 downto 0); -- Update to 32 bits
   -- Clock period definitions
   constant clk_period : time := 10 ps;
BEGIN
 -- Instantiate the single-cycle MIPS Processor in VHDL
   uut: MIPS PORT MAP (
          clk => clk,
          reset => reset,
          pc_out => pc_out,
          alu_result => alu_result
        );

   -- Clock process definitions
   clk_process : process
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin  
      -- hold reset state for 100 ns.
      reset <= '1';
      wait for 100 ns;
      reset <= '0';

      -- Insert additional stimulus here
      -- Example: You can add more test cases by assigning values to signals
      -- and checking the output results after a specific period.

      wait;
   end process;

END behavior;


