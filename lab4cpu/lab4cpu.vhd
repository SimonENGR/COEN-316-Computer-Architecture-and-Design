library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity datapath is
    port(
        clk    : in std_logic;
        reset  : in std_logic;
        out_a_dp : out std_logic_vector(31 downto 0);
        out_b_dp : out std_logic_vector(31 downto 0);
        pc_out_dp : out std_logic_vector(3 downto 0);
        overflow_dp : out std_logic;
        zero_dp : out std_logic

    );
end datapath;

architecture arch_datapath of datapath is

    -- SECTION A - PROGRAM COUNTER REGISTER
    signal pc : std_logic_vector(31 downto 0); -- verified

    -- SECTION B - INSTRUCTION CACHE
    signal instr_address : std_logic_vector(4 downto 0); -- verified
    signal instruction   : std_logic_vector(31 downto 0); -- verified
    
    -- SECTION C - SIGN EXTENSION
    --signal extfunc : std_logic_vector(1 downto 0);
    signal extended_instruction : std_logic_vector(31 downto 0);
    
    -- SECTION D - REGFILE LOGIC & SIGNALS FOR PORTMAP
    signal reg_din          : std_logic_vector(31 downto 0);
    signal out_a, out_b : std_logic_vector(31 downto 0);
    signal rsregaddr, rtregaddr, write_reg : std_logic_vector(4 downto 0); -- those are the 5 bits addresses going into regfile
                                                                           -- rs and rt for next_address are out_a and out_b
    
    -- SECTION E - ALU LOGIC & SIGNALS FOR PORTMAP
    signal alu_x, alu_y, alu_output : std_logic_vector(31 downto 0);
    signal alu_zero, alu_overflow : std_logic;
    
    -- SECTION F - DATA CACHE LOGIC
    type t_memory_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal t_mem : t_memory_array;
    -- MEMORY REGISTERS (DATA CACHE)
    signal data_address   : std_logic_vector(4 downto 0); -- 5 bits from ALU output
    signal data_to_write  : std_logic_vector(31 downto 0); -- Input from regfile (out_b)
    signal read_data_from_mem : std_logic_vector(31 downto 0); -- Memory read output
    
    -- SECTION G - CONTROL UNIT SIGNALS
    signal opcode : std_logic_vector(5 downto 0);
    signal instrc_func : std_logic_vector(5 downto 0);
    
    -- one bit signals
    signal reg_write : std_logic; -- Signal G1 - goes to Section D
    signal reg_dst : std_logic; -- Signal G2 - goes to Section D
    signal memory_to_register : std_logic; -- Signal G3 - Into Regfile's din When 1, takes ALU output (Section E)
                                                                          -- When 0 Data Cache output (Section F)
    signal alusrc : std_logic; -- Signal G4
    signal add_sub : std_logic; -- Signal G5
    signal datacache_write : std_logic; -- Signal G6 0 dont write, 1 write into data cache
    
    -- two bits signals
    signal logic_func : std_logic_vector(1 downto 0); -- 00 = AND; 01 = OR; 10 = XOR; 11 = NOR;
    signal extfunc : std_logic_vector(1 downto 0); -- logic for padding the immediate value
    signal branch_type : std_logic_vector(1 downto 0);
    signal pc_sel : std_logic_vector(1 downto 0);
    
    -- SECTION H - NEXTADDR LOGIC & SIGNALS FOR PORTMAP
    signal next_pc : std_logic_vector(31 downto 0);
    signal target_address : std_logic_vector(25 downto 0);

