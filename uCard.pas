unit uCard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.Controls.Presentation, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ImgList, REST.Types, REST.Client,
  REST.Response.Adapter, Data.Bind.ObjectScope, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, FMX.Platform, FMX.Menus;

type
  TCardFrame = class(TFrame)
    Layout1: TLayout;
    FeedImage: TImage;
    Layout2: TLayout;
    MenuButton: TButton;
    ProfileCircle: TCircle;
    NameLabel: TLabel;
    Layout3: TLayout;
    DownloadButton: TButton;
    LoveButton: TButton;
    CommentButton: TButton;
    GoButton: TButton;
    DescLabel: TLabel;
    FollowButton: TButton;
    TimeLabel: TLabel;
    DataMT: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldFillBitmapBitmap: TLinkPropertyToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkPropertyToFieldText4: TLinkPropertyToField;
    LinkPropertyToFieldText5: TLinkPropertyToField;
    LinkPropertyToFieldBitmap: TLinkPropertyToField;
    Glyph1: TGlyph;
    Glyph2: TGlyph;
    Glyph3: TGlyph;
    Timer1: TTimer;
    RESTRequest2: TRESTRequest;
    FDMemTable2: TFDMemTable;
    RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter;
    RESTResponse2: TRESTResponse;
    RESTClient2: TRESTClient;
    NetHTTPClient1: TNetHTTPClient;
    ProgressBar: TProgressBar;
    Layout4: TLayout;
    Line1: TLine;
    Timer2: TTimer;
    EditPromptButton: TButton;
    CopyPromptButton: TButton;
    CopyImageButton: TButton;
    UpscaleButton: TButton;
    UpscaleMenu: TPopupMenu;
    CodeFormerMI: TMenuItem;
    RealESRGANMI: TMenuItem;
    Swin2SRMI: TMenuItem;
    GFPGANMI: TMenuItem;
    SwinirMI: TMenuItem;
    RundallesrMI: TMenuItem;
    EsrganMI: TMenuItem;
    CopyBitmapButton: TButton;
    UtilsMenu: TPopupMenu;
    DeleteMI: TMenuItem;
    SendImg2ImgButton: TButton;
    procedure FollowButtonClick(Sender: TObject);
    procedure LoveButtonClick(Sender: TObject);
    procedure CommentButtonClick(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure DownloadButtonClick(Sender: TObject);
    procedure CommentsLabelClick(Sender: TObject);
    procedure ProfileCircleClick(Sender: TObject);
    procedure FeedImageDblClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure EditPromptButtonClick(Sender: TObject);
    procedure CopyPromptButtonClick(Sender: TObject);
    procedure CopyImageButtonClick(Sender: TObject);
    procedure CodeFormerMIClick(Sender: TObject);
    procedure RealESRGANMIClick(Sender: TObject);
    procedure Swin2SRMIClick(Sender: TObject);
    procedure GFPGANMIClick(Sender: TObject);
    procedure UpscaleButtonClick(Sender: TObject);
    procedure SwinirMIClick(Sender: TObject);
    procedure RundallesrMIClick(Sender: TObject);
    procedure EsrganMIClick(Sender: TObject);
    procedure CopyBitmapButtonClick(Sender: TObject);
    procedure DeleteMIClick(Sender: TObject);
    procedure SendImg2ImgButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FMainFeedMT: TFDMemTable;
    procedure UpscaleImage(AName: string; AVersion: string);
  end;

implementation

{$R *.fmx}

uses
  Unit1, System.Threading, System.DateUtils, IdHashMessageDigest, System.IOUtils;

function SaveControl(AControl: TControl): String;
var
  LMS: TMemoryStream;
  LSS: TStringStream;
  LName: string;
begin
  LName := AControl.Name;
  AControl.Name := '';
  try
    LMS := TMemoryStream.Create;
    try
      LMS.WriteComponent(AControl);
      LMS.Position := 0;
      LSS := TStringStream.Create;
      try
        ObjectBinaryToText(LMS, LSS);
        Result := LSS.DataString;
      finally
        LSS.Free;
      end;
    finally
      LMS.Free;
    end;
  finally
    AControl.Name := LName;
  end;
end;

function MD5(const AString: String): String;
var
  LHash: TIdHashMessageDigest5;
begin
  LHash := TIdHashMessageDigest5.Create;
  try
    Result := LHash.HashStringAsHex(AString);
  finally
    LHash.Free;
  end;
end;

procedure TCardFrame.DeleteMIClick(Sender: TObject);
begin
  MainForm.DeleteCard(Self);
end;

procedure TCardFrame.DownloadButtonClick(Sender: TObject);
begin
  // Download
  MainForm.SaveDialog.FileName := DescLabel.Text + '.png';
  if MainForm.SaveDialog.Execute then
  begin
    FeedImage.Bitmap.SaveToFile(MainForm.SaveDialog.FileName);
  end;
end;

procedure TCardFrame.EditPromptButtonClick(Sender: TObject);
begin
  MainForm.PromptMemo.Lines.Text := DescLabel.Text;
end;

procedure TCardFrame.EsrganMIClick(Sender: TObject);
begin
  UpscaleImage(TMenuItem(Sender).Text, 'c263265e04b16fda1046d1828997fc27b46610647a3348df1c72fbffbdbac912');
end;

procedure TCardFrame.UpscaleButtonClick(Sender: TObject);
begin
  CodeFormerMIClick(CodeFormerMI);
end;

procedure TCardFrame.UpscaleImage(AName: string; AVersion: string);
begin
  var MS := TMemoryStream.Create;
  try
  FeedImage.Bitmap.SaveToStream(MS);
  MainForm.PredictionFromImageStream(AVersion,NameLabel.Text + ' - ' + AName,DescLabel.Text,MS);
  finally
    MS.Free;
  end;
end;

procedure TCardFrame.CodeFormerMIClick(Sender: TObject);
begin
  UpscaleImage(TMenuItem(Sender).Text, '7de2ea26c616d5bf2245ad0d5e24f0ff9a6204578a5c876db53142edd9d2cd56');
end;

procedure TCardFrame.CommentButtonClick(Sender: TObject);
begin
  // Comment
end;

procedure TCardFrame.CommentsLabelClick(Sender: TObject);
begin
  // View Comments
end;

procedure TCardFrame.CopyBitmapButtonClick(Sender: TObject);
var
  clp: IFMXClipboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService) then
  begin
    clp := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
    clp.SetClipboard(FeedImage.Bitmap);
  end;
end;

procedure TCardFrame.CopyImageButtonClick(Sender: TObject);
var
  clp: IFMXClipboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService) then
  begin
    clp := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
    clp.SetClipboard(SaveControl(FeedImage));
  end;
end;

procedure TCardFrame.CopyPromptButtonClick(Sender: TObject);
var
  clp: IFMXClipboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService) then
  begin
    clp := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
    clp.SetClipboard(DescLabel.Text);
  end;
end;

procedure TCardFrame.FeedImageDblClick(Sender: TObject);
begin
  // Double Tap Like
  LoveButtonClick(Sender);
end;

procedure TCardFrame.FollowButtonClick(Sender: TObject);
begin
  // Follow
end;

procedure TCardFrame.FrameResize(Sender: TObject);
begin
  FeedImage.Width := Self.Width;
end;

procedure TCardFrame.GFPGANMIClick(Sender: TObject);
begin
  UpscaleImage(TMenuItem(Sender).Text, '9283608cc6b7be6b65a8e44983db012355fde4132009bf99d976b2f0896856a3');
end;

procedure TCardFrame.GoButtonClick(Sender: TObject);
begin
  // Go
end;

procedure TCardFrame.LoveButtonClick(Sender: TObject);
begin
  // Like
end;

procedure TCardFrame.ProfileCircleClick(Sender: TObject);
begin
  // View Profile
end;

procedure TCardFrame.RealESRGANMIClick(Sender: TObject);
begin
  UpscaleImage(TMenuItem(Sender).Text, '42fed1c4974146d4d2414e2be2c5277c7fcf05fcc3a73abf41610695738c1d7b');
end;

procedure TCardFrame.RundallesrMIClick(Sender: TObject);
begin
  UpscaleImage(TMenuItem(Sender).Text, '32fdb2231d00a10d33754cc2ba794a2dfec94216579770785849ce6f149dbc69');
end;

procedure TCardFrame.SendImg2ImgButtonClick(Sender: TObject);
begin
  var LFilename := ExtractFilePath(ParamStr(0)) + 'img2img.png';
  FeedImage.Bitmap.SaveToFile(LFilename);
  MainForm.ImageEdit.Text := LFilename;
end;

procedure TCardFrame.Swin2SRMIClick(Sender: TObject);
begin
  UpscaleImage(TMenuItem(Sender).Text, 'a01b0512004918ca55d02e554914a9eca63909fa83a29ff0f115c78a7045574f');
end;

procedure TCardFrame.SwinirMIClick(Sender: TObject);
begin
  UpscaleImage(TMenuItem(Sender).Text, '660d922d33153019e8c263a3bba265de882e7f4f70396546b6c9c8f9d47a021a');
end;

procedure TCardFrame.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  RESTRequest2.Params[0].Value := 'Token ' + MainForm.APIKeyEdit.Text;
  RESTRequest2.Resource := Self.Hint;
  RESTRequest2.Execute;
  var LStatus := FDMemTable2.FieldByName('status').AsWideString;

  if LStatus='succeeded' then
  begin
    var LOutput := FDMemTable2.FieldByName('output').AsWideString.Replace('["','').Replace('"]','').Replace('\/','/');
    if LOutput<>'' then
    begin
      //DataMT.Edit;
      //DataMT.FieldByName('Description').AsString := LOutput.Replace('["','').Replace('"]','').Replace('\/','/');
      //DataMT.Post;

      TTask.Run(procedure var LMS: TMemoryStream; begin
        LMS := TMemoryStream.Create;
        var HTTPClient := TNetHTTPClient.Create(Self);
        try

          HTTPClient.Get(LOutput,LMS);
          TThread.Synchronize(nil,procedure begin
            var LFileName := TPath.Combine(ExtractFilePath(ParamStr(0)),MD5(DataMT.FieldByName('Name').AsString + IntToStr(DateTimeToUnix(Now))) + '.png');
            LMS.SaveToFile(LFileName);
            DataMT.Edit;
            TBlobField(DataMT.FieldByName('Image')).LoadFromStream(LMS);
            DataMT.Post;
            FMainFeedMT.Append;
            FMainFeedMT.CopyRecord(DataMT);
            FMainFeedMT.Post;
          end);
        finally
          LMS.Free;
          HTTPClient.Free;
          TThread.Synchronize(nil,procedure begin
            ProgressBar.Visible := False;
            //StatusLabel.Text := 'Status: ' + LStatus;
          end);
        end;
      end);
    end
    else
    begin
      DataMT.Edit;
      DataMT.FieldByName('Description').AsString := 'failed';
      DataMT.Post;
      ProgressBar.Visible := False;
    end;

    Timer1.Enabled := False;
  end
  else
  begin
    if ProgressBar.Value=ProgressBar.Max then
      ProgressBar.Value := ProgressBar.Min
    else
      ProgressBar.Value := ProgressBar.Value+5;
    Timer1.Enabled := True;
  end;
end;

procedure TCardFrame.Timer2Timer(Sender: TObject);
begin
  if ProgressBar.Visible = False then
  begin
    Timer2.Enabled := False;
  end
  else
  begin
    if ProgressBar.Value=ProgressBar.Max then
      ProgressBar.Value := ProgressBar.Min
    else
      ProgressBar.Value := ProgressBar.Value+5;
  end;
end;

end.
