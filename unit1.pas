// released under MIT license
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if CheckBox1.Checked and GetPower() then
  begin
    Label5.Caption := GetVoltage();
    Label6.Caption := GetCurrent();
  end
  else
  begin
    Label5.Caption := '-';
    Label6.Caption := '-';
  end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
     StrPCopy(ComPort, ComboBox1.Items[ComboBox1.ItemIndex]);
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  PowPort := ComboBox2.ItemIndex;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  PowerON();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  PowerOFF();
end;

end.

