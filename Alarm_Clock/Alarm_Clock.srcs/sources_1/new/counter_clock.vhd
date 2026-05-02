library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;  

entity counter_clock is
        port (
        clk     : in  std_logic;                             
        rst     : in  std_logic;                           
        en      : in  std_logic; 
        
        sw_0 : in std_logic;
        btnc_press : in std_logic;
        btnu_press : in std_logic;
        btnr_press : in std_logic;
                            
        total_clock_seconds : out std_logic_vector(16 downto 0);    ---2 na 17 = az 131072 abychom meli dost mista na až 86400 sekund
        
        clk_minutes_x0 : out std_logic_vector(3 downto 0);      ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
        clk_minutes_0x : out std_logic_vector(3 downto 0);      ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
        clk_hours_x0   : out std_logic_vector(3 downto 0);      ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
        clk_hours_0x   : out std_logic_vector(3 downto 0);       ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
        
        clk_dp_out : out std_logic_vector(7 downto 0)   --!!
        );
end entity counter_clock;

-------------------------------------------------

architecture Behavioral of counter_clock is
    signal sig_clock_on : std_logic := '0';     ---zapnutí/vypnutí budíku
    signal sig_time_unit : integer range 4 to 7 := 7;     ---jaký zrovna řád chceme (0-> 0-9, 1-> 0-5, 2-> 0-9, 3-> 0-2)
    
    signal sig_m_0x : integer range 0 to 9 := 0;
    signal sig_m_x0 : integer range 0 to 5 := 0;
    signal sig_h_0x : integer range 0 to 9 := 0;
    signal sig_h_x0 : integer range 0 to 2 := 0;
    
    signal sig_total_clock_seconds : integer := 0;
    signal sig_seconds : integer range 0 to 59 := 0;

begin
    p_clock_startstop : process (clk) is
    begin
        if rising_edge(clk) then
            if (rst = '1' and sw_0 = '1') then
                sig_clock_on <= '0';
            elsif (btnc_press = '1') then    
                sig_clock_on <= not sig_clock_on;
            end if;
        end if;
    end process p_clock_startstop;
    
    p_time_unit_edit : process (clk) is     ---prepinani mezi rady budiku
    begin
        if rising_edge(clk) then
            if (rst = '1' and sw_0 = '1') then         ---při startu cloku řád bude na 3
                sig_time_unit <= 7;
            elsif (btnr_press = '1' and sw_0 = '1') then       ---při potvrzeni se řád zase přepne na 0 pokud byl na 3
                if (sig_time_unit = 4) then     
                    sig_time_unit <= 7;
                else sig_time_unit <= sig_time_unit - 1;        ---jinak se posune o další výše
                end if;
            end if;
        end if;
    end process p_time_unit_edit;
   
    p_clock_setting : process (clk) is 
    begin   
        if rising_edge(clk) then
            if (rst = '1' and sw_0 = '1') then
                sig_seconds <= 0;
                sig_m_0x <= 0;
                sig_m_x0 <= 0;
                sig_h_0x <= 0;
                sig_h_x0 <= 0;
                elsif (sig_clock_on = '0') then         ---  anulovani sekund
                    sig_seconds <= 0;
                
                    if (btnu_press = '1' and sw_0 = '1') then
                    case sig_time_unit is
                        when 4 =>
                            if (sig_m_0x = 9) then
                                sig_m_0x <= 0;
                            else sig_m_0x <= sig_m_0x + 1;
                            end if;
                        when 5 =>
                            if (sig_m_x0 = 5) then
                                sig_m_x0 <= 0;
                            else sig_m_x0 <= sig_m_x0 + 1;
                            end if;
                        when 6 =>
                            if (sig_h_x0 = 2) then
                                if (sig_h_0x = 3) then
                                    sig_h_0x <= 0;
                                else sig_h_0x <= sig_h_0x + 1; 
                                end if;
                            else 
                                if (sig_h_0x = 9) then
                                    sig_h_0x <= 0;
                                else sig_h_0x <= sig_h_0x + 1;
                                end if;
                            end if;
                        when 7 =>
                            if (sig_h_x0 = 2) then
                                sig_h_x0 <= 0;
                            else sig_h_x0 <= sig_h_x0 + 1;
                                if sig_h_x0 = 1 and sig_h_0x > 3 then
                                    sig_h_0x <= 3;
                                end if;
                            end if;
                    end case;
                end if;
                
            elsif (en = '1') then
                if (sig_seconds = 59) then
                    sig_seconds <= 0;
                    if sig_m_0x = 9 then
                        sig_m_0x <= 0;
                        if sig_m_x0 = 5 then
                            sig_m_x0 <= 0;
                            if sig_h_x0 = 2 and sig_h_0x = 3 then
                                sig_h_0x <= 0;
                                sig_h_x0 <= 0;
                            elsif sig_h_0x = 9 then
                                sig_h_0x <= 0;
                                sig_h_x0 <= sig_h_x0 + 1;
                            else sig_h_0x <= sig_h_0x + 1;
                            end if;
                        else sig_m_x0 <= sig_m_x0 + 1;
                        end if;
                    else sig_m_0x <= sig_m_0x + 1;
                    end if;
                else sig_seconds <= sig_seconds + 1; -- Normální krok sekund
                end if;
            end if;
        end if;
    end process p_clock_setting;
    
    p_clk_dp_out : process (sig_time_unit, sig_clock_on) is
    begin
        clk_dp_out <= "11111111";
        
        if sig_clock_on = '0' then
            case sig_time_unit is
                when 4 => clk_dp_out(4) <= '0'; 
                when 5 => clk_dp_out(5) <= '0';
                when 6 => clk_dp_out(6) <= '0';
                when 7 => clk_dp_out(7) <= '0';
                when others => null;
            end case;
        end if;
    end process p_clk_dp_out;
    
    sig_total_clock_seconds <= ((sig_m_0x * 60) + (sig_m_x0 * 600) + (sig_h_0x * 3600) + (sig_h_x0 * 36000) + sig_seconds);

    total_clock_seconds <= std_logic_vector(to_unsigned(sig_total_clock_seconds, 17)); ---vystup celkových sekund
    
    clk_minutes_x0 <= std_logic_vector(to_unsigned(sig_m_x0, 4)); ---prevedeny sekundy na minuty a jejich vystup-x0
    clk_minutes_0x <= std_logic_vector(to_unsigned(sig_m_0x, 4)); ---prevedeny sekundy na minuty a jejich vystup-0x

    clk_hours_x0 <= std_logic_vector(to_unsigned(sig_h_x0, 4)); ---prevedeny sekundy na minuty, pak hodiny a jejich vystup-x0
    clk_hours_0x <= std_logic_vector(to_unsigned(sig_h_0x, 4)); ---prevedeny sekundy na minuty, pak hodiny a jejich vystup-0x

end Behavioral;