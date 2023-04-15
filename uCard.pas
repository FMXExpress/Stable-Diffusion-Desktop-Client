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
  System.Net.HttpClient, System.Net.HttpClientComponent, FMX.Platform;

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
  private
    { Private declarations }
  public
    { Public declarations }
    FMainFeedMT: TFDMemTable;
  end;

implementation

{$R *.fmx}

uses
  Unit1, System.Threading, System.DateUtils, IdHashMessageDigest, System.IOUtils;

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

procedure TCardFrame.CommentButtonClick(Sender: TObject);
begin
  // Comment
end;

procedure TCardFrame.CommentsLabelClick(Sender: TObject);
begin
  // View Comments
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
