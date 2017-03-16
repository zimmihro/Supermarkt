program Simulation;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Form1},
  HilfsFunktionen in 'HilfsFunktionen.pas',
  Kassensystem in 'Kassensystem.pas',
  Kunden in 'Kunden.pas',
  Sortiment in 'Sortiment.pas',
  Supermarkt in 'Supermarkt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
