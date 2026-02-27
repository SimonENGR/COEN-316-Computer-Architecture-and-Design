-- 32 x 32 register file
-- two read ports, one write port with write enable
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
entity regfile is
    port( 
	din: in std_logic_vector(3 downto 0);
	reset : in std_logic;
	clk: in std_logic;
	write : in std_logic;
	read_a : in std_logic_vector(1 downto 0);
	read_b : in std_logic_vector(1 downto 0);
	write_address : in std_logic_vector(1 downto 0);
	out_a : out std_logic_vector(3 downto 0);
	out_b : out std_logic_vector(3 downto 0)
    );
end regfile;


architecture arch_reg of regfile is
    type t_register_array is array (0 to 3) of std_logic_vector(3 downto 0);
    signal t_reg : t_register_array;
    signal t_next: t_register_array;


begin
    --current state logic
    process(clk,reset) -- updating the occupancy in the register
    begin
        if (reset = '1') then
            t_reg(0 to 3) <= (others=>"0000");
        elsif (clk'event and clk = '1') then
	    if(write = '1') then
                t_reg <= t_next;
            end if;
        end if;
    end process;

    --Assigning the state of select
     t_next(to_integer(unsigned(write_address))) <= din;
    
    --Assigning out_a and out_b
    out_a <= t_reg(to_integer(unsigned(read_a)));
    out_b <= t_reg(to_integer(unsigned(read_b)));
end architecture;
