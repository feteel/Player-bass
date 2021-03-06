unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bass, StdCtrls, Buttons, ExtCtrls, ShellApi;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Panel1: TPanel;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    ListBox1: TListBox;
    ListBox2: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    OpenDialog2: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ScrollBar2Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);

  private
    { Private declarations }
     procedure AddFiles(filename: string);
     procedure Playitem(item: integer);
     procedure DropFile(var Msg:TWMDropFiles);  message WM_DropFiles;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  stream: hstream;
  track: boolean;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
DragAcceptFiles(Handle,true);
 if BASS_init(-1,44100,0,handle,nil) then
   exit;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   BASS_FREE();
end;





procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Bass_ChannelPause(stream);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
 BASS_ChannelStop(stream);
   BASS_CHANNELsetPosition(stream,0,0);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
if  track=False then
 ScrollBar1.Position:= BASS_ChannelGetPosition(stream, 0);
end;

procedure TForm1.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin

  if ScrollCode = scEndScroll then
  begin
  BASS_ChannelSetPosition(stream, Scrollbar1.Position,0);
  track:=False;
  end
  Else
   track:=true;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin

if openDialog1.Execute=False then   exit;
 AddFiles(OpenDialog1.FileName);
  LIstBox1.ItemIndex:=LIstBox1.Items.Count-1;
  PlayItem(ListBox1.ItemIndex);

               end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
 if BASS_ChannelisActive(stream)=BASS_Active_Paused then
Bass_channelPlay(stream, false)
Else
  PlayItem(ListBox1.ItemIndex);
end;
Procedure TForm1.AddFiles(filename: string);
begin
  listBox2.items.add(FileName);
  listBox1.items.Add(ExtractFilename(filename));
   if ListBox1.ItemIndex=-1 then
    ListBox1.ItemIndex:=ListBox1.Items.count-1;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
 if OpenDialog1.Execute=false then  exit;
   AddFiles(OpenDialog1.FileName);

end;
   procedure TForm1.PlayItem(item: integer);
   begin
    if item<0 then exit;
   if stream<>0  then
BASS_streamFree(stream);
stream:= Bass_streamCreateFile(false, PChar(ListBox2.items.strings[item]), 0, 0, 0);
   if stream=0 then
showmessage('������ ���� �� ��������!')
Else
begin
panel1.caption:= ExtractFileName(ListBox2.items.strings[item]);
    ScrollBar1.Min:=0;
    ScrollBar1.Max:= BASS_ChannelGetLength(stream, 0)-1;
    ScrollBar1.Position:=0;
    BASS_ChannelPlay(stream, false);

               end  ;
   end;


procedure TForm1.SpeedButton2Click(Sender: TObject);
var
inindex: integer;
begin
 inindex:= ListBox1.ItemIndex;
 ListBox1.Items.Delete(Inindex);
 ListBox2.Items.Delete(Inindex);
if inindex>ListBox1.Items.Count-1 then
inindex:=LIstBox1.Items.Count-1;
LIstBox1.ItemIndex:=inindex;

end;

procedure TForm1.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_DElete then
  SpeedButton2.Click;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
 PlayItem(ListBox1.ItemIndex);
end;

procedure TForm1.ScrollBar2Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
 BASS_SetVolume(ScrollBar2.Position/100);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
if SaveDialog1.Execute then
 ListBox2.Items.SaveToFile(SaveDialog1.FileName);

end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
var i: integer;
begin
if OpenDialog2.Execute=false then exit;
  ListBox2.Items.LoadFromFile(OpenDialog2.FileName);
  ListBox1.Items.LoadFromFile(OpenDialog2.FileName);
  for i:=0 to ListBox1.Items.Count-1 do
  listBox1.Items.strings[i]:=ExtractFileName(listBox1.Items.strings[i]);


end;

Procedure TForm1.DropFile(var MSG: TWMDropFiles);
var
CFileName: array[0..MAX_Path] of Char;
begin
 try
 if DragQueryFile(MSG.Drop, 0, CfileName, MaX_Path)>0 then
 begin
 AddFiles(CFileName);
  Msg.Result:=0;
   end;
   finally
  DragFinish(MSG.Drop);
  end;
  end;


   procedure TForm1.Timer2Timer(Sender: TObject);
   var
   L,R,L1,R1: integer;
   Level: DWORD;
begin
  if BASS_ChannelIsActive(stream)<>  BASS_Active_Playing then Exit;
   Level:= BASS_ChannelGetLevel(stream);
  L:= HiWORD(Level);
  R:= LOWORD(Level);
  PaintBox1.Canvas.Brush.Color:= clWhite;
  PaintBox1.Canvas.FillRect(PaintBox1.Canvas.Cliprect);

 PaintBox2.Canvas.Brush.Color:= clWhite;
 PaintBox2.Canvas.FillRect(PaintBox1.Canvas.Cliprect);


  L1:=Round(L / (32768/ PaintBox1.Height));
  R1:=Round(R / (32768/ PaintBox2.Height));
  PaintBox1.Canvas.Brush.Color:= clBlue;
  PaintBox2.Canvas.Brush.Color:= clBlue;
  PaintBox1.Canvas.Rectangle (0, PaintBox1.Height-L1, PaintBox1.Width, PaintBox1.Height);
  PaintBox2.Canvas.Rectangle (0, PaintBox2.Height-R1, PaintBox2.Width, PaintBox2.Height);


end;

end.
