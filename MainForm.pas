unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Supermarkt, HilfsFunktionen,
  Vcl.ComCtrls, JvExComCtrls, JvComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, JvExControls, JvChart, System.UITypes, JvListView;

type
  TForm1 = class(TForm)
    JvPageControl1: TJvPageControl;
    GrundeinstellungenTabSheet: TTabSheet;
    ZufallsparameterTabSheet: TTabSheet;
    StartButton: TButton;
    PauseButton: TButton;
    geschwindigkeitBar: TTrackBar;
    Timer1: TTimer;
    KassenChart: TJvChart;
    WartezeitChart: TJvChart;
    WarteZeitLabel: TLabel;
    UhrzeitLabel: TLabel;
    KassierteKundenLabel: TLabel;
    KassierteKundenTextLabel: TLabel;
    LaengsteWartezeitTextLabel: TLabel;
    LaengsteWartezeitLabel: TLabel;
    AnzahlKassenEdit: TEdit;
    minGeldEdit: TEdit;
    maxAlterEdit: TEdit;
    minAlterEdit: TEdit;
    KundenfrequenzEdit: TEdit;
    maxGeldEdit: TEdit;
    maxGeldLabel: TLabel;
    minGeldLabel: TLabel;
    minAlterLabel: TLabel;
    maxAlterLabel: TLabel;
    KundenfrequenzLabel: TLabel;
    AnzahlKassenLabel: TLabel;
    wartendeKundenText: TLabel;
    wartendeKundenLabel: TLabel;
    KundenImMarktLabel: TLabel;
    KundenImMarktText: TLabel;
    WarteZeitTextLabel: TLabel;
    GeschwindigkeitText: TLabel;
    AktuelleGeschwindigkeitLabel: TLabel;
    GeschwindigkeitEinheitText: TLabel;
    AlterKleingeldQuoteText: TLabel;
    maxScanGeschwindigkeitText: TLabel;
    KleingeldZahlerAltText: TLabel;
    KleingeldZahlerRestText: TLabel;
    AlterKleingeldQuoteEdit: TEdit;
    KleingeldZahlerAltEdit: TEdit;
    KleingeldZahlerRestEdit: TEdit;
    maxScanGeschwindigkeitEdit: TEdit;
    BeendenButton: TButton;
    KundenkapazitaetLabel: TLabel;
    KundenkapazitaetEdit: TEdit;
    UhrzeitText: TLabel;
    FlashmobQuoteLabel: TLabel;
    FlashmobQuoteEdit: TEdit;
    KundenImMarktChart: TJvChart;
    TageText: TLabel;
    TageLabel: TLabel;
    procedure StartButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PauseButtonClick(Sender: TObject);
    procedure geschwindigkeitBarChange(Sender: TObject);
    procedure BeendenButtonClick(Sender: TObject);
    procedure AnzahlKassenEditExit(Sender: TObject);
  private
    KundenParameter   : TKundenparameter;
    KassenParameter   : TKassenParameter;
    KleingeldParameter: TKleingeldParameter;
    SortimentParameter: TSortimentParameter;
    Multiplikator     : integer;
    Supermarkt        : TSupermarkt;
    Laufzeit          : integer;
    MaxWartezeit      : integer;
    procedure ParameterEinlesen();
    procedure KundenparameterEinlesen();
    procedure KassenParameterEinlesen();
    procedure KleingeldParameterEinlesen();
    procedure ChartsAnpassen();
    procedure KassenChartAktualisieren();
    procedure WartezeitChartAktualisieren();
    procedure KundenImMarktChartAktualisieren();
    procedure EingabeFelderUmschalten();
    procedure LabelsAktualisieren();
    procedure LabelsZuruecksetzen();
    procedure ChartsZuruecksetzen();
    function NutzerEingabenPruefen(): boolean;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.StartButtonClick(Sender: TObject);
begin
  if self.NutzerEingabenPruefen then
  begin
    self.LabelsZuruecksetzen;
    self.ChartsZuruecksetzen;
    self.Laufzeit     := 0;
    self.MaxWartezeit := 0;
    self.ParameterEinlesen;
    self.SortimentParameter.Pfad         := ExtractFilePath(ParamStr(0)) + 'Sortiment.txt';
    self.SortimentParameter.Trennzeichen := '|';
    self.Supermarkt := TSupermarkt.Create(KassenParameter, KundenParameter, SortimentParameter,
      KleingeldParameter);
    self.ChartsAnpassen;
    self.EingabeFelderUmschalten;
    self.Timer1.Interval := Trunc(1000 / geschwindigkeitBar.Position);
    self.Timer1.Enabled  := true;
  end;
end;

