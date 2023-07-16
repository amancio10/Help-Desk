unit U_Historico;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TFrm_Historico = class(TForm)
    Button1: TButton;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBNavigator1: TDBNavigator;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBMemo1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Historico: TFrm_Historico;

implementation

{$R *.dfm}

uses U_Dados, U_Principal;

procedure TFrm_Historico.Button1Click(Sender: TObject);
begin
 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.SQL.Add('select * from HelpDesk where STATUS like "ABERTO" and ID_USUARIO = ' +
 Frm_Principal.ID_USUARIO);
 Dados.Query_HelpDesk.Open;
end;

procedure TFrm_Historico.DBGrid1DrawColumnCell(Sender: TObject;
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

   If Dados.Query_HelpDesk.FieldByName('STATUS').AsString = 'RESOLVIDO' then // condição
    Dbgrid1.Canvas.Font.Color:= clGreen; // coloque aqui a cor desejada

  Dbgrid1.DefaultDrawDataCell(Rect, dbgrid1.columns[datacol].field, State);
end;

procedure TFrm_Historico.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key = vk_delete) THEN
 Abort;
end;

procedure TFrm_Historico.DBMemo1KeyPress(Sender: TObject; var Key: Char);
begin
 key := #0;
end;

procedure TFrm_Historico.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Dados.ADOConnection.Close;
end;

procedure TFrm_Historico.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #27 then
  begin
    Key := #0;
    Close;
  end;
end;

procedure TFrm_Historico.FormShow(Sender: TObject);
begin
 Dados.Query_HelpDesk.Close;
 Dados.Query_HelpDesk.SQL.Clear;
 Dados.Query_HelpDesk.SQL.Add('select * from HelpDesk where ID_USUARIO = ' +
 Frm_Principal.ID_USUARIO);
 Dados.Query_HelpDesk.Open;
end;

end.
