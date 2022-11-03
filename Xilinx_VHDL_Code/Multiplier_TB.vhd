--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:03:55 01/15/2022
-- Design Name:   
-- Module Name:   C:/Users/sofya/OneDrive/Desktop/mov_average_fin/Multiplier_TB.vhd
-- Project Name:  mov_average_fin
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Booth16
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Multiplier_TB IS
END Multiplier_TB;
 
ARCHITECTURE behavior OF Multiplier_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Booth 
	 generic(
		   x : INTEGER := 16;
	      y : INTEGER := 16
    );
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         start : IN  std_logic;
			M     : in  std_logic_vector(x-1 downto 0);
         Q     : in  std_logic_vector(y-1 downto 0);
         valid : out std_logic;
         P     : out std_logic_vector(x+y-1 downto 0)
         );
    END COMPONENT;

	--Generic values
	constant x: integer := 16; -- Size of multiplicand
	constant y: integer := 16; -- Size of multiplier

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal start : std_logic := '0';
   signal M : std_logic_vector(x-1 downto 0) := (others => '0');
   signal Q : std_logic_vector(y-1 downto 0) := (others => '0');

 	--Outputs
   signal valid : std_logic;
   signal P : std_logic_vector(x+y-1 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Booth
        GENERIC MAP (
			 x => x,
			 y => y
		  )
	     PORT MAP (
          CLK => CLK,
          RST => RST,
          start => start,
          M => M,
          Q => Q,
          valid => valid,
          P => P
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RST <= '1';
      wait for CLK_period;	
		RST <= '0';
      wait for CLK_period;

		M <= "1111111111111001"; -- (-7)
		Q <= "0000000000000111"; -- (+7)
		wait for CLK_period;
		start <= '1';
		wait for CLK_period;
		start <= '0';

      wait;
   end process;

END;
