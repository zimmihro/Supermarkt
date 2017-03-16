unit Kunden;

interface

uses System.SysUtils, System.Variants,
  System.Classes, System.Generics.Collections, Sortiment, Hilfsfunktionen;

const
  GRENZE_BARGELD = 0.9;

type

  TWarenkorb = class
    private
      FArtikelListe: TList<TArtikel>;
      function getArtikelWert(): double;
      function getArtikelAnzahl(): integer;
    public
      constructor create();
      property ArtikelListe: TList<TArtikel> read FArtikelListe write FArtikelListe;
      property ArtikelAnzahl: integer read getArtikelAnzahl;
      property Wert: double read getArtikelWert;
      procedure ArtikelHinzufuegen(Artikel: TArtikel);
      // procedure ArtikelEntfernen;
  end;

  TKunde = class
    private
      FAlter                : integer;
      FKundenstatus         : TKundenStatus;
      FTimerAussetzenCounter: integer;
      FBargeld              : double;
      FSortiment            : TSortiment;
      FWarenkorb            : TWarenkorb;
      FDauerAufenthalt      : integer;
      FDauerWarteschlange   : integer;
      function WarteschlangenBeurteilen(Warteschlangen: TList<TWarteschlangenVolumen>): TList<TWarteschlangenVolumen>;
    public
      constructor create(Alter: integer; Bargeld: double; Sortiment: TSortiment);
      property Alter: integer read FAlter write FAlter;
      property Kundenstatus: TKundenStatus read FKundenstatus write FKundenstatus;
      property TimerAussetzenCounter: integer read FTimerAussetzenCounter write FTimerAussetzenCounter;
      property Bargeld: double read FBargeld write FBargeld;
      property Sortiment: TSortiment read FSortiment write FSortiment;
      property Warenkorb: TWarenkorb read FWarenkorb write FWarenkorb;
      property DauerAufenthalt: integer read FDauerAufenthalt write FDauerAufenthalt;
      property DauerWarteschlange: integer read FDauerWarteschlange write FDauerWarteschlange;
      procedure ArtikelEinpacken();
      procedure TimerEvent();
      procedure ArtikelEntfernen();
      function WarteschlangeWaehlen(Warteschlangen: TList<TWarteschlangenVolumen>): integer;
      function Bezahlen(Betrag: double; KleingeldParameter: TKleingeldParameter): boolean;
  end;

  TKundenVerwalter = class
    private
      FKundenVerwalterStatus            : TKundenVerwalterStatus;
      FKundenListe                      : TList<TKunde>;
      FKundenFrequenz                   : integer;
      FKundenKapazitaet                 : integer;
      FFlashmobQuote                    : integer;
      FFlashmobTimer                    : integer;
      FSortiment                        : TSortiment;
      FMinAlter                         : integer;
      FMaxAlter                         : integer;
      FMinBargeld                       : integer;
      FMaxBargeld                       : integer;
      FEntfernteKunden                  : double;
      FKuerzesteWartezeit               : double;
      FLaengsteWartezeit                : double;
      FWartezeitGesamt                  : double;
      FAufenthaltGesamt                 : double;
      FMaxWartezeitDurchschnitt         : double;
      procedure AufenthaltMessen();
      procedure KassierteKundenEntfernen();
      procedure MaxWartezeitDurchschnittAktualisieren();
      procedure FlashMobStarten();
      procedure FlashMob();
      function getKundenAnzahl(): integer;
      function getEinpackendeKunden(): integer;
      function getWartendeKunden(): integer;
      function getWartezeitDurchschnitt(): double;
      function getAufenthaltDurchschnitt(): double;
      function getWartezeitDurchschnittString: string;
    public
      constructor create(Parameter: TKundenParameter; Sortiment: TSortiment);
      property Kundenverwalterstatus: TKundenVerwalterStatus read FKundenVerwalterStatus write FKundenVerwalterStatus;
      property KundenListe: TList<TKunde> read FKundenListe write FKundenListe;
      property KundenFrequenz: integer read FKundenFrequenz write FKundenFrequenz;
      property KundenKapazitaet: integer read FKundenKapazitaet write FKundenKapazitaet;
      property FlashmobQuote: integer read FFlashmobQuote write FFlashmobQuote;
      property FlashMobTimer: integer read FFlashmobTimer write FFlashmobTimer;
      property KundenAnzahl: integer read getKundenAnzahl;
      property KundenBeimEinpacken: integer read getEinpackendeKunden;
      property KundenBeimWarten: integer read getWartendeKunden;
      property Sortiment: TSortiment read FSortiment write FSortiment;
      property MinAlter: integer read FMinAlter write FMinAlter;
      property MaxAlter: integer read FMaxAlter write FMaxAlter;
      property MinBargeld: integer read FMinBargeld write FMinBargeld;
      property MaxBargeld: integer read FMaxBargeld write FMaxBargeld;
      property EntfernteKunden: double read FEntfernteKunden write FEntfernteKunden;
      property WartezeitGesamt: double read FWartezeitGesamt write FWartezeitGesamt;
      property AufenthaltGesamt: double read FAufenthaltGesamt write FAufenthaltGesamt;
      property LaengsteWartezeit: double read FLaengsteWartezeit write FLaengsteWartezeit;
      property KuerzesteWartezeit: double read FKuerzesteWartezeit write FKuerzesteWartezeit;
      property Wartezeitdurchschnitt: double read getWartezeitDurchschnitt;
      property WartezeitdurchschnittString: string read getWartezeitDurchschnittString;
      property MaxWartezeitDurchschnitt: double read FMaxWartezeitDurchschnitt write FMaxWartezeitDurchschnitt;
      property AufenthaltDurchschnitt: double read getAufenthaltDurchschnitt;
      procedure KundeErstellen(); overload;
      procedure KundeErstellen(Limit: integer); overload;
      procedure TimerEvent(supermarktOffen: boolean);
  end;

