----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:25:41 02/01/2022 
-- Design Name: 
-- Module Name:    top_module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_module is
	Port ( clk : in std_logic;
			 rst : in std_logic;
			 output : out std_logic_vector(15 downto 0);
			 i_RX_Serial :in std_logic
			 );
end Top_module;

architecture Behavioral of Top_module is

component digitalfilteriir is
    generic(
  x : INTEGER := 16; -- size of multiplicand (M)
  y : INTEGER := 16  -- size of multiplier (Q)
 );
    Port (  
	 clk: in std_logic; -- i_clk
	 rst : in std_logic;
    shift_en: in std_logic; -- r_RX_DV
    input: in std_logic_vector(x-1 downto 0); -- o_rx_byte
    output: out std_logic_vector(y-1 downto 0)
	 );
    
end component;

component recieverIIR is
  generic (
    g_CLKS_PER_BIT : integer := 834     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0):="00000000";
	 bit_16_RX_Byte : out std_logic_vector(15 downto 0):="0000000000000000"
    );
end component;

--signal shift_en : std_logic;
signal o_RX_DV : std_logic;
signal shift : std_logic;
signal input : std_logic_vector (15 downto 0);
signal o_RX_byte: std_logic_vector (7 downto 0);
--signal data : std_logic_vector(15 downto 0);

begin

tx_digitalfilteriir : digitalfilteriir
	Port map (
				clk => clk,
				rst => rst,
            shift_en => shift,
            input => input,
            output => output
	);
tx_recieverIIR : recieverIIR
	Port map (
				i_Clk   => clk,
				i_RX_Serial => i_RX_Serial, 
				o_RX_DV => shift,   
				o_RX_Byte => o_RX_Byte, 
				bit_16_RX_Byte => input
	);

end Behavioral;