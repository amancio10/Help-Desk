unit U_Painel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, Vcl.Imaging.jpeg;

type
  TFrm_Painel = class(TForm)
    Image1: TImage;
    Image5: TImage;
    Image4: TImage;
    Image2: TImage;
    Image3: TImage;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LbQuantAguardando: TLabel;
    LbQuantAndamento: TLabel;
    LbQuantResolvidos: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Bt_Atualizar: TSpeedButton;
    Timer1: TTimer;
    Lb_Status_Atualizacao: TLabel;
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Label7Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Bt_AtualizarClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Painel: TFrm_Painel;

implementation

{$R *.dfm}

uses U_Dados;

procedure TFrm_Painel.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if not odd(Dados.Query_HelpDesk.RecNo) then
    if not(gdSelected in State) then
    begin
      DBGrid1.Canvas.Brush.Color := clSkyBlue;
      DBGrid1.Canvas.FillRect(Rect);
      DBGrid1.DefaultDrawDataCell(Rect, Column.Field, State);
    end;
end;

procedure TFrm_Painel.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key = vk_delete) THEN
 Abort;
end;

procedure TFrm_Painel.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #27 then
  begin
   key := #0;
   Close;
  end;
end;

procedure TFrm_Painel.FormShow(Sender: TObject);
begin
 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.SQL.Add('SELECT COUNT(*) as total FROM HelpDesk');
 Dados.Query_HelpDesk.sql.add('Where STATUS like "ABERTO"');
 Dados.Query_HelpDesk.Open;

 LbQuantAguardando.Caption := Dados.Query_HelpDesk.FieldByname('total').AsString;


 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.SQL.Add('SELECT COUNT(*) as total FROM HelpDesk');
 Dados.Query_HelpDesk.sql.add('Where STATUS like "EM ANDAMENTO"');
 Dados.Query_HelpDesk.Open;

 LbQuantAndamento.Caption := Dados.Query_HelpDesk.FieldByname('total').AsString;


 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.SQL.Add('SELECT COUNT(*) as total FROM HelpDesk');
 Dados.Query_HelpDesk.sql.add('Where STATUS like "RESOLVIDO"');
 Dados.Query_HelpDesk.Open;

 LbQuantResolvidos.Caption := Dados.Query_HelpDesk.FieldByname('total').AsString;


 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.sql.add('select * from HelpDesk');
 Dados.Query_HelpDesk.sql.add('Where STATUS like "ABERTO"');
 Dados.Query_HelpDesk.Open;

 Lb_Status_Atualizacao.Caption := 'Atualizado em: ' + DateToStr(Date) + ' - ' + TimeToStr(Time);
end;

procedure TFrm_Painel.Label7Click(Sender: TObject);
begin
 Close;
end;

procedure TFrm_Painel.Bt_AtualizarClick(Sender: TObject);
begin
 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.SQL.Add('SELECT COUNT(*) as total FROM HelpDesk');
 Dados.Query_HelpDesk.sql.add('Where STATUS like "ABERTO"');
 Dados.Query_HelpDesk.sql.add('and DATA_ABERTURA between :DatInicial and :DatFinal');
 Dados.Query_HelpDesk.Parameters[0].Value := FormatDateTime('yyyy/mm/dd', DateTimePicker1.Date);
 Dados.Query_HelpDesk.Parameters[1].Value := FormatDateTime('yyyy/mm/dd', DateTimePicker2.Date);
 Dados.Query_HelpDesk.Open;

 LbQuantAguardando.Caption := Dados.Query_HelpDesk.FieldByname('total').AsString;


 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.SQL.Add('SELECT COUNT(*) as total FROM HelpDesk');
 Dados.Query_HelpDesk.sql.add('Where STATUS like "EM ANDAMENTO"');
 Dados.Query_HelpDesk.sql.add('and DATA_ABERTURA between :DatInicial and :DatFinal');
 Dados.Query_HelpDesk.Parameters[0].Value := FormatDateTime('yyyy/mm/dd', DateTimePicker1.Date);
 Dados.Query_HelpDesk.Parameters[1].Value := FormatDateTime('yyyy/mm/dd', DateTimePicker2.Date);
 Dados.Query_HelpDesk.Open;

 LbQuantAndamento.Caption := Dados.Query_HelpDesk.FieldByname('total').AsString;



 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.SQL.Add('SELECT COUNT(*) as total FROM HelpDesk');
 Dados.Query_HelpDesk.sql.add('Where STATUS like "RESOLVIDO"');
 Dados.Query_HelpDesk.sql.add('and DATA_ABERTURA between :DatInicial and :DatFinal');
 Dados.Query_HelpDesk.Parameters[0].Value := FormatDateTime('yyyy/mm/dd', DateTimePicker1.Date);
 Dados.Query_HelpDesk.Parameters[1].Value := FormatDateTime('yyyy/mm/dd', DateTimePicker2.Date);
 Dados.Query_HelpDesk.Open;

 LbQuantResolvidos.Caption := Dados.Query_HelpDesk.FieldByname('total').AsString;


 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.sql.add('select * from HelpDesk');
 Dados.Query_HelpDesk.sql.add('Where STATUS like "ABERTO"');
 Dados.Query_HelpDesk.sql.add('and DATA_ABERTURA between :DatInicial and :DatFinal');
 Dados.Query_HelpDesk.Parameters[0].Value := FormatDateTime('yyyy/mm/dd', DateTimePicker1.Date);
 Dados.Query_HelpDesk.Parameters[1].Value := FormatDateTime('yyyy/mm/dd', DateTimePicker2.Date);
 Dados.Query_HelpDesk.Open;

 Lb_Status_Atualizacao.Caption := 'Atualizado em: ' + DateToStr(Date) + ' - ' + TimeToStr(Time);
end;

procedure TFrm_Painel.Timer1Timer(Sender: TObject);
begin
 Bt_Atualizar.Click;
end;

end.
