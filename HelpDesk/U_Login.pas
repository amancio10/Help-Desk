unit U_Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TFrm_Login = class(TForm)
    Button1: TButton;
    DBLookupComboBox1: TDBLookupComboBox;
    Edit_Senha: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label2MouseEnter(Sender: TObject);
    procedure Label2MouseLeave(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FPodeFechar: boolean;
  public
    { Public declarations }
  end;

var
  Frm_Login: TFrm_Login;

implementation

{$R *.dfm}

uses U_Dados, U_Principal, U_Cad_User;

procedure TFrm_Login.Button1Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TFrm_Login.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose := FPodeFechar;
end;

procedure TFrm_Login.FormCreate(Sender: TObject);
begin
 FPodeFechar := false;
end;

procedure TFrm_Login.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then
  begin
   Key := #0;
   SpeedButton1.Click;
  end;
end;

procedure TFrm_Login.FormShow(Sender: TObject);
begin
 DBLookupComboBox1.SetFocus;
 Label1.Caption := ' Hoje é ' + FormatDateTime ('dddd", "dd" de "mmmm" de "yyyy',now);
 Dados.Query_Login.Open;
end;

procedure TFrm_Login.Label2Click(Sender: TObject);
begin
 Try
  Application.CreateForm(TFrm_Cad_User, Frm_Cad_User);
  Frm_Cad_User.TIPO_EDICAO := 'CRIACAO';
  Frm_Cad_User.ShowModal;
 Finally
  Frm_Cad_User.Free;
 end;
end;

procedure TFrm_Login.Label2MouseEnter(Sender: TObject);
begin
 Label2.Font.Style := Label2.Font.Style + [fsUnderline];
end;

procedure TFrm_Login.Label2MouseLeave(Sender: TObject);
begin
 Label2.Font.Style := Label2.Font.Style - [fsUnderline];
end;

procedure TFrm_Login.SpeedButton1Click(Sender: TObject);
begin
 if (DBLookupComboBox1.Text <> '') and (Edit_Senha.Text <> '') then
  begin

  if Edit_Senha.Text = Dados.Query_Login.FieldByName('SENHA').AsString then
   begin
    Frm_Principal.ID_USUARIO     := Dados.Query_Login.FieldByName('ID').AsString;
    Frm_Principal.NOME_USUARIO   := Dados.Query_Login.FieldByName('NOME').AsString;
    Frm_Principal.PRIORIDADE     := Dados.Query_Login.FieldByName('PRIORIDADE').AsString;
    Frm_Principal.FUNCAO         := Dados.Query_Login.FieldByName('FUNCAO').AsString;
    Frm_Principal.EMAIL          := Dados.Query_Login.FieldByName('E_MAIL').AsString;
    Frm_Principal.RAMAL          := Dados.Query_Login.FieldByName('RAMAL').AsString;
    Frm_Principal.LOCAL_TRABALHO := Dados.Query_Login.FieldByName('LOCAL_TRABALHO').AsString;
    Frm_Principal.PRIORIDADE     := Dados.Query_Login.FieldByName('PRIORIDADE').AsString;
    Frm_Principal.NOTIFICACAO    := Dados.Query_Login.FieldByName('NOTIFICACAO').AsString;

    Frm_Principal.StatusBar1.Panels[0].Text := 'Bem vindo ' +
    Dados.Query_Login.FieldByName('USUARIO').AsString;

    FPodeFechar := true;
    Frm_Login.Close;
   end
    else
     begin
      MessageDlg('Senha incorreta!', mtWarning, [mbOK], 0);
      Edit_Senha.Clear;
      Edit_Senha.SetFocus;
     end;
  end
   else
   MessageDlg('Usuário ou senha incorretos!', mtWarning, [mbOK], 0);
end;

end.
