object Form1: TForm1
  Left = 660
  Top = 0
  Anchors = [akLeft, akTop, akRight, akBottom]
  AutoSize = True
  Caption = 'SImulationsprojekt - Tobias Zimmermann'
  ClientHeight = 790
  ClientWidth = 1289
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object KassenChart: TJvChart
    Left = 271
    Top = 28
    Width = 1018
    Height = 300
    Options.PenLegends.Strings = (
      'Kunden in Warteschlange')
    Options.ChartKind = ckChartBar
    Options.Title = 'Kassen'#252'bersicht'
    Options.NoDataMessage = 'Keine Daten'
    Options.YAxisHeader = 'Anzahl Kunden'
    Options.XAxisValuesPerDivision = 1
    Options.XAxisLabelAlignment = taLeftJustify
    Options.XAxisDateTimeMode = False
    Options.XAxisHeader = 'Kassen'
    Options.XOrigin = 0
    Options.YOrigin = 0
    Options.YStartOffset = 42
    Options.MarkerSize = 4
    Options.PrimaryYAxis.YMax = 10.000000000000000000
    Options.PrimaryYAxis.YLegendDecimalPlaces = 0
    Options.SecondaryYAxis.YMax = 10.000000000000000000
    Options.SecondaryYAxis.YLegendDecimalPlaces = 0
    Options.MouseDragObjects = False
    Options.Legend = clChartLegendBelow
    Options.LegendRowCount = 0
    Options.AxisLineWidth = 3
    Options.HeaderFont.Charset = DEFAULT_CHARSET
    Options.HeaderFont.Color = clWindowText
    Options.HeaderFont.Height = -11
    Options.HeaderFont.Name = 'Tahoma'
    Options.HeaderFont.Style = []
    Options.LegendFont.Charset = DEFAULT_CHARSET
    Options.LegendFont.Color = clWindowText
    Options.LegendFont.Height = -11
    Options.LegendFont.Name = 'Tahoma'
    Options.LegendFont.Style = []
    Options.AxisFont.Charset = DEFAULT_CHARSET
    Options.AxisFont.Color = clWindowText
    Options.AxisFont.Height = -11
    Options.AxisFont.Name = 'Tahoma'
    Options.AxisFont.Style = []
    Options.DivisionLineColor = clTeal
    Options.PaperColor = clWindow
    Options.AxisLineColor = clBlack
    Options.CursorColor = clBlack
    Options.CursorStyle = psSolid
  end
  object WartezeitChart: TJvChart
    Left = 271
    Top = 359
    Width = 498
    Height = 431
    AutoSize = True
    Options.PenLegends.Strings = (
      'Durchschnittliche Wartezeit gesamt'
      'Durchschnittliche Wartezeit Stundenweise')
    Options.Title = 'Wartezeit im Durchschnitt'
    Options.NoDataMessage = 'keine Daten'
    Options.YAxisHeader = 'Wartezeit in Sekunden'
    Options.XAxisValuesPerDivision = 0
    Options.XAxisLabelAlignment = taLeftJustify
    Options.XAxisDateTimeMode = False
    Options.XAxisHeader = 'Zeit in Minuten'
    Options.PenCount = 2
    Options.XOrigin = 0
    Options.YOrigin = 0
    Options.YStartOffset = 42
    Options.PrimaryYAxis.YMax = 10.000000000000000000
    Options.PrimaryYAxis.YLegendDecimalPlaces = 0
    Options.SecondaryYAxis.YMax = 10.000000000000000000
    Options.SecondaryYAxis.YLegendDecimalPlaces = 0
    Options.MouseDragObjects = False
    Options.Legend = clChartLegendBelow
    Options.LegendRowCount = 0
    Options.AxisLineWidth = 3
    Options.HeaderFont.Charset = DEFAULT_CHARSET
    Options.HeaderFont.Color = clWindowText
    Options.HeaderFont.Height = -11
    Options.HeaderFont.Name = 'Tahoma'
    Options.HeaderFont.Style = []
    Options.LegendFont.Charset = DEFAULT_CHARSET
    Options.LegendFont.Color = clWindowText
    Options.LegendFont.Height = -11
    Options.LegendFont.Name = 'Tahoma'
    Options.LegendFont.Style = []
    Options.AxisFont.Charset = DEFAULT_CHARSET
    Options.AxisFont.Color = clWindowText
    Options.AxisFont.Height = -11
    Options.AxisFont.Name = 'Tahoma'
    Options.AxisFont.Style = []
    Options.PaperColor = clWhite
    Options.AxisLineColor = clBlack
    Options.CursorColor = clBlack
    Options.CursorStyle = psSolid
  end
  object WarteZeitLabel: TLabel
    Left = 518
    Top = 334
    Width = 103
    Height = 19
    Caption = '00:00 Minuten'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object UhrzeitLabel: TLabel
    Left = 164
    Top = 566
    Width = 60
    Height = 29
    Caption = '08:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object KassierteKundenLabel: TLabel
    Left = 215
    Top = 442
    Width = 9
    Height = 19
    Alignment = taRightJustify
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object KassierteKundenTextLabel: TLabel
    Left = 29
    Top = 442
    Width = 126
    Height = 19
    Caption = 'Kassierte Kunden:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LaengsteWartezeitTextLabel: TLabel
    Left = 29
    Top = 467
    Width = 130
    Height = 19
    Caption = 'L'#228'ngste Wartezeit:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LaengsteWartezeitLabel: TLabel
    Left = 215
    Top = 469
    Width = 9
    Height = 19
    Alignment = taRightJustify
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object wartendeKundenText: TLabel
    Left = 316
    Top = 6
    Width = 187
    Height = 19
    Caption = 'Wartende Kunden gesamt:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object wartendeKundenLabel: TLabel
    Left = 509
    Top = 6
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object KundenImMarktLabel: TLabel
    Left = 990
    Top = 334
    Width = 9
    Height = 19
    Alignment = taRightJustify
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object KundenImMarktText: TLabel
    Left = 837
    Top = 334
    Width = 147
    Height = 19
    Caption = 'Kunden im Gesch'#228'ft:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object WarteZeitTextLabel: TLabel
    Left = 316
    Top = 334
    Width = 196
    Height = 19
    Caption = 'Durchschnittliche Wartezeit:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object UhrzeitText: TLabel
    Left = 29
    Top = 566
    Width = 83
    Height = 29
    Caption = 'Uhrzeit:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object KundenImMarktChart: TJvChart
    Left = 791
    Top = 355
    Width = 498
    Height = 435
    AutoSize = True
    Options.PenLegends.Strings = (
      'Kunden')
    Options.Title = 'Anzahl der Kunden im Markt'
    Options.NoDataMessage = 'keine Daten'
    Options.YAxisHeader = 'Anzahl Kunden'
    Options.XAxisValuesPerDivision = 0
    Options.XAxisLabelAlignment = taLeftJustify
    Options.XAxisDateTimeMode = False
    Options.XAxisHeader = 'Zeit in Minuten'
    Options.XOrigin = 0
    Options.YOrigin = 0
    Options.PrimaryYAxis.YMax = 10.000000000000000000
    Options.PrimaryYAxis.YLegendDecimalPlaces = 0
    Options.SecondaryYAxis.YMax = 10.000000000000000000
    Options.SecondaryYAxis.YLegendDecimalPlaces = 0
    Options.MouseDragObjects = False
    Options.Legend = clChartLegendBelow
    Options.LegendRowCount = 0
    Options.AxisLineWidth = 3
    Options.HeaderFont.Charset = DEFAULT_CHARSET
    Options.HeaderFont.Color = clWindowText
    Options.HeaderFont.Height = -11
    Options.HeaderFont.Name = 'Tahoma'
    Options.HeaderFont.Style = []
    Options.LegendFont.Charset = DEFAULT_CHARSET
    Options.LegendFont.Color = clWindowText
    Options.LegendFont.Height = -11
    Options.LegendFont.Name = 'Tahoma'
    Options.LegendFont.Style = []
    Options.AxisFont.Charset = DEFAULT_CHARSET
    Options.AxisFont.Color = clWindowText
    Options.AxisFont.Height = -11
    Options.AxisFont.Name = 'Tahoma'
    Options.AxisFont.Style = []
    Options.PaperColor = clWhite
    Options.AxisLineColor = clBlack
    Options.CursorColor = clBlack
    Options.CursorStyle = psSolid
  end
  object TageText: TLabel
    Left = 29
    Top = 531
    Width = 48
    Height = 29
    Caption = 'Tag:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object TageLabel: TLabel
    Left = 211
    Top = 531
    Width = 13
    Height = 29
    Alignment = taRightJustify
    Caption = '1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object JvPageControl1: TJvPageControl
    Left = 0
    Top = 0
    Width = 265
    Height = 353
    ActivePage = GrundeinstellungenTabSheet
    TabOrder = 0
    object GrundeinstellungenTabSheet: TTabSheet
      Caption = 'Grundeinstellungen'
      object maxGeldLabel: TLabel
        Left = 9
        Top = 207
        Width = 130
        Height = 13
        Caption = 'Maximaler Bargeldbestand:'
      end
      object minGeldLabel: TLabel
        Left = 9
        Top = 180
        Width = 126
        Height = 13
        Caption = 'Minimaler Bargeldbestand:'
      end
      object minAlterLabel: TLabel
        Left = 9
        Top = 126
        Width = 63
        Height = 13
        Caption = 'Mindestalter:'
      end
      object maxAlterLabel: TLabel
        Left = 9
        Top = 153
        Width = 59
        Height = 13
        Caption = 'H'#246'chstalter:'
      end
      object KundenfrequenzLabel: TLabel
        Left = 9
        Top = 99
        Width = 108
        Height = 13
        Caption = 'Kunden / Minute (ca.):'
      end
      object AnzahlKassenLabel: TLabel
        Left = 9
        Top = 19
        Width = 73
        Height = 13
        Caption = 'Anzahl Kassen:'
      end
      object GeschwindigkeitText: TLabel
        Left = 9
        Top = 249
        Width = 129
        Height = 13
        Caption = 'Simulierte Geschwindigkeit:'
      end
      object AktuelleGeschwindigkeitLabel: TLabel
        Left = 145
        Top = 249
        Width = 12
        Height = 13
        Caption = '30'
      end
      object GeschwindigkeitEinheitText: TLabel
        Left = 160
        Top = 249
        Width = 89
        Height = 13
        Caption = 'Minuten / Sekunde'
      end
      object KundenkapazitaetLabel: TLabel
        Left = 9
        Top = 72
        Width = 84
        Height = 13
        Caption = 'Kundenkapazit'#228't:'
      end
      object AnzahlKassenEdit: TEdit
        Left = 145
        Top = 16
        Width = 41
        Height = 21
        Hint = 'Anzahl der Supermarktkassen die gleichzeitig kassieren k'#246'nnen.'
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 0
        Text = '8'
      end
      object minGeldEdit: TEdit
        Left = 145
        Top = 177
        Width = 41
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 5
        Text = '5'
      end
      object maxAlterEdit: TEdit
        Left = 145
        Top = 150
        Width = 41
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 4
        Text = '72'
      end
      object minAlterEdit: TEdit
        Left = 145
        Top = 123
        Width = 41
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 3
        Text = '14'
      end
      object KundenfrequenzEdit: TEdit
        Left = 145
        Top = 96
        Width = 41
        Height = 21
        Hint = 
          'Anzahl der Kunden die pro simulierter Minute maximal generiert w' +
          'erden'
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 2
        Text = '3'
      end
      object maxGeldEdit: TEdit
        Left = 145
        Top = 204
        Width = 41
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 6
        Text = '100'
      end
      object geschwindigkeitBar: TTrackBar
        Left = 9
        Top = 269
        Width = 240
        Height = 45
        BorderWidth = 2
        LineSize = 2
        Max = 120
        Min = 1
        Frequency = 5
        Position = 30
        TabOrder = 7
        OnChange = geschwindigkeitBarChange
      end
      object KundenkapazitaetEdit: TEdit
        Left = 145
        Top = 69
        Width = 41
        Height = 21
        Hint = 
          'Maximale Anzahl an Kunden die den Supermarkt gleichzeitig nutzen' +
          ' k'#246'nnen. '
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 1
        Text = '200'
      end
    end
    object ZufallsparameterTabSheet: TTabSheet
      Caption = 'Zufallsparameter'
      ImageIndex = 1
      object AlterKleingeldQuoteText: TLabel
        Left = 11
        Top = 16
        Width = 156
        Height = 13
        Caption = 'Mindestalter f'#252'r Kleingeldmodus:'
      end
      object maxScanGeschwindigkeitText: TLabel
        Left = 11
        Top = 97
        Width = 166
        Height = 13
        Caption = 'maximal gescannte Ware / Minute:'
      end
      object KleingeldZahlerAltText: TLabel
        Left = 11
        Top = 43
        Width = 124
        Height = 13
        Caption = 'Kleingeldzahler (Alt) in %:'
      end
      object KleingeldZahlerRestText: TLabel
        Left = 11
        Top = 70
        Width = 133
        Height = 13
        Caption = 'Kleingeldzahler (Rest) in %:'
      end
      object FlashmobQuoteLabel: TLabel
        Left = 11
        Top = 124
        Width = 114
        Height = 13
        Caption = 'Flashmob - Quote in '#8240
      end
      object AlterKleingeldQuoteEdit: TEdit
        Left = 184
        Top = 13
        Width = 49
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 0
        Text = '70'
      end
      object KleingeldZahlerAltEdit: TEdit
        Left = 184
        Top = 40
        Width = 49
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 1
        Text = '40'
      end
      object KleingeldZahlerRestEdit: TEdit
        Left = 183
        Top = 67
        Width = 49
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 2
        Text = '5'
      end
      object maxScanGeschwindigkeitEdit: TEdit
        Left = 183
        Top = 94
        Width = 49
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 3
        Text = '40'
      end
      object FlashmobQuoteEdit: TEdit
        Left = 184
        Top = 121
        Width = 49
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 4
        Text = '3'
      end
    end
  end
  object PauseButton: TButton
    Left = 160
    Top = 372
    Width = 75
    Height = 25
    Caption = 'Pause'
    TabOrder = 1
    OnClick = PauseButtonClick
  end
  object BeendenButton: TButton
    Left = 46
    Top = 372
    Width = 75
    Height = 25
    Caption = 'Beenden'
    TabOrder = 2
    Visible = False
    OnClick = BeendenButtonClick
  end
  object StartButton: TButton
    Left = 46
    Top = 372
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 3
    OnClick = StartButtonClick
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 1208
    Top = 163
  end
end
