object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'BIN Wizard'
  ClientHeight = 384
  ClientWidth = 726
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
    Top = 89
    Width = 710
    Height = 268
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
        Width = 120
      end
      item
        Caption = 'Start'
        Width = 100
      end
      item
        Caption = 'End'
        Width = 100
      end>
    HideSelection = False
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnData = lvFilesData
  end
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 726
    Height = 81
    Align = alTop
    Caption = 'panTop'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 694
    object labOutputSize: TLabel
      Left = 104
      Top = 18
      Width = 60
      Height = 13
      Caption = 'Output Size:'
    end
    object labMinInputSize: TLabel
      Left = 304
      Top = 18
      Width = 72
      Height = 13
      Caption = 'Min. input size:'
    end
    object labFillByte: TLabel
      Left = 455
      Top = 18
      Width = 41
      Height = 13
      Caption = 'Fill byte:'
    end
    object btnAddFile: TButton
      Left = 8
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Add File'
      TabOrder = 0
      OnClick = btnAddFileClick
    end
    object btnMerge: TButton
      Left = 348
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Merge!'
      TabOrder = 1
      OnClick = btnMergeClick
    end
    object btnRemoveFile: TButton
      Left = 89
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Remove File'
      TabOrder = 2
      OnClick = btnRemoveFileClick
    end
    object cbOutputSize: TComboBox
      Left = 170
      Top = 15
      Width = 121
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
      Left = 170
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Move Up'
      TabOrder = 4
      OnClick = btnUpClick
    end
    object btnDown: TButton
      Left = 251
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Move Down'
      TabOrder = 5
      OnClick = btnDownClick
    end
    object btnNew: TButton
      Left = 8
      Top = 13
      Width = 75
      Height = 25
      Caption = 'New'
      TabOrder = 6
      OnClick = btnNewClick
    end
    object cbMinInputSize: TComboBox
      Left = 382
      Top = 15
      Width = 59
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 7
      Text = '8KB'
      OnChange = cbMinInputSizeChange
      Items.Strings = (
        '4KB'
        '8KB')
    end
    object cbFillByte: TComboBox
      Left = 502
      Top = 15
      Width = 84
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 8
      Text = '255 ($FF)'
      OnChange = cbFillByteChange
      Items.Strings = (
        '0'
        '255 ($FF)')
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 365
    Width = 726
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitWidth = 694
  end
  object odBinFile: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Supported file formats'
        FileMask = '*.bin; *.rom'
      end
      item
        DisplayName = 'BIN File'
        FileMask = '*.bin'
      end
      item
        DisplayName = 'ROM File'
        FileMask = '*.rom'
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
      end
      item
        DisplayName = 'ROM File'
        FileMask = '*.rom'
      end>
    Options = []
    Left = 296
    Top = 160
  end
end
