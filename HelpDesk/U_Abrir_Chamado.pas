unit U_Abrir_Chamado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TFrm_Abrir_Chamado = class(TForm)
    Image_Fundo: TImage;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Lb_Urgencia: TLabel;
    Lb_Justificatica: TLabel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Lb_ID: TLabel;
    LB_Nome: TLabel;
    LB_Funcao: TLabel;
    LB_Ramal: TLabel;
    LB_Email: TLabel;
    CBox_Ajuda: TComboBox;
    CBox_Urgencia: TComboBox;
    Memo1: TMemo;
    Edit_Justificativa: TEdit;
    Bt_Enviar: TButton;
    Bt_Limpar: TButton;
    procedure CBox_UrgenciaSelect(Sender: TObject);
    procedure Bt_LimparClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Bt_EnviarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Abrir_Chamado: TFrm_Abrir_Chamado;

implementation

{$R *.dfm}

uses U_Principal,
     IdSMTP,
     IdMessage,
     IdSSLOpenSSL,
     IdExplicitTLSClientServerBase, U_Dados;

procedure TFrm_Abrir_Chamado.Bt_EnviarClick(Sender: TObject);
var
 xSMTP: TIdSMTP;
 xMessage: TIdMessage;
 xSocketSSL : TIdSSLIOHandlerSocketOpenSSL;
 EMIAL : string;
begin

 if ((Edit_Justificativa.Visible = true) and (Edit_Justificativa.Text <> '')) or (Edit_Justificativa.Visible = False)
  then
  begin

   if (CBox_Ajuda.Text <> '') and (CBox_Urgencia.Text <> '') and (Memo1.Text <> '')
    then
    begin
     Frm_Abrir_Chamado.Caption := 'Abertura de chamado técnico (aguarde...)';

     // <---------- Inserir chamado no banco de dados -----------
      Dados.Query_HelpDesk.Open;
      Dados.Query_HelpDesk.Insert;

      Dados.Query_HelpDesk.FieldByName('NOME_USUARIO').AsString   := Frm_Principal.NOME_USUARIO;
      Dados.Query_HelpDesk.FieldByName('RAMAL').AsString          := Frm_Principal.RAMAL;
      Dados.Query_HelpDesk.FieldByName('FUNCAO').AsString         := Frm_Principal.FUNCAO;
      Dados.Query_HelpDesk.FieldByName('E_MAIL').AsString         := Frm_Principal.EMAIL;
      Dados.Query_HelpDesk.FieldByName('ID_USUARIO').AsString     := Frm_Principal.ID_USUARIO;
      Dados.Query_HelpDesk.FieldByName('LOCAL_TRABALHO').AsString := Frm_Principal.LOCAL_TRABALHO;
      Dados.Query_HelpDesk.FieldByName('DEPARTAMENTO').AsString   := Frm_Principal.DEPARTAMENTO;

      Dados.Query_HelpDesk.FieldByName('PROBLEMA').AsString       := CBox_Ajuda.Text;
      Dados.Query_HelpDesk.FieldByName('DESCRICAO').AsString      := Memo1.Text;
      Dados.Query_HelpDesk.FieldByName('PRIORIDADE').AsString     := CBox_Urgencia.Text;
      Dados.Query_HelpDesk.FieldByName('JUSTIFICATIVA').AsString  := Edit_Justificativa.Text;
      Dados.Query_HelpDesk.FieldByName('STATUS').AsString         := 'ABERTO';
      Dados.Query_HelpDesk.FieldByName('DATA_ABERTURA').Value     := Date;
      Dados.Query_HelpDesk.FieldByName('HORA_ABERTURA').Value     := Time;

      if CBox_Urgencia.ItemIndex = 3 then
        Dados.Query_HelpDesk.FieldByName('JUSTIFICATIVA').Value   := Edit_Justificativa.Text;

      Dados.Query_HelpDesk.Post;

     // <------- Preparar e-mail para envio ------------------
   if Frm_Principal.NOTIFICACAO = 'ATIVO' then
    begin
      EMIAL := 'Olá, ' + Dados.Query_HelpDesk.FieldByName('NOME_USUARIO').AsString + ' seu chamado Nº ' +
                Dados.Query_HelpDesk.FieldByName('ID').AsString +
                ' foi enviado para análise de nosso Suporte.' +
                #13#10 +
                'Te manteremos informado(a) por aqui! ;D' +
                #13#10 +
                #13#10 +
                '---------------------------' +
                #13#10 +
                'Texto do seu chamado:' +
                #13#10 +
                Dados.Query_HelpDesk.FieldByName('DESCRICAO').AsString +
                #13#10 +
                #13#10 +
                'Departameto de tecnologia';

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
            xSMTP.Host := 'smtp.gmail.com'; // Esse exemplo de Host é do Gmail
            xSMTP.Port := 465 ;
            xSMTP.AuthType := satDefault;
            xSMTP.Username := 'SeuEmail@gmail.com';
            xSMTP.Password := 'SuaSenha'; // Essa deve ser a senha configurada em "autenticação de duas etapas" do seu e-mail
            xSMTP.UseTLS := utUseExplicitTLS;
            xMessage.From.Address := 'HELP DESK'; // Nome no remetente
            xMessage.Recipients.Add;
            xMessage.Recipients.Items[0].Address := Dados.Query_HelpDesk.FieldByName('E_MAIL').AsString;   // E-mail do destinatário
            xMessage.Subject := 'SEU CHAMADO Nº ' + Dados.Query_HelpDesk.FieldByName('ID').AsString + ' FOI ATUALIZADO';  // Assunto do E-mial
            xMessage.Body.Add(EMIAL);
            {*
              Para o envio de e-mails funcionar você precisa manter as DLL's:
              libeay32.dll & ssleay32.dll
              na pasta do executavel...
            *}
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
    end;

      Dados.Query_HelpDesk.Close;
      Dados.ADOConnection.Close;
      MessageDlg('Chamado enviado com sucesso! =D', mtInformation, [mbOk], 0);
      Bt_Limpar.Click;
      Close;
    end
    else
     MessageDlg('Por favor preencha todos os campos!', mtWarning, [mbOk], 0);
  end
  else
   MessageDlg('Por favor justifique a urgência do seu chamado!', mtWarning, [mbOk], 0);
