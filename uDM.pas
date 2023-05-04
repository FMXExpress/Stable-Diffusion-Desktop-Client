unit uDM;

interface

uses
  System.SysUtils, System.Classes, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TDM = class(TDataModule)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    RESTClient2: TRESTClient;
    RESTRequest2: TRESTRequest;
    RESTResponse2: TRESTResponse;
    RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter;
    FDMemTable2: TFDMemTable;
    RESTClient3: TRESTClient;
    RESTRequest3: TRESTRequest;
    RESTResponse3: TRESTResponse;
    RESTResponseDataSetAdapter3: TRESTResponseDataSetAdapter;
    FDMemTable3: TFDMemTable;
    RESTClient4: TRESTClient;
    RESTRequest4: TRESTRequest;
    RESTResponse4: TRESTResponse;
    RESTResponseDataSetAdapter4: TRESTResponseDataSetAdapter;
    FDMemTable4: TFDMemTable;
  private
    { Private declarations }
  public
    { Public declarations }
    function FileToBase64(const FileName: string): string;
    function MemoryStreamToBase64(const MemoryStream: TMemoryStream): string;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.NetEncoding, System.Net.Mime;


function TDM.MemoryStreamToBase64(const MemoryStream: TMemoryStream): string;
var
  OutputStringStream: TStringStream;
  Base64Encoder: TBase64Encoding;
  MimeType: string;
begin
  MemoryStream.Position := 0;
  OutputStringStream := TStringStream.Create('', TEncoding.ASCII);
  try
    Base64Encoder := TBase64Encoding.Create;
    try
      Base64Encoder.Encode(MemoryStream, OutputStringStream);
      MimeType := 'image/png';
      Result := 'data:' + MimeType + ';base64,' + OutputStringStream.DataString;
    finally
      Base64Encoder.Free;
    end;
  finally
    OutputStringStream.Free;
  end;
end;

function TDM.FileToBase64(const FileName: string): string;
var
  InputStream: TFileStream;
  OutputStringStream: TStringStream;
  Base64Encoder: TBase64Encoding;
  MimeType: string;
  LKind: TMimeTypes.TKind;
begin
  InputStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    OutputStringStream := TStringStream.Create('', TEncoding.ASCII);
    try
      Base64Encoder := TBase64Encoding.Create;
      try
        Base64Encoder.Encode(InputStream, OutputStringStream);
        TMimeTypes.Default.GetFileInfo(FileName,MimeType,LKind);
        Result := 'data:' + MimeType + ';base64,' + OutputStringStream.DataString;
      finally
        Base64Encoder.Free;
      end;
    finally
      OutputStringStream.Free;
    end;
  finally
    InputStream.Free;
  end;
end;

end.
