unit BINWizard.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  System.Generics.Collections, System.Math;

type
  TBinFile = class
    Path: String;
    Size: Integer;
    StartAddr: Integer;
    EndAddr: Integer;
  end;

type
  TBinFiles = class
  private
    FItems: TObjectList<TBinFile>;
    FMaxSize: Integer;
    function GetFreeSpace: Integer;
    function GetMaxSize: Integer;
    procedure SetMaxSize(const Value: Integer);
  public
    property Items: TObjectList<TBinFile> read FItems write FItems;
    property FreeSpace: Integer read GetFreeSpace;
    property MaxSize: Integer read GetMaxSize write SetMaxSize;

    function AddFile(AFilePath: String): Boolean;
    procedure RemoveFile(AIndex: Integer);

    procedure Merge(AOutputFileName: String);

    procedure UpdateBinAddresses;

    constructor Create;
    destructor Destroy; override;
  end;

type
  TMainForm = class(TForm)
    cbOutputSize: TComboBox;
    Label1: TLabel;
    lvFiles: TListView;
    btnAddFile: TButton;
    btnRemoveFile: TButton;
    btnMerge: TButton;
    Panel1: TPanel;
    odBinFile: TFileOpenDialog;
    StatusBar: TStatusBar;
    btnUp: TButton;
    btnDown: TButton;
    sdBinFile: TFileSaveDialog;
    procedure btnAddFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvFilesData(Sender: TObject; Item: TListItem);
    procedure btnRemoveFileClick(Sender: TObject);
    procedure cbOutputSizeChange(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnMergeClick(Sender: TObject);
  private
    { Private declarations }
    FBinFiles: TBinFiles;
    procedure UpdateControls;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.btnAddFileClick(Sender: TObject);
begin
  if odBinFile.Execute then
  begin
    if not FBinFiles.AddFile(odBinFile.FileName) then
      ShowMessage('Error while adding file. (Isn''t too big?)');
  end;

  UpdateControls;
end;

procedure TMainForm.btnDownClick(Sender: TObject);
begin
  if (lvFiles.ItemIndex < FBinFiles.Items.Count-1) and
     (lvFiles.ItemIndex <> -1) then
  begin
    FBinFiles.Items.Move(lvFiles.ItemIndex, lvFiles.ItemIndex+1);
    FBinFiles.UpdateBinAddresses;
    lvFiles.ItemIndex := -1;
  end;
  UpdateControls;
end;

procedure TMainForm.btnMergeClick(Sender: TObject);
begin
  if sdBinFile.Execute then
    FBinFiles.Merge(sdBinFile.FileName);
end;

procedure TMainForm.btnRemoveFileClick(Sender: TObject);
begin
  if lvFiles.ItemIndex <> -1 then
    FBinFiles.RemoveFile(lvFiles.ItemIndex);
  UpdateControls;
end;

procedure TMainForm.btnUpClick(Sender: TObject);
begin
  if lvFiles.ItemIndex > 0 then
  begin
    FBinFiles.Items.Move(lvFiles.ItemIndex, lvFiles.ItemIndex-1);
    FBinFiles.UpdateBinAddresses;
    lvFiles.ItemIndex := -1;
  end;
  UpdateControls;
end;

procedure TMainForm.cbOutputSizeChange(Sender: TObject);
begin
  FBinFiles.MaxSize := Round(Power(2, cbOutputSize.ItemIndex)) * 8 * 1024;
  UpdateControls;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FBinFiles := TBinFiles.Create;
  FBinFiles.MaxSize := Round(Power(2, cbOutputSize.ItemIndex)) * 8 * 1024;
  UpdateControls;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FBinFiles.Free;
end;

procedure TMainForm.lvFilesData(Sender: TObject; Item: TListItem);
var
  size: Integer;
  startAddr, endAddr: Integer;
  hexSize: Byte;
begin
  Item.Caption := (Item.Index+1).ToString;
  Item.SubItems.Add(FBinFiles.Items[Item.Index].Path);

  size := FBinFiles.Items[Item.Index].Size;
  startAddr := FBinFiles.Items[Item.Index].StartAddr;
  endAddr := FBinFiles.Items[Item.Index].EndAddr;

  hexSize := 4;
  if cbOutputSize.ItemIndex > 3 then
    hexSize := 8;

  Item.SubItems.Add(size.ToString + 'b ($'+IntToHex(size, hexSize)+')');
  Item.SubItems.Add('$'+IntToHex(startAddr, hexSize));
  Item.SubItems.Add('$'+IntToHex(endAddr-1, hexSize));
end;

procedure TMainForm.UpdateControls;
begin
  FBinFiles.UpdateBinAddresses;
  lvFiles.Items.Count := FBinFiles.Items.Count;
  lvFiles.Invalidate;

  StatusBar.SimpleText := 'Free space: ' + FBinFiles.GetFreeSpace.ToString + ' bytes';
end;

{ TBinFiles }

function TBinFiles.AddFile(AFilePath: String): Boolean;
var
  fs: TFileStream;
  binFile: TBinFile;
begin
  Result := False;

  fs := TFileStream.Create(AFilePath, fmOpenRead or fmShareDenyNone);
  try
    if (fs.Size = 0) then Exit;

    if (GetFreeSpace >= fs.Size) then
    begin
      binFile := TBinFile.Create;
      binFile.Path := AFilePath;
      binFile.Size := fs.Size;

      FItems.Add(binFile);

      UpdateBinAddresses;

      Result := True;
    end;
  finally
    fs.Free;
  end;
end;

procedure TBinFiles.RemoveFile(AIndex: Integer);
begin
  FItems.Remove(Fitems[AIndex]);
end;

constructor TBinFiles.Create;
begin
  FItems := TObjectList<TBinFile>.Create;
  FMaxSize := 8 * 1024;
end;

destructor TBinFiles.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TBinFiles.GetFreeSpace: Integer;
var
  occupiedSpace: Integer;
  binFile: TBinFile;
begin
  occupiedSpace := 0;

  for binFile in FItems do
    occupiedSpace := occupiedSpace + (binFile.EndAddr - binFile.StartAddr);

  Result := FMaxSize - occupiedSpace;
  if Result < 0 then
    Result := 0;
end;

function TBinFiles.GetMaxSize: Integer;
begin
  Result := FMaxSize;
end;

procedure TBinFiles.Merge(AOutputFileName: String);
var
  ms: TMemoryStream;
  msInput: TMemoryStream;
  binFile: TBinFile;
  occupiedSize: Integer;
  fillSize: Integer;
  i: Integer;
begin
  ms := TMemoryStream.Create;

  try
    for binFile in FItems do
    begin
      msInput := TMemoryStream.Create;
      try
        msInput.LoadFromFile(binFile.Path);
        msInput.Position := 0;
        occupiedSize := binFile.EndAddr - binFile.StartAddr;
        ms.CopyFrom(msInput, msInput.Size);
        fillSize := occupiedSize - binFile.Size;
        if fillSize > 0 then
        begin
          for i := 1 to fillSize do
            ms.WriteData($ff, 1);
        end;
      finally
         msInput.Free;
      end;
    end;

    ms.SaveToFile(AOutputFileName);
  finally
    ms.Free;
  end;
end;

procedure TBinFiles.SetMaxSize(const Value: Integer);
begin
  FMaxSize := Value;
  UpdateBinAddresses;
end;

procedure TBinFiles.UpdateBinAddresses;
var
  binFile: TBinFile;
  requiredBlocks: Integer;
  lastEndAddr: Integer;
  i: Integer;
begin
  lastEndAddr := 0;

  for i := 0 to FItems.Count-1 do
  begin
    binFile := Fitems[i];

    requiredBlocks := 1;
    while (requiredBlocks * 8 * 1024) < binFile.Size do
      Inc(requiredBlocks);

    binFile.StartAddr := lastEndAddr;
    binFile.EndAddr := lastEndAddr + (requiredBlocks * 8 * 1024);

    lastEndAddr := binFile.EndAddr;
  end;
end;

end.
