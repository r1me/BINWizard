object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'BIN Wizard'
  ClientHeight = 384
  ClientWidth = 694
  Color = clBtnFace
  Constraints.MinHeight = 256
  Constraints.MinWidth = 710
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lvFiles: TListView
    AlignWithMargins = True
    Left = 8
    Top = 57
    Width = 678
    Height = 300
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alClient
    Columns = <
      item
        Caption = '#'
        Width = 35
      end
      item
        AutoSize = True
        Caption = 'Path'
      end
      item
        Caption = 'Size'
        Width = 100
      end
      item
        Caption = 'Start'
        Width = 100
      end
      item
        Caption = 'End'
        Width = 100
      end>
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnData = lvFilesData
    ExplicitHeight = 398
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 694
    Height = 49
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 18
      Width = 60
      Height = 13
      Caption = 'Output Size:'
    end
    object btnAddFile: TButton
      Left = 276
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddFileClick
    end
    object btnMerge: TButton
      Left = 611
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Merge!'
      TabOrder = 1
      OnClick = btnMergeClick
    end
    object btnRemoveFile: TButton
      Left = 357
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Remove'
      TabOrder = 2
      OnClick = btnRemoveFileClick
    end
    object cbOutputSize: TComboBox
      Left = 90
      Top = 15
      Width = 167
      Height = 21
      Style = csDropDownList
      ItemIndex = 3
      TabOrder = 3
      Text = '64KB (27C512)'
      OnChange = cbOutputSizeChange
      Items.Strings = (
        '8KB (27C64)'
        '16KB (27C128)'
        '32KB (27C256)'
        '64KB (27C512)'
        '128KB (27C010)'
        '256KB (27C020)'
        '512KB (27C040)')
    end
    object btnUp: TButton
      Left = 438
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Move Up'
      TabOrder = 4
      OnClick = btnUpClick
    end
    object btnDown: TButton
      Left = 519
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Move Down'
      TabOrder = 5
      OnClick = btnDownClick
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 365
    Width = 694
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitTop = 463
  end
  object odBinFile: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'BIN File'
        FileMask = '*.bin'
      end>
    Options = []
    Left = 216
    Top = 160
  end
  object sdBinFile: TFileSaveDialog
    DefaultExtension = '*.bin'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'BIN File'
        FileMask = '*.bin'
      end>
    Options = []
    Left = 296
    Top = 160
  end
end