begin

    -- SECTION A - PROGRAM COUNTER REGISTER
    process(clk, reset)
    begin
        if (reset = '1') then
            pc <= (others => '0');
        elsif (clk'event and clk = '1') then
           -- if (reg_write = '1') then
            pc <= next_pc;
           -- end if;
        end if;
    end process;
    pc_out_dp <= pc(3 downto 0);
    -- SECTION B - INSTRUCTION CACHE
    instr_address <= pc(4 downto 0); -- verified
    process(instr_address)
    begin
        case instr_address is
            --write MIPS instructions as necessary
            when "00000" => instruction <= "00100000000000110000000000000000"; -- addi r3, r0, 0
            when "00001" => instruction <= "00100000000000010000000000000000"; -- addi r1, r0, 0
            when "00010" => instruction <= "00100000000000010000000000000000"; -- addi r1, r0, 0
            when "00011" => instruction <= "00000000001000100000100000100000"; -- add r1,r1,r2
            when "00100" => instruction <= "00100000010000101111111111111111"; -- addi r2, r2, -1
            when "00101" => instruction <= "00010000010000110000000000000001"; -- beq r2,r3 (+1) THERE
            when "00110" => instruction <= "00001000000000000000000000000011"; -- jump 3  (LOOP)
            when "00111" => instruction <= "10101100000000010000000000000000"; -- sw r1, 0(r0)
            when "01000" => instruction <= "10001100000001000000000000000000"; -- lw r4, 0(r0)
            when "01001" => instruction <= "00110000100001000000000000001010"; -- andi r4,r4, 0x000A
            when "01010" => instruction <= "00110100100001000000000000000001"; -- ori r4,r4, 0x0001
            when "01011" => instruction <= "00111000100001000000000000001011"; -- xori r4,r4, 0xB
            when "01100" => instruction <= "00111000100001000000000000000000"; -- xori r4,r4, 0x0000
            when others =>  instruction <= "00000000000000000000000000000000"; -- dont care
        end case;
    end process;

    -- SECTION C - SIGN EXTENSION
    process(extfunc, instruction)
    begin
        case extfunc is
            when "00" => extended_instruction <= instruction(15 downto 0) & "0000000000000000";
            when "01" => extended_instruction <= (15 downto 0 => instruction(15)) & instruction(15 downto 0);
            when "10" => extended_instruction <= (15 downto 0 => instruction(15)) & instruction(15 downto 0);
            when "11" => extended_instruction <= "0000000000000000" & instruction(15 downto 0);
            when others => extended_instruction <= (others => '0');
        end case;
    end process;
    
    -- SECTION D - INSTRUCTION DECOMPOSITION
    target_address <= instruction(25 downto 0); -- Forward to Section H -- verified
    rsregaddr <= instruction(25 downto 21); -- Forward to regfile logic -- verified
    rtregaddr <= instruction(20 downto 16); -- Forward to regfile logic -- verified
    
    opcode <= instruction(31 downto 26); -- Forward to Control logic -- verified
    instrc_func <= instruction(5 downto 0); -- Forward to Control logic -- verified
    
    -- MUX controlled by reg_dst
    process(reg_dst, instruction)
    begin
        if reg_dst = '1' then
            write_reg <= instruction(15 downto 11); -- verified
        else
            write_reg <= instruction(20 downto 16); -- verified
        end if;
    end process;

    -- SECTION D - DATA REGISTERS LOGIC & SIGNALS FOR PORTMAP
    regfile_inst : entity work.regfile
    port map(
        din => reg_din,
        reset => reset,
        clk => clk,
        write => reg_write, -- from G
        read_a => rsregaddr, -- from D
        read_b => rtregaddr, -- from D
        write_address => write_reg, -- from D
        out_a => out_a,
        out_b => out_b
    );
    out_a_dp <= out_a;
    out_b_dp <= out_b;

    -- SECTION E - ALU LOGIC & SIGNALS FOR PORTMAP
    -- logic for first input, straight from regfile
    alu_x <= out_a;
    -- logic for second input, straight from
    process(alusrc, out_b, extended_instruction)
    begin
        if alusrc = '1' then
            alu_y <= extended_instruction;
        else
            alu_y <= out_b;
        end if;
    end process;

    alu_inst : entity work.alu
    port map(
        x => alu_x,
        y => alu_y,
        add_sub => add_sub,
        logic_func => logic_func,
        func => branch_type,
        output => alu_output,
        overflow => alu_overflow,
        zero => alu_zero
    );
    overflow_dp <= alu_overflow;
    zero_dp <= alu_zero;
    -- Section F Data cache (memory)
    -- Map address
    data_address <= alu_output(4 downto 0); -- Extract 5 bits from ALU result
    data_to_write <= out_b;
    -- Memory process
    process(clk,reset, datacache_write, data_address, data_to_write,t_mem) -- updating the occupancy in the register
    begin
        --writing into memory logic
        if (reset = '1') then
            t_mem(0 to 31) <= (others=>"00000000000000000000000000000000");
        elsif (clk'event and clk = '1') then
            if(datacache_write = '1') then
            -- Write data to memory
                t_mem(to_integer(unsigned(data_address))) <= data_to_write;
            end if;
        end if;
     -- Read from memory logic
        read_data_from_mem <= t_mem(to_integer(unsigned(data_address)));
    end process;

    -- MUX after Data Cache
    process(memory_to_register, read_data_from_mem, alu_output)
    begin
        if memory_to_register = '1' then
            reg_din <= read_data_from_mem; -- Data from memory back into regfile's data input
        else
            reg_din <= alu_output; -- Data directly from ALU back into regfile's data input
        end if;
    end process;

-- SECTION G - CONTROL LOGIC
    process(opcode, instrc_func)
    begin
        case opcode is
    -- add/sub/slt/and/or/xor/nor/jr
            when "000000" =>
        -- add
                if instrc_func = "100000" then
                    reg_write <= '1';
                    reg_dst <= '1';
                    memory_to_register <= '0';
                    ALUSrc <= '0';
                    add_sub <= '0';
                    datacache_write <= '0';
                    logic_func <= "00";
                    extfunc <= "10";
                    branch_type <= "00";
                    pc_sel <= "00";

        -- sub
                elsif instrc_func = "100010" then
                    reg_write <= '1';
                    reg_dst <= '1';
                    memory_to_register <= '0';
                    ALUSrc <= '0';
                    add_sub <= '1';
                    datacache_write <= '0';
                    logic_func <= "00";
                    extfunc <= "10";
                    branch_type <= "00";
                    pc_sel <= "00";

        -- slt
                elsif instrc_func = "101010" then
                    reg_write <= '1';
                    reg_dst <= '1';
                    memory_to_register <= '0';
                    ALUSrc <= '0';
                    add_sub <= '1';
                    datacache_write <= '0';
                    logic_func <= "00";
                    extfunc <= "10";
                    branch_type <= "00";
                    pc_sel <= "00";

        -- and
                elsif instrc_func = "100100" then
                    reg_write <= '1';
                    reg_dst <= '1';
                    memory_to_register <= '0';
                    ALUSrc <= '0';
                    add_sub <= '1';
                    datacache_write <= '0';
                    logic_func <= "00";
                    extfunc <= "11";
                    branch_type <= "00";
                    pc_sel <= "00";

        -- or
                elsif instrc_func = "100101" then
                    reg_write <= '1';
                    reg_dst <= '1';
                    memory_to_register <= '0';
                    ALUSrc <= '0';
                    add_sub <= '1';
                    datacache_write <= '0';
                    logic_func <= "01";
                    extfunc <= "11";
                    branch_type <= "00";
                    pc_sel <= "00";

        -- xor
                elsif instrc_func = "100110" then
                    reg_write <= '1';
                    reg_dst <= '1';
                    memory_to_register <= '0';
                    ALUSrc <= '0';
                    add_sub <= '1';
                    datacache_write <= '0';
                    logic_func <= "10";
                    extfunc <= "11";
                    branch_type <= "00";
                    pc_sel <= "00";

        -- nor
                elsif instrc_func = "100111" then
                    reg_write <= '1';
                    reg_dst <= '1';
                    memory_to_register <= '0';
                    ALUSrc <= '0';
                    add_sub <= '1';
                    datacache_write <= '0';
                    logic_func <= "11";
                    extfunc <= "11";
                    branch_type <= "00";
                    pc_sel <= "00";

        -- jr
                elsif instrc_func = "001000" then
                    reg_write <= '0';
                    reg_dst <= '0';
                    memory_to_register <= '0';
                    ALUSrc <= '0';
                    add_sub <= '0';
                    datacache_write <= '0';
                    logic_func <= "00";
                    extfunc <= "00";
                    branch_type <= "11"; -- dc
                    pc_sel <= "10";
                end if;

    -- addi
            when "001000" =>
                reg_write <= '1';
                reg_dst <= '0';
                memory_to_register <= '0';
                ALUSrc <= '1';
                add_sub <= '0';
                datacache_write <= '0';
                logic_func <= "00";
                extfunc <= "10";
                branch_type <= "00";
                pc_sel <= "00";
    -- slti
            when "001010" =>
                reg_write <= '1';
                reg_dst <= '0';
                memory_to_register <= '0';
                ALUSrc <= '1';
                add_sub <= '1';
                datacache_write <= '0';
                logic_func <= "00";
                extfunc <= "10";
                branch_type <= "00";
                pc_sel <= "00";
    -- andi
            when "001100" =>
                reg_write <= '1';
                reg_dst <= '0';
                memory_to_register <= '0';
                ALUSrc <= '1';
                add_sub <= '1';
                datacache_write <= '0';
                logic_func <= "00";
                extfunc <= "11";
                branch_type <= "00";
                pc_sel <= "00";
    -- ori
            when "001101" =>
                reg_write <= '1';
                reg_dst <= '0';
                memory_to_register <= '0';
                ALUSrc <= '1';
                add_sub <= '1';
                datacache_write <= '0';
                logic_func <= "01";
                extfunc <= "11";
                branch_type <= "00";
                pc_sel <= "00";
    -- xori
            when "001110" =>
                reg_write <= '1';
                reg_dst <= '0';
                memory_to_register <= '0';
                ALUSrc <= '1';
                add_sub <= '1';
                datacache_write <= '0';
                logic_func <= "10";
                extfunc <= "11";
                branch_type <= "00";
                pc_sel <= "00";
    -- lw
            when "100011" =>
                reg_write <= '1';
                reg_dst <= '0';
                memory_to_register <= '1';
                ALUSrc <= '1';
                add_sub <= '0';
                datacache_write <= '0';
                logic_func <= "10";
                extfunc <= "10";
                branch_type <= "00";
                pc_sel <= "00";
    -- sw
            when "101011" =>
                reg_write <= '0';
                reg_dst <= '0';
                memory_to_register <= '0';
                ALUSrc <= '1';
                add_sub <= '0';
                datacache_write <= '1';
                logic_func <= "10";
                extfunc <= "10";
                branch_type <= "00";
                pc_sel <= "00";
            when others =>
                reg_write <= '0';
                reg_dst <= '0';
                memory_to_register <= '0';
                ALUSrc <= '0';
                add_sub <= '0';
                datacache_write <= '0';
                logic_func <= "00";
                extfunc <= "00";
                branch_type <= "00";
                pc_sel <= "00";
        end case;
    end process;
    
-- SECTION H - NEXTADDR LOGIC & SIGNALS FOR PORTMAP
    next_address_inst : entity work.next_address
    port map(
        rs => out_a, -- rs here is the 32 bits output from regfile, not the rsregaddr 5 bit value that was used to find the address of the value
        rt => out_b,
        pc => pc, -- verified
        target_address => target_address,
        branch_type => branch_type,
        pc_sel => pc_sel,
        next_pc => next_pc
    );

end arch_datapath;
