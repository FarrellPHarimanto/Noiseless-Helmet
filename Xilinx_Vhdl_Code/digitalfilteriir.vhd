----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:49:09 01/27/2022 
-- Design Name: 
-- Module Name:    digitalfilteriir - Behavioral 
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
--use IEEE.NUMERIC_STD.all;

entity digitalfilteriir is
    generic(
		x : INTEGER := 16; -- size of multiplicand (M)
		y : INTEGER := 16  -- size of multiplier (Q)
	);
    port(   Clk: in std_logic; -- i_clk
				rst : in std_logic;
            shift_en: in std_logic; -- r_RX_DV
            input: in std_logic_vector(x-1 downto 0); -- o_rx_byte
            OUTPUT: out std_logic_vector(y-1 downto 0));
end digitalfilteriir;

architecture Behavioral of digitalfilteriir is
    signal p5_en, p10_en, p15_en, ACC_CLR, count: std_logic;
    signal sel: std_logic_vector(4 downto 0);
    signal p0, p1, p2, p3, p4, p5, p8, p9, p10, p13, p14, p15, M: std_logic_vector(y-1 downto 0);
    signal acc, add, tadd, Q: std_logic_vector(y-1 downto 0);
    signal mult: std_logic_vector(y+y-1 downto 0);
	 signal start, valid : std_logic;
	
component Booth is
	generic(
		x : INTEGER := 16; -- size of multiplicand (M)
		y : INTEGER := 16  -- size of multiplier (Q)
	);
	
   port (
        CLK   : in  std_logic;
        RST   : in  std_logic;
        start : in  std_logic;
        M     : in  std_logic_vector(x-1 downto 0);
        Q     : in  std_logic_vector(y-1 downto 0);
        valid  : out std_logic;
        P     : out std_logic_vector(x+y-1 downto 0)
   );
end component;
	
begin

process(clk)
begin
    -- shift register --
	 if rst = '1' then
		  p0 <= (others => '0');
		  p1 <= (others => '0');
        p2 <= (others => '0');
        -- p3 = p6
        -- p4 = p7
        p3 <= (others => '0');
        p4 <= (others => '0');
        -- p8 = p11
        -- p9 = p12
        p8 <= (others => '0');
        p9 <= (others => '0');
        p13 <= (others => '0');
        p14 <= (others => '0');
    elsif (shift_en  = '1' and rising_edge(clk)) then
        p0 <= input;
		  p1 <= p0;
        p2 <= p1;
        -- p3 = p6
        -- p4 = p7
        p3 <= p5;
        p4 <= p3;
        -- p8 = p11
        -- p9 = p12
        p8 <= p10;
        p9 <= p8;
        p13 <= p15;
        p14 <= p13;
    end if;

    -- p5 register
	 if rst = '1' then
		  p5 <= (others => '0');
    elsif (rising_edge(clk) and p5_en = '1') then
        p5 <= acc;
    end if;

    -- p10 register
	 if rst = '1' then
		  p10 <= (others => '0');
    elsif (rising_edge(clk) and p10_en = '1') then
        p10 <= acc;
    end if;

    -- p15 register
	 if rst = '1' then
		  p15 <= (others => '0');
	 elsif (rising_edge(clk) and p15_en = '1') then
        p15 <= acc; 
    end if;
    
    -- accumulator:
    if ACC_CLR = '1' then
        acc <= (others => '0');
    elsif (rising_edge(clk) and count = '1') then
        acc <= add;
    end if;
    
    -- prevent overflow for adder:
    if (mult(x+y-2) = '0' and acc(x-1) = '0' and tadd(y-1) = '1') then
        -- if positive + positive = negative
        add <= "0111111111111111";
    elsif (mult(x+y-2) = '1' and acc(x-1) = '1' and tadd(y-1) = '0') then 
        -- if negative + negative = positive
        add <= "1000000000000001";
    else
        add <= tadd;
    end if;
    
    -- controller for counter
    if shift_en = '1' then -- rx_dv
        count <= '1';
    elsif sel = "10110" then -- clock 22
        count <= '0';
    end if;

    -- counter
    if count = '0' or rst ='1' then
        sel <= (others => '0');
    elsif rising_edge(clk) and valid = '1' then
        sel <= sel + 1;
		  start <= '1';
    end if;

    -- comparator
    if sel = "00000" or sel = "00111" or sel = "01110" or sel = "10101" then
        -- clear accumulator
        ACC_CLR <= '1';
		  p5_en <= '0';
        p10_en <= '0';
        p15_en <= '0';
    elsif sel = "00110" then -- 6
        p5_en <= '1';
    elsif sel = "01101" then -- 13
        p10_en <= '1';
    elsif sel = "10100" then -- 20
        p15_en <= '1';
    else
        ACC_CLR <= '0';
        p5_en <= '0';
        p10_en <= '0';
        p15_en <= '0';
    end if;

    -- multiplexer
    case sel is
        -- when "00000" => 0, clear accumulator
        when "00001" => -- 1
            M <= input; -- p0
            Q <= "0000000010010100";-- b00
        when "00010" => -- 2
            M <= p1;
            Q <= "0000000000000000";-- b01
        when "00011" => -- 3
            M <= p2;
            Q <= "1111111101010100";-- b02
        when "00100" => -- 4
            M <= p3;
            Q <= "0111111100101000";-- -a01
        when "00101" => -- 5
            M <= p4;
            Q <= "1100000010101010";-- -a02
        -- when "00110" => 6, add 1st section accumulator to p5
        -- when "00111" => 7, clear accumulator
        when "01000" => -- 8
            M <= p5;
            Q <= "0000000010100010";-- b10
        when "01001" => -- 9
            M <= p3;
            Q <= "0000000000000000";-- b11
        when "01010" => -- 10
            M <= p4;
            Q <= "1111111101010010";-- b12
        when "01011" => -- 11
            M <= p8;
            Q <= "0111111101110100";-- a11
        when "01100" => -- 12
            M <= p9;
            Q <= "1100000010101010";--a12
        -- when "01101" => 13, add 2nd section accumulator to p10
        -- when "01110" => 14, clear accumulator
        when "01111" => -- 15
            M <= p10;
            Q <= "0000000010010010";-- b20
        when "10000" => -- 16
            M <= p8;
            Q <= "0000000000000000";-- b21
        when "10001" => -- 17
            M <= p9;
            Q <= "1111111101101010";-- b22
        when "10010" => -- 18
            M <= p13;
            Q <= "0111111010101010";--a21
        when "10011" => -- 19
            M <= p14;
            Q <= "1100000101101010"; -- -a22
        -- when "10100" => 20, add 3rd section accumulator to p15
        -- when "10101" => 21, clear accumulator
        when others =>
            -- clear accumulator
            M <= (others => '0');
            Q <= (others => '0');
    end case;

end process;

multiplier : Booth
generic map(
		x => 16, -- size of multiplicand (M)
		y => 16  -- size of multiplier (Q)
	)
	
   port map (
        CLK   => clk,
        RST   => rst,
        start => start,
        M     => M,
        Q     => Q,
        valid  => valid,
        P     => mult
   );

-- (1,7) * (1,15) = (2,22)
--mult <= M * Q;
-- temporary add: to prevent overflow

tadd <= mult(x+y-2 downto x-1) + acc when valid = '1';

output <= (p15) when valid = '1' ;

end Behavioral;