library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_seconds_compare is
end tb_seconds_compare;

architecture tb of tb_seconds_compare is

    component seconds_compare
        port (rst             : in std_logic;
              clk             : in std_logic;
              ce              : in std_logic;
              alarm_en        : in std_logic; 
              buzzer_off      : in std_logic;
              s_clock         : in std_logic_vector (16 downto 0);
              s_alarm         : in std_logic_vector (16 downto 0);
              buzzer_interval : out std_logic);
    end component;

    signal rst             : std_logic;
    signal clk             : std_logic;
    signal ce              : std_logic := '0';
    signal alarm_en        : std_logic := '0';
    signal buzzer_off      : std_logic := '0';
    signal s_clock         : std_logic_vector (16 downto 0) := (others => '0');
    signal s_alarm         : std_logic_vector (16 downto 0) := (others => '0');
    signal buzzer_interval : std_logic;

    constant TbPeriod : time := 10 ns; -- 100MHz hodiny
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : seconds_compare
    port map (rst             => rst,
              clk             => clk,
              ce              => ce,
              alarm_en        => alarm_en,
              buzzer_off      => buzzer_off,
              s_clock         => s_clock,
              s_alarm         => s_alarm,
              buzzer_interval => buzzer_interval);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    p_ce_gen : process
    begin
        while TbSimEnded /= '1' loop
            ce <= '1';
            wait for TbPeriod;
            ce <= '0';
            wait for TbPeriod * 9;
        end loop;
        wait;
    end process;

    stimuli : process
    begin
        alarm_en <= '0';
        buzzer_off <= '0';
        s_clock <= (others => '0');
        s_alarm <= std_logic_vector(to_unsigned(30, 17)); 
        
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 50 ns;

        alarm_en <= '1';
        
        for i in 0 to 40 loop
            s_clock <= std_logic_vector(to_unsigned(i, 17));
            wait for TbPeriod * 20; 
        end loop;

        buzzer_off <= '1';
        wait for 40 ns;
        buzzer_off <= '0';
        
        wait for 200 ns;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;