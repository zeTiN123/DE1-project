library ieee;
use ieee.std_logic_1164.all;

entity tb_counter_alarm is
end tb_counter_alarm;

architecture tb of tb_counter_alarm is

    component counter_alarm
        port (clk                 : in std_logic;
              rst                 : in std_logic;
              en                  : in std_logic;
              btnc_press          : in std_logic;
              btnu_press          : in std_logic;
              btnr_press          : in std_logic;
              alarm_on            : out std_logic;
              total_alarm_seconds : out std_logic_vector (16 downto 0);
              alr_minutes_x0      : out std_logic_vector (3 downto 0);
              alr_minutes_0x      : out std_logic_vector (3 downto 0);
              alr_hours_x0        : out std_logic_vector (3 downto 0);
              alr_hours_0x        : out std_logic_vector (3 downto 0));
    end component;

    signal clk                 : std_logic;
    signal rst                 : std_logic;
    signal en                  : std_logic;
    signal btnc_press          : std_logic;
    signal btnu_press          : std_logic;
    signal btnr_press          : std_logic;
    signal alarm_on            : std_logic;
    signal total_alarm_seconds : std_logic_vector (16 downto 0);
    signal alr_minutes_x0      : std_logic_vector (3 downto 0);
    signal alr_minutes_0x      : std_logic_vector (3 downto 0);
    signal alr_hours_x0        : std_logic_vector (3 downto 0);
    signal alr_hours_0x        : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : counter_alarm
    port map (clk                 => clk,
              rst                 => rst,
              en                  => en,
              btnc_press          => btnc_press,
              btnu_press          => btnu_press,
              btnr_press          => btnr_press,
              alarm_on            => alarm_on,
              total_alarm_seconds => total_alarm_seconds,
              alr_minutes_x0      => alr_minutes_x0,
              alr_minutes_0x      => alr_minutes_0x,
              alr_hours_x0        => alr_hours_x0,
              alr_hours_0x        => alr_hours_0x);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        en <= '0';
        btnc_press <= '0';
        btnu_press <= '0';
        btnr_press <= '0';

        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;

        btnu_press <= '1'; wait for TbPeriod;
        btnu_press <= '0'; wait for TbPeriod * 3;

        btnr_press <= '1'; wait for TbPeriod;
        btnr_press <= '0'; wait for TbPeriod * 5;

        for i in 1 to 3 loop
            btnu_press <= '1'; wait for TbPeriod;
            btnu_press <= '0'; wait for TbPeriod * 3;
        end loop;

        btnr_press <= '1'; wait for TbPeriod;
        btnr_press <= '0'; wait for TbPeriod * 5;

        for i in 1 to 5 loop
            btnu_press <= '1'; wait for TbPeriod;
            btnu_press <= '0'; wait for TbPeriod * 3;
        end loop;

        btnr_press <= '1'; wait for TbPeriod;
        btnr_press <= '0'; wait for TbPeriod * 5;

        for i in 1 to 8 loop
            btnu_press <= '1'; wait for TbPeriod;
            btnu_press <= '0'; wait for TbPeriod * 3;
        end loop;
        
        btnc_press <= '1'; wait for TbPeriod;
        btnc_press <= '0'; wait for TbPeriod * 5;

        wait for 200 ns;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_counter_alarm of tb_counter_alarm is
    for tb
    end for;
end cfg_tb_counter_alarm;