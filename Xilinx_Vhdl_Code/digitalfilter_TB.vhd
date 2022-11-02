--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:22:54 01/29/2022
-- Design Name:   
-- Module Name:   C:/Users/adrie/IIR_filter_project/digitalfilter_TB.vhd
-- Project Name:  IIR_filter_project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: digitalfilteriir
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------LIBRARY ieee;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY digitalfilter_TB IS
END digitalfilter_TB;
 
ARCHITECTURE behavior OF digitalfilter_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT digitalfilteriir
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         shift_en : IN  std_logic;
         input : IN  std_logic_vector(15 downto 0);
         output : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal shift_en : std_logic := '0';
   signal input : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: digitalfilteriir PORT MAP (
          clk => clk,
          rst => rst,
          shift_en => shift_en,
          input => input,
          output => output
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	--reset
	rst_proc : process
	begin
		rst <= '1';
		wait for 10 ns;
		rst <= '0';
		wait;
	end process;

   -- Stimulus process
   stim_proc: process
   begin		
		for i in 1 to 100 loop
			shift_en <= '1';
			input <= input + "00101011";
			wait for 10 ns;
			shift_en <= '0';
			wait for 5000 ns;
		end loop;
      wait;
   end process;

END;