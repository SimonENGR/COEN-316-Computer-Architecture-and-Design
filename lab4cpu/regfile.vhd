-- 32 x 32 register file
-- two read ports, one write port with write enable
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity regfile is
    port(
        din           : in  std_logic_vector(31 downto 0);
        reset         : in  std_logic;
        clk           : in  std_logic;
        write         : in  std_logic;
        read_a        : in  std_logic_vector(4 downto 0); -- rs
        read_b        : in  std_logic_vector(4 downto 0); -- rt
        write_address : in  std_logic_vector(4 downto 0);
        out_a         : out std_logic_vector(31 downto 0);
        out_b         : out std_logic_vector(31 downto 0)
    );
end regfile;

architecture arch_reg of regfile is
    type t_register_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal t_reg  : t_register_array;
    signal t_next : t_register_array;
begin

    -- Combinational process to form the next state of the register file.
    process(t_reg, write, write_address, din)
    begin
        -- Start with the current register state.
        t_next <= t_reg;
        -- If write is enabled, update the targeted register.
        if write = '1' then
            t_next(to_integer(unsigned(write_address))) <= din;
        end if;
    end process;

    -- Clocked process to update the register state.
    process(clk, reset)
    begin
        if reset = '1' then
            t_reg <= (others => (others => '0'));
        elsif rising_edge(clk) then
            t_reg <= t_next;
        end if;
    end process;

    -- Read ports.
    out_a <= t_reg(to_integer(unsigned(read_a)));
    out_b <= t_reg(to_integer(unsigned(read_b)));
end architecture;
