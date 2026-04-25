library ieee;
use ieee.std_logic_1164.all;

entity tb_clock_display is
end tb_clock_display;

architecture tb of tb_clock_display is

    component clock_display
        port (clk            : in std_logic;
              rst            : in std_logic;
              clk_minutes_x0 : in std_logic_vector (3 downto 0);
              clk_minutes_0x : in std_logic_vector (3 downto 0);
              clk_hours_x0   : in std_logic_vector (3 downto 0);
              clk_hours_0x   : in std_logic_vector (3 downto 0);
              alr_minutes_x0 : in std_logic_vector (3 downto 0);
              alr_minutes_0x : in std_logic_vector (3 downto 0);
              alr_hours_x0   : in std_logic_vector (3 downto 0);
              alr_hours_0x   : in std_logic_vector (3 downto 0);
              seg            : out std_logic_vector (6 downto 0);
              an             : out std_logic_vector (7 downto 0));
    end component;

    signal clk            : std_logic;
    signal rst            : std_logic;
    signal clk_minutes_x0 : std_logic_vector (3 downto 0);
    signal clk_minutes_0x : std_logic_vector (3 downto 0);
    signal clk_hours_x0   : std_logic_vector (3 downto 0);
    signal clk_hours_0x   : std_logic_vector (3 downto 0);
    signal alr_minutes_x0 : std_logic_vector (3 downto 0);
    signal alr_minutes_0x : std_logic_vector (3 downto 0);
    signal alr_hours_x0   : std_logic_vector (3 downto 0);
    signal alr_hours_0x   : std_logic_vector (3 downto 0);
    signal seg            : std_logic_vector (6 downto 0);
    signal an             : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : clock_display
    port map (clk            => clk,
              rst            => rst,
              clk_minutes_x0 => clk_minutes_x0,
              clk_minutes_0x => clk_minutes_0x,
              clk_hours_x0   => clk_hours_x0,
              clk_hours_0x   => clk_hours_0x,
              alr_minutes_x0 => alr_minutes_x0,
              alr_minutes_0x => alr_minutes_0x,
              alr_hours_x0   => alr_hours_x0,
              alr_hours_0x   => alr_hours_0x,
              seg            => seg,
              an             => an);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        clk_minutes_0x <= "0000";
        clk_minutes_x0 <= "0000";
        clk_hours_0x   <= "0000";
        clk_hours_x0   <= "0000";
        
        alr_minutes_0x <= "0000";
        alr_minutes_x0 <= "0000";
        alr_hours_0x   <= "0000";
        alr_hours_x0   <= "0000";
        
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;
        
        clk_hours_x0   <= "0001";   -- hodiny 1 ->1x
        clk_hours_0x   <= "0011";   -- hodiny 3 ->x3
        clk_minutes_x0 <= "0101";   -- minuty 5 ->5x
        clk_minutes_0x <= "1000";   -- minuty 8 ->x8

        alr_hours_x0   <= "0010";   -- hodiny 2 ->2x
        alr_hours_0x   <= "0001";   -- hodiny 1 ->x1
        alr_minutes_x0 <= "0000";   -- minuty 0 ->0x
        alr_minutes_0x <= "1001";   -- minuty 9 ->x9
        
        wait for 300 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_clock_display of tb_clock_display is
    for tb
    end for;
end cfg_tb_clock_display;
