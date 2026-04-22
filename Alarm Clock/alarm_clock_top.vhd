library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alarm_clock_top is
    Port (  clk : in std_logic;
            
            btnu : in std_logic;
            btnc : in std_logic;
            btnr : in std_logic;
            btnd : in std_logic;
            sw : in std_logic_vector (15 downto 0);
            
            seg : out std_logic_vector (6 downto 0);
            an : out std_logic_vector (7 downto 0);
            led16_r : out std_logic
            );
end alarm_clock_top;

architecture Behavioral of alarm_clock_top is
    
    component clk_en is
    generic ( G_max : positive); 
    Port (  clk : in std_logic;
            rst : in std_logic;
            ce : out std_logic
            );
    end component clk_en;
    
    component debounce_btnu is
    Port (  clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            btnu_in : in STD_LOGIC;
            btnu_state : out STD_LOGIC;
            btnu_release : out STD_LOGIC;
            btnu_press : out STD_LOGIC
            );
    end component debounce_btnu;
    
    component debounce_btnr is
    Port (  clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            btnr_in : in STD_LOGIC;
            btnr_state : out STD_LOGIC;
            btnr_release : out STD_LOGIC;
            btnr_press : out STD_LOGIC
            );
    end component debounce_btnr;
    
    component debounce_btnc is
    Port (  clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            btnc_in : in STD_LOGIC;
            btnc_state : out STD_LOGIC;
            btnc_release : out STD_LOGIC;
            btnc_press : out STD_LOGIC
            );
    end component debounce_btnc;
    
    component debounce_btnd is
    Port (  clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            btnd_in : in STD_LOGIC;
            btnd_state : out STD_LOGIC;
            btnd_release : out STD_LOGIC;
            btnd_press : out STD_LOGIC
            );
    end component debounce_btnd;
    
    component counter_clock is
    port (  clk     : in  std_logic;                             
            rst     : in  std_logic;                           
            en      : in  std_logic; 
        
            sw_0 : in std_logic;
            btnc_press : in std_logic;
            btnu_press : in std_logic;
            btnr_press : in std_logic;
                            
            total_clock_seconds : out std_logic_vector(16 downto 0);    
        
            clk_minutes_x0 : out std_logic_vector(3 downto 0);     
            clk_minutes_0x : out std_logic_vector(3 downto 0);      
            clk_hours_x0   : out std_logic_vector(3 downto 0);      
            clk_hours_0x   : out std_logic_vector(3 downto 0)       
            );
    end component counter_clock;
    
    component counter_alarm is
    port (  clk     : in  std_logic;                             
            rst     : in  std_logic;                           
            en      : in  std_logic;

            sw_0 : in std_logic;
            btnc_press : in std_logic;
            btnu_press : in std_logic;
            btnr_press : in std_logic;
        
            alarm_on : out std_logic;        
                                
            total_alarm_seconds : out std_logic_vector(16 downto 0);    
        
            alr_minutes_x0 : out std_logic_vector(3 downto 0);      
            alr_minutes_0x : out std_logic_vector(3 downto 0);      
            alr_hours_x0   : out std_logic_vector(3 downto 0);      
            alr_hours_0x   : out std_logic_vector(3 downto 0)       
            );
    end component counter_alarm;
    
    component seconds_compare is
    Port (  rst             : in STD_LOGIC;
            clk             : in STD_LOGIC;
            ce              : in STD_LOGIC; 
            alarm_en        : in std_logic;
            buzzer_off      : in STD_LOGIC; 
            s_clock         : in STD_LOGIC_vector (16 downto 0); 
            s_alarm         : in STD_LOGIC_vector (16 downto 0); 
            buzzer_interval : out STD_LOGIC
            ); 
    end component seconds_compare;
    
    component clock_display is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           
           clk_minutes_x0 : in std_logic_vector(3 downto 0);       
           clk_minutes_0x : in std_logic_vector(3 downto 0);       
           clk_hours_x0   : in std_logic_vector(3 downto 0);       
           clk_hours_0x   : in std_logic_vector(3 downto 0);       
           
           alr_minutes_x0 : in std_logic_vector(3 downto 0);       
           alr_minutes_0x : in std_logic_vector(3 downto 0);       
           alr_hours_x0   : in std_logic_vector(3 downto 0);       
           alr_hours_0x   : in std_logic_vector(3 downto 0);       
           
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0)
           );
    end component clock_display;        
    
    -- Internal signal(s)
    signal sig_cnt_en : std_logic;
    signal sig_btnu_press : std_logic;
    signal sig_btnc_press : std_logic;
    signal sig_btnr_press : std_logic;
    
    signal sig_s_clock : std_logic_vector (16 downto 0);
    signal sig_clk_m0x : std_logic_vector (3 downto 0);
    signal sig_clk_mx0 : std_logic_vector (3 downto 0);
    signal sig_clk_h0x : std_logic_vector (3 downto 0);
    signal sig_clk_hx0 : std_logic_vector (3 downto 0);
    
    signal sig_s_alarm : std_logic_vector (16 downto 0);
    signal sig_alr_m0x : std_logic_vector (3 downto 0);
    signal sig_alr_mx0 : std_logic_vector (3 downto 0);
    signal sig_alr_h0x : std_logic_vector (3 downto 0);
    signal sig_alr_hx0 : std_logic_vector (3 downto 0);
    
    signal sig_buzz_off : std_logic;

