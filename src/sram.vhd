-- Simple SRAM implementation

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram is
port(
	address   : in  std_logic_vector(5 downto 0);
	datain    : in  std_logic_vector(31 downto 0);
	clk       : in  std_logic;
	we        : in  std_logic;
	dataout   : out std_logic_vector(31 downto 0)
);
end sram;

architecture Behavioral of sram is

type memory_array is array(0 to 63) of std_logic_vector(31 downto 0);

signal memory : memory_array := (
			x"20001000", x"00000009", x"bf404600", x"46004600", x"bf404600", x"46004600", x"e7f6e7f6", x"00000000",
			x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", 
			x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", 
			x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", 
			x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", 
			x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", 
			x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", 
			x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000"
);


--Infer Block RAM for Xilinx FPGA                   
attribute ram_style : string;                       
attribute ram_style of memory : signal is "block";

-- Infer Block RAM for Lattice FPGA
attribute syn_ramstyle : string;
attribute syn_ramstyle of memory : signal is "block_ram";

signal r_address  : std_logic_vector(5 downto 0) := (others => '0');

begin

process(clk)
begin
	if rising_edge(clk) then
		--Latch address
		r_address <= address;

		if(we /= '0') then
			memory(to_integer(unsigned(r_address))) <= datain;
		end if;
	end if;
end process;

dataout <= memory(to_integer(unsigned(r_address)));

end Behavioral;
