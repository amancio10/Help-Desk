unit U_Resp_Chamados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.DBCtrls, DB;

type
  TFrm_Resp_Chamados = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    DBComboBox1: TDBComboBox;
    DBMemo1: TDBMemo;
    GroupBox2: TGroupBox;
    DBText1: TDBText;
    Label3: TLabel;
    DBText2: TDBText;
    Label4: TLabel;
    DBText3: TDBText;
    Label5: TLabel;
    Label6: TLabel;
    DBText4: TDBText;
    Label7: TLabel;
    DBText5: TDBText;
    Label8: TLabel;
    DBText6: TDBText;
    Image1: TImage;
    Bt_Salvar: TButton;
    Memo_Chamado: TMemo;
    Label9: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Bt_SalvarClick(Sender: TObject);
    procedure Memo_ChamadoKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Resp_Chamados: TFrm_Resp_Chamados;

implementation

{$R *.dfm}

uses U_Dados,
     IdSMTP,
     IdMessage,
     IdSSLOpenSSL,
     IdExplicitTLSClientServerBase, U_Principal;

procedure TFrm_Resp_Chamados.Bt_SalvarClick(Sender: TObject);
var
 xSMTP: TIdSMTP;
 xMessage: TIdMessage;
 xSocketSSL : TIdSSLIOHandlerSocketOpenSSL;
 EMIAL : string;
begin
 if (DBComboBox1.Text <> '') and (DBMemo1.Text <> '') then
  begin

   if Dados.Query_HelpDesk.State in [dsInsert, dsEdit] then
    begin
     Frm_Resp_Chamados.Caption := 'Responder Chamados (aguarde...)';

     Dados.Query_HelpDesk.FieldByName('RESPONDIDO_POR').AsString := Frm_Principal.NOME_USUARIO;
     Dados.Query_HelpDesk.FieldByName('DATA_FECHAMENTO').Value := Date;
     Dados.Query_HelpDesk.FieldByName('HORA_FECHAMENTO').Value := Time;
     Dados.Query_HelpDesk.Post;

    if Frm_Principal.NOTIFICACAO = 'ATIVO' then
     begin
       EMIAL := 'Olá, ' + Dados.Query_HelpDesk.FieldByName('NOME_USUARIO').AsString + ' seu chamado Nº ' +
                Dados.Query_HelpDesk.FieldByName('ID').AsString +
                ' foi atualizado para: ' + Dados.Query_HelpDesk.FieldByName('STATUS').AsString +
                #13#10 +
                #13#10 +
                '---------------------------' +
                #13#10 +
                'Texto do seu chamado:' +
                #13#10 +
                Dados.Query_HelpDesk.FieldByName('DESCRICAO').AsString +
                #13#10 +
                #13#10 +
                '---------------------------' +
                #13#10 +
                'Resposta:' +
                #13#10 +
                Dados.Query_HelpDesk.FieldByName('RESPOSTA').AsString +
                #13#10 +
                #13#10 +
                'Departameto de tecnologia!';


        // <------- Enviar e-mail ---------------------
          try
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
            xMessage.From.Address := 'HELP DESK';
            xMessage.Recipients.Add;
            xMessage.Recipients.Items[0].Address := Dados.Query_HelpDesk.FieldByName('E_MAIL').AsString; //Frm_Principal.EMAIL;
            xMessage.Subject := 'SEU CHAMADO Nº ' + Dados.Query_HelpDesk.FieldByName('ID').AsString + ' FOI ATUALIZADO';
            xMessage.Body.Add(EMIAL);
          try
           xSMTP.Connect;
           xSMTP.Send(xMessage);
        //   showMessage('Menssagem enviada com sucesso');
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

     MessageDlg('Chamado atualizado com sucesso! =D', mtInformation, [mbOK], 0);
     Close;
      end
     else
     begin
      MessageDlg('Chamado atualizado com sucesso! =D', mtInformation, [mbOK], 0);
      Close;
     end;
    end;

  end
   else
   MessageDlg('Preencha todas as informações!', mtWarning, [mbOK], 0);
end;

procedure TFrm_Resp_Chamados.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Dados.Query_HelpDesk.State in [dsInsert, dsEdit] then
  begin

    if messageBox(handle, 'Deseja salvar as alterações?', 'ATENÇÃO',
      mb_IconInformation + mb_YesNo) = mrYes then
    begin
      Dados.Query_HelpDesk.Post;
      MessageDlg('Chamado atualizado com sucesso! =D', mtInformation, [mbOK], 0);
    end
     else
     Dados.Query_HelpDesk.Cancel;

  end;
end;

procedure TFrm_Resp_Chamados.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then
  begin
   key := #0;
   Close;
  end;
end;

procedure TFrm_Resp_Chamados.FormShow(Sender: TObject);
begin
 Memo_Chamado.Text := Dados.Query_HelpDesk.FieldByName('DESCRICAO').AsString;
end;

procedure TFrm_Resp_Chamados.Memo_ChamadoKeyPress(Sender: TObject; var Key: Char);
begin
 key := #0;
end;

end.
