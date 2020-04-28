// released under MIT license
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Unit2;

const

  VERSION = '1.5';

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonAbout: TButton;
    ButtonON: TButton;
    ButtonOFF: TButton;
    CheckBoxMonitor: TCheckBox;
    ComboBoxComPort: TComboBox;
    ComboBoxPowPort: TComboBox;
    LabelPortCom: TLabel;
    LabelPowPort: TLabel;
    LabelVoltage: TLabel;
    LabelCurrent: TLabel;
    LabelVoltageValue: TLabel;
    LabelCurrentValue: TLabel;
    LabelTargetVoltage: TLabel;
    LabelMaxCurrent: TLabel;
    Panel1: TPanel;
    ShapePowerStatus: TShape;
    Timer1: TTimer;
    ToggleBoxStayOnTop: TToggleBox;
    ToggleBoxConnect: TToggleBox;
    procedure ButtonAboutClick(Sender: TObject);
    procedure ButtonONClick(Sender: TObject);
    procedure ButtonOFFClick(Sender: TObject);
    procedure CheckBoxMonitorChange(Sender: TObject);
    procedure ComboBoxComPortChange(Sender: TObject);
    procedure ComboBoxPowPortChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBoxConnectChange(Sender: TObject);
    procedure ToggleBoxStayOnTopChange(Sender: TObject);
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
var
  PowerStatus: Boolean;
begin
  if FatalError or not ToggleBoxConnect.Checked then
  begin
    ShapePowerStatus.Brush.Color := clGray;
    LabelVoltageValue.Caption := '-';
    LabelCurrentValue.Caption := '-';
    Exit;
  end;
  PowerStatus := GetPower();
  if PowerStatus then
  begin
    ShapePowerStatus.Brush.Color := clLime;
    if CheckBoxMonitor.Checked then
    begin
      LabelVoltageValue.Caption := GetVoltage();
      LabelCurrentValue.Caption := GetCurrent();
    end;
  end
  else
  begin
    ShapePowerStatus.Brush.Color := clBlack;
    LabelVoltageValue.Caption := '-';
    LabelCurrentValue.Caption := '-';
  end;
end;

procedure TForm1.ToggleBoxConnectChange(Sender: TObject);
begin
 if ToggleBoxConnect.Checked = True then
 begin
   FatalError := False;
   ToggleBoxConnect.Caption := 'Disconnect';
   LabelTargetVoltage.Caption := '(' + GetTargetVoltage() + ')';
   if not FatalError then
   begin
     LabelMaxCurrent.Caption := '(' + GetMaxCurrent() + ')';
   end;
   if FatalError then
   begin
     LabelTargetVoltage.Caption := '()';
     LabelMaxCurrent.Caption := '()';
   end;
 end
 else
 begin
   ToggleBoxConnect.Caption := 'Connect';
   LabelTargetVoltage.Caption := '()';
   LabelMaxCurrent.Caption := '()';
 end;
end;

procedure TForm1.ToggleBoxStayOnTopChange(Sender: TObject);
begin
  if ToggleBoxStayOnTop.Checked then
  begin
    Form1.FormStyle := fsSystemStayOnTop;
  end
  else
  begin
    Form1.FormStyle := fsNormal;
  end;
end;

procedure TForm1.ComboBoxComPortChange(Sender: TObject);
begin
  ToggleBoxConnect.Checked := False;
  StrPCopy(ComPort, ComboBoxComPort.Items[ComboBoxComPort.ItemIndex]);
end;

procedure TForm1.ComboBoxPowPortChange(Sender: TObject);
begin
  ToggleBoxConnect.Checked := False;
  PowPort := ComboBoxPowPort.ItemIndex;
end;

procedure TForm1.ButtonONClick(Sender: TObject);
begin
  ToggleBoxConnect.Checked := True;
  PowerON();
end;

procedure TForm1.ButtonAboutClick(Sender: TObject);
begin
  ShowMessage('TTI PL Ctl tool V' + VERSION);
end;

procedure TForm1.ButtonOFFClick(Sender: TObject);
begin
  ToggleBoxConnect.Checked := True;
  PowerOFF();
end;

procedure TForm1.CheckBoxMonitorChange(Sender: TObject);
begin
  if CheckBoxMonitor.Checked then
  begin
    ToggleBoxConnect.Checked := True;
  end;
end;

end.

