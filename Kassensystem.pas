unit Kassensystem;

interface

uses System.SysUtils, System.Variants, ExtCtrls,
  System.Classes, System.Generics.Collections, Sortiment, Kunden, Hilfsfunktionen;

type

  TWarteschlange = class
  private
    FKundenListe         : TList<TKunde>;
    FWarteschlangenNummer: integer;
    FIstGeoeffnet        : boolean;
    function getKundenAnzahl(): integer;
    function getArtikelVolumen(): integer;
  public
    property WarteschlangenNummer: integer read FWarteschlangenNummer write FWarteschlangenNummer;
    property IstGeoeffnet        : boolean read FIstGeoeffnet write FIstGeoeffnet;
    property KundenListe         : TList<TKunde> read FKundenListe write FKundenListe;
    property KundenAnzahl        : integer read getKundenAnzahl;
    property ArtikelVolumen      : integer read getArtikelVolumen;
    constructor create(WarteschlangenNummer: integer);
    procedure SchlangeOeffnen();
    procedure SchlangeSchliessen();
    procedure EventTimer();
  end;

  TKasse = class
  private
    FKassenNummer      : integer;
    FKassenStatus      : TKassenStatus;
    FWarteschlange     : TWarteschlange;
    FAktuellerKunde    : TKunde;
    FIndexScanvorgang  : integer;
    FGescannteArtikel  : TList<TArtikel>;
    FRechnungsBetrag   : double;
    FKleingeldParameter: TKleingeldParameter;
    procedure KassiereKunde();
    procedure ScanneWare();
    procedure ArtikelStornieren();
    procedure NaechsterKunde();
    function getKundenInSchlange(): integer;
    function getRechnungsBetrag(): double;
    function getOeffnungsStatus(): boolean;
  public
    property KassenNummer      : integer read FKassenNummer write FKassenNummer;
    property IstGeoffnet       : boolean read getOeffnungsStatus;
    property KassenStatus      : TKassenStatus read FKassenStatus write FKassenStatus;
    property Warteschlange     : TWarteschlange read FWarteschlange write FWarteschlange;
    property AktuellerKunde    : TKunde read FAktuellerKunde write FAktuellerKunde;
    property IndexScanvorgang  : integer read FIndexScanvorgang write FIndexScanvorgang;
    property KundenInSchlange  : integer read getKundenInSchlange;
    property KleingeldParameter: TKleingeldParameter read FKleingeldParameter
      write FKleingeldParameter;
    property Rechnungsbetrag : double read getRechnungsBetrag write FRechnungsBetrag;
    property GescannteArtikel: TList<TArtikel> read FGescannteArtikel write FGescannteArtikel;
    constructor create(KassenNummer: integer; InputWarteschlange: TWarteschlange;
      KleingeldParameter: TKleingeldParameter);
    procedure KasseOeffnen();
    procedure KasseSchliessen();
    procedure KassenTimerEvent();
  end;

  TKassenSystem = class
  private
    FKassenListe        : TList<TKasse>;
    FWarteschlangenListe: TList<TWarteschlange>;
    FLaengsteSchlange   : integer;
    procedure OeffneKasse();
    procedure SchliesseKasse();
    procedure verwalteKassenBedarf();
    procedure langsteSchlangeErmitteln();
    function getWartendeKundenDurchschnitt(): double;
    function getOffeneSchlangen(): double;
    function getOffeneKassen(): integer;
    function getWartendeKundenGesamt(): double;
    function getKuerzesteWarteschlange(): integer;
  public
    constructor create(Parameter: TKassenParameter; KleingeldParameter: TKleingeldParameter);
    property KassenListe: TList<TKasse> read FKassenListe write FKassenListe;
    property WarteschlangenListe: TList<TWarteschlange> read FWarteschlangenListe
      write FWarteschlangenListe;
      property LaengsteSchlange : integer read FLaengsteSchlange write FLaengsteSchlange;
    property WartendeKundenGesamt: double read getWartendeKundenGesamt;
    property OffeneSchlangen: double read getOffeneSchlangen;
    property OffeneKassen: integer read getOffeneKassen;
    property WartendeKundenDurchschnitt: double read getWartendeKundenDurchschnitt;

    procedure TimerEvent;
  end;

implementation

{ TKasse }

procedure TKasse.ArtikelStornieren();
begin
  self.GescannteArtikel.Sort;
  self.GescannteArtikel.Delete(self.GescannteArtikel.Count - 1);
end;

constructor TKasse.create(KassenNummer: integer; InputWarteschlange: TWarteschlange;
  KleingeldParameter: TKleingeldParameter);
