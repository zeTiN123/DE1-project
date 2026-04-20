library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;  

entity counter_clock is
        port (
        clk     : in  std_logic;                             
        rst     : in  std_logic;                           
        en      : in  std_logic;      
                            
        total_clock_seconds : out std_logic_vector(16 downto 0);    ---2 na 17 = az 131072 abychom meli dost mista na až 86400 sekund
        
        clk_minutes_x0 : out std_logic_vector(3 downto 0);      ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
        clk_minutes_0x : out std_logic_vector(3 downto 0);      ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
        clk_hours_x0   : out std_logic_vector(3 downto 0);      ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
        clk_hours_0x   : out std_logic_vector(3 downto 0)       ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
    );
end entity counter_clock;

-------------------------------------------------

architecture Behavioral of counter_clock is

  
    constant C_MAX : integer := 86400 - 1;
 
    signal sig_cnt : integer range 0 to C_MAX := 0;

begin

   
    p_counter : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then    
                sig_cnt <= 0;

            elsif en = '1' then  
                if sig_cnt = C_MAX then
                    sig_cnt <= 0;
                else
                    sig_cnt <= sig_cnt + 1;
                end if;          
            end if;
        end if;
    end process p_counter;

    total_clock_seconds <= std_logic_vector(to_unsigned(sig_cnt, 17)); ---vystup celkových sekund
    
    clk_minutes_x0 <= std_logic_vector(to_unsigned(((sig_cnt / 60) mod 60)/10, 4)); ---prevedeny sekundy na minuty a jejich vystup-x0
    clk_minutes_0x <= std_logic_vector(to_unsigned(((sig_cnt / 60) mod 60) mod 10, 4)); ---prevedeny sekundy na minuty a jejich vystup-0x

    clk_hours_x0 <= std_logic_vector(to_unsigned(((sig_cnt / 3600) mod 24)/10, 4)); ---prevedeny sekundy na minuty, pak hodiny a jejich vystup-x0
    clk_hours_0x <= std_logic_vector(to_unsigned(((sig_cnt / 3600) mod 24) mod 10, 4)); ---prevedeny sekundy na minuty, pak hodiny a jejich vystup-0x

end Behavioral;