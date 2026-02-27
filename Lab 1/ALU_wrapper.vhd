--Lab 1 COEN 316 ALU VHDL file
--Simon Guindon 40058301
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ALU_wrapper is
    port(x_in, y_in : in std_logic_vector(3 downto 0); -- two input
-- operands
        add_sub : in std_logic ;
-- 0 = add , 1 = sub
        logic_func : in std_logic_vector(1 downto 0 ) ; -- 00 = AND,
-- 01 = OR , 10 = XOR , 11 = NOR
        func : in std_logic_vector(1 downto 0 ) ; -- 00 = lui,5
-- 01 = setless , 10 = arith , 11 = logic
        output_out : out std_logic_vector(3 downto 0) ;
        overflow : out std_logic ;
        zero : out std_logic);
end ALU_wrapper ;

architecture arch_alu of ALU_wrapper is
    --result of the add/sub mux
    signal add_sub_result : std_logic_vector (31 downto 0);
    --result of the logic mux
    signal logic_func_result : std_logic_vector (31 downto 0);
    signal addition_result : std_logic_vector (31 downto 0);
    signal substraction_result : std_logic_vector (31 downto 0);
    signal x,y, output : std_logic_vector(31 downto 0);

begin
    x(3 downto 0) <= x_in(3) & x_in(2) & x_in(1) & x_in(0);
    y(3 downto 0) <= y_in(3) & y_in(2) & y_in(1) & y_in(0);
    x(31 downto 4) <= (others =>'0');
    y(31 downto 4) <= (others =>'0');
    output_out(3 downto 0) <= output(3 downto 0);


    addition_result <= x + y;
    substraction_result <= x - y;
    process (addition_result, substraction_result, add_sub) --instantiate process 1 for add/sub
    begin             --begin process 1
    --generating the add/sub output
        case add_sub is
            when '0' =>
                add_sub_result <= addition_result; -- addition when add_sub is 0
            when others =>
                add_sub_result <= substraction_result; -- substraction when add_sub is 1
        end case;
    end process;

    process (x, y, logic_func) --instantiate process 2 for logical operation
    begin             --begin process 2
    --generating the logical operation output
        case logic_func is
            when "00" =>
                logic_func_result <= x and y; -- addition when add_sub is 0
            when "01" =>
                logic_func_result <= x or y; -- addition when add_sub is 0
            when "10" =>
                logic_func_result <= x xor y; -- addition when add_sub is 0
            when others =>
                logic_func_result <= x nor y; -- addition when add_sub is 0
        end case;
    end process;

    process (x, y, add_sub_result, logic_func_result, func) --instantiate process 3 for ALU output
    begin             --begin process 3
    --generating the ALU output
        case func is
            when "00" =>
                output <= y;
            when "01" =>
                output <= "0000000000000000000000000000000" & add_sub_result(31); --31 zeroes and MSB of ASR
            when "10" =>
                output <= add_sub_result;
            when others =>
                output <= logic_func_result;
        end case;
    end process;
    process (add_sub_result) -- instantiate process 1 for add/sub
    begin
    -- generating the add/sub output
        if add_sub_result = 0 then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;
    --process for unsigned overflow
    process (x_in, y_in, add_sub, add_sub_result)
    begin
        if (add_sub = '0') then  -- Addition
            if (x_in(3) = '0' AND y_in(3) = '0' AND add_sub_result(3) = '0') then
                overflow <= '0';
            elsif (x_in(3) = '0' AND y_in(3) = '0' AND add_sub_result(3) = '1') then
                overflow <= '0';
            elsif (x_in(3) = '0' AND y_in(3) = '1' AND add_sub_result(3) = '0') then
                overflow <= '1';
            elsif (x_in(3) = '0' AND y_in(3) = '1' AND add_sub_result(3) = '1') then
                overflow <= '0';
            elsif (x_in(3) = '1' AND y_in(3) = '0' AND add_sub_result(3) = '0') then
                overflow <= '1';
            elsif (x_in(3) = '1' AND y_in(3) = '0' AND add_sub_result(3) = '1') then
                overflow <= '0';
            elsif (x_in(3) = '1' AND y_in(3) = '1' AND add_sub_result(3) = '0') then
                overflow <= '1';
            elsif (x_in(3) = '1' AND y_in(3) = '1' AND add_sub_result(3) = '1') then
                overflow <= '1';
            end if;
        else -- Subtraction
            if (x_in(3) = '0' AND y_in(3) = '0' AND add_sub_result(3) = '0') then
                overflow <= '0';
            elsif (x_in(3) = '0' AND y_in(3) = '0' AND add_sub_result(3) = '1') then
                overflow <= '1';
            elsif (x_in(3) = '0' AND y_in(3) = '1' AND add_sub_result(3) = '0') then
                overflow <= '1';
            elsif (x_in(3) = '0' AND y_in(3) = '1' AND add_sub_result(3) = '1') then
                overflow <= '1';
            elsif (x_in(3) = '1' AND y_in(3) = '0' AND add_sub_result(3) = '0') then
                overflow <= '0';
            elsif (x_in(3) = '1' AND y_in(3) = '0' AND add_sub_result(3) = '1') then
                overflow <= '0';
            elsif (x_in(3) = '1' AND y_in(3) = '1' AND add_sub_result(3) = '0') then
                overflow <= '0';
            elsif (x_in(3) = '1' AND y_in(3) = '1' AND add_sub_result(3) = '1') then
                overflow <= '1';
            end if;
        end if;
    end process;


end architecture;

