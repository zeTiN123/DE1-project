library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_display is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           
           clk_minutes_x0 : in std_logic_vector(3 downto 0);       ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
           clk_minutes_0x : in std_logic_vector(3 downto 0);       ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
           clk_hours_x0   : in std_logic_vector(3 downto 0);       ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
           clk_hours_0x   : in std_logic_vector(3 downto 0);       ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
           
           alr_minutes_x0 : in std_logic_vector(3 downto 0);       ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
           alr_minutes_0x : in std_logic_vector(3 downto 0);       ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
           alr_hours_x0   : in std_logic_vector(3 downto 0);       ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
           alr_hours_0x   : in std_logic_vector(3 downto 0);       ---2 na 4 = az 16 abychom meli 0,1,2,...,9 = na 10 cisel
           
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);               ---an[7 až 4] clock a an[3 až 0] alarm
           
           dp_in : in std_logic_vector(7 downto 0);         --!!
           dp : out std_logic                               --!!
           );            
           
end clock_display;

architecture Behavioral of clock_display is

    -- Component declaration for clock enable
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
 
    -- Component declaration for binary counter
    component counter is
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;
 
    component bin2seg is
          -- TODO: Add component declaration of `bin2seg` 
          Port ( 
                bin : in STD_LOGIC_VECTOR (3 downto 0);
                seg : out STD_LOGIC_VECTOR (6 downto 0)
           );
        
    end component bin2seg;
 
    -- Internal signals
    -- TODO: Add other needed signals sig-bin a sig_digit
    signal sig_en       :  std_logic;
    signal sig_bin      :  std_logic_vector (3 downto 0);
    signal sig_digit    :  std_logic_vector (2 downto 0);       ---vyběr anody(0,1,2,3)
    

begin

    ------------------------------------------------------------------------
    -- Clock enable generator for refresh timing
    ------------------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => 2 )  -- Adjust for flicker-free multiplexing    !!!!!!
        port map (                  -- For simulation: 2
            clk => clk,             -- For implementation: 100_000
            rst => rst,
            ce  => sig_en
        );

    counter_0 : counter
        generic map ( G_BITS => 3 )     ---0,1,2,3
        port map (
            clk => clk,
            rst => rst,
            en  => sig_en,
            cnt => sig_digit
        );

    ------------------------------------------------------------------------
    -- Digit select
    ------------------------------------------------------------------------
        sig_bin <= alr_minutes_0x when (sig_digit = "000") else
                   alr_minutes_x0 when (sig_digit = "001") else
                   alr_hours_0x when (sig_digit = "010") else
                   alr_hours_x0 when (sig_digit = "011") else
                   
                   clk_minutes_0x when (sig_digit = "100") else
                   clk_minutes_x0 when (sig_digit = "101") else
                   clk_hours_0x when (sig_digit = "110") else
                   clk_hours_x0;

    ------------------------------------------------------------------------
    -- 7-segment decoder
    ------------------------------------------------------------------------
    decoder_0 : bin2seg
        port map (
            -- TODO: Add component instantiation of `bin2seg`
            bin => sig_bin,
            seg => seg
            );

    ------------------------------------------------------------------------
    -- Anode select process
    ------------------------------------------------------------------------
    p_anode_select : process (sig_digit) is
    begin
        case sig_digit is
            when "000" =>        
                an <= "11111110";       ---an[0]
                dp <= dp_in(0);
            when "001" =>
                an <= "11111101";       ---an[1]
                dp <= dp_in(1);
            when "010" =>
                an <= "11111011";       ---an[2]
                dp <= dp_in(2);
            when "011" =>
                an <= "11110111";       ---an[3]
                dp <= dp_in(3);
            when "100" =>        
                an <= "11101111";       ---an[4]
                dp <= dp_in(4);
            when "101" =>
                an <= "11011111";       ---an[5]
                dp <= dp_in(5);
            when "110" =>
                an <= "10111111";       ---an[6]
                dp <= dp_in(6);
            when "111" =>
                an <= "01111111";       ---an[7]
                dp <= dp_in(7);
            
            -- TODO: Add another anode selection(s)

            when others =>
                an <= "11111111";  -- All off
                dp <= '1';
        end case;
    end process;
    
end Behavioral;
