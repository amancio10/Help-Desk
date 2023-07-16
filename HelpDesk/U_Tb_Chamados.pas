unit U_Tb_Chamados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Menus, Vcl.Grids, Vcl.DBGrids, comobj;

type
  TFrm_Tb_Chamados = class(TForm)
    DBGrid1: TDBGrid;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    ResposnderChamado1: TMenuItem;
    N2: TMenuItem;
    Sair1: TMenuItem;
    Panel1: TPanel;
    Image6: TImage;
    Image2: TImage;
    Image4: TImage;
    Image8: TImage;
    Image1: TImage;
    Grupo_Buscar: TGroupBox;
    Label1: TLabel;
    Imagem_Buscar: TImage;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Edit_Nome: TEdit;
    CheckBox2: TCheckBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    CBox_Local: TComboBox;
    CBox_Status: TComboBox;
    ProgressBar1: TProgressBar;
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Imagem_BuscarClick(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure ResposnderChamado1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Tb_Chamados: TFrm_Tb_Chamados;

implementation

{$R *.dfm}

uses U_Dados, U_Resp_Chamados;

procedure TFrm_Tb_Chamados.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if not odd(Dados.Query_HelpDesk.RecNo) then
    if not(gdSelected in State) then
    begin
      DBGrid1.Canvas.Brush.Color := clSkyBlue;
      DBGrid1.Canvas.FillRect(Rect);
      DBGrid1.DefaultDrawDataCell(Rect, Column.Field, State);
    end;

 If Dados.Query_HelpDesk.FieldByName('STATUS').AsString = 'ABERTO' then // condição
    Dbgrid1.Canvas.Font.Color:= clRed; // coloque aqui a cor desejada

  If Dados.Query_HelpDesk.FieldByName('STATUS').AsString = 'EM ANDAMENTO' then // condição
    Dbgrid1.Canvas.Font.Color:= clGreen; // coloque aqui a cor desejada

  Dbgrid1.DefaultDrawDataCell(Rect, dbgrid1.columns[datacol].field, State);
end;

procedure TFrm_Tb_Chamados.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key = vk_delete) THEN
 Abort;
end;

procedure TFrm_Tb_Chamados.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Dados.ADOConnection.Close;
end;

procedure TFrm_Tb_Chamados.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then
  begin
   key := #0;
   Close;
  end;
end;

procedure TFrm_Tb_Chamados.FormShow(Sender: TObject);
begin
 DateTimePicker1.DateTime := Date;
 DateTimePicker2.DateTime := Date;

 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.SQL.Add('select * from HelpDesk');
 Dados.Query_HelpDesk.SQL.Add('where STATUS like ' + chr(39) + 'ABERTO' + chr(39));
 Dados.Query_HelpDesk.Open;
end;

procedure TFrm_Tb_Chamados.Image1Click(Sender: TObject);
begin
 Dados.Query_HelpDesk.Next;
end;

procedure TFrm_Tb_Chamados.Image2Click(Sender: TObject);
 var
  PLANILHA: Variant;
  LINHA,CONT: Integer;
