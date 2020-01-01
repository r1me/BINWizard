unit BINWizard.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  System.Generics.Collections, System.Math, System.UITypes;

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
    function GetFreeSpace: Integer;
  public
    property Items: TObjectList<TBinFile> read FItems write FItems;
    property FreeSpace: Integer read GetFreeSpace;

    function AddFile(AFilePath: String): Boolean;
    procedure RemoveFile(AIndex: Integer);

    procedure Merge(AOutputFileName: String);
    procedure Clear;

    procedure UpdateBinAddresses;

    constructor Create;
    destructor Destroy; override;
  end;

type
  TMainForm = class(TForm)
    cbOutputSize: TComboBox;
    labOutputSize: TLabel;
    lvFiles: TListView;
    btnAddFile: TButton;
    btnRemoveFile: TButton;
    btnMerge: TButton;
    panTop: TPanel;
    odBinFile: TFileOpenDialog;
    StatusBar: TStatusBar;
    btnUp: TButton;
    btnDown: TButton;
    sdBinFile: TFileSaveDialog;
    btnNew: TButton;
    cbMinInputSize: TComboBox;
    labMinInputSize: TLabel;
    cbFillByte: TComboBox;
    labFillByte: TLabel;
    procedure btnAddFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvFilesData(Sender: TObject; Item: TListItem);
    procedure btnRemoveFileClick(Sender: TObject);
    procedure cbOutputSizeChange(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnMergeClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure cbMinInputSizeChange(Sender: TObject);
    procedure cbFillByteChange(Sender: TObject);
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

uses
  BINWizard.Settings;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FBinFiles := TBinFiles.Create;
  UpdateControls;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FBinFiles.Free;
end;

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
var
  currItemIndex: Integer;
begin
  currItemIndex := lvFiles.ItemIndex;
  if (currItemIndex < FBinFiles.Items.Count-1) and
     (currItemIndex <> -1) then
  begin
    FBinFiles.Items.Move(currItemIndex, currItemIndex+1);
    FBinFiles.UpdateBinAddresses;
    UpdateControls;
    lvFiles.ItemIndex := currItemIndex+1;
  end;
end;

procedure TMainForm.btnMergeClick(Sender: TObject);
begin
  if sdBinFile.Execute then
    FBinFiles.Merge(sdBinFile.FileName);
end;

procedure TMainForm.btnNewClick(Sender: TObject);
begin
  if lvFiles.Items.Count > 0 then
    if MessageDlg('Do you want to create a new file?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then Exit;

  FBinFiles.Clear;
  UpdateControls;
end;

procedure TMainForm.btnRemoveFileClick(Sender: TObject);
begin
  if lvFiles.ItemIndex <> -1 then
  begin
    FBinFiles.RemoveFile(lvFiles.ItemIndex);
    lvFiles.ItemIndex := -1;
  end;
  UpdateControls;
end;

procedure TMainForm.btnUpClick(Sender: TObject);
var
  currItemIndex: Integer;
begin
  currItemIndex := lvFiles.ItemIndex;
  if currItemIndex > 0 then
  begin
    FBinFiles.Items.Move(currItemIndex, currItemIndex-1);
    FBinFiles.UpdateBinAddresses;
    UpdateControls;
    lvFiles.ItemIndex := currItemIndex-1;
  end;
end;

procedure TMainForm.cbFillByteChange(Sender: TObject);
begin
  case cbFillByte.ItemIndex of
    0: g_Settings.FillByte := 0;
    1: g_Settings.FillByte := 255;
    else
      g_Settings.FillByte := 255;
  end;
end;

procedure TMainForm.cbMinInputSizeChange(Sender: TObject);
begin
  case cbMinInputSize.ItemIndex of
    0: g_Settings.MinInputBinSize := 4;
    1: g_Settings.MinInputBinSize := 8;
    else
      g_Settings.MinInputBinSize := 8;
  end;

  UpdateControls;
end;

procedure TMainForm.cbOutputSizeChange(Sender: TObject);
begin
  case cbOutputSize.ItemIndex of
    0: g_Settings.OutputBinSize := 8;
    1: g_Settings.OutputBinSize := 16;
    2: g_Settings.OutputBinSize := 32;
    3: g_Settings.OutputBinSize := 64;
    4: g_Settings.OutputBinSize := 128;
    5: g_Settings.OutputBinSize := 256;
    6: g_Settings.OutputBinSize := 512;
    else
      g_Settings.OutputBinSize := 64;
  end;

  UpdateControls;
end;

procedure TMainForm.lvFilesData(Sender: TObject; Item: TListItem);
var
  size: Integer;
  startAddr, endAddr: Integer;
begin
  Item.Caption := (Item.Index+1).ToString;
  Item.SubItems.Add(FBinFiles.Items[Item.Index].Path);

  size := FBinFiles.Items[Item.Index].Size;
  startAddr := FBinFiles.Items[Item.Index].StartAddr;
  endAddr := FBinFiles.Items[Item.Index].EndAddr;

  Item.SubItems.Add(size.ToString + 'b ($'+IntToHex(size, 5)+')');
  Item.SubItems.Add('$'+IntToHex(startAddr, 5));
  Item.SubItems.Add('$'+IntToHex(endAddr-1, 5));
end;

procedure TMainForm.UpdateControls;
begin
  case g_Settings.OutputBinSize of
    8  : cbOutputSize.ItemIndex := 0;
    16 : cbOutputSize.ItemIndex := 1;
    32 : cbOutputSize.ItemIndex := 2;
    64 : cbOutputSize.ItemIndex := 3;
    128: cbOutputSize.ItemIndex := 4;
    256: cbOutputSize.ItemIndex := 5;
    512: cbOutputSize.ItemIndex := 6;
    else
      cbOutputSize.ItemIndex := 3;
  end;

  case g_Settings.MinInputBinSize of
    4: cbMinInputSize.ItemIndex := 0;
    8: cbMinInputSize.ItemIndex := 1;
    else
      cbMinInputSize.ItemIndex := 1;
  end;

  case g_Settings.FillByte of
    0  : cbFillByte.ItemIndex := 0;
    255: cbFillByte.ItemIndex := 1;
    else
      cbFillByte.ItemIndex := 1;
  end;

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

procedure TBinFiles.Clear;
begin
  FItems.Clear;
end;

constructor TBinFiles.Create;
begin
  FItems := TObjectList<TBinFile>.Create;
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

  Result := (g_Settings.OutputBinSize * 1024) - occupiedSpace;
  if Result < 0 then
    Result := 0;
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
            ms.WriteData(g_Settings.FillByte, 1);
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
    while (requiredBlocks * g_Settings.MinInputBinSize * 1024) < binFile.Size do
      Inc(requiredBlocks);

    binFile.StartAddr := lastEndAddr;
    binFile.EndAddr := lastEndAddr + (requiredBlocks * g_Settings.MinInputBinSize * 1024);

    lastEndAddr := binFile.EndAddr;
  end;
end;

end.
