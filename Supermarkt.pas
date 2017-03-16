unit Supermarkt;

interface

uses System.SysUtils, System.Variants,
  System.Classes, System.Generics.Collections, Sortiment, Kunden, Kassensystem, Hilfsfunktionen;

type

  TSupermarkt = class
    private
      FSortiment                : TSortiment;
      FKassenSystem             : TKassenSystem;
      FKundenVerwalter          : TKundenVerwalter;
      FUhrzeit                  : integer;
      FIstGeoeffnet             : boolean;
      FWartezeitenNachStunden   : TList<double>;
      FWartezeitenAktuelleStunde: TList<double>;
      function getWarteschlangenVolumen(): TList<TWarteschlangenVolumen>;
      procedure KundenAnKassensystemUebergeben();
      procedure SupermarktSchliessen();
      procedure SupermarktOeffnen();
      procedure UhrzeitAktualisieren();
      function getUhrzeit(): string;
    public
      property Sortiment                : TSortiment read FSortiment write FSortiment;
      property Kassensystem             : TKassenSystem read FKassenSystem write FKassenSystem;
      property Kundenverwalter          : TKundenVerwalter read FKundenVerwalter write FKundenVerwalter;
      property SchlangenVolumen         : TList<TWarteschlangenVolumen> read getWarteschlangenVolumen;
      property Uhrzeit                  : integer read FUhrzeit write FUhrzeit;
      property UhrzeitString            : string read getUhrzeit;
      property IstGeoeffnet             : boolean read FIstGeoeffnet write FIstGeoeffnet;
      property WarteZeitenNachStunden   : TList<double> read FWartezeitenNachStunden write FWartezeitenNachStunden;
      property WartezeitenAktuelleStunde: TList<double> read FWartezeitenAktuelleStunde
        write FWartezeitenAktuelleStunde;
      constructor create(KassenParameter: TKassenParameter; KundenParameter: TKundenParameter;
        SortimentParameter: TSortimentParameter; KleingeldParameter: TKleingeldParameter);
      procedure TimerEvent();
  end;

implementation

{ TSupermarkt }

constructor TSupermarkt.create(KassenParameter: TKassenParameter; KundenParameter: TKundenParameter;
  SortimentParameter: TSortimentParameter; KleingeldParameter: TKleingeldParameter);
begin
  self.Sortiment := TSortiment.create(SortimentParameter);
  self.Kassensystem := TKassenSystem.create(KassenParameter, KleingeldParameter);
  self.Kundenverwalter := TKundenVerwalter.create(KundenParameter, self.Sortiment);
  self.IstGeoeffnet := true;
  self.Uhrzeit := 8 * 60;
end;

function TSupermarkt.getUhrzeit: string;
var
  stunden      : Extended;
  stundenString: string;
  minuten      : Extended;
  minutenString: string;
begin
  stunden := ((self.Uhrzeit.ToExtended - (self.Uhrzeit mod 60)) / 60);
  if stunden < 10 then
    stundenString := '0' + stunden.ToString()
  else
    stundenString := stunden.ToString();
  minuten := self.Uhrzeit.ToExtended - (stunden * 60);
  if minuten < 10 then
    minutenString := '0' + minuten.ToString()
  else
    minutenString := minuten.ToString();
  Result := stundenString + ':' + minutenString;
end;

function TSupermarkt.getWarteschlangenVolumen: TList<TWarteschlangenVolumen>;
var
  Volumen     : TWarteschlangenVolumen;
  VolumenListe: TList<TWarteschlangenVolumen>;
  i           : integer;
begin
  VolumenListe := TList<TWarteschlangenVolumen>.create;
  for i := 0 to self.Kassensystem.WarteschlangenListe.Count - 1 do
  begin
    Volumen.ArtikelVolumen := self.Kassensystem.WarteschlangenListe[i].ArtikelVolumen;
    Volumen.SchlangenNummer := i;
    Volumen.SchlangeOffen := self.Kassensystem.WarteschlangenListe[i].IstGeoeffnet;
    VolumenListe.Add(Volumen);
  end;
  Result := VolumenListe;
end;

procedure TSupermarkt.KundenAnKassensystemUebergeben;
var
  i          : integer;
  wunschkasse: integer;
begin
  try

    if self.Kundenverwalter.KundenAnzahl > 0 then
    begin
      for i := 0 to self.Kundenverwalter.KundenAnzahl - 1 do
      begin
        if self.Kundenverwalter.KundenListe[i].Kundenstatus = ksBereitZumZahlen then
        begin
          wunschkasse := self.Kundenverwalter.KundenListe[i].WarteschlangeWaehlen(self.SchlangenVolumen);
          if wunschkasse <= (self.Kassensystem.WarteschlangenListe.Count - 1) then
          begin
            self.Kassensystem.WarteschlangenListe[wunschkasse].KundenListe.Add(self.Kundenverwalter.KundenListe[i]);
            self.Kundenverwalter.KundenListe[i].Kundenstatus := ksInWarteschlange;
          end;
        end;
      end;
    end;
  finally

  end;
end;

procedure TSupermarkt.SupermarktOeffnen;
begin
  self.IstGeoeffnet := true;
end;

procedure TSupermarkt.SupermarktSchliessen;
begin
  self.IstGeoeffnet := false;
  self.Kundenverwalter.KundenListe.Clear;
end;

procedure TSupermarkt.TimerEvent;
begin
  self.UhrzeitAktualisieren;
  self.Kassensystem.TimerEvent;
  self.Kundenverwalter.TimerEvent(self.IstGeoeffnet);
  self.KundenAnKassensystemUebergeben;

end;

procedure TSupermarkt.UhrzeitAktualisieren;
begin
  self.Uhrzeit := self.Uhrzeit + 1;
  if self.Uhrzeit = (20 * 60) then
    self.SupermarktSchliessen;
  if (self.Uhrzeit > (20 * 60)) and (self.Kundenverwalter.KundenListe.Count = 0) then
    self.Uhrzeit := 7 * 60;
  if self.Uhrzeit = (8 * 60) then
    self.SupermarktOeffnen;
end;

end.
