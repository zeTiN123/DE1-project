library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;  

entity seconds_compare is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           ce : in STD_LOGIC; -------1Hz interval pro pipani buzzeru
           buzzer_off : in STD_LOGIC; -------pripojeno na signal od press_btnc
           s_clock : in STD_LOGIC_vector (16 downto 0); ---aktualni pocet sekund z cloku
           s_alarm : in STD_LOGIC_vector (16 downto 0) := "00000000000000011"; ---prepocteny sekundy z budiku pro compare, NASTAVENO NA 3 PRI ZACATKU ABY NEDOSLO K PIPNUTI PRI STARTU
           buzzer_interval : out STD_LOGIC); ---vychozí 0 nebo 1 pro spustení budiku,alarmu
end seconds_compare;

architecture Behavioral of seconds_compare is
    
    signal sig_frequent_buzz : STD_LOGIC := '0';    ---aby neustale nepipal tak se prubezne vypne a zapne diky podmince AND pak pipá
    signal sig_buzzer_activate : STD_LOGIC := '0';
    ---pouze upraveny counter abychom mohli vydavat pipani budiku v intervalech
    ---jak se ukazalo tak wait for lze pouzivat jen v simulacich
begin
    p_buzzer : process (clk) is
    begin
        if rising_edge(clk) then    ---detekuje nabeznou hranu
            if (rst = '1') then       ---synchronizace
                sig_buzzer_activate <= '0';
                
            elsif (buzzer_off = '1') then  ---zmacknuti BTNC vypne buzzer
                sig_buzzer_activate <= '0';
                    
            elsif (s_clock = s_alarm) then  ---pokud se hodnoty sekund shoduji zapne se buzzer
                sig_buzzer_activate <= '1';     ---!!!!ale ten se jen spusti na přesně tu jednu chvilku kdy se časy shoduji -> OPRAVA: spustí activaci ktera do vypnuti bezi 
            end if;
            if (ce = '1') then
                sig_frequent_buzz <= not sig_frequent_buzz;
            end if;         
        end if;
    end process p_buzzer;
    
    buzzer_interval <= sig_buzzer_activate and sig_frequent_buzz;
    
end Behavioral;
