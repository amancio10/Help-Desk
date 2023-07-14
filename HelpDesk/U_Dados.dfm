object Dados: TDados
  Height = 266
  Width = 256
  object ADOConnection: TADOConnection
    Left = 56
    Top = 40
  end
  object Query_Login: TADOQuery
    Parameters = <>
    Left = 48
    Top = 120
  end
  object Query_HelpDesk: TADOQuery
    Parameters = <>
    Left = 48
    Top = 192
  end
  object Source_Login: TDataSource
    DataSet = Query_Login
    Left = 160
    Top = 120
  end
  object Source_HelpDesk: TDataSource
    DataSet = Query_HelpDesk
    Left = 160
    Top = 192
  end
end
