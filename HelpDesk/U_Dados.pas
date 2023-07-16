unit U_Dados;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Forms;

type
  TDados = class(TDataModule)
    ADOConnection: TADOConnection;
    Query_Login: TADOQuery;
    Query_HelpDesk: TADOQuery;
    Source_Login: TDataSource;
    Source_HelpDesk: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dados: TDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