procedure TForm1.WartezeitChartAktualisieren;
begin
  if self.Supermarkt.Kundenverwalter.MaxWartezeitDurchschnitt > self.Supermarkt.Kundenverwalter.MaxWartezeitStundenDurchschnitt
  then
    self.WartezeitChart.Options.PrimaryYAxis.YMax :=
      self.Supermarkt.Kundenverwalter.MaxWartezeitDurchschnitt + 1
  else
    self.WartezeitChart.Options.PrimaryYAxis.YMax :=
      self.Supermarkt.Kundenverwalter.MaxWartezeitStundenDurchschnitt + 1;
  self.WartezeitChart.Data.Value[0, Laufzeit] :=
    self.Supermarkt.Kundenverwalter.Wartezeitdurchschnitt;
  if self.Supermarkt.Kundenverwalter.WarteZeitenNachStunden.Count > 0 then
    self.WartezeitChart.Data.Value[1, Laufzeit] :=
      self.Supermarkt.Kundenverwalter.WarteZeitenNachStunden.Last;
  self.WartezeitChart.PlotGraph;
end;

procedure TForm1.AnzahlKassenEditExit(Sender: TObject);
begin
  if strtoint(self.AnzahlKassenEdit.Text) = 0 then
  begin
    MessageDlg('Wert muss mindestens 1 sein', mtWarning, mbOKCancel, 0);
    self.AnzahlKassenEdit.Text := '1';
  end;
end;

procedure TForm1.BeendenButtonClick(Sender: TObject);
begin
  self.Timer1.Enabled := false;
  self.Supermarkt.Free;
  self.EingabeFelderUmschalten;
end;

procedure TForm1.EingabeFelderUmschalten;
begin
  self.AnzahlKassenEdit.Enabled           := not self.AnzahlKassenEdit.Enabled;
  self.KundenfrequenzEdit.Enabled         := not self.KundenfrequenzEdit.Enabled;
  self.minAlterEdit.Enabled               := not self.minAlterEdit.Enabled;
  self.maxAlterEdit.Enabled               := not self.maxAlterEdit.Enabled;
  self.minGeldEdit.Enabled                := not self.minGeldEdit.Enabled;
  self.maxGeldEdit.Enabled                := not self.maxGeldEdit.Enabled;
  self.AlterKleingeldQuoteEdit.Enabled    := not self.AlterKleingeldQuoteEdit.Enabled;
  self.KleingeldZahlerAltEdit.Enabled     := not self.KleingeldZahlerAltEdit.Enabled;
  self.KleingeldZahlerRestEdit.Enabled    := not self.KleingeldZahlerRestEdit.Enabled;
  self.KundenkapazitaetEdit.Enabled       := not self.KundenkapazitaetEdit.Enabled;
  self.maxScanGeschwindigkeitEdit.Enabled := not self.maxScanGeschwindigkeitEdit.Enabled;
  self.StartButton.Visible                := not self.StartButton.Visible;
  self.BeendenButton.Visible              := not self.BeendenButton.Visible;
  self.FlashmobQuoteEdit.Enabled          := self.FlashmobQuoteEdit.Enabled;
end;

procedure TForm1.geschwindigkeitBarChange(Sender: TObject);
begin
  self.Timer1.Interval                      := Trunc(1000 / self.geschwindigkeitBar.Position);
  self.AktuelleGeschwindigkeitLabel.Caption := self.geschwindigkeitBar.Position.ToString();
end;

procedure TForm1.KassenChartAktualisieren;
var
  I: integer;
begin
  self.KassenChart.Options.PrimaryYAxis.YMax := self.Supermarkt.Kassensystem.LaengsteSchlange;
  self.KassenChart.Options.PrimaryYAxis.YDivisions := self.Supermarkt.Kassensystem.LaengsteSchlange;
  for I := 0 to self.KassenParameter.AnzahlKassen - 1 do
    if self.Supermarkt.Kassensystem.KassenListe[I].IstGeoffnet then
      self.KassenChart.Data.Value[0, I] := self.Supermarkt.Kassensystem.KassenListe[I]
        .Warteschlange.KundenAnzahl;
  self.KassenChart.PlotGraph;
end;

procedure TForm1.ChartsAnpassen;
begin
  self.KassenChart.Data.ValueCount                  := self.KassenParameter.AnzahlKassen;
  self.KassenChart.Options.PenColor[0]              := clGreen;
  self.WartezeitChart.Options.PenColor[0]           := clBlack;
  self.WartezeitChart.Options.PenColor[1]           := clBlue;
  self.WartezeitChart.Data.ValueCount               := 13 * 60;
  self.KundenImMarktChart.Options.PenColor[0]       := clBlack;
  self.KundenImMarktChart.Options.PrimaryYAxis.YMax :=
    self.Supermarkt.Kundenverwalter.KundenKapazitaet;
  self.KundenImMarktChart.Data.ValueCount := 13 * 60;
end;

