library ieee;
use ieee.std_logic_1164.all;

entity tb_counter_clock is
end tb_counter_clock;

architecture tb of tb_counter_clock is

    component counter_clock
        port (
            clk                 : in  std_logic;
            rst                 : in  std_logic;
            en                  : in  std_logic;
            sw_0                : in  std_logic;  -- PŘIDÁNO: Přepínač režimu
            btnc_press          : in  std_logic;
            btnu_press          : in  std_logic;
            btnr_press          : in  std_logic;
            total_clock_seconds : out std_logic_vector(16 downto 0);
            clk_minutes_x0      : out std_logic_vector(3 downto 0);
            clk_minutes_0x      : out std_logic_vector(3 downto 0);
            clk_hours_x0        : out std_logic_vector(3 downto 0);
            clk_hours_0x        : out std_logic_vector(3 downto 0)
        );
    end component;

    signal sig_clk                 : std_logic;
    signal sig_rst                 : std_logic;
    signal sig_en                  : std_logic := '0';
    
    signal sig_sw_0                : std_logic := '0';  -- PŘIDÁNO
    signal sig_btnc_press          : std_logic := '0';
    signal sig_btnu_press          : std_logic := '0';
    signal sig_btnr_press          : std_logic := '0';
    
    signal sig_total_clock_seconds : std_logic_vector (16 downto 0);
    signal sig_clk_minutes_x0      : std_logic_vector (3 downto 0);
    signal sig_clk_minutes_0x      : std_logic_vector (3 downto 0);
    signal sig_clk_hours_x0        : std_logic_vector (3 downto 0);
    signal sig_clk_hours_0x        : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : counter_clock
    port map (
        clk                 => sig_clk,
        rst                 => sig_rst,
        en                  => sig_en,
        sw_0                => sig_sw_0,  -- PŘIDÁNO
        btnc_press          => sig_btnc_press,
        btnu_press          => sig_btnu_press,
        btnr_press          => sig_btnr_press,
        total_clock_seconds => sig_total_clock_seconds,
        clk_minutes_x0      => sig_clk_minutes_x0,
        clk_minutes_0x      => sig_clk_minutes_0x,
        clk_hours_x0        => sig_clk_hours_x0,
        clk_hours_0x        => sig_clk_hours_0x
    );

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    sig_clk <= TbClock;

    p_en_gen : process
    begin
        if TbSimEnded = '1' then
            wait;
        end if;
        sig_en <= '0';
        wait for 90 ns;
        sig_en <= '1';
        wait for 10 ns; 
    end process;

    stimuli : process
    begin
        sig_sw_0       <= '0';
        sig_btnc_press <= '0';
        sig_btnu_press <= '0';
        sig_btnr_press <= '0';

        sig_rst <= '1';
        wait for 50 ns;
        sig_rst <= '0';
        wait for 50 ns;
        
        -- Přepneme SW_0 nahoru, abychom mohli nastavovat čas a zapínat hodiny
        sig_sw_0 <= '1';
        wait for TbPeriod;
        
        sig_btnu_press <= '1'; wait for TbPeriod; sig_btnu_press <= '0'; wait for TbPeriod * 3;
        
        sig_btnr_press <= '1'; wait for TbPeriod; sig_btnr_press <= '0'; wait for TbPeriod * 3;
        
        for i in 1 to 3 loop
            sig_btnu_press <= '1'; wait for TbPeriod; sig_btnu_press <= '0'; wait for TbPeriod * 3;
        end loop;

        sig_btnr_press <= '1'; wait for TbPeriod; sig_btnr_press <= '0'; wait for TbPeriod * 3;
        
        for i in 1 to 5 loop
            sig_btnu_press <= '1'; wait for TbPeriod; sig_btnu_press <= '0'; wait for TbPeriod * 3;
        end loop;

        sig_btnr_press <= '1'; wait for TbPeriod; sig_btnr_press <= '0'; wait for TbPeriod * 3;
        
        for i in 1 to 8 loop
            sig_btnu_press <= '1'; wait for TbPeriod; sig_btnu_press <= '0'; wait for TbPeriod * 3;
        end loop;

        sig_btnc_press <= '1'; wait for TbPeriod; 
        sig_btnc_press <= '0'; 
        
        wait for 500 ns;

        sig_btnc_press <= '1'; wait for TbPeriod; 
        sig_btnc_press <= '0';
        
        wait for 200 ns;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_counter_clock of tb_counter_clock is
    for tb
    end for;
end cfg_tb_counter_clock;