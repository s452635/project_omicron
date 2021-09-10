# System Kolejowy "Omicron"

projekt w Prologu, Podstawy Programowania Deklaratywnego 2021SL
twórca: Zofia M. Machalska

# Założenie systemu eksperckiego.

System stworzony do wyszukiwania przyjazdów i odjazdów na dany przystanej i o danej godzinie (informacje pobrane od użytkownika) z bazy danych. Nazwany po piętnastej literze alfabetu greckiego.

# Moduły systemu.

![image](https://user-images.githubusercontent.com/66226017/132905542-cfe0088e-68d9-4888-98e8-79bde8415d45.png)

Projekt zawiera także folder 'scrapped', w którym znajdują się są niedokończone lub nieużyte moduły lub bazy danych. Plik 'scrapped/scraps.pl' zawiera poprzednie wersje niektórych reguł.

Warto też wspomnieć o dokumencie 'data/dreslo_railway.pdf', który zawiera czytelniejszą dla człowieka wersję informacji z baz danych o przystankach ('data/stops.pl') i połączeniach ('data/links.pl').

# Krótki opis wybranych procedur.

Przykład działania menu głównego.

![image](https://user-images.githubusercontent.com/66226017/132905661-e3880e96-e43a-4b20-8bd7-ad5dc2c00bc1.png)

Opis współpracy reguł (zawartych w modułach: menus.pl oraz arr_dep.pl) w trakcie wyświetlania przyjazdów i odjazdów.

W prawym górnym rogu zostało wyszczególnione wywołanie reguły findall, które w połączeniu z odpowiednią wersją routeIdfinder przeszukuje bazę i zapisuje powiązane dane do listy.

![image](https://user-images.githubusercontent.com/66226017/132906823-db28f371-3cab-476c-9704-5eac218c1e7f.png)

# Przykład użycia.

Aby uruchomić program, należy uruchomiwszy swipl w folderze zawierającym projekt, użyć komendy consult na pliku 'project_omicron/omicron.pl'.

![image](https://user-images.githubusercontent.com/66226017/132905806-0b760abb-e348-4d7f-bc0a-6f276347d374.png)

Menu główne stawia przed użytkownikiem trzy opcje: sprawdzenie przyjazdów i odjazdów, znalezienie połączenia między miastami i wyjście z programu. Druga opcja co prawda prowadzi do kwestionariusza, ale pobrane przezeń informacje nie zostają wykorzystane, ponieważ funkcje wyszukujące drogę nie zostały zaimplementowane.

![image](https://user-images.githubusercontent.com/66226017/132905824-8ba67c87-a473-4e92-9d77-a2c5baab411e.png)

Przykładowo wypełniony kwestionariusz. Wpisane przez użytkownika odpowiedzi są sprawdzane, w razie błędów pytanie zostaje zadane ponownie.

![image](https://user-images.githubusercontent.com/66226017/132905860-50af24b0-adb2-4000-b31e-6d091425b134.png)

Tabela pokazująca przyjazdy. Ta część programu daję opcję obejrzenia także odjazdów (po wpisaniu dep) oraz powrót do menu głównego (back).

![image](https://user-images.githubusercontent.com/66226017/132905902-4be800bb-a321-42f5-9a8f-6a99fa2d1c99.png)

Po powrocie do menu głównego, użycie trzeciej opcji zakończy działanie programu. Można też ponownie użyć pierwszej opcji, aby obejrzeć przyjazdy i odjazdy o innej godzinie i/albo z innego miasta.

![image](https://user-images.githubusercontent.com/66226017/132905926-9d1db9f3-39bc-4e0c-a1fc-a7003fcb1209.png)
