unit U_Cad_User;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TFrm_Cad_User = class(TForm)
    Bt_Confirmar: TButton;
    Bt_Cancelar: TButton;
    ChecNotificacoes: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Lb_Status_Senha: TLabel;
    Label11: TLabel;
    Edt_Nome: TEdit;
    Edt_Usuario: TEdit;
    Edt_Funcao: TEdit;
    Edt_Telefone: TEdit;
    Edt_Ramal: TEdit;
    Edt_Email: TEdit;
    ComboBox1: TComboBox;
    Edt_Senha: TEdit;
    Edt_Confim_Senha: TEdit;
    ComboBox2: TComboBox;
    Image1: TImage;
    procedure Bt_ConfirmarClick(Sender: TObject);
    procedure Bt_CancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edt_Confim_SenhaExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TIPO_EDICAO : string;
  end;

var
  Frm_Cad_User: TFrm_Cad_User;

implementation

{$R *.dfm}

uses U_Dados, U_Principal;

procedure TFrm_Cad_User.Bt_CancelarClick(Sender: TObject);
begin
 Close;
end;

procedure TFrm_Cad_User.Bt_ConfirmarClick(Sender: TObject);
begin
if (Edt_Nome.Text <> '') and (Edt_Funcao.Text <> '') and(Edt_Usuario.Text <> '') and
   (Edt_Senha.Text <> '') and (Edt_Ramal.Text <> '') and(Edt_Email.Text <> '') and
   (Edt_Telefone.Text <> '') and (ComboBox1.Text <> '') and (ComboBox2.Text <> '') and
   (Lb_Status_Senha.Caption = 'As senha correspondem :)') then      ///
 begin
  if TIPO_EDICAO = 'CRIACAO' then
   begin
    Dados.Query_Login.Insert;
    Dados.Query_Login.FieldByName('PRIORIDADE').AsString   := 'USER';
   end
    else
  Dados.Query_Login.Edit;

  Dados.Query_Login.FieldByName('NOME').AsString           := Edt_Nome.Text;
  Dados.Query_Login.FieldByName('FUNCAO').AsString         := Edt_Funcao.Text;
  Dados.Query_Login.FieldByName('USUARIO').AsString        := Edt_Usuario.Text;
  Dados.Query_Login.FieldByName('SENHA').AsString          := Edt_Senha.Text;
  Dados.Query_Login.FieldByName('RAMAL').AsString          := Edt_Ramal.Text;
  Dados.Query_Login.FieldByName('E_MAIL').AsString         := Edt_Email.Text;
  Dados.Query_Login.FieldByName('TELEFONE').AsString       := Edt_Telefone.Text;
  Dados.Query_Login.FieldByName('LOCAL_TRABALHO').AsString := ComboBox1.Text;
  Dados.Query_Login.FieldByName('DEPARTAMENTO').AsString   := ComboBox2.Text;

  if ChecNotificacoes.Checked = true then
  begin
   Dados.Query_Login.FieldByName('NOTIFICACAO').AsString := 'ATIVO';
  end
  else
   Dados.Query_Login.FieldByName('NOTIFICACAO').AsString := 'INATIVO';

  Dados.Query_Login.Post;

  MessageDlg('Seu cadastro foi realizado com sucesso! ;)', mtInformation, [mbOK], 0);
  Close;
 end
 else
  MessageDlg('Por favor preencha todos os campos!', mtWarning, [mbOK], 0);
end;

procedure TFrm_Cad_User.Edt_Confim_SenhaExit(Sender: TObject);
begin
 if Edt_Confim_Senha.Text = Edt_Senha.Text then
  begin
   Lb_Status_Senha.Caption := 'As senha correspondem :)';
   Lb_Status_Senha.Font.Color := clGreen;
  end
   else
  begin
   Lb_Status_Senha.Caption := 'As senha não correspondem :)';
   Lb_Status_Senha.Font.Color := clMaroon;
  end;
end;

procedure TFrm_Cad_User.FormShow(Sender: TObject);
begin
 if TIPO_EDICAO = 'EDICAO' then
  begin
   Dados.Query_Login.Close;
   Dados.Query_Login.SQL.Clear;
   Dados.Query_Login.SQL.Add('select * from Login');
   Dados.Query_Login.SQL.Add('where ID = ' + Frm_Principal.ID_USUARIO);
   Dados.Query_Login.Open;

  Edt_Nome.Text     := Dados.Query_Login.FieldByName('NOME').AsString;
  Edt_Funcao.Text   := Dados.Query_Login.FieldByName('FUNCAO').AsString;
  Edt_Usuario.Text  := Dados.Query_Login.FieldByName('USUARIO').AsString;
  Edt_Senha.Text    := Dados.Query_Login.FieldByName('SENHA').AsString;
  Edt_Ramal.Text    := Dados.Query_Login.FieldByName('RAMAL').AsString;
  Edt_Email.Text    := Dados.Query_Login.FieldByName('E_MAIL').AsString;
  Edt_Telefone.Text := Dados.Query_Login.FieldByName('TELEFONE').AsString;
  ComboBox1.Text    := Dados.Query_Login.FieldByName('LOCAL_TRABALHO').AsString;
  ComboBox2.Text    := Dados.Query_Login.FieldByName('DEPARTAMENTO').AsString;

   if Dados.Query_Login.FieldByName('NOTIFICACAO').AsString = 'ATIVO' then
    begin
     ChecNotificacoes.Checked := true;
    end
     else
    ChecNotificacoes.Checked := false;
  end;
end;

end.