implementation

{ TWarenkorb }

procedure TWarenkorb.ArtikelHinzufuegen(Artikel: TArtikel);
begin
  self.ArtikelListe.Add(Artikel);
end;

constructor TWarenkorb.create;
begin
  self.ArtikelListe := TList<TArtikel>.create;
end;

function TWarenkorb.getArtikelAnzahl: integer;
begin
  result := self.ArtikelListe.Count;
end;

function TWarenkorb.getArtikelWert: double;
var
  Wert   : double;
  Artikel: integer;
begin
  Wert := 0;
  for Artikel := 0 to self.ArtikelListe.Count - 1 do
    Wert := Wert + ArtikelListe[Artikel].Wert;
  result := Wert;
end;

{ TKunde }

procedure TKunde.ArtikelEinpacken();
var
  randomArtikelIndex: integer;
begin
  randomArtikelIndex := Random(self.Sortiment.ArtikeAnzahl);
  if ZufallsBoolean(60) then
  begin
    self.Warenkorb.ArtikelHinzufuegen(self.Sortiment.WarenListe[randomArtikelIndex]);
    if ZufallsBoolean(7) then
      self.Warenkorb.ArtikelListe.Delete(self.Warenkorb.ArtikelAnzahl - 1);
  end;
  if self.Warenkorb.Wert > (self.Bargeld * GRENZE_BARGELD) then
  begin
    self.TimerAussetzenCounter := Zufallszahl(5, 15);
    self.Kundenstatus := ksZurKasseGehen;
  end
  else if ZufallsBoolean(4) then
  begin
    self.TimerAussetzenCounter := Zufallszahl(5, 15);
    self.Kundenstatus := ksZurKasseGehen;
  end;
end;

procedure TKunde.ArtikelEntfernen;
begin
  if self.Warenkorb.ArtikelAnzahl > 0 then
    self.Warenkorb.ArtikelListe.Delete(0);
end;

function TKunde.Bezahlen(Betrag: double; KleingeldParameter: TKleingeldParameter): boolean;
var
  kleingeldQuote: integer;
  kleinGeldModus: boolean;
begin
  kleingeldQuote := Random(100);
  kleinGeldModus := ((self.Alter > KleingeldParameter.AlterKleingeldquote) and
    (kleingeldQuote < KleingeldParameter.KleingeldZahlerAlt));
  if kleinGeldModus or (kleingeldQuote < KleingeldParameter.KleingeldZahlerRest) then
    result := false
  else
    result := self.Bargeld > Betrag;
end;

constructor TKunde.create(Alter: integer; Bargeld: double; Sortiment: TSortiment);
begin
  self.Alter := Alter;
  self.Bargeld := Bargeld;
  self.Warenkorb := TWarenkorb.create;
  self.Sortiment := Sortiment;
  self.Kundenstatus := ksArtikelEinpacken;
  self.DauerAufenthalt := 0;
end;

procedure TKunde.TimerEvent;
begin
  if self.TimerAussetzenCounter > 0 then
  begin
    self.TimerAussetzenCounter := self.TimerAussetzenCounter - 1;
    Exit;
  end;
  if self.Kundenstatus = ksArtikelEinpacken then
    self.ArtikelEinpacken;
  if self.Kundenstatus = ksZurKasseGehen then
    self.Kundenstatus := ksBereitZumZahlen;
end;

function TKunde.WarteschlangenBeurteilen(Warteschlangen: TList<TWarteschlangenVolumen>): TList<TWarteschlangenVolumen>;
var
  schaetzMultiplikator      : double;
  persoenlicherEindruck     : TWarteschlangenVolumen;
  persoenlicherEindruckListe: TList<TWarteschlangenVolumen>;
  I                         : integer;
