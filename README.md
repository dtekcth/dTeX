Datateknologsektionens LaTeX-klasser
====================================

## Installation

Kräver xelatex, latexmk mm för att kunna köras

    make install

## `dtek` class

Inkluderar sektionens logotyp, `\title` och `\date` i sidhuvudet.

### Options

Väljs när man laddar klassen

    \documentclass[options]{dtek}

* `includeaddress`: inkluderar sektionens fysiska och digitala adresser i sidfoten

### Kommandon

* `\maketitle`: skriver ut titel, given av `\title{}`.
* `\makewholepagetitle` gör en hel titelsida med titel, sektionens logga(biglogo.pdf) och subtitel som kan skrivas i `\subtitle{}`.
* `\TitleHeadLeft{Titel}`: ändrar titeln i headern. Default beteende är att använda titeln som angets i `\title{}`.
* `\TitleHeadRight{Titel}` lägger en titel i headern under kompileringsdatumet.


## `dtekprotokoll` class

Utöver det som nämns ovan inkluderar denna klassen `\motesnummer` och `\verksamhetsar` i sidhuvudet samt plats för signaturer i sidfoten.

### Options

* `twojust`: används för protokoll som kräver två justerare.

### `funktionarer`

Environment som används för att skapa en närvarolista.

    \begin{funktionarer}
      \funktionar[sekr]{Sekreterare}{Adam Sandberg Eriksson}{saadam}
    \end{funktionarer}

### Kommandon

* `\plats`, `\motesnummer` och `\verksamhetsar`: måste anges.

* `\funktionar[snabbkommando]{funktion}{namn}{email}`: Används bara med `funktionarer` ovan. Om man tar med `[snabbkommande]` skapas `\snabbkommando` som expanderar till `namn`.

* `\makesigns{sekreterare}{ordförande}[justerare1][justerare2]`: I slutet av protokollet, för signaturrader.

## `dtekkallelse` class

För att använda sektionens häftiga kallelsemall kan man använda dokumentklassen dtekkallelse.
Precis som med `dtekprotokoll` så inkluderar klassen `\motesnummer` och `\verksamhetsar`.
Förutom dessa funktioner inkluderas även;

### Kommandon

* `\start` För mötets start
* `\plats` För mötets plats
* `\typ` För mötets typ, denna sätts automagiskt av klassen till antingen `Dagordning`, `Agenda` eller `Kallelse` beroende på vilket av `\agenda`, `\kallelse` eller `\dagordning` är sant (standard är bara dagordning sant).
* `\listtyp` Rubrik till föredragningslistan.
* `\dokumenttyp` Text som följer efter `\typ` vid headers och titel

### Föredragningslista & underpunkter
Environment som används för att skapa en föredragningslista.

    \begin{foredragningslista}
        \punkt Detta är en punkt som syns i alla typer.
        \secr{Hemlig text till punkt 1 som bara syns i agendor}
        \elab{Förklaring till punkt 1 som syns i kallelser och agendor}

        \punkt Detta är en annan punkt som syns i alla typer
        \begin{underpunkter}
            \item Detta är en underpunkt till andra punkten
        \end{underpunkter}
    \end{foredragningslista}

Beroende på typen som används vid typsättningen av dokumentet syns texten i de olika fälten.

* `\punkt` - Syns i alla typer (skrivs i foredragninslista-miljön),
* `\elab` - Syns i kallelser och agendor,
* `\secr` - Syns bara i agendor (döljs alltså i kallelser och dagordningar).

Förtydligande: i dagordningar syns alltså bara punkter och vanliga LaTeX-text.

### Typsättning av de olika typerna

För att specificera vilken typ som ska typsättas används parametern skriver man:
    xelatex -jobname $typ '\providecommand{\$typ{true}}\input{$filnamn}'

Parametrar:

* -jobname sätter namnet på filen som kommer genereras (annars kommer de olika typerna skriva över varandra).
* $typ Ett av `agenda`, `kallelse` eller `dagordning`
* $filnamn Namnet på filen som ska typsättas
