library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alarm_clock_top is
-- Testbench nemá žádné porty
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

    ------------------------------------------------------------------------
    -- HLAVNÍ TESTOVACÍ SCÉNÁŘ
    ------------------------------------------------------------------------
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

        -- 1. ZAPNUTÍ DESKY A RESET (Zamčený komparátor)
        sw(15) <= '1'; wait for 2 us;
        sw(15) <= '0'; wait for 2 us;

        --------------------------------------------------------------------
        -- 2. NASTAVENÍ HLAVNÍHO ČASU NA 20:42
        --------------------------------------------------------------------
        sw(0) <= '1'; -- Zapneme režim HODIN
        wait for 1 us;

        -- Desítky hodin: 2
        for i in 1 to 2 loop push_button(btnu); end loop;
        push_button(btnr); 

        -- Jednotky hodin: 0 (Tady jen posuneme řád dál)
        push_button(btnr); 

        -- Desítky minut: 4
        for i in 1 to 4 loop push_button(btnu); end loop;
        push_button(btnr); 

        -- Jednotky minut: 2
        for i in 1 to 2 loop push_button(btnu); end loop;
        push_button(btnr); 

        --------------------------------------------------------------------
        -- 3. NASTAVENÍ BUDÍKU NA 21:58
        --------------------------------------------------------------------
        sw(0) <= '0'; -- Zapneme režim BUDÍKU
        wait for 1 us;

        -- Desítky hodin: 2
        for i in 1 to 2 loop push_button(btnu); end loop;
        push_button(btnr); 

        -- Jednotky hodin: 1
        push_button(btnu); 
        push_button(btnr); 

        -- Desítky minut: 5
        for i in 1 to 5 loop push_button(btnu); end loop;
        push_button(btnr); 

        -- Jednotky minut: 8
        for i in 1 to 8 loop push_button(btnu); end loop;
        push_button(btnr);

        --------------------------------------------------------------------
        -- 4. SPUŠTĚNÍ SYSTÉMU A ČEKÁNÍ NA SHODU
        --------------------------------------------------------------------
        sw(1) <= '1'; -- Zapnutí budíku (připraveno na zítřek)
        wait for 1 us;
        
        sw(0) <= '1'; -- Návrat zobrazení zpět na hodiny
        wait for 1 us;
        
        -- Zmáčkneme BTNC = Start hodin a Odemčení komparátoru
        push_button(btnc);

        -- Nyní čekáme 1 milisekundu (V simulačním čase to odpovídá cca 83 minutám).
        -- Během této doby čas přeteče přes 21:58 a budík začne zvonit (blikat led16_r).
        wait for 1 ms;

        --------------------------------------------------------------------
        -- 5. VYPNUTÍ ZVONÍCÍHO BUDÍKU
        --------------------------------------------------------------------
        -- Dalším stiskem BTNC budík "zamáčkneme" a umlčíme ho.
        push_button(btnc);
        
        -- Chvilku počkáme, abychom v grafu viděli, že led16_r opravdu zhasla
        wait for 10 us;

        -- 6. UKONČENÍ TESTOVÁNÍ
        sim_ended <= true;
        wait;
    end process;

end tb;