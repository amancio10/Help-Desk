object Dados: TDados
  Height = 266
  Width = 256
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=DB.mdb;Persist Secu' +
      'rity Info=False;'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 56
    Top = 40
  end
  object Query_Login: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Login')
    Left = 48
    Top = 120
  end
  object Query_HelpDesk: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from HelpDesk')
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