begin
  schaetzMultiplikator := (100 - Random(20)) / 100;
  persoenlicherEindruckListe := TList<TWarteschlangenVolumen>.create;
  for I := 0 to Warteschlangen.Count - 1 do
  begin
    if Warteschlangen[I].SchlangeOffen then
    begin
      persoenlicherEindruck.ArtikelVolumen := Warteschlangen[I].ArtikelVolumen * schaetzMultiplikator;
      persoenlicherEindruck.SchlangenNummer := Warteschlangen[I].SchlangenNummer;
      persoenlicherEindruck.SchlangeOffen := Warteschlangen[I].SchlangeOffen;
      persoenlicherEindruckListe.Add(persoenlicherEindruck);
    end;
  end;
  result := persoenlicherEindruckListe;
end;

function TKunde.WarteschlangeWaehlen(Warteschlangen: TList<TWarteschlangenVolumen>): integer;
var
  randomQuote            : integer;
  subjektiveEinschaetzung: TList<TWarteschlangenVolumen>;
begin
  try
    randomQuote := Random(100);
    subjektiveEinschaetzung := self.WarteschlangenBeurteilen(Warteschlangen);
    subjektiveEinschaetzung.Sort;
    if subjektiveEinschaetzung.Count = 1 then
    begin
      result := subjektiveEinschaetzung[0].SchlangenNummer;
      Exit;
    end;
    if subjektiveEinschaetzung[0].ArtikelVolumen < (subjektiveEinschaetzung[1].ArtikelVolumen * 0.8) then
    begin
      result := subjektiveEinschaetzung[0].SchlangenNummer;
      Exit;
    end;
    if randomQuote < 40 then
      result := subjektiveEinschaetzung[1].SchlangenNummer
    else
      result := subjektiveEinschaetzung[0].SchlangenNummer;
  finally
    subjektiveEinschaetzung.Free;
  end;
end;

{ TKundenVerwalter }

procedure TKundenVerwalter.AufenthaltMessen;
var
  I: integer;
begin
  try
    if Assigned(self.KundenListe) then
    begin
      for I := 0 to self.KundenListe.Count - 1 do
      begin
        self.KundenListe[I].DauerAufenthalt := self.KundenListe[I].DauerAufenthalt + 1;
        if self.KundenListe[I].Kundenstatus = ksInWarteschlange then
          self.KundenListe[I].DauerWarteschlange := self.KundenListe[I].DauerWarteschlange + 1;
      end;
    end;
  finally

  end;

end;

constructor TKundenVerwalter.create(Parameter: TKundenParameter; Sortiment: TSortiment);
begin
  self.Kundenverwalterstatus := kvNormal;
  self.KundenListe := TList<TKunde>.create;
  self.KundenFrequenz := Parameter.KundenFrequenz;
  self.KundenKapazitaet := Parameter.KundenKapazitaet;
  self.FlashmobQuote := Parameter.FlashmobQuote;
  self.MinAlter := Parameter.MinAlter;
  self.MaxAlter := Parameter.MaxAlter;
  self.MinBargeld := Parameter.MinBargeld;
  self.MaxBargeld := Parameter.MaxBargeld;
  self.Sortiment := Sortiment;
  self.EntfernteKunden := 0;
  self.WartezeitGesamt := 0;
  self.LaengsteWartezeit := 0;
  self.MaxWartezeitDurchschnitt := 0;
end;

procedure TKundenVerwalter.FlashMob;
begin
  self.KundeErstellen(self.KundenFrequenz * Zufallszahl(3, 10));
  self.FFlashmobTimer := self.FlashMobTimer - 1;
  if self.FlashMobTimer = 0 then
    self.Kundenverwalterstatus := kvNormal
end;

procedure TKundenVerwalter.FlashMobStarten;
begin
  self.FlashMobTimer := Zufallszahl(5, 15);
  self.Kundenverwalterstatus := kvFlashMob;
end;

function TKundenVerwalter.getAufenthaltDurchschnitt: double;
begin
  if self.EntfernteKunden > 0 then
    result := self.AufenthaltGesamt / self.EntfernteKunden
  else
    result := 0
end;

function TKundenVerwalter.getEinpackendeKunden: integer;
var
  Kunden: integer;
  I     : integer;
begin
  Kunden := 0;
  for I := 0 to self.KundenAnzahl - 1 do
  begin
    if self.KundenListe[I].Kundenstatus = ksArtikelEinpacken then
      Inc(Kunden);
  end;
  result := Kunden;
end;

function TKundenVerwalter.getKundenAnzahl: integer;
begin
  result := self.KundenListe.Count;
