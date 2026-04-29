library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alarm_clock_top is
end tb_alarm_clock_top;

architecture tb of tb_alarm_clock_top is

    component alarm_clock_top
        Port (  
            clk     : in std_logic;
            btnu    : in std_logic;
            btnc    : in std_logic;
            btnr    : in std_logic;
            btnd    : in std_logic;
            sw      : in std_logic_vector (15 downto 0);
            seg     : out std_logic_vector (6 downto 0);
            an      : out std_logic_vector (7 downto 0);
            led16_r : out std_logic
        );
    end component;

    signal clk     : std_logic := '0';
    signal btnu    : std_logic := '0';
    signal btnc    : std_logic := '0';
    signal btnr    : std_logic := '0';
    signal btnd    : std_logic := '0';
    signal sw      : std_logic_vector(15 downto 0) := (others => '0');
    
    signal seg     : std_logic_vector(6 downto 0);
    signal an      : std_logic_vector(7 downto 0);
    signal led16_r : std_logic;

    constant clk_period : time := 10 ns; 
    signal sim_ended    : boolean := false;

begin

    uut: alarm_clock_top port map (
        clk     => clk,
        btnu    => btnu,
        btnc    => btnc,
        btnr    => btnr,
        btnd    => btnd,
        sw      => sw,
        seg     => seg,
        an      => an,
        led16_r => led16_r
    );

    clk_process : process
    begin
        while not sim_ended loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    stim_proc: process
        procedure push_button(signal btn : out std_logic) is
        begin
            btn <= '1';
            wait for 2 us; 
            btn <= '0';
            wait for 2 us; 
        end procedure;

    begin
        sw <= (others => '0');
        btnu <= '0'; btnc <= '0'; btnr <= '0'; btnd <= '0';

        sw(15) <= '1'; wait for 2 us;
        sw(15) <= '0'; wait for 2 us;

        sw(0) <= '1'; 
        wait for 1 us;

        for i in 1 to 2 loop push_button(btnu); end loop;
        push_button(btnr); 

        push_button(btnr); 

        for i in 1 to 4 loop push_button(btnu); end loop;
        push_button(btnr); 

        for i in 1 to 2 loop push_button(btnu); end loop;
        push_button(btnr); 

        sw(0) <= '0'; 
        wait for 1 us;

        for i in 1 to 2 loop push_button(btnu); end loop;
        push_button(btnr); 

        push_button(btnu); 
        push_button(btnr); 

        for i in 1 to 5 loop push_button(btnu); end loop;
        push_button(btnr); 

        for i in 1 to 8 loop push_button(btnu); end loop;
        push_button(btnr);

        sw(1) <= '1'; 
        wait for 1 us;
        
        sw(0) <= '1'; 
        wait for 1 us;
        
        push_button(btnc);

        wait for 1 ms;

        push_button(btnc);
        
        wait for 10 us;

        sim_ended <= true;
        wait;
    end process;

end tb;