begin
  self.KassenNummer       := KassenNummer;
  self.KassenStatus       := ksGeschlossen;
  self.Warteschlange      := InputWarteschlange;
  self.KleingeldParameter := KleingeldParameter;
  self.IndexScanvorgang   := 0;
end;

function TKasse.getKundenInSchlange: integer;
begin
  result := self.Warteschlange.KundenListe.Count;
end;

function TKasse.getOeffnungsStatus: boolean;
begin
  result := not(self.KassenStatus = ksGeschlossen);
end;

function TKasse.getRechnungsBetrag: double;
var
  i     : integer;
  Betrag: double;
begin
  Betrag   := 0;
  for i    := 0 to self.GescannteArtikel.Count - 1 do
    Betrag := Betrag + self.GescannteArtikel[i].Wert;
  result   := Betrag;
end;

procedure TKasse.ScanneWare();
begin
  if Assigned(self.AktuellerKunde) then
  begin
    try
      if self.IndexScanvorgang < self.AktuellerKunde.Warenkorb.ArtikelListe.Count - 1 then
      begin
        repeat
          self.GescannteArtikel.Add(self.AktuellerKunde.Warenkorb.ArtikelListe[IndexScanvorgang]);
          IndexScanvorgang := IndexScanvorgang + 1;
        until ((Random(30) = 30) or
          (self.IndexScanvorgang = self.AktuellerKunde.Warenkorb.ArtikelListe.Count - 1));
      end
      else
      begin
        self.KassenStatus     := ksWareScannenFertig;
        self.IndexScanvorgang := 0;
      end;
    finally

    end;
  end
  else
    self.KassenStatus := ksNaechsterKunde;
end;

procedure TKasse.KassenTimerEvent;
begin
  case self.KassenStatus of
    ksWareScannen:
      self.ScanneWare;
    ksWareScannenFertig:
      self.KassiereKunde;
    ksKassieren:
      self.KassiereKunde;
    ksKassierenFertig:
      self.NaechsterKunde;
    ksNaechsterKunde:
      self.NaechsterKunde;
    ksNaechsterKundeFertig:
      self.ScanneWare;
    ksBereitZumSchliessen:
      self.KasseSchliessen;
  end;
end;

procedure TKasse.KasseOeffnen;
begin
  self.Warteschlange.IstGeoeffnet := true;
  self.KassenStatus               := ksNaechsterKunde;
end;

procedure TKasse.KasseSchliessen;
begin
  if self.KundenInSchlange = 0 then
  begin
    self.KassenStatus               := ksGeschlossen;
    self.Warteschlange.IstGeoeffnet := false;
  end;
end;

procedure TKasse.KassiereKunde();
begin
  if self.Rechnungsbetrag > self.AktuellerKunde.Bargeld then
    self.ArtikelStornieren;
  if self.AktuellerKunde.Bezahlen(self.Rechnungsbetrag, self.KleingeldParameter) then
  begin
    self.Rechnungsbetrag             := 0;
    self.AktuellerKunde.Kundenstatus := ksZahlenFertig;
    self.AktuellerKunde              := nil;
    self.KassenStatus                := ksKassierenFertig;
    self.GescannteArtikel.Free;
  end;
end;

procedure TKasse.NaechsterKunde;
begin
  self.KassenStatus := ksNaechsterKunde;
  if self.KundenInSchlange > 0 then
  begin
    self.AktuellerKunde   := self.Warteschlange.KundenListe[0];
    self.GescannteArtikel := TList<TArtikel>.create;
    self.Warteschlange.KundenListe.Delete(0);
    self.KassenStatus := ksNaechsterKundeFertig;
  end;

end;

{ TWarteschlange }

constructor TWarteschlange.create(WarteschlangenNummer: integer);
begin
  self.IstGeoeffnet         := false;
  self.KundenListe          := TList<TKunde>.create;
  self.WarteschlangenNummer := WarteschlangenNummer;
end;

procedure TWarteschlange.EventTimer;
var
  i: integer;
begin
  for i := 0 to self.KundenListe.Count - 1 do
  begin
    self.KundenListe[i].DauerWarteschlange := self.KundenListe[i].DauerWarteschlange + 1
  end;
end;

function TWarteschlange.getArtikelVolumen(): integer;
var
  volumen: integer;
  i      : integer;
begin
  volumen := 0;
  for i   := 0 to self.KundenAnzahl - 1 do
  begin
    volumen := volumen + self.KundenListe[i].Warenkorb.ArtikelAnzahl;
  end;
  result := volumen;
end;

function TWarteschlange.getKundenAnzahl: integer;
begin
  result := self.KundenListe.Count;
end;

procedure TWarteschlange.SchlangeOeffnen;
begin
  self.IstGeoeffnet := true;