end;

function TKundenVerwalter.getWartendeKunden: integer;
var
  Kunden: integer;
  I     : integer;
begin
  Kunden := 0;
  for I := 0 to self.KundenAnzahl - 1 do
  begin
    if (self.KundenListe[I].Kundenstatus = ksInWarteschlange) or (self.KundenListe[I].Kundenstatus = ksBereitZumZahlen)
    then
      Inc(Kunden);
  end;
  result := Kunden;
end;

function TKundenVerwalter.getWartezeitDurchschnitt: double;
begin
  if self.EntfernteKunden > 0 then
    result := self.WartezeitGesamt / self.EntfernteKunden / 2
  else
    result := 0
end;

function TKundenVerwalter.getWartezeitDurchschnittString: string;
var
  minuten       : double;
  sekunden      : double;
  minutenstring : string;
  sekundenstring: string;
begin
  minuten := trunc(self.Wartezeitdurchschnitt);
  sekunden := trunc((trunc((self.Wartezeitdurchschnitt - minuten) * 100) / 100) * 60);
  if minuten >= 10 then
    minutenstring := minuten.ToString()
  else
    minutenstring := '0' + minuten.ToString();
  if sekunden >= 10 then
    sekundenstring := sekunden.ToString()
  else
    sekundenstring := '0' + sekunden.ToString();
  result := minutenstring + ':' + sekundenstring + ' Minuten';
end;

procedure TKundenVerwalter.KassierteKundenEntfernen;
var
  I: integer;
begin
  if Assigned(self.KundenListe) then
    try
      I := self.KundenListe.Count - 1;
      while I >= 0 do
      begin
        if self.KundenListe[I].Kundenstatus = ksZahlenFertig then
        begin
          if self.KuerzesteWartezeit > self.KundenListe[I].DauerWarteschlange then
            self.KuerzesteWartezeit := self.KundenListe[I].DauerWarteschlange;
          if self.LaengsteWartezeit < self.KundenListe[I].DauerWarteschlange then
            self.LaengsteWartezeit := self.KundenListe[I].DauerWarteschlange;
          self.EntfernteKunden := self.EntfernteKunden + 1;
          self.WartezeitGesamt := self.WartezeitGesamt + self.KundenListe[I].DauerWarteschlange;
          self.AufenthaltGesamt := self.AufenthaltGesamt + self.KundenListe[I].DauerAufenthalt;
          self.KundenListe.Delete(I);
        end;
        dec(I);
      end;
    finally

    end;
end;

procedure TKundenVerwalter.KundeErstellen();
var
  Alter  : integer;
  Bargeld: integer;
  I      : integer;
begin
  for I := 1 to self.KundenFrequenz - 1 do
  begin
    if (self.KundenListe.Count < self.KundenKapazitaet) and (ZufallsBoolean(60)) then
    begin
      Alter := Zufallszahl(self.MinAlter, self.MaxAlter);
      Bargeld := Zufallszahl(self.MinBargeld, self.MaxBargeld);
      self.KundenListe.Add(TKunde.create(Alter, Bargeld, self.Sortiment));
    end;
  end;
end;

procedure TKundenVerwalter.KundeErstellen(Limit: integer);
var
  Alter  : integer;
  Bargeld: integer;
  I      : integer;
begin
  for I := 1 to Limit - 1 do
  begin
    if (self.KundenListe.Count < self.KundenKapazitaet) and (ZufallsBoolean(60)) then
    begin
      Alter := Zufallszahl(self.MinAlter, self.MaxAlter);
      Bargeld := Zufallszahl(self.MinBargeld, self.MaxBargeld);
      self.KundenListe.Add(TKunde.create(Alter, Bargeld, self.Sortiment));
    end;
  end;
end;

procedure TKundenVerwalter.MaxWartezeitDurchschnittAktualisieren;
begin
  if self.Wartezeitdurchschnitt > self.MaxWartezeitDurchschnitt then
    self.MaxWartezeitDurchschnitt := self.Wartezeitdurchschnitt;
end;

procedure TKundenVerwalter.TimerEvent(supermarktOffen: boolean);
var
  I: integer;
begin
  self.AufenthaltMessen;
  self.MaxWartezeitDurchschnittAktualisieren;
  if supermarktOffen then
    case self.Kundenverwalterstatus of
      kvNormal:
        begin
          self.KundeErstellen;
          if ZufallsBoolean(self.FlashmobQuote, 1000) then
            self.FlashMobStarten;
        end;
      kvFlashMob:
        self.FlashMob;
    end;
  self.KassierteKundenEntfernen;
  for I := 0 to self.KundenListe.Count - 1 do
  begin
    self.KundenListe[I].TimerEvent;
  end;

end;

end.
