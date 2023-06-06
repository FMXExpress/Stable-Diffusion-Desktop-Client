unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  FMX.ScrollBox, FMX.Memo, FMX.Effects, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.StorageBin, System.ImageList, FMX.ImgList, FMX.BufferedLayout,
  FMX.Edit, FMX.Memo.Types, FMX.MultiView, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FMX.DialogService.Async;

type
  TMainForm = class(TForm)
    StoryHSB: THorzScrollBox;
    Layout1: TLayout;
    ScrollLeftButton: TButton;
    ScrollRightButton: TButton;
    MaterialOxfordBlueSB: TStyleBook;
    ToolBar1: TToolBar;
    ShadowEffect4: TShadowEffect;
    Label1: TLabel;
    FeedVSB: TVertScrollBox;
    FeedMT: TFDMemTable;
    StoryMT: TFDMemTable;
    Label2: TLabel;
    GenerateButton: TButton;
    ImageList1: TImageList;
    Layout2: TLayout;
    PredictionMemo: TMemo;
    PromptMemo: TMemo;
    EmptyVSBLayout: TLayout;
    MultiView1: TMultiView;
    NegativePromptMemo: TMemo;
    Label3: TLabel;
    TemplateMT: TFDMemTable;
    VComboBox: TComboBox;
    VersionMT: TFDMemTable;
    VersionEdit: TEdit;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkControlToField1: TLinkControlToField;
    Label4: TLabel;
    Label5: TLabel;
    LinkPropertyToFieldText: TLinkPropertyToField;
    SaveDialog: TSaveDialog;
    APIKeyEdit: TEdit;
    APIKeyButton: TButton;
    SessionsCB: TComboBox;
    NewSessionButton: TButton;
    SessionsMT: TFDMemTable;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    EnhanceButton: TButton;
    EnhanceTimer: TTimer;
    EnhanceMemo: TMemo;
    Label6: TLabel;
    ImageEdit: TEdit;
    Layout3: TLayout;
    OpenButton: TButton;
    OpenDialog: TOpenDialog;
    StrengthTB: TTrackBar;
    StrengthLabel: TLabel;
    Img2ImgLayout: TLayout;
    procedure ScrollLeftButtonClick(Sender: TObject);
    procedure ScrollRightButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CameraButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure APIKeyButtonClick(Sender: TObject);
    procedure NewSessionButtonClick(Sender: TObject);
    procedure SessionsCBChange(Sender: TObject);
    procedure EnhanceButtonClick(Sender: TObject);
    procedure EnhanceTimerTimer(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure StrengthTBChange(Sender: TObject);
    procedure VComboBoxChange(Sender: TObject);
  private
    { Private declarations }
    RanOnce: Boolean;
  public
    { Public declarations }
    FId: String;
    FCircle: Integer;
    FCard: Integer;
    FSessionFile: String;
    procedure Restore;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    procedure NewSession(ASession: String);
    procedure PredictionFromImageStream(AVersion, AName, ADesc: String; AMemoryStream: TMemoryStream);
    procedure DeleteCard(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  System.Threading, System.Hash, System.IOUtils, uCircle, uCard, uDM;

procedure TMainForm.DeleteCard(Sender: TObject);
begin
  TTask.Run(procedure begin
    TLayout(TCardFrame(Sender).Parent).Parent := nil;
    FreeAndNil(TLayout(TCardFrame(Sender).Parent));
  end);
end;

procedure TMainForm.Restore;
var
  LCard: TCardFrame;
  LCircle: TCircleFrame;
  LStream: TStream;
  LScene: TLayout;
begin

  FeedMT.First;
  while not FeedMT.Eof do
    begin

      // With TScene Buffering
      LScene := TLayout.Create(Self);
      LCard := TCardFrame.Create(Self);
      LCard.Timer1.Enabled := False;
      LCard.ProgressBar.Visible := False;
      LCard.Name := 'Card'+FCard.ToString;
      LCard.Align := TAlignLayout.Client;
      LCard.DataMT.DisableControls;
      LCard.DataMT.Append;
      LCard.DataMT.CopyRecord(FeedMT);
      LCard.DataMT.Post;
      LCard.DataMT.EnableControls;
      LCard.Position.Y := 999999999;
      LCard.NameLabel.AutoSize := True;
      LScene.Height := LCard.Height;
      LCard.Parent := LScene;
      LScene.Align := TAlignLayout.Top;
      LScene.Parent := FeedVSB;

      Inc(FCard);

      FeedMT.Next;
    end;
end;

procedure TMainForm.PredictionFromImageStream(AVersion, AName, ADesc: String; AMemoryStream: TMemoryStream);
begin

  var LMS := TMemoryStream.Create;
  LMS.LoadFromStream(AMemoryStream);

  TTask.Run(procedure begin

    var LUpscaleJson := '{"version": "%version%", "input": {"image":"%base64%"}}';

    if AVersion='9283608cc6b7be6b65a8e44983db012355fde4132009bf99d976b2f0896856a3' then
    begin
      LUpscaleJson := LUpscaleJson.Replace('"image"','"img"');
    end;

    DM.RestRequest1.Params[0].Value := 'Token ' + APIKeyEdit.Text;
    DM.RestRequest1.Params[1].Value := LUpscaleJson.Replace('%version%',AVersion).Replace('%base64%',DM.MemoryStreamToBase64(LMS)).Replace(#13#10,'');

    DM.RestRequest1.Execute;

    TThread.Synchronize(nil,procedure begin
      if DM.FDMemTable1.FindField('id')<>nil then
      begin
        var LId := DM.FDMemTable1.FieldByName('id').AsWideString;

        var LScene := TLayout.Create(Self);
        var LCard := TCardFrame.Create(Self);
        LCard.Name := 'Card'+FCard.ToString;
        LCard.Hint := LId;
        LCard.FMainFeedMT := FeedMT;
        LCard.Align := TAlignLayout.Client;
        LCard.DataMT.DisableControls;
        LCard.DataMT.Append;
        LCard.DataMT.CopyRecord(TemplateMT);
        LCard.DataMT.FieldByName('Name').AsString := AName;
        LCard.DataMT.FieldByName('Description').AsString := ADesc;
       // LCard.DataMT.FieldByName('Description').AsString := LOutput;
        LCard.DataMT.Post;
        LCard.DataMT.EnableControls;
        LCard.Position.Y := 999999999;
        LCard.NameLabel.AutoSize := True;
        LScene.Height := LCard.Height;
        LCard.Parent := LScene;
        LScene.Align := TAlignLayout.Top;
        LScene.Parent := FeedVSB;

        Inc(FCard);
      end;
    end);

    LMS.Free;
  end);
end;

procedure TMainForm.APIKeyButtonClick(Sender: TObject);
begin
  APIKeyEdit.Visible := not APIKeyEdit.Visible;
end;

procedure TMainForm.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if not RanOnce then
    begin
      RanOnce := True;

      var LSessionFileName := THashMD5.GetHashString(SessionsMT.FieldByName('Name').AsString);
      FSessionFile := TPath.Combine(TPath.GetDocumentsPath,LSessionFileName+'.fds');
      if TFile.Exists(TPath.Combine(TPath.GetDocumentsPath,LSessionFileName+'.fds')) then
      begin
        FeedMT.LoadFromFile(FSessionFile);
      end;

      Restore;
    end;
end;

procedure TMainForm.CameraButtonClick(Sender: TObject);
begin
  if APIKeyEdit.Text='' then
  begin
    ShowMessage('Please enter an API key.');
    Exit;
  end;

  GenerateButton.Enabled := False;


  TTask.Run(procedure begin

  DM.RestRequest1.Params[0].Value := 'Token ' + APIKeyEdit.Text;

  if (VComboBox.Selected<>nil) then
  begin
    if VComboBox.Selected.Text.Contains('Img2Img') then
    begin
      var LMS := TMemoryStream.Create;
      if ImageEdit.Text.Substring(0,4)<>'http' then
        LMS.LoadFromFile(ImageEdit.Text);

      var LImg2ImgJson := '{"version": "%version%","input": {"prompt": "%prompt%","negative_prompt":"%nprompt%", "strength":%strength%, "image":"%base64%"}}';

      DM.RestRequest1.Params[1].Value := LImg2ImgJson.Replace('%prompt%',PromptMemo.Lines.Text)
      .Replace('%nprompt%',NegativePromptMemo.Lines.Text)
      .Replace('%version%',VersionEdit.Text)
      .Replace('%strength%',Format('%.2f',[StrengthTB.Value]));


      if ImageEdit.Text.Substring(0,4)<>'http' then
        DM.RestRequest1.Params[1].Value := DM.RestRequest1.Params[1].Value.Replace('%base64%',DM.MemoryStreamToBase64(LMS)).Replace(#13#10,'')
      else
        DM.RestRequest1.Params[1].Value := DM.RestRequest1.Params[1].Value.Replace('%base64%',ImageEdit.Text);

      LMS.Free;
    end
    else
    begin
      DM.RestRequest1.Params[1].Value := PredictionMemo.Lines.Text.Replace('%prompt%',PromptMemo.Lines.Text)
      .Replace('%nprompt%',NegativePromptMemo.Lines.Text)
      .Replace('%version%',VersionEdit.Text);
    end;
  end;

  DM.RestRequest1.Execute;
  if DM.FDMemTable1.FindField('id')<>nil then
  begin
    FId := DM.FDMemTable1.FieldByName('id').AsWideString;

    TThread.Synchronize(nil,procedure begin
      var LScene := TLayout.Create(Self);
      var LCard := TCardFrame.Create(Self);
      LCard.Name := 'Card'+FCard.ToString;
      LCard.Hint := FId;
      LCard.FMainFeedMT := FeedMT;
      LCard.Align := TAlignLayout.Client;
      LCard.DataMT.DisableControls;
      LCard.DataMT.Append;
      LCard.DataMT.CopyRecord(TemplateMT);
      LCard.DataMT.FieldByName('Name').AsString := VersionMT.FieldByName('Name').AsString;
      LCard.DataMT.FieldByName('Description').AsString := PromptMemo.Lines.Text;
     // LCard.DataMT.FieldByName('Description').AsString := LOutput;
      LCard.DataMT.Post;
      LCard.DataMT.EnableControls;
      LCard.Position.Y := 999999999;
      LCard.NameLabel.AutoSize := True;
      LScene.Height := LCard.Height;
      LCard.Parent := LScene;
      LScene.Align := TAlignLayout.Top;
      LScene.Parent := FeedVSB;

      Inc(FCard);

      GenerateButton.Enabled := True;
    end);

  end
  else
  begin
    TThread.Synchronize(nil,procedure begin
      ShowMessage('A valid response was not received.');
      GenerateButton.Enabled := True;
    end);
  end;

  end);

end;

procedure TMainForm.EnhanceButtonClick(Sender: TObject);
begin
  EnhanceButton.Enabled := False;
  DM.RestRequest3.Params[0].Value := 'Token ' + APIKeyEdit.Text;
  DM.RestRequest3.Params[1].Value := EnhanceMemo.Lines.Text.Replace('%prompt%',PromptMemo.Lines.Text);
  DM.RestRequest3.Execute;
  try
    DM.RestRequest4.Resource := DM.FDMemTable3.FieldByName('id').AsString;
    EnhanceTimer.Enabled := True;
  except
    ShowMessage('Enhance failed');
  end;
end;

procedure TMainForm.EnhanceTimerTimer(Sender: TObject);
begin
  EnhanceTimer.Enabled := False;
  DM.RestRequest4.Params[0].Value := 'Token ' + APIKeyEdit.Text;
  DM.RestRequest4.Execute;
  if DM.FDMemTable4.FieldByName('status').AsString='succeeded' then
  begin
    PromptMemo.Lines.Text := DM.FDMemTable4.FieldByName('output').AsString;
    EnhanceButton.Enabled := False;
  end
  else
  begin
    EnhanceTimer.Enabled := True;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FeedMT.SaveToFile(FSessionFile);
  CanClose := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if APIKeyEdit.Text<>'' then
   APIKeyEdit.Visible := False;

  if TFile.Exists(TPath.Combine(TPath.GetDocumentsPath,'sd_sessions.fds')) then
    SessionsMT.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'sd_sessions.fds'));


  Application.OnIdle := AppIdle;
end;

procedure TMainForm.NewSession(ASession: String);
begin
  FeedMT.SaveToFile(FSessionFile);
  FeedMT.EmptyDataSet;

  EmptyVSBLayout.Parent := MainForm;
  FeedVSB.Content.DeleteChildren;
  EmptyVSBLayout.Parent := FeedVSB;

  FSessionFile := TPath.Combine(TPath.GetDocumentsPath,THashMD5.GetHashString(ASession)+'.fds');
  FeedMT.SaveToFile(FSessionFile);
  SessionsMT.AppendRecord([ASession]);
  SessionsMT.SaveToFile(TPath.Combine(TPath.GetDocumentsPath,'sd_sessions.fds'));
end;

procedure TMainForm.NewSessionButtonClick(Sender: TObject);
begin
 TDialogServiceAsync.InputQuery('Enter a new session name', ['Text:'], [''],
    procedure(const AResult: TModalResult; const AValues: array of string)
     begin
       case AResult of
        mrOk: begin
                var AValue := AValues[0];
                TThread.Synchronize(nil,procedure begin
                  NewSession(AValue);
                end);
              end;
       end;
     end);
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    ImageEdit.Text := OpenDialog.FileName;

  end;
end;

procedure TMainForm.ScrollLeftButtonClick(Sender: TObject);
begin
  StoryHSB.ScrollBy(Trunc(StoryHSB.Height*0.8), 0);
end;

procedure TMainForm.ScrollRightButtonClick(Sender: TObject);
begin
  StoryHSB.ScrollBy(-1*Trunc(StoryHSB.Height*0.8), 0);
end;

procedure TMainForm.SessionsCBChange(Sender: TObject);
begin
  if RanOnce = True then
  begin
    FeedMT.SaveToFile(FSessionFile);
    FeedMT.EmptyDataSet;

    EmptyVSBLayout.Parent := MainForm;
    FeedVSB.Content.DeleteChildren;
    EmptyVSBLayout.Parent := FeedVSB;

    var LLoadSessionFile := THashMD5.GetHashString(SessionsCB.Selected.Text);
    FSessionFile := TPath.Combine(TPath.GetDocumentsPath,LLoadSessionFile+'.fds');
    if TFile.Exists(TPath.Combine(TPath.GetDocumentsPath,LLoadSessionFile+'.fds')) then
    begin
      FeedMT.LoadFromFile(FSessionFile);
    end;

    Restore;
  end;
end;

procedure TMainForm.StrengthTBChange(Sender: TObject);
begin
  StrengthLabel.Text := 'Strength: ' + FloatToStr(StrengthTB.Value);
end;

procedure TMainForm.VComboBoxChange(Sender: TObject);
begin
  if (VComboBox.Selected<>nil) then
  begin
    if VComboBox.Selected.Text.Contains('Img2Img') then
    begin
      Img2ImgLayout.Visible := True;
    end
    else
    begin
      Img2ImgLayout.Visible := False;
    end;
  end;
end;

end.
