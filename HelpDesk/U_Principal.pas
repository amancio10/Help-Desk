unit U_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ActnMan, System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.Ribbon,
  Vcl.RibbonLunaStyleActnCtrls, ShellAPI, Vcl.ComCtrls;

type
  TFrm_Principal = class(TForm)
    Ribbon1: TRibbon;
    RibbonPage1: TRibbonPage;
    RibbonGroup1: TRibbonGroup;
    Image_Fundo: TImage;
    ImageList_Small: TImageList;
    ImageList_Large: TImageList;
    ActionManager: TActionManager;
    Action1: TAction;
    Action5: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    Action11: TAction;
    Action12: TAction;
    RibbonPage2: TRibbonPage;
    RibbonGroup2: TRibbonGroup;
    RibbonPage3: TRibbonPage;
    RibbonGroup3: TRibbonGroup;
    RibbonGroup4: TRibbonGroup;
    Action3: TAction;
    StatusBar1: TStatusBar;
    procedure Action1Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action11Execute(Sender: TObject);
    procedure Action9Execute(Sender: TObject);
    procedure Action10Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action12Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ID_USUARIO, NOME_USUARIO, PRIORIDADE, FUNCAO,
    EMAIL, RAMAL, LOCAL_TRABALHO, DEPARTAMENTO, NOTIFICACAO : string;
  end;

var
  Frm_Principal: TFrm_Principal;

implementation

{$R *.dfm}

uses U_Dados, U_Abrir_Chamado, U_Historico, U_Cad_User, U_Comunicar_Atividade,
  U_Tb_Chamados, U_Painel, U_Login;

procedure AbrirFormulario(T: TFormClass; F: TForm);
begin

 Try
  Application.CreateForm(T, F);
  F.ShowModal;
 Finally
  F.Free;
 End;

end;

procedure AbrirLink(const URL: string);
begin
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TFrm_Principal.Action10Execute(Sender: TObject);
begin
  AbrirLink('https://github.com/amancio10');
end;

procedure TFrm_Principal.Action11Execute(Sender: TObject);
begin
 Try
  Application.CreateForm(TFrm_Cad_User, Frm_Cad_User);
  Frm_Cad_User.TIPO_EDICAO := 'EDICAO';
  Frm_Cad_User.Caption     := 'Meus dados';
  Frm_Cad_User.ShowModal;
 Finally
  Frm_Cad_User.Free;
 end;
end;

procedure TFrm_Principal.Action12Execute(Sender: TObject);
begin
  if PRIORIDADE = 'ADM' then
  begin
    AbrirFormulario(TFrm_Comunicar_Atividade, Frm_Comunicar_Atividade);
  end
  else
    MessageDlg('Você não tem permissão para acessar essa ferramenta!',
      mtWarning, [mbOK], 0);
end;

procedure TFrm_Principal.Action1Execute(Sender: TObject);
begin
 AbrirFormulario(TFrm_Abrir_Chamado, Frm_Abrir_Chamado);
end;

procedure TFrm_Principal.Action3Execute(Sender: TObject);
begin
 AbrirFormulario(TFrm_Historico, Frm_Historico);
end;

procedure TFrm_Principal.Action5Execute(Sender: TObject);
begin
if PRIORIDADE = 'ADM' then
  begin
    AbrirFormulario(TFrm_Tb_Chamados, Frm_Tb_Chamados);
  end
  else
    MessageDlg('Você não tem permissão para acessar essa ferramenta!',
      mtWarning, [mbOK], 0);
end;

procedure TFrm_Principal.Action7Execute(Sender: TObject);
begin
if PRIORIDADE = 'ADM' then
begin

 Try
  Application.CreateForm(TFrm_Cad_User, Frm_Cad_User);
  Frm_Cad_User.TIPO_EDICAO := 'CRIACAO';
  Frm_Cad_User.Caption     := 'Cadastro de usuários';
  Frm_Cad_User.ShowModal;
 Finally
  Frm_Cad_User.Free;
 end;

end
 else
  MessageDlg('Você não tem permissão para acessar essa ferramenta!',
      mtWarning, [mbOK], 0);
end;

procedure TFrm_Principal.Action8Execute(Sender: TObject);
begin
if PRIORIDADE = 'ADM' then
  begin
    AbrirFormulario(TFrm_Painel, Frm_Painel);
  end
  else
    MessageDlg('Você não tem permissão para acessar essa ferramenta!',
      mtWarning, [mbOK], 0);
end;

procedure TFrm_Principal.Action9Execute(Sender: TObject);
begin
 AbrirLink('https://www.linkedin.com/in/amancio-santos');
end;

procedure TFrm_Principal.FormShow(Sender: TObject);
begin
 Try
  Application.CreateForm(TFrm_Login, Frm_Login);
  Frm_Login.ShowModal;
 Finally
  Frm_Login.Free;
 End;
end;

end.
