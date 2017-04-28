unit HilfsFunktionen;

interface

uses
  SysUtils;

function Zufallszahl(minimum, maximum: integer): integer;
function ZufallsBoolean(Wahrscheinlichkeit: integer): boolean; overload;
function ZufallsBoolean(Wahrscheinlichkeit: integer; Basis: integer): boolean; overload;

type

  TKassenStatus = (ksWareScannen, ksWareScannenFertig, ksKassieren, ksKassierenFertig,
    ksNaechsterKunde, ksNaechsterKundeFertig, ksBereitZumSchliessen, ksGeschlossen);

  TKundenStatus = (ksArtikelEinpacken, ksZurKasseGehen, ksBereitZumZahlen, ksInWarteschlange,
    ksZahlen, ksZahlenFertig);

  TKundenVerwalterStatus = (kvNormal, kvFlashMob);

  TWarteschlangenVolumen = record
    ArtikelVolumen: double;
    SchlangenNummer: integer;
    SchlangeOffen: boolean;
  end;

  TKassenParameter = record
    AnzahlKassen: integer;
    maxScanGeschwindigkeit: integer;
  end;

  TSortimentParameter = record
    Pfad: string;
    Trennzeichen: string;
  end;

  TKleingeldParameter = record
    AlterKleingeldquote: integer;
    KleingeldZahlerAlt: integer;
    KleingeldZahlerRest: integer;
  end;

  TKundenParameter = record
    MinAlter: integer;
    MaxAlter: integer;
    MinBargeld: integer;
    MaxBargeld: integer;
    Kundenfrequenz: integer;
    Kundenkapazitaet: integer;
    FlashmobQuote: integer;
  end;

  TAuswertungsParameter = record
    KassierteKunden: integer;
    WartezeitDurchschnitt : integer;
    WartezeitMaximum : integer;
    WartezeitMinimun : integer;
    WarenkorbDurchschnitt : double;
    FlashmobAnzahl : integer;
    RechnungsBetragDurchschnitt : double;
    RechnungsBetragMaximum : double;
    Laufzeit: integer;
  end;

implementation

function Zufallszahl(minimum, maximum: integer): integer;
begin
  Result := Random(maximum - minimum) + minimum;
end;

function ZufallsBoolean(Wahrscheinlichkeit: integer): boolean;
begin
  Result := Random(100) < Wahrscheinlichkeit;
end;

function ZufallsBoolean(Wahrscheinlichkeit: integer; Basis: integer): boolean;
begin
  Result := Random(Basis) < Wahrscheinlichkeit;
end;

end.
