unit U_Comunicar_Atividade;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TFrm_Comunicar_Atividade = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit_Remetente: TEdit;
    Edit_Assunto: TEdit;
    Edit_Email: TEdit;
    Memo_Corpo_Email: TMemo;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Comunicar_Atividade: TFrm_Comunicar_Atividade;

implementation

{$R *.dfm}

uses  IdSMTP,
      IdMessage,
      IdSSLOpenSSL,
      IdExplicitTLSClientServerBase;

procedure TFrm_Comunicar_Atividade.Button1Click(Sender: TObject);
var
 xSMTP: TIdSMTP;
 xMessage: TIdMessage;
 xSocketSSL : TIdSSLIOHandlerSocketOpenSSL;
begin
 if (Edit_Remetente.Text <> '') and (Edit_Assunto.Text <> '')
 and (Edit_Email.Text <> '') and (Memo_Corpo_Email.Text <> '') then
  begin

        // <------- Enviar e-mail ---------------------
          try
            Frm_Comunicar_Atividade.Caption := 'Comunicar atividade (aguarde...)';
            xSMTP := TIdSMTP.Create;
            xMessage := TIdMessage.Create;
            xSocketSSL := TIdSSLIOHandlerSocketOpenSSL.Create;
            xSocketSSL.SSLOptions.Mode := sslmClient;
            xSocketSSL.SSLOptions.Method := sslvTLSv1_2;
            xSocketSSL.Host := 'smtp.gmail.com'; // Esse exemplo de Host é do Gmail
            xSocketSSL.Port := 465 ;
            xSMTP.IOHandler := xSocketSSL;
            xSMTP.Host := 'smtp.gmail.com';  // Esse exemplo de Host é do Gmail
            xSMTP.Port := 465 ;
            xSMTP.AuthType := satDefault;
            xSMTP.Username := 'SeuEmail@gmail.com';
            xSMTP.Password := 'SuaSenha'; // Essa deve ser a senha configurada em "autenticação de duas etapas" do seu e-mail
            xSMTP.UseTLS := utUseExplicitTLS;
            xMessage.From.Address := Edit_Remetente.Text; //'HELP DESK';
            xMessage.Recipients.Add;
            xMessage.Recipients.Items[0].Address := Edit_Email.Text;
            xMessage.Subject := Edit_Assunto.Text;
          try
           xSMTP.Connect;
           xSMTP.Send(xMessage);
           MessageDlg('Menssagem enviada com sucesso', mtInformation, [mbOK], 0);
           Close;
          except on E: Exception do
            raise Exception.Create('Erro ao enviar email: ' + E.Message);
          end;
          finally
            FreeAndNil(xSMTP);
            FreeAndNil(xMessage);
            FreeAndNil(xSocketSSL);
          end;
      // ------- Enviar e-mail --------------------- >

     {*
       Para o envio de e-mails funcionar você precisa manter as DLL's:
       libeay32.dll & ssleay32.dll
       na pasta do executavel...
     *}

  end
   else
   MessageDlg('Favor preencha todos os campos!', mtWarning, [mbOK], 0);
end;

procedure TFrm_Comunicar_Atividade.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then
  begin
   Key := #0;
   Close;
  end;
end;

end.
