object DM: TDM
  Height = 480
  Width = 640
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://api.replicate.com/v1/predictions'
    ContentType = 'application/json'
    Params = <>
    SynchronizedEvents = False
    Left = 160
    Top = 64
  end
  object RESTRequest1: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'Authorization'
        Options = [poDoNotEncode]
        Value = 'Token %api_key%'
      end
      item
        Kind = pkREQUESTBODY
        Name = 'body743FA4081F4C440C91A2D44F7691E32F'
        Value = 
          '{"version": "%version%","input": {"prompt": "%prompt%","negative' +
          '_prompt":"%nprompt%"}}'
        ContentTypeStr = 'application/json'
      end>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 144
    Top = 136
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    Left = 256
    Top = 88
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Active = True
    Dataset = FDMemTable1
    FieldDefs = <>
    Response = RESTResponse1
    TypesMode = Rich
    Left = 264
    Top = 168
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'completed_at'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'created_at'
        DataType = ftDateTime
      end
      item
        Name = 'error'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'id'
        DataType = ftWideString
        Size = 26
      end
      item
        Name = 'input'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'logs'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'metrics'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'output'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'started_at'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'status'
        DataType = ftWideString
        Size = 8
      end
      item
        Name = 'urls'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'version'
        DataType = ftWideString
        Size = 64
      end
      item
        Name = 'webhook_completed'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 272
    Top = 248
  end
  object RESTClient2: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://api.replicate.com/v1/predictions'
    ContentType = 'application/x-www-form-urlencoded'
    Params = <>
    SynchronizedEvents = False
    Left = 448
    Top = 88
  end
  object RESTRequest2: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient2
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'Authorization'
        Options = [poDoNotEncode]
        Value = 'Token %api_key%'
      end>
    Resource = 'cqdlci7y4zbc3fnrhtctvsbucq'
    Response = RESTResponse2
    SynchronizedEvents = False
    Left = 432
    Top = 192
  end
  object RESTResponse2: TRESTResponse
    ContentType = 'application/json'
    Left = 528
    Top = 144
  end
  object RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter
    Active = True
    Dataset = FDMemTable2
    FieldDefs = <>
    Response = RESTResponse2
    TypesMode = Rich
    Left = 536
    Top = 208
  end
  object FDMemTable2: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'completed_at'
        DataType = ftDateTime
      end
      item
        Name = 'created_at'
        DataType = ftDateTime
      end
      item
        Name = 'error'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'id'
        DataType = ftWideString
        Size = 26
      end
      item
        Name = 'input'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'logs'
        DataType = ftWideString
        Size = 902
      end
      item
        Name = 'metrics'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'output'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'started_at'
        DataType = ftDateTime
      end
      item
        Name = 'status'
        DataType = ftWideString
        Size = 9
      end
      item
        Name = 'urls'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'version'
        DataType = ftWideString
        Size = 64
      end
      item
        Name = 'webhook_completed'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 488
    Top = 288
  end
  object RESTClient3: TRESTClient
    BaseURL = 'https://api.replicate.com/v1/predictions'
    Params = <>
    SynchronizedEvents = False
    Left = 80
    Top = 256
  end
  object RESTRequest3: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient3
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'Authorization'
        Options = [poDoNotEncode]
        Value = 'Token %api_key%'
      end
      item
        Kind = pkREQUESTBODY
        Name = 'body7E86320BF8944C89A4DFC53FC1BAD6FC'
        Value = 
          '{"version": "d53a494f0f1f4130d39cbe574c25d267910e1fce4e7f4b34fe1' +
          '5f22976aed332", "input": {"prompt": "%prompt%"}}'
        ContentTypeStr = 'application/json'
      end>
    Response = RESTResponse3
    SynchronizedEvents = False
    Left = 88
    Top = 320
  end
  object RESTResponse3: TRESTResponse
    Left = 104
    Top = 368
  end
  object RESTResponseDataSetAdapter3: TRESTResponseDataSetAdapter
    Dataset = FDMemTable3
    FieldDefs = <>
    Response = RESTResponse3
    TypesMode = Rich
    Left = 120
    Top = 392
  end
  object FDMemTable3: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 208
    Top = 384
  end
  object RESTClient4: TRESTClient
    BaseURL = 'https://api.replicate.com/v1/predictions'
    Params = <>
    SynchronizedEvents = False
    Left = 296
    Top = 328
  end
  object RESTRequest4: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient4
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'Authorization'
        Options = [poDoNotEncode]
        Value = 'Token %api_key%'
      end>
    Resource = '7lswsyevjzbi3otimjkwujj5e4'
    Response = RESTResponse4
    SynchronizedEvents = False
    Left = 288
    Top = 384
  end
  object RESTResponse4: TRESTResponse
    Left = 368
    Top = 352
  end
  object RESTResponseDataSetAdapter4: TRESTResponseDataSetAdapter
    Dataset = FDMemTable4
    FieldDefs = <>
    Response = RESTResponse4
    TypesMode = Rich
    Left = 336
    Top = 408
  end
  object FDMemTable4: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 400
    Top = 392
  end
end
