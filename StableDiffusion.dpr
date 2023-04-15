program StableDiffusion;

uses
  System.StartUpCopy,
  FMX.Forms,
  Skia.FMX,
  Unit1 in 'Unit1.pas' {MainForm},
  uCircle in 'uCircle.pas' {CircleFrame: TFrame},
  uCard in 'uCard.pas' {CardFrame: TFrame},
  uDM in 'uDM.pas' {DM: TDataModule};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
