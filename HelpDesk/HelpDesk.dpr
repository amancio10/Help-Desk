program HelpDesk;

uses
  Vcl.Forms,
  U_Principal in 'U_Principal.pas' {Frm_Principal},
  U_Dados in 'U_Dados.pas' {Dados: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.CreateForm(TDados, Dados);
  Application.Run;
end.
