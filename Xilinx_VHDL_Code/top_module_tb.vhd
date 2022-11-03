--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:34:26 02/01/2022
-- Design Name:   
-- Module Name:   C:/Users/adrie/IIR_Filter_Project/top_module_tb.vhd
-- Project Name:  IIR_Filter_Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Top_module
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
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_module_tb IS
END top_module_tb;
 
ARCHITECTURE behavior OF top_module_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Top_module
    PORT(clk : in std_logic;
			 rst : in std_logic;
			 output : out std_logic_vector(15 downto 0);
			 i_RX_Serial :in std_logic
			 );
         
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal i_RX_Serial : std_logic := '0';


 	--Outputs
   signal output : std_logic_vector(15 downto 0);


   -- Clock period definitions
   constant clk_period : time := 125 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Top_module PORT MAP (
          clk => clk,
          rst => rst,
          output => output,
          i_RX_Serial => i_RX_Serial
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
 rst_proc: process
 begin
  rst <= '1';
  wait for 10 ns;
  rst <= '0';
  wait;
 end process;
 
   -- Stimulus process
   stim_proc: process
   begin
			i_RX_Serial <= '0';  -- start bit
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 0 
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 1 
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 2
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 3
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 4
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- bit 5
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 6
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- bit 7
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- stop bit
			wait for 0.1042 ms;		
			
			i_RX_Serial <= '1';  -- jeda
			wait for 0.1042 ms;

			i_RX_Serial <= '0';  -- start bit
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- bit 0 
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 1 
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 2
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 3
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 4
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 5
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 6
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- bit 7
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- stop bit
			wait for 0.1042 ms;
			
			i_RX_Serial <= '1';  -- jeda
			wait for 0.1042 ms;

			i_RX_Serial <= '0';  -- start bit
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 0 
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 1 
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- bit 2
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 3
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 4
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 5
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 6
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- bit 7
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- stop bit
			wait for 0.1042 ms;
			
			i_RX_Serial <= '1';  -- jeda
			wait for 0.1042 ms;

			i_RX_Serial <= '0';  -- start bit
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 0 
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 1 
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 2
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 3
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 4
			wait for 0.1042 ms;
			i_RX_Serial <= '0';  -- bit 5
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- bit 6
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- bit 7
			wait for 0.1042 ms;
			i_RX_Serial <= '1';  -- stop bit
			wait for 0.1042 ms;
			
		
   end process;

END;
