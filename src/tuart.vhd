----------------------------------------------------------------------------------
-- Company:        STMicroelectronics
-- Engineer:       David Siorpaes
-- Create Date:    09:50:25 06/30/2015 
-- Module Name:    tuart - Behavioral 
-- Description:    Trivial UART. Just sends data with 8N1 format.
--                 UART baud rate is derived from input clock frequency.
--                 Clock divider must be a power of 2.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tuart is
    Port ( CLOCK : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           START : in  STD_LOGIC;
           BUSY : out STD_LOGIC;
           TX : out  STD_LOGIC);
end tuart;

architecture Behavioral of tuart is
signal datahold : std_logic_vector (7 downto 0) := (others => '0');
signal counter : std_logic_vector (1 downto 0) := (others => '0');
signal uart_clock : std_logic;
begin
	--tuart process
	process(CLOCK, start)
	--State machine descriptor
	--N=10        IDLE state
	--N=0         START condition
	--N>0 && N<9  Transmitting data
	--N=9         STOP condition
	variable N : integer := 10;
	begin
		if rising_edge(CLOCK) then
			--Manage BUSY signal: if not IDLE, BUSY
			if N = 10 then
				BUSY <= '0';
				TX <= '1';
			else
				BUSY <= '1';
			end if;

			--Send START condition
			if N = 0 then
				TX <= '0';
				N := 1;
			
			--Send Data
			elsif N > 0 and N < 9 then
				TX <= datahold(N-1);
				N := N + 1;
			
			--Send STOP condition, restart state machine, no more busy
			elsif N = 9 then
				TX <= '1';
				N := 10;
			end if;
			
			--If start=1 initiate transmission.
			--Transmission starts only if tuart is idle
			if start = '1' and N = 10 then
				--Sample data and start state machine. Mark BUSY
				datahold <= DATA;
				N := 0;
				BUSY <= '1';
			end if;		
		end if;
	end process;
end Behavioral;
