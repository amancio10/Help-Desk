program HelpDesk;

uses
  Vcl.Forms,
  U_Principal in 'U_Principal.pas' {Frm_Principal},
  U_Dados in 'U_Dados.pas' {Dados: TDataModule},
  U_Abrir_Chamado in 'U_Abrir_Chamado.pas' {Frm_Abrir_Chamado},
  U_Historico in 'U_Historico.pas' {Frm_Historico},
  U_Cad_User in 'U_Cad_User.pas' {Frm_Cad_User},
  U_Comunicar_Atividade in 'U_Comunicar_Atividade.pas' {Frm_Comunicar_Atividade},
  U_Tb_Chamados in 'U_Tb_Chamados.pas' {Frm_Tb_Chamados},
  U_Resp_Chamados in 'U_Resp_Chamados.pas' {Frm_Resp_Chamados},
  U_Painel in 'U_Painel.pas' {Frm_Painel},
  U_Login in 'U_Login.pas' {Frm_Login};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDados, Dados);
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.Run;
end.