begin
 CONT := Dados.Query_HelpDesk.RecordCount;
 ProgressBar1.Max := CONT;
 ProgressBar1.Position := 0;
 Dados.Query_HelpDesk.Filtered := FALSE;
 LINHA:=2;

 PLANILHA:=CreateOleObject('Excel.Application');
 PLANILHA.caption:='';
 PLANILHA.visible:=false;
 PLANILHA.workbooks.add(1);

 PLANILHA.cells[1,1]  := 'ID';
 PLANILHA.cells[1,2]  := 'DATA_ABERTURA';
 PLANILHA.cells[1,3]  := 'VALOR';
 PLANILHA.cells[1,4]  := 'DESCRICAO';
 PLANILHA.cells[1,5]  := 'DATA_FECHAMENTO';
 PLANILHA.cells[1,6]  := 'RESPOSTA';
 PLANILHA.cells[1,7]  := 'RESPONDIDO_POR';
 PLANILHA.cells[1,8]  := 'ID_USUARIO';
 PLANILHA.cells[1,9]  := 'NOME_USUARIO';
 PLANILHA.cells[1,10] := 'FUNCAO';
 PLANILHA.cells[1,11] := 'RAMAL';
 PLANILHA.cells[1,12] := 'TELEFONE';
 PLANILHA.cells[1,13] := 'E_MAIL';
 PLANILHA.cells[1,14] := 'PRIORIDADE';
 PLANILHA.cells[1,15] := 'JUSTIFICATIVA';
 PLANILHA.cells[1,16] := 'STATUS';
 PLANILHA.cells[1,17] := 'OBS';

  Dados.Query_HelpDesk.First;
  Dados.Query_HelpDesk.DisableControls;

  try
    while not Dados.Query_HelpDesk.Eof do
    begin
      PLANILHA.cells[LINHA, 1]  := Dados.Query_HelpDesk.FieldByName('ID').AsString;
      PLANILHA.cells[LINHA, 2]  := Dados.Query_HelpDesk.FieldByName('DATA_ABERTURA').AsString;
      PLANILHA.cells[LINHA, 3]  := Dados.Query_HelpDesk.FieldByName('PROBLEMA').AsString;
      PLANILHA.cells[LINHA, 4]  := Dados.Query_HelpDesk.FieldByName('DESCRICAO').AsString;
      PLANILHA.cells[LINHA, 5]  := Dados.Query_HelpDesk.FieldByName('DATA_FECHAMENTO').AsString;
      PLANILHA.cells[LINHA, 6]  := Dados.Query_HelpDesk.FieldByName('RESPOSTA').AsString;
      PLANILHA.cells[LINHA, 7]  := Dados.Query_HelpDesk.FieldByName('RESPONDIDO_POR').AsString;
      PLANILHA.cells[LINHA, 8]  := Dados.Query_HelpDesk.FieldByName('ID_USUARIO').AsString;
      PLANILHA.cells[LINHA, 9]  := Dados.Query_HelpDesk.FieldByName('NOME_USUARIO').AsString;
      PLANILHA.cells[LINHA, 10] := Dados.Query_HelpDesk.FieldByName('FUNCAO').AsString;
      PLANILHA.cells[LINHA, 11] := Dados.Query_HelpDesk.FieldByName('RAMAL').AsString;
      PLANILHA.cells[LINHA, 12] := Dados.Query_HelpDesk.FieldByName('TELEFONE').AsString;
      PLANILHA.cells[LINHA, 13] := Dados.Query_HelpDesk.FieldByName('E_MAIL').AsString;
      PLANILHA.cells[LINHA, 14] := Dados.Query_HelpDesk.FieldByName('PRIORIDADE').AsString;
      PLANILHA.cells[LINHA, 15] := Dados.Query_HelpDesk.FieldByName('JUSTIFICATIVA').AsString;
      PLANILHA.cells[LINHA, 16] := Dados.Query_HelpDesk.FieldByName('STATUS').AsString;
      PLANILHA.cells[LINHA, 17] := Dados.Query_HelpDesk.FieldByName('OBS').AsString;

      LINHA := LINHA + 1;
      Dados.Query_HelpDesk.Next;
      ProgressBar1.Position := ProgressBar1.Position + 1;
    end;
    PLANILHA.columns.autofit;
    PLANILHA.visible := true;
  finally
    Dados.Query_HelpDesk.EnableControls;
    PLANILHA := Unassigned;
    ProgressBar1.Position := 0;
    MessageDlg('Concluído! =D', mtInformation, [mbOK], 0);
  end;
end;

procedure TFrm_Tb_Chamados.Image4Click(Sender: TObject);
begin
 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.Open;
end;

procedure TFrm_Tb_Chamados.Image8Click(Sender: TObject);
begin
 Dados.Query_HelpDesk.Prior;
end;

procedure TFrm_Tb_Chamados.Imagem_BuscarClick(Sender: TObject);
begin
 Dados.Query_HelpDesk.close;

  Dados.Query_HelpDesk.sql.clear;
  Dados.Query_HelpDesk.sql.add('select * from HelpDesk');


// if Edit_Nome.Text <> '' then
//   begin
    Dados.Query_HelpDesk.sql.add('where NOME_USUARIO like' + chr(39)
      + '%' + Edit_Nome.Text + '%' + chr(39));
//   end;

  if (CBox_Local.Text <> '') and (CBox_Local.Text <> 'TODOS') then
   begin
    Dados.Query_HelpDesk.sql.add('and LOCAL_TRABALHO like' + chr(39)+ CBox_Local.Text + chr(39));
   end;

  if (CBox_Status.Text <> '') and (CBox_Status.Text <> 'TODOS') then
   begin
    Dados.Query_HelpDesk.sql.add('and STATUS like' + chr(39)+ CBox_Status.Text + chr(39));
   end;

  Dados.Query_HelpDesk.sql.add('and DATA_ABERTURA between :DatInicial and :DatFinal');


  if CheckBox2.Checked = true then
   begin
    Dados.Query_HelpDesk.sql.add('Order by NOME_USUARIO');
   end;

  Dados.Query_HelpDesk.Parameters[0].Value := FormatDateTime('yyyy/mm/dd', DateTimePicker1.Date);
  Dados.Query_HelpDesk.Parameters[1].Value := FormatDateTime('yyyy/mm/dd', DateTimePicker2.Date);

  Dados.Query_HelpDesk.open;
end;

procedure TFrm_Tb_Chamados.ResposnderChamado1Click(Sender: TObject);
begin
  Try
   Application.CreateForm(TFrm_Resp_Chamados, Frm_Resp_Chamados);
   Frm_Resp_Chamados.ShowModal;
  Finally
   Frm_Resp_Chamados.Free;
  End;
end;

procedure TFrm_Tb_Chamados.Sair1Click(Sender: TObject);
begin
 Close;
end;

end.