begin
    
    gen_Hz : clk_en
        generic map (G_max => 20)  --- pro desku 100_000_000, pro sim 20
        port map (
            clk => clk,
            rst => sw(15),
            ce => sig_cnt_en
        );
    
    debounce_btnu_0 : debounce_btnu
        port map (
            clk       => clk,
            rst       => sw(15),
            btnu_in    => btnu,
            btnu_press => sig_btnu_press
        );
        
    debounce_btnc_0 : debounce_btnc
        port map (
            clk       => clk,
            rst       => sw(15),
            btnc_in    => btnc,
            btnc_press => sig_btnc_press
        );
        
    debounce_btnr_0 : debounce_btnr
        port map (
            clk       => clk,
            rst       => sw(15),
            btnr_in    => btnr,
            btnr_press => sig_btnr_press
        );
        
    debounce_btnd_0 : debounce_btnd
        port map (
            clk       => clk,
            rst       => sw(15),
            btnd_in    => btnd,
            btnd_press => sig_buzz_off
        );
        
    counter_clock_0 : counter_clock
        port map (
            clk     => clk,
            rst     => sw(15),
            en => sig_cnt_en,
            btnu_press => sig_btnu_press,
            btnc_press => sig_btnc_press,
            btnr_press => sig_btnr_press,
            sw_0 => sw(0),
            
            total_clock_seconds => sig_s_clock,
            clk_minutes_0x => sig_clk_m0x,
            clk_minutes_x0 => sig_clk_mx0,
            clk_hours_0x => sig_clk_h0x,
            clk_hours_x0 => sig_clk_hx0
        );
    counter_alarm_0 : counter_alarm
        port map (
            clk     => clk,
            rst     => sw(15),
            en => sig_cnt_en,
            btnu_press => sig_btnu_press,
            btnc_press => sig_btnc_press,
            btnr_press => sig_btnr_press,
            sw_0 => sw(0),
            
            total_alarm_seconds => sig_s_alarm,
            alr_minutes_0x => sig_alr_m0x,
            alr_minutes_x0 => sig_alr_mx0,
            alr_hours_0x => sig_alr_h0x,
            alr_hours_x0 => sig_alr_hx0
            
            ---alarm_on => ...
        );
        
    compare : seconds_compare
        port map (
            clk => clk,
            rst => sw(15),
            ce => sig_cnt_en,
            buzzer_off => sig_buzz_off,
            alarm_en => sw(1),
            
            s_clock => sig_s_clock,
            s_alarm => sig_s_alarm,
            
            buzzer_interval => led16_r
        );
    
    display : clock_display
        port map (
            clk => clk,
            rst => sw(15),
            
            clk_minutes_0x => sig_clk_m0x,
            clk_minutes_x0 => sig_clk_mx0,
            clk_hours_0x => sig_clk_h0x,
            clk_hours_x0 => sig_clk_hx0,
            
            alr_minutes_0x => sig_alr_m0x,
            alr_minutes_x0 => sig_alr_mx0,
            alr_hours_0x => sig_alr_h0x,
            alr_hours_x0 => sig_alr_hx0,
            
            seg => seg,
            an => an
        );

end Behavioral;