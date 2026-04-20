# DE1-project
Alarm_Clock - Projekt z předmětu DE1, tým Bagačka, Focher a Langová

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Cv. 1.:

Obr. 1: Prvotní verze blokového schéma pro Alarm Clock
<img width="1227" height="656" alt="obrazek" src="https://github.com/user-attachments/assets/92999e23-0832-4dd0-afc5-6c04e7930755" />

Princip či premise:
- Principální rozděleni Nexys A7 50T segmentovek na 2 části: 1. část, tedy an[3->0], zobrazuje Clock a 2. část (an[7->4]) zobrazuje Alarm. 

Clock
- counter_clock = čítač clk s vystupy "seconds" (odpovídá sig_cnt, naše základní jednotka pro porovnávání v modulu Compare a pro převody na vyšší jednotky času)
"minutes" (převod sig_cnt (seconds) na uběhlé minuty pro zobrazení na anodách, vypočet přes MODulo a dělení 60 atd.)
"hours" (převod sig_cnt (seconds) na uběhlé hodiny pro zobrazení na anodách, vypočet přes MODulo a dělení 60 atd.)
G_max na 24•60•60 = 86400, tedy počet sekund v jednom dni (24 hodin)

Alarm
- podobný princip jako clock ale s důležitým nastavením hodin a minut pro spouštění budíku, při porovnání s aktualním časem Clocku
vychozí zase "seconds", "minutes" a "hours", sekundy pro porovnání, minuty a hodiny na zobrazeni 
myšlenka: "uživatel si tlačítky asi BTNU, BTNR a BTNC zvolí čas k spuštění budíku, volí si hodiny a minuty, ty se převedou zpět na sekundy a vyvodí "seconds"  pro porovnání,
BTNC asi pro potvrzení a spuštění, čítač zde spíše funguje pro synchronizaci s Clockem"

Compare
- modul porovnávající počet uběhlých sekund z Clocku s počtem sekund na Alarmu (budíku), sc == sd a ještě podmínka, výchozím bude signál s frekvencí pro modul buzzeru

Buzzer
- deska má vástup typu mono audio output, tedy buď zkusíme připojit na jednoduchý reproduktor a vytvoříme modul pro zvukovou signalizaci,
a nebo, což se jeví ve fázi simulaci a vytváření přijatelnější, světelná signalizace RGB LEDky za stanovené frekvence  

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Cv. 2.:
- počátky vytváření modulů a testování něktrých testbenchů

Clk_en
- vytvořen pro čítače atd.

Debouncery
- vytvořeny "debounce_btnu", "debounce_btnr" a "debounce_btnc" pro tlačítka BTNU, BTNR a BTNC.
- vystupující signály se napojí převážně do modulu "counter_alarm" pro nastavení času budíku (Hours:Minutes)

Obr. 2: Zobrazená simulace pro tb_debounce_BTNC, zobrazující stisknutí tlačítka (začatek, konec, výchozí signál)
<img width="1192" height="813" alt="obrazek" src="https://github.com/user-attachments/assets/765a15de-3a16-4e31-bc81-07ac9a2f253c" />

Counter_Clock
- modul vytvořen, vystupem jsou opravdu uplynulé sekundy(CELKOVÉ sekundy pro compare!!!!!, NE zbytek sekund po přepočtu na minuty), minuty a hodiny
- pro dosavadní testování je zvýšen sekundový čas, sig_en <= '1'; wait for 900 us;
  
Obr. 3: Zobrazená simulace pro tb_counter_clock, zobrazující uplynulé sekundy, minuty a hodiny
<img width="1649" height="812" alt="obrazek" src="https://github.com/user-attachments/assets/593b9d27-8c5c-4b3e-b080-1510a1dcb5cb" />

Seconds_compare
- vytvořena prvotni verze modulu pro porovnavani sekund z clocku a alarmu, s logickým vystupem 0 či 1 pro aktivaci buzzeru
- compare porovnává, ale signál buzzeru je poslán v přesný okamžik shody -> úprava kódu přes counter, který umožní v Hz intervalech pípání buzzeru dokud není BTNC vypnut

Obr. 3: Odsimulování pro Alarm na 3 sekundách, Clock si postupně dopočítá a při shodě je aktivován buzzer v ustáleném bzučení a dokud není pomocí BTNC vypnut
<img width="1637" height="449" alt="obrazek" src="https://github.com/user-attachments/assets/20fb292a-d638-4b10-8802-e97aaceefc82" />

Obr. 4: Vylepšený Seconds_compare s vyřešením shody (pípnutí) na začátku a s výchozím signálem v podobě pípání v intervalech 
<img width="1623" height="476" alt="obrazek" src="https://github.com/user-attachments/assets/15b0d6c3-9b51-431c-9eab-73306eefced8" />

Clock_Display
- upravená komponenta display_driver ze cvičení na jednotku zobrazující vstupní hodiny a minuty podle řádů na displej
- nezapomenout upravit G_max na třeba 100_000 pro plynulé zobrazení (ideálně 1 kHz => 100_000_000/1000 = G_max = 100_000, zhruba 250 FPS)

Obr. 5: Zobrazení pevně daných hodnot času CLOCKu (čas 13:58) a ALARMu (čas 21:09) do zobrazení na displeji pro an[7 až 0]
<img width="1552" height="763" alt="obrazek" src="https://github.com/user-attachments/assets/abdb42ed-63a1-4b98-8a44-7e261fa9f1bc" />

Counter_Alarm
- vytvořen modul pro synchorní nastavování budíku, !!!!CO UDĚLÁ BUZZER_ON S BUZZER_OFF????
- BTNC -> zapnutí/ vypnutí budíku
- BTNR -> posun v řádech jednotek zprava doprava, přeskok by měl přeskočit
- BTNU -> nastavení hodnoty na dotyčném řádu, pouze zvyšuje a při přeskoku by měla od 0 

Obr. 6: Zobrazení nastavování podle tlačítek požadovaného budíku (13:58) a výstup pro displej
<img width="1572" height="792" alt="obrazek" src="https://github.com/user-attachments/assets/d20b0dd4-bef2-4ae5-9949-99dd041901ce" />

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Cv. 3.:
-

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
