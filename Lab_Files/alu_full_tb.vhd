-- ALU Testbench (tests for all outputs
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

entity alu_tb is
end entity; 


architecture TB of alu_full_tb is 

    component alu        
        generic (WIDTH : positive := 32);
        port (
            a, b              : in  std_logic_vector(WIDTH-1 downto 0);
            opsel, ir_sh      : in  std_logic_vector(4 downto 0);
            result, result_hi : out std_logic_vector(WIDTH-1 downto 0);
            branch_taken      : out std_logic
            );
    end component;
    CONSTANT WIDTH : positive := 32;
    signal a, b, result, result_hi : std_logic_vector(WIDTH-1 downto 0); 
    signal ir_sh, opsel : std_logic_vector(4 downto 0); 
    signal branch_taken : std_logic;   

begin 
    
    UUT : alu 
    generic map (WIDTH => WIDTH)
    port map(
        a               => a,
        b               => b,
        opsel           => opsel,
        ir_sh           => ir_sh,
        result          => result,
        result_hi       => result_hi,
        branch_taken    => branch_taken
    );

    process
    begin 
        -- test 10 + 15 (no overflow)
        opsel    <= "00000";
        a <= conv_std_logic_vector(10, a'length);
        b <= conv_std_logic_vector(15, b'length);
        wait for 40 ns;
        assert(result = conv_std_logic_vector(25, result'length)) report "Error : 10 +15 = " & integer'image(conv_integer(result)) & " instead of 25" severity warning;
        assert(result_hi = conv_std_logic_vector(0, result_hi'length)) report "Hi Register Incorrect for 10 + 15 it equals: " & integer'image(conv_integer(result_hi)) severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for 10 + 15" severity warning;
        
        -- test 25 - 10 (no overflow)
        opsel    <= "00001";
        a <= conv_std_logic_vector(25, a'length);
        b <= conv_std_logic_vector(10, b'length);
        wait for 40 ns;
        assert(result = conv_std_logic_vector(15, result'length)) report "Error : 25-10 = " & integer'image(conv_integer(result)) & " instead of 15" severity warning;
        assert(result_hi = conv_std_logic_vector(0, result_hi'length)) report "Hi Register Incorrect for 25 -10 it equals: " & integer'image(conv_integer(result_hi)) severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for 25 - 10" severity warning;
        

                -- test 10 + 15 (no overflow)
        opsel    <= "00010";
        a <= std_logic_vector(to_signed(10, WIDTH));
        b <= std_logic_vector(to_signed(-4, WIDTH));
        wait for 40 ns;
        assert(result = std_logic_vector(to_signed(-40, WIDTH))) report "Error : 10*-4 = " & integer'image(conv_integer(result)) & " instead of -40" severity warning;
        assert(result_hi = std_logic_vector(to_signed(-1, WIDTH))) report "Error : 10*-4 = " & integer'image(conv_integer(result_hi)) & " instead of -1" severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for 10*-4" severity warning;

        
        opsel    <= "00011";
        a <= conv_std_logic_vector(65536, a'length);
        b <= conv_std_logic_vector(131072, b'length);
        wait for 40 ns;
        assert(result = conv_std_logic_vector(0, result'length)) report "Error : 65536 * 131072 = " & integer'image(conv_integer(result)) & " instead of 0" severity warning;
        assert(result_hi = conv_std_logic_vector(2, result_hi'length)) report "Error : 65536 * 131072 = " & integer'image(conv_integer(result_hi)) & " instead of 2" severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for 65536 * 131072" severity warning;

        opsel    <= "00100";
        a <= x"0000FFFF";
        b <= x"FFFF1234";
        wait for 40 ns;
        assert(result = x"00001234") report "Error : A and B = " & integer'image(conv_integer(result)) & " instead of 00001234" severity warning;
        assert(result_hi = conv_std_logic_vector(0, result_hi'length)) report "Error : HI A and B = " & integer'image(conv_integer(result_hi)) & " instead of 0" severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for A and B" severity warning;

        opsel    <= "00111";
        ir_sh <= conv_std_logic_vector(4, ir_sh'length);
        b <= x"0000000F";
        wait for 40 ns;
        assert(result = conv_std_logic_vector(0, result'length)) report "Error : B logical RS = " & integer'image(conv_integer(result)) & " instead of 0" severity warning;
        assert(result_hi = conv_std_logic_vector(0, result_hi'length)) report "Error : HI B logical RS = " & integer'image(conv_integer(result_hi)) & " instead of 0" severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for B logical RS" severity warning;

        


        opsel    <= "01000";
        ir_sh <= conv_std_logic_vector(1, ir_sh'length);
        b <= x"F0000008";
        wait for 40 ns;
        assert(result = x"F8000004") report "Error : B arithmetic RS = " & integer'image(conv_integer(result)) & " instead of xF8000004" severity warning;
        assert(result_hi = conv_std_logic_vector(0, result_hi'length)) report "Error : HI B Arithmetic RS = " & integer'image(conv_integer(result_hi)) & " instead of 0" severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for B logical RS" severity warning;

        opsel    <= "01000";
        ir_sh <= conv_std_logic_vector(1, ir_sh'length);
        b <= x"00000008";
        wait for 40 ns;
        assert(result = x"00000004") report "Error : B arithmetic RS = " & integer'image(conv_integer(result)) & " instead of x00000004" severity warning;
        assert(result_hi = conv_std_logic_vector(0, result_hi'length)) report "Error : HI B Arithmetic RS = " & integer'image(conv_integer(result_hi)) & " instead of 0" severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for B logical RS" severity warning;


        opsel    <= "01001";
        a <= conv_std_logic_vector(10, a'length);
        b <= conv_std_logic_vector(15, b'length);
        wait for 40 ns;
        assert(result = conv_std_logic_vector(1, result'length)) report "Error : A < B = " & integer'image(conv_integer(result)) & " instead of 1" severity warning;
        assert(result_hi = conv_std_logic_vector(0, result_hi'length)) report "Error : HI A < B = " & integer'image(conv_integer(result_hi)) & " instead of 0" severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for A < B" severity warning;

        opsel    <= "01001";
        a <= conv_std_logic_vector(15, a'length);
        b <= conv_std_logic_vector(10, b'length);
        wait for 40 ns;
        assert(result = conv_std_logic_vector(0, result'length)) report "Error : A < B = " & integer'image(conv_integer(result)) & " instead of 0" severity warning;
        assert(result_hi = conv_std_logic_vector(0, result_hi'length)) report "Error : HI A < B = " & integer'image(conv_integer(result_hi)) & " instead of 0" severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for A < B" severity warning;

        opsel    <= "01010";
        a <= conv_std_logic_vector(5, a'length);
        wait for 40 ns;
        assert(result = conv_std_logic_vector(0, result'length)) report "Error : blez = " & integer'image(conv_integer(result)) & " instead of 0" severity warning;
        assert(result_hi = conv_std_logic_vector(0, result_hi'length)) report "Error : HI blez = " & integer'image(conv_integer(result_hi)) & " instead of 0" severity warning;
        assert(branch_taken = '0') report "Error                                   : branch_taken incorrect for blez" severity warning;

        opsel    <= "01011";
        a <= conv_std_logic_vector(5, a'length);
        wait for 40 ns;
        assert(result = conv_std_logic_vector(0, result'length)) report "Error : bgtz = " & integer'image(conv_integer(result)) & " instead of 0" severity warning;
        assert(result_hi = conv_std_logic_vector(0, result_hi'length)) report "Error : HI bgtz = " & integer'image(conv_integer(result_hi)) & " instead of 0" severity warning;
        assert(branch_taken = '1') report "Error                                   : branch_taken incorrect for bgtz" severity warning;


        report "Simulation Finished";
        wait;
        
    end process;



end TB;



