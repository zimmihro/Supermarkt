unit Sortiment;

interface

uses System.SysUtils, System.Variants,
  System.Classes, System.Generics.Collections, HilfsFunktionen;

type

  TArtikel = class
  private
    FWert: double;
    FName: string;
    procedure setWert(wert : double);
  public
    property Wert: double read FWert write setWert;
    property Name: string read FName write FName;
    constructor create(Name : string; Wert : double);
  end;

  TSortiment = class
  private
    FWarenListe : TList<TArtikel>;
    function getArtikelAnzahl():integer;
  public
    property WarenListe  : TList<TArtikel> read FWarenListe write FWarenListe;
    property ArtikeAnzahl : integer read getArtikelAnzahl;
    constructor create(Parameter: TSortimentParameter);
  end;

implementation

{ TSortiment }

constructor TSortiment.create(Parameter: TSortimentParameter);
var
  katalog : TStringList;
  zeilenNummer: integer;
  zeile : string;
  artikelName : string;
  artikelWert : double;
  trennzeichenPosition : integer;
begin
  self.WarenListe := TList<TArtikel>.create;
  katalog := TStringList.Create;
  try
    katalog.LoadFromFile(Parameter.Pfad);
    for zeilenNummer := 0 to katalog.Count - 1 do
    begin
      zeile := katalog[zeilenNummer];
      trennzeichenPosition := zeile.IndexOf(Parameter.Trennzeichen);
      artikelName := zeile.Substring(0, trennzeichenPosition - 1);
      artikelWert := zeile.Substring(trennzeichenPosition + 1).ToDouble;
      self.WarenListe.Add(TArtikel.create(artikelName, artikelWert));
    end;
  finally
    katalog.Free;
  end;

end;

function TSortiment.getArtikelAnzahl: integer;
begin
  result := self.WarenListe.Count;
end;

{ TArtikel }

constructor TArtikel.create(Name : string; Wert : double);
begin
  self.Name := Name;
  self.Wert := Wert;
end;

procedure TArtikel.setWert(Wert : double);
begin
  if Wert > 0 then
    self.FWert := wert
  else
    raise Exception.Create('Artikel Nr.:' +self.Name + ' hat einen fehlerhaften Preis');
end;

end.
