unit BINWizard.Settings;

interface

uses
  System.Classes, System.SysUtils, System.IniFiles, Vcl.Forms;

type
  TSettings = class
  private
    FFileName: String;
    FOutputBinSize: Integer;
    FMinInputBinSize: Integer;
    FFillByte: Byte;
  public
    property OutputBinSize: Integer read FOutputBinSize write FOutputBinSize;
    property MinInputBinSize: Integer read FMinInputBinSize write FMinInputBinSize;
    property FillByte: Byte read FFillByte write FFillByte;

    procedure LoadFromFile;
    procedure SaveToFile;

    constructor Create(AFileName: String);
    destructor Destroy; override;
  end;

var
  g_Settings: TSettings;

implementation

{ TSettings }

constructor TSettings.Create(AFileName: String);
begin
  FFileName := AFileName;
  LoadFromFile;
end;

destructor TSettings.Destroy;
begin
  SaveToFile;

  inherited;
end;

procedure TSettings.LoadFromFile;
var
  settings_file: TMemIniFile;
begin
  settings_file := TMemIniFile.Create(FFileName, TEncoding.UTF8);
  try
    FOutputBinSize := settings_file.ReadInteger('Settings', 'OutputBinSize', 64);
    FMinInputBinSize := settings_file.ReadInteger('Settings', 'MinInputBinSize', 8);
    FFillByte := settings_file.ReadInteger('Settings', 'FillByte', 255);
  finally
    settings_file.Free;
  end;
end;

procedure TSettings.SaveToFile;
var
  settings_file: TMemIniFile;
begin
  settings_file := TMemIniFile.Create(FFileName, TEncoding.UTF8);
  try
    settings_file.WriteInteger('Settings', 'OutputBinSize', FOutputBinSize);
    settings_file.WriteInteger('Settings', 'MinInputBinSize', FMinInputBinSize);
    settings_file.WriteInteger('Settings', 'FillByte', FFillByte);

    settings_file.UpdateFile;
  finally
    settings_file.Free;
  end;
end;

initialization
  g_Settings := TSettings.Create(ChangeFileExt(Application.ExeName, '.ini'));

finalization
  g_Settings.Free;

end.
