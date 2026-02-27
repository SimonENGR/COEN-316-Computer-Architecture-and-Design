library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity next_address is
    port(
        rs : in std_logic_vector(31 downto 0);
        rt : in std_logic_vector(31 downto 0);
        pc : in std_logic_vector(31 downto 0);
        target_address : in std_logic_vector(25 downto 0);
        branch_type : in std_logic_vector(1 downto 0);
        pc_sel : in std_logic_vector(1 downto 0);
        next_pc : out std_logic_vector(31 downto 0)
    );
end next_address;

architecture arch_next_address of next_address is

    signal pc_plus_one : std_logic_vector(31 downto 0);
    signal pc_plus_one_plus_branch_offset : std_logic_vector(31 downto 0);
    signal rs_eq_rt : std_logic;
    signal rs_ne_rt : std_logic;
    signal rs_ltz : std_logic;
    signal pc_beq : std_logic_vector(31 downto 0);
    signal pc_bne : std_logic_vector(31 downto 0);
    signal pc_blz : std_logic_vector(31 downto 0);
    signal address_cond : std_logic_vector(31 downto 0);
    signal target_address_fullbits : std_logic_vector(31 downto 0);
    signal target_address_branch_offset : std_logic_vector(15 downto 0);

begin
    pc_plus_one <= std_logic_vector(unsigned(pc) + 1);
    target_address_branch_offset <= target_address(15 downto 0);
    pc_plus_one_plus_branch_offset <= std_logic_vector(unsigned(pc) + 1 + unsigned(target_address_branch_offset));
    target_address_fullbits <= "000000" & target_address;

    rs_eq_rt <= '1' when rs = rt else '0';
    rs_ne_rt <= '1' when rs /= rt else '0';
    rs_ltz <= '1' when rs(31) = '1' else '0';

    process(pc_plus_one, pc_plus_one_plus_branch_offset, rs_eq_rt)
    begin
        if rs_eq_rt = '1' then
            pc_beq <= pc_plus_one_plus_branch_offset;
        else
            pc_beq <= pc_plus_one;
        end if;
    end process;
    process(pc_plus_one, pc_plus_one_plus_branch_offset, rs_ne_rt)
    begin
        if rs_ne_rt = '1' then
            pc_bne <= pc_plus_one_plus_branch_offset;
        else
            pc_bne <= pc_plus_one;
        end if;
    end process;
    process(pc_plus_one, pc_plus_one_plus_branch_offset, rs_ltz)
    begin
        if rs_ltz = '1' then
            pc_blz <= pc_plus_one_plus_branch_offset;
        else
            pc_blz <= pc_plus_one;
        end if;
    end process;
    process(pc_plus_one, pc_beq, pc_bne, pc_blz, branch_type)
    begin
        case branch_type is
            when "00" => address_cond <= pc_plus_one;
            when "01" => address_cond <= pc_beq;
            when "10" => address_cond <= pc_bne;
            when others => address_cond <= pc_blz;
        end case;
    end process;
    process(address_cond, target_address_fullbits, rs, pc_sel)
    begin
        case pc_sel is
            when "00" => next_pc <= address_cond;
            when "01" => next_pc <= target_address_fullbits;
            when others => next_pc <= rs;
        end case;
    end process;
end arch_next_address;