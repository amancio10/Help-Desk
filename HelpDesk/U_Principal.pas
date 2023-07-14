unit U_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ActnMan, System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.Ribbon,
  Vcl.RibbonLunaStyleActnCtrls;

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
    Action2: TAction;
    Action5: TAction;
    Action6: TAction;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Principal: TFrm_Principal;

implementation

{$R *.dfm}

end.