procedure TForm1.ChartsZuruecksetzen;
begin
  self.KassenChart.Data.Clear;
  self.KassenChart.PlotGraph;
  self.WartezeitChart.Data.Clear;
  self.WartezeitChart.PlotGraph;
  self.KundenImMarktChart.Data.Clear;
  self.KundenImMarktChart.PlotGraph;
end;

procedure TForm1.KassenParameterEinlesen;
begin
  self.KassenParameter.AnzahlKassen           := strtoint(self.AnzahlKassenEdit.Text);
  self.KassenParameter.maxScanGeschwindigkeit := strtoint(self.maxScanGeschwindigkeitEdit.Text);
end;

procedure TForm1.KleingeldParameterEinlesen;
begin
  self.KleingeldParameter.AlterKleingeldquote := strtoint(self.AlterKleingeldQuoteEdit.Text);
  self.KleingeldParameter.KleingeldZahlerAlt  := strtoint(self.KleingeldZahlerAltEdit.Text);
  self.KleingeldParameter.KleingeldZahlerRest := strtoint(self.KleingeldZahlerRestEdit.Text);
end;

procedure TForm1.KundenImMarktChartAktualisieren;
begin
  self.KundenImMarktChart.Data.Value[0, Laufzeit] := self.Supermarkt.Kundenverwalter.KundenAnzahl;
  self.KundenImMarktChart.PlotGraph;
end;

procedure TForm1.KundenparameterEinlesen;
begin
  self.KundenParameter.Kundenfrequenz   := strtoint(self.KundenfrequenzEdit.Text);
  self.KundenParameter.MinAlter         := strtoint(self.minAlterEdit.Text);
  self.KundenParameter.MaxAlter         := strtoint(self.maxAlterEdit.Text);
  self.KundenParameter.MinBargeld       := strtoint(self.minGeldEdit.Text);
  self.KundenParameter.MaxBargeld       := strtoint(self.maxGeldEdit.Text);
  self.KundenParameter.KundenKapazitaet := strtoint(self.KundenkapazitaetEdit.Text);
  self.KundenParameter.FlashmobQuote    := strtoint(self.FlashmobQuoteEdit.Text);
end;

procedure TForm1.LabelsAktualisieren;
begin
  self.wartendeKundenLabel.Caption := self.Supermarkt.Kassensystem.WartendeKundenGesamt.ToString();
  self.KundenImMarktLabel.Caption  := self.Supermarkt.Kundenverwalter.KundenAnzahl.ToString();
  self.KassierteKundenLabel.Caption := self.Supermarkt.Kundenverwalter.EntfernteKunden.ToString();
  self.WarteZeitLabel.Caption := self.Supermarkt.Kundenverwalter.WartezeitdurchschnittString;
  self.UhrzeitLabel.Caption   := self.Supermarkt.UhrzeitString;
  self.LaengsteWartezeitLabel.Caption := self.Supermarkt.Kundenverwalter.LaengsteWartezeit.
    ToString();
  self.TageLabel.Caption := self.Supermarkt.Tag.ToString();
end;

procedure TForm1.LabelsZuruecksetzen;
begin
  self.wartendeKundenLabel.Caption    := '0';
  self.KundenImMarktLabel.Caption     := '0';
  self.KassierteKundenLabel.Caption   := '0';
  self.WarteZeitLabel.Caption         := '0';
  self.UhrzeitLabel.Caption           := '08:00';
  self.LaengsteWartezeitLabel.Caption := '0';
end;

function TForm1.NutzerEingabenPruefen: boolean;
begin
  if not(self.AnzahlKassenEdit.Text = '') and not(self.minGeldEdit.Text = '') and
    not(self.maxGeldEdit.Text = '') and not(self.minAlterEdit.Text = '') and
    not(self.maxAlterEdit.Text = '') and not(self.KundenfrequenzEdit.Text = '') then
    result := true
  else
  begin
    result := false;
    MessageDlg('Bitte Eingabeparameter prüfen!', mtInformation, [mbOk], 0);
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Supermarkt.TimerEvent;
  self.KassenChartAktualisieren;
  self.WartezeitChartAktualisieren;
  self.KundenImMarktChartAktualisieren;
  self.LabelsAktualisieren;
  if self.Laufzeit = 13 * 80 then
  begin
    self.Laufzeit := 0;
    self.ChartsZuruecksetzen;
  end
  else
    Inc(self.Laufzeit);
end;

procedure TForm1.ParameterEinlesen;
begin
  self.Multiplikator := self.geschwindigkeitBar.Position;
  self.KassenParameterEinlesen;
  self.KundenparameterEinlesen;
  self.KleingeldParameterEinlesen;
end;

procedure TForm1.PauseButtonClick(Sender: TObject);
begin
  self.Timer1.Enabled := not self.Timer1.Enabled;
  if self.PauseButton.Caption = 'Pause' then
    self.PauseButton.Caption := 'weiter'
  else
    self.PauseButton.Caption := 'Pause';
end;

end.
