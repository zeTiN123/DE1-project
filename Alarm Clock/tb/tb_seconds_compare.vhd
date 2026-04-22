library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity tb_seconds_compare is
end tb_seconds_compare;

architecture tb of tb_seconds_compare is

    component seconds_compare
        port (rst             : in std_logic;
              clk             : in std_logic;
              ce              : in std_logic;
              buzzer_off      : in std_logic;
              s_clock         : in std_logic_vector (16 downto 0);
              s_alarm         : in std_logic_vector (16 downto 0);
              buzzer_interval : out std_logic);
    end component;

    signal rst             : std_logic;
    signal clk             : std_logic;
    signal ce              : std_logic := '0';
    signal buzzer_off      : std_logic := '0';
    signal s_clock         : std_logic_vector (16 downto 0) := (others => '0');
    signal s_alarm         : std_logic_vector (16 downto 0) := "00000000000000011";
    signal buzzer_interval : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here ------100MHz
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : seconds_compare
    port map (rst             => rst,
              clk             => clk,
              ce              => ce,
              buzzer_off      => buzzer_off,
              s_clock         => s_clock,
              s_alarm         => s_alarm,
              buzzer_interval => buzzer_interval);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;
    
    
    
    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        ce <= '0';
        wait for 30 ns;
        ce <= '1';
        wait for 10 ns;
        
        buzzer_off <= '0';
        s_clock <= (others => '0');
        s_alarm <= std_logic_vector(to_unsigned(41, 17));

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;
        
        for i in 0 to 50 loop
            s_clock <= std_logic_vector(to_unsigned(i,17));
            wait for 10 ns;
        end loop;
        -- ***EDIT*** Add stimuli here
        wait for 50 ns;
        
        buzzer_off <= '1';
        wait for 20 ns;
        buzzer_off <= '0';
        
        wait for 50 ns;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_seconds_compare of tb_seconds_compare is
    for tb
    end for;
end cfg_tb_seconds_compare;