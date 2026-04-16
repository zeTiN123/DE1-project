library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;  

entity counter_clock is
        port (
        clk     : in  std_logic;                             
        rst     : in  std_logic;                           
        en      : in  std_logic;                          
        seconds : out std_logic_vector(16 downto 0);    ---2 na 17 = az 131072 abychom meli dost mista na až 86400 sekund
        minutes : out std_logic_vector(5 downto 0);     ---2 na 6 = 64 abychom meli dost mista na až 60 minut
        hours   : out std_logic_vector(4 downto 0)      ---2 na 5 = 32 abychom meli dost mista na až 24 hodin        
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

    seconds <= std_logic_vector(to_unsigned(sig_cnt, 17)); ---vystup sekund
    
    minutes <= std_logic_vector(to_unsigned((sig_cnt / 60) mod 60, 6)); ---prevedeny sekundy na minuty a jejich vystup

    hours <= std_logic_vector(to_unsigned((sig_cnt / 3600) mod 24, 5)); ---prevedeny sekundy na minuty, pak hodiny a jejich vystup
    

end Behavioral;