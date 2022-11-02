library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
	 
entity Booth is
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
end entity;

architecture rtl of Booth is
    signal A : std_logic_vector(x-1 downto 0); -- Accumulator register (same size as M)
	 signal M_int : std_logic_vector(x-1 downto 0); -- Internal register (same size as M)
    signal Q_int : std_logic_vector(y-1 downto 0); -- Internal register (same size as Q)
	 signal q0_prev : std_logic; -- flip-flop to contain previous Q_int(0)
    signal n : integer:= (x+y)/2; -- Counter of add/sub operations
    signal run : std_logic := '0'; -- running state flip-flop
begin

    process(CLK, RST)
	     variable temp: std_logic_vector(x-1 downto 0);
    begin
        if RST = '1' then
                A <= (others => '0');
					 M_int <= (others => '0');
                Q_int <= (others => '0');
					 q0_prev <= '0';
                n <= 0;
                run <= '0';
                valid <= '1';
		  elsif rising_edge(CLK) then
            if run = '1' then
                if n = 0 then
                    run <= '0';
                    valid <= '1';
                else 
                    if(Q_int(0) = '1' and q0_prev = '0') then
						      temp := A - M_int;
                    elsif (Q_int(0) = '0' and q0_prev = '1') then
                        temp := A + M_int;
						  else
						      temp := A;
                    end if;	     
						  A <= temp(x-1) & temp(x-1 downto 1);    -- Arithmetic shift right before store to Accumulator
						  Q_int <= temp(0) & Q_int(y-1 downto 1); -- continue shift right into Q_int
						  q0_prev <= Q_int(0);                    -- store the previous Q_int(0) 
                    n <= n - 1; 		-- decrement counter
                end if;
            elsif start = '1' then
                M_int <= M;               -- Store multiplicand to internal register
                Q_int <= Q;               -- Store multiplier to internal register
                n <= y;                   -- Set counter to size of multiplier
                run <= '1';					 -- Calculation in progress
                valid <= '0';					 -- Calculation in progress
            end if;
        end if;
    end process;
	 
	 P <= A & Q_int;
end architecture;