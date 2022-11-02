----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:16:49 02/01/2022 
-- Design Name: 
-- Module Name:    recieverIIR - Behavioral 
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
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity recieverIIR is
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
end recieverIIR;
 
 
architecture rtl of recieverIIR is
 
  type t_SM_Main is (s_Idle, s_RX_Start_Bit, s_RX_Data_Bits,
                     s_RX_Stop_Bit, s_Cleanup);
  signal r_SM_Main : t_SM_Main := s_Idle;
 
  signal r_RX_Data_R : std_logic := '0';
  signal r_RX_Data   : std_logic := '0';
  signal loaden : std_logic;
  signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal r_Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal r_RX_Byte   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_RX_DV     : std_logic := '0';
  signal select_high : std_logic := '0';
  signal selectanddv : std_logic_vector(1 downto 0);
  signal Q1 : std_logic_vector( 7 downto 0):="00000000";
  signal Q2 : std_logic_vector( 7 downto 0):="00000000";
  signal Q3 : std_logic_vector( 7 downto 0):="00000000";
  signal Q4 : std_logic_vector( 7 downto 0):="00000000";
  
begin
 
  -- Purpose: Double-register the incoming data.
  -- This allows it to be used in the UART RX Clock Domain.
  -- (It removes problems caused by metastabiliy)
  p_SAMPLE : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      r_RX_Data_R <= i_RX_Serial;
      r_RX_Data   <= r_RX_Data_R;
    end if;
  end process p_SAMPLE;
   
 
  -- Purpose: Control RX state machine
  p_UART_RX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
         
      case r_SM_Main is
 
        when s_Idle =>
          r_RX_DV     <= '0';
          r_Clk_Count <= 0;
          r_Bit_Index <= 0;
 
          if r_RX_Data = '0' then       -- Start bit detected
            r_SM_Main <= s_RX_Start_Bit;
          else
            r_SM_Main <= s_Idle;
          end if;
 
           
        -- Check middle of start bit to make sure it's still low
        when s_RX_Start_Bit =>
          if r_Clk_Count = (g_CLKS_PER_BIT-1)/2 then
            if r_RX_Data = '0' then
              r_Clk_Count <= 0;  -- reset counter since we found the middle
              r_SM_Main   <= s_RX_Data_Bits;
            else
              r_SM_Main   <= s_Idle;
            end if;
          else
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Start_Bit;
          end if;
 
           
        -- Wait g_CLKS_PER_BIT-1 clock cycles to sample serial data
        when s_RX_Data_Bits =>
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Data_Bits;
          else
            r_Clk_Count            <= 0;
            r_RX_Byte(r_Bit_Index) <= r_RX_Data;
             
            -- Check if we have sent out all bits
            if r_Bit_Index < 7 then
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= s_RX_Data_Bits;
            else
              r_Bit_Index <= 0;
              r_SM_Main   <= s_RX_Stop_Bit;
            end if;
          end if;
 
 
        -- Receive Stop bit.  Stop bit = 1
        when s_RX_Stop_Bit =>
          -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Stop_Bit;
          else
			   select_high <= not select_high;
            r_RX_DV     <= '1';
            r_Clk_Count <= 0;
            r_SM_Main   <= s_Cleanup;
				o_RX_Byte <= r_RX_Byte;
          end if;
 
                   
        -- Stay here 1 clock
        when s_Cleanup =>
          r_SM_Main <= s_Idle;
          r_RX_DV   <= '0';
 
             
        when others =>
          r_SM_Main <= s_Idle;
 
      end case;
    end if;
  end process p_UART_RX;
 
  o_RX_DV   <= r_RX_DV;
  selectanddv <= r_RX_DV & select_high;
  
  
  
  --- select high generator
  Process(r_RX_DV)
  begin
  if r_RX_DV = '1' then 
  loaden <= '1';
  elsif r_RX_DV = '0' then
  loaden <='0';
  end if;
  end process;
  
  Process(i_Clk)
  begin
  if rising_edge(i_Clk) then
  if loaden ='1' then 
		if selectanddv = "10" then
		Q1 <= r_RX_Byte;
		Q2 <= Q1;
		elsif selectanddv = "11" then 
		Q3 <= r_RX_Byte;
		Q4 <= Q3;
	end if;
  end if;
 end if;
  bit_16_RX_Byte <= Q4 & Q2;
  
  end process;
  end rtl;