end;

procedure TWarteschlange.SchlangeSchliessen;
begin
  self.IstGeoeffnet := false;
end;

{ TKassenVerwalter }

constructor TKassenSystem.create(Parameter: TKassenParameter;
  KleingeldParameter: TKleingeldParameter);
var
  i: integer;
begin
  self.LaengsteSchlange := 0;
  self.WarteschlangenListe := TList<TWarteschlange>.create;
  for i                    := 0 to Parameter.AnzahlKassen - 1 do
    self.WarteschlangenListe.Add(TWarteschlange.create(i));
  self.KassenListe := TList<TKasse>.create;
  for i            := 0 to Parameter.AnzahlKassen - 1 do
    self.KassenListe.Add(TKasse.create(i, self.WarteschlangenListe[i], KleingeldParameter))
end;

procedure TKassenSystem.OeffneKasse;
var
  i: integer;
begin
  for i := 0 to self.KassenListe.Count - 1 do
  begin
    if not self.KassenListe[i].IstGeoffnet or not self.WarteschlangenListe[i].IstGeoeffnet then
    begin
      self.KassenListe[i].KasseOeffnen;
      self.WarteschlangenListe[i].SchlangeOeffnen;
      exit;
    end;
  end;
end;

procedure TKassenSystem.SchliesseKasse;
begin
  self.KassenListe[getKuerzesteWarteschlange].KasseSchliessen; { TODO -ofehler }
end;

function TKassenSystem.getWartendeKundenDurchschnitt: double;
begin
  if self.WartendeKundenGesamt = 0 then
    result := 0
  else
    result := self.WartendeKundenGesamt / self.OffeneSchlangen;
end;

function TKassenSystem.getKuerzesteWarteschlange: integer;
var
  kurz : integer;
  Kasse: integer;
  i    : integer;
begin
  Kasse := 0;
  kurz  := 1000;
  for i := 0 to self.KassenListe.Count - 1 do
  begin
    if self.WarteschlangenListe[i].IstGeoeffnet then
    begin
      if kurz > self.WarteschlangenListe[i].KundenAnzahl then
      begin
        kurz  := self.WarteschlangenListe[i].KundenAnzahl;
        Kasse := self.WarteschlangenListe[i].WarteschlangenNummer;
      end;
    end;
  end;
  result := Kasse;
end;

function TKassenSystem.getOffeneKassen: integer;
var
  i           : integer;
  OffeneKassen: integer;
begin
  OffeneKassen := 0;
  for i        := 0 to self.KassenListe.Count - 1 do
  begin
    if self.KassenListe[i].IstGeoffnet then
      Inc(OffeneKassen);
  end;
  result := OffeneKassen;
end;

function TKassenSystem.getOffeneSchlangen: double;
var
  i              : integer;
  OffeneSchlangen: double;
begin
  OffeneSchlangen := 0;
  for i           := 0 to self.WarteschlangenListe.Count - 1 do
  begin
    if (self.WarteschlangenListe[i].IstGeoeffnet) or
      (self.WarteschlangenListe[i].KundenListe.Count > 0) then
      OffeneSchlangen := OffeneSchlangen + 1;
  end;
  result := OffeneSchlangen;
end;

function TKassenSystem.getWartendeKundenGesamt: double;
var
  i     : integer;
  Kunden: double;
begin
  Kunden := 0;
  for i  := 0 to self.WarteschlangenListe.Count - 1 do
    if self.WarteschlangenListe[i].KundenAnzahl > 0 then
      Kunden := Kunden + self.WarteschlangenListe[i].KundenAnzahl.ToDouble;
  result     := Kunden;
end;

procedure TKassenSystem.langsteSchlangeErmitteln;
var
  i: Integer;
begin
  for i := 0 to self.WarteschlangenListe.Count - 1 do
  if self.WarteschlangenListe[i].KundenAnzahl > self.LaengsteSchlange then
    self.LaengsteSchlange := self.WarteschlangenListe[i].KundenAnzahl;
end;

procedure TKassenSystem.verwalteKassenBedarf;
begin
  if (self.OffeneKassen = 0) or (self.WartendeKundenDurchschnitt > 4) then
    self.OeffneKasse;
  if (self.WartendeKundenDurchschnitt < 3) and (self.OffeneKassen > 1) then
    self.SchliesseKasse;
end;

procedure TKassenSystem.TimerEvent;
var
  i: integer;
begin
self.langsteSchlangeErmitteln;
  self.verwalteKassenBedarf;
  for i := 0 to self.KassenListe.Count - 1 do
    self.KassenListe[i].KassenTimerEvent;
end;

end.
