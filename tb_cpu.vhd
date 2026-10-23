----------------------------------------------------------------------------------
-- Module : tb_cpu (testbench)
-- Applies RESET for one rising edge, then runs the Set 9 program
-- and checks ACC, Z and PC after every clock against Appendix B.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_cpu is
end tb_cpu;

architecture Behavioral of tb_cpu is

    -- signals connected to the CPU
    signal CLK    : STD_LOGIC := '0';
    signal RESET  : STD_LOGIC := '0';
    signal Q      : STD_LOGIC_VECTOR(7 downto 0);
    signal Z      : STD_LOGIC;
    signal PC_OUT : STD_LOGIC_VECTOR(3 downto 0);
	 
	 
	 -- clock period
    constant CLK_PERIOD : time := 10 ns;

begin

    -- the CPU under test
    UUT : entity work.cpu_top
        port map (
            CLK    => CLK,
            RESET  => RESET,
            Q      => Q,
            Z      => Z,
            PC_OUT => PC_OUT
        );
		  
		  
	 -- clock generator: low for 5 ns, high for 5 ns, repeat
    clk_process : process
    begin
        CLK <= '0';
        wait for CLK_PERIOD / 2;
        CLK <= '1';
        wait for CLK_PERIOD / 2;
    end process;
	 
	 
	 -- test sequence
    stim_process : process

        -- compares ACC, Z and PC with the expected values
        procedure check (
            exp_q  : in STD_LOGIC_VECTOR(7 downto 0);
            exp_z  : in STD_LOGIC;
            exp_pc : in STD_LOGIC_VECTOR(3 downto 0);
            name   : in string) is
				
				
		  begin
            assert (Q = exp_q) and (Z = exp_z) and (PC_OUT = exp_pc)
                report name & " FAILED"
                severity error;
        end procedure;

    begin
        -- cycle 0: RESET = 1 for one rising edge
        RESET <= '1';
        wait until rising_edge(CLK);
		  
		  wait for 1 ns;
        check(x"00", '1', "0000", "RESET");
        RESET <= '0';
			
			
        -- cycle 1: LDI 0xFF
        wait until rising_edge(CLK);
        wait for 1 ns;
        check(x"FF", '0', "0001", "LDI 0xFF");

        -- cycle 2: NOT
        wait until rising_edge(CLK);
        wait for 1 ns;
        check(x"00", '1', "0010", "NOT");

        -- cycle 3: JZ 0x05 (taken, next PC = 5)
        wait until rising_edge(CLK);
        wait for 1 ns;
        check(x"00", '1', "0101", "JZ 0x05 taken");

        -- cycle 4: ADD 0x11
        wait until rising_edge(CLK);
        wait for 1 ns;
        check(x"11", '0', "0110", "ADD 0x11");

        -- cycle 5: SHL
        wait until rising_edge(CLK);
        wait for 1 ns;
        check(x"22", '0', "0111", "SHL (1st)");

        -- cycle 6: JZ 0x00 (not taken, next PC = 8)
        wait until rising_edge(CLK);
        wait for 1 ns;
        check(x"22", '0', "1000", "JZ 0x00 not taken");

        -- cycle 7: SHL
        wait until rising_edge(CLK);
        wait for 1 ns;
        check(x"44", '0', "1001", "SHL (2nd)");

        -- last instruction done
        report "Test finished. If no FAILED message above, all checks passed."
            severity note;
        wait;
    end process;

end Behavioral;
		  