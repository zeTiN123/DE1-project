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
              an             : out std_logic_vector (7 downto 0);
              dp_in          : in std_logic_vector(7 downto 0); 
              dp             : out std_logic                    
        );
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
    signal dp_in          : std_logic_vector (7 downto 0) := (others => '1'); 
    signal dp             : std_logic;

    constant TbPeriod : time := 10 ns; 
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
              an             => an,
              dp_in          => dp_in, 
              dp             => dp     
    );

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin

        rst <= '1';
        clk_minutes_0x <= "0000";
        clk_minutes_x0 <= "0000";
        clk_hours_0x   <= "0000";
        clk_hours_x0   <= "0000";
        alr_minutes_0x <= "0000";
        alr_minutes_x0 <= "0000";
        alr_hours_0x   <= "0000";
        alr_hours_x0   <= "0000";
        dp_in          <= "11110111"; -- Aktivní tečka(an3)
        
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;
        
        clk_hours_x0   <= "0001";   -- 1
        clk_hours_0x   <= "0011";   -- 3 -> 13 hodin
        clk_minutes_x0 <= "0101";   -- 5
        clk_minutes_0x <= "1000";   -- 8 -> 58 minut

        alr_hours_x0   <= "0010";   -- 2
        alr_hours_0x   <= "0001";   -- 1 -> 21 hodin
        alr_minutes_x0 <= "0000";   -- 0
        alr_minutes_0x <= "1001";   -- 9 -> 09 minut
        
        wait for 1000 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;