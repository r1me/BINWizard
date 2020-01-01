program BINWizard;

uses
  Vcl.Forms,
  BINWizard.MainForm in 'BINWizard.MainForm.pas' {MainForm},
  BINWizard.Settings in 'BINWizard.Settings.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
