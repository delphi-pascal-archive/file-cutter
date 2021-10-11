unit KUPROJECT;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, Spin, ExtDlgs, Buttons;

type
  TForm1 = class(TForm)
    Button2: TButton;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Edit1: TEdit;
    Label1: TLabel;
    Button3: TButton;
    Edit: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Button5: TButton;
    Label5: TLabel;
    ComboBox1: TComboBox;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    Label6: TLabel;
    Edit2: TEdit;
    OpenDialog2: TOpenDialog;
    Label7: TLabel;
    BitBtn1: TBitBtn;
    procedure Button2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
   end;

var
  Form1: TForm1;
implementation

{$R *.DFM}    

procedure TForm1.Button2Click(Sender: TObject);
var
    re,we: File;
    nread, nwrite,evro: Integer;
    cap, reg, chast, istel:  String;
    Buf: array[1..1024] of Char;
    param,t: Word;
    tex: Textfile;
    size: Longint;
begin
  if edit1.text='' then begin
    messagebox(0,'Сперва необходимо выбрать файл для резки','Error',0);
    Exit;
  end;

  if edit2.text='' then begin
    MessageBox(0,'Введите имя папки','Error',0);
    Exit;
   end;

  if combobox1.text='' then
  begin
    MessageBox(0,'Введите размер куска','Error',0);
    Exit;
  end;
  reg:=ComboBox1.Text;
  val(reg,size, evro);
  size:=size*1024;
  if ComboBox1.Text='Размер дискеты 1.44 Мб' then size:=1440000;
  if ComboBox1.Text='Размер дискеты 1.38 Мб' then size:=1380000;

  if not CreateDir('c:\'+edit2.text) then
  begin
    MessageBox(0,'Невозможно создать папку с таким именем','Error',0);
    Exit;
  end;

  AssignFile(re,edit1.text);
  Reset(re,1);
  istel:=Copy(Edit1.Text,Length(ExtractFileDir(Edit1.Text))+1,Length(Edit1.Text)-
              Length(ExtractFileDir(Edit1.Text)));
  Assignfile(tex,('c:\'+edit2.text+'\Head.vkq'));
  Rewrite(tex);
  Writeln(tex,istel);
  Writeln(tex,size);
  Closefile(tex);
  param:=FileSize(re) div size;

  if Filesize(re) mod size > 0 then param:=param+1;
  for t:=0 to param-1 do
  begin
    Seek(re,size*t);
    str(t,chast);
    cap:=chast+'.vks';
    AssignFile(we, ('c:\'+edit2.text+'\'+cap));
    Rewrite(we,1);
    repeat
      BlockRead(re, Buf, SizeOf(Buf), NRead);
      BlockWrite(we, Buf, NRead, NWrite);
    until ((FileSize(we)>size) or (NRead = 0)) or (NWrite <> NRead);
    CloseFile(we);
  end;
  CloseFile(re);
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
  messagebox(0,'Эта программа нужна для резки файла на куски '+
               'и для их последующего восстановления','Cutter v1.0 - VKSSoft Copyright (c) 2004',0);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit1.Text:=OpenDialog1.FileName;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if opendialog2.Execute then
    Edit.text:= ExtractFileDir(Opendialog2.FileName)+'\';
end;


procedure TForm1.BitBtn1Click(Sender: TObject);
var
      Vf1, Vf2 : File;
      NRead, NWrite: Integer;
      Buf: array[1..1024] of Char;
      p,evro,chislo: Integer;
      res: Longint;
      f: TSearchRec;
      tex: TextFile;
      ero,er,cap,seno,path: String;
begin
  chislo:=1;
  if edit.text='' then
  begin
    Messagebox(0,'Выберите папку с кусками','Error',0);
    Exit;
  end;

  if edit2.text='' then
  begin
    Messagebox(0,'Введите имя папки на С:\ куда будет положен восстановленный файл','Error',0);
    Exit;
  end;

  if not CreateDir('c:\'+edit2.text) then path:='c:\'+Edit2.Text;
  path:=edit.Text;

  if FindFirst(path+'*.vks', faanyfile, F)=0 then
     while FindNext(F) = 0 do chislo:=chislo+1;
  FindClose(F);

  if FindFirst(path+'Head.vkq', faanyfile, F)<>0 then
  begin
    MessageBox(0,'Головной файл "Head.vkq" не найден! Работа не может продолжаться','Error',0);
    Exit;
  end;

  Assignfile(tex,path+'Head.vkq');
  Reset(tex);
  Readln(tex, ero);
  Readln(tex,er);
  AssignFile(Vf1,'c:\'+Edit2.Text+'\'+ero);
  Rewrite(Vf1,1);
  val(er,res,evro);
  for p:=0 to chislo - 1 do
  begin
    str(p,seno);
    cap:=seno+'.vks';
    AssignFile(Vf2,path+cap);
    Reset(Vf2,1);
    Seek(vf1,res*p);
    repeat
       BlockRead(Vf2, Buf, SizeOf(Buf), NRead);
       BlockWrite(Vf1, Buf, NRead, NWrite);
    until (NRead = 0) or (NWrite <> NRead);

    CloseFile(Vf2);
  end;
  CloseFile(tex);
  CloseFile(vf1);
end;

end.
