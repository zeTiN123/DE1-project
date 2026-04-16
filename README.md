# DE1-project
Alarm_Clock - Projekt z předmětu DE1, tým Bagačka, Focher a Langová

Obr. 1: Prvotní verze blokového schéma pro Alarm Clock
<img width="1227" height="656" alt="obrazek" src="https://github.com/user-attachments/assets/7d4be329-be60-4113-8527-3fd26c0ea448" />

Princip či premise:
Principální rozděleni Nexys A7 50T segmentovek na 2 části: 1. část, tedy an[3->0], zobrazuje Clock a 2. část (an[7->4]) zobrazuje Alarm. 

Clock
-counter_clock = čítač clk s vystupy "seconds" (odpovídá sig_cnt, naše základní jednotka pro porovnávání v modulu Compare a pro převody na vyšší jednotky času)
"minutes" (převod sig_cnt (seconds) na uběhlé minuty pro zobrazení na anodách, vypočet přes MODulo a dělení 60 atd.)
"hours" (převod sig_cnt (seconds) na uběhlé hodiny pro zobrazení na anodách, vypočet přes MODulo a dělení 60 atd.)
G_max na 24*60*60 = 86400, tedy počet sekund v jednom dni (24 hodin)

Alarm
-podobný princip jako clock ale s důležitým nastavením hodin a minut pro spouštění budíku, při porovnání s aktualním časem Clocku
vychozí zase "seconds", "minutes" a "hours", sekundy pro porovnání, minuty a hodiny na zobrazeni 
myšlenka: "uživatel si tlačítky asi BTNU, BTNR a BTNC zvolí čas k spuštění budíku, volí si hodiny a minuty, ty se převedou zpět na sekundy a vyvodí "seconds"  pro porovnání,
BTNC asi pro potvrzení a spuštění, čítač zde spíše funguje pro synchronizaci s Clockem"

Compare
- modul porovnávající počet uběhlých sekund z Clocku s počtem sekund na Alarmu (budíku), sc == sd a ještě podmínka, výchozím bude signál s frekvencí pro modul buzzeru

Buzzer
-deska má vástup typu mono audio output, tedy buď zkusíme připojit na jednoduchý reproduktor a vytvoříme modul pro zvukovou signalizaci,
a nebo, což se jeví ve fázi simulaci a vytváření přijatelnější, světelná signalizace RGB LEDky za stanovené frekvence  