end;

procedure TFrm_Abrir_Chamado.Bt_LimparClick(Sender: TObject);
begin
 CBox_Ajuda.ItemIndex       := -1;
 CBox_Urgencia.ItemIndex    := -1;
 Edit_Justificativa.Visible := False;
 Lb_Justificatica.Visible   := False;
 Lb_Urgencia.Caption        := 'Nível de urgência:';
 Memo1.Clear;
end;

procedure TFrm_Abrir_Chamado.CBox_UrgenciaSelect(Sender: TObject);
begin
 if CBox_Urgencia.ItemIndex = 0 then Lb_Urgencia.Caption := 'Nível de urgência: (até 04h)';
 if CBox_Urgencia.ItemIndex = 1 then Lb_Urgencia.Caption := 'Nível de urgência: (até 24h)';
 if CBox_Urgencia.ItemIndex = 2 then Lb_Urgencia.Caption := 'Nível de urgência: (até 48h)';

 if CBox_Urgencia.ItemIndex = 0 then
  begin
   Edit_Justificativa.Visible := True;
   Lb_Justificatica.Visible   := True;
  end
   else
  begin
   Edit_Justificativa.Visible := False;
   Lb_Justificatica.Visible   := False;
   Edit_Justificativa.Clear;
  end;
end;

procedure TFrm_Abrir_Chamado.FormShow(Sender: TObject);
begin
 Lb_ID.Caption     := Frm_Principal.ID_USUARIO;
 LB_Nome.Caption   := Frm_Principal.NOME_USUARIO;
 LB_Funcao.Caption := Frm_Principal.FUNCAO;
 LB_Ramal.Caption  := Frm_Principal.RAMAL;
 LB_Email.Caption  := Frm_Principal.EMAIL;
end;

end.
