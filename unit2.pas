// released under MIT license
unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, Dialogs, StrUtils;

var
  ComPort: array[0..4] of Char = 'COM1';  // COMxx
  PowPort: Integer = 1;
  FatalError: Boolean = False;

procedure PowerOn();
procedure PowerOff();
function GetPower(): Boolean;
function GetVoltage(): String;
function GetCurrent(): String;
function GetTargetVoltage(): String;
function GetMaxCurrent(): String;

implementation

var
  ComFile: THandle = INVALID_HANDLE_VALUE;

procedure OpenCom();
var
  Device: array[0..10] of Char;
  Dcb: TDCB;
  CommTimeouts : TCommTimeouts;

begin
     FatalError := False;
     Device := '\\.\' + ComPort;
     ComFile := CreateFile(Device,
       GENERIC_READ or GENERIC_WRITE,
       0,
       nil,
       OPEN_EXISTING,
       FILE_ATTRIBUTE_NORMAL,
       0);
     if ComFile = INVALID_HANDLE_VALUE then
     begin
        FatalError := True;
        ShowMessage('Cannot open COM port');
        Exit;
     end;

     Dcb := Default(TDCB);
     if not GetCommState(ComFile, Dcb) then
        Exit;

     with Dcb do
     begin
       BaudRate := 9600;
       ByteSize := 8;
       Parity := NOPARITY;
       StopBits := ONESTOPBIT;
       Flags := bm_DCB_fOutX or bm_DCB_fInX;
     end;
     if not SetCommState(ComFile, Dcb) then
        Exit;

     CommTimeouts := Default(TCommTimeouts);
     with CommTimeouts do
     begin
         ReadIntervalTimeout :=          MAXDWORD;
         ReadTotalTimeoutConstant :=     0;
         ReadTotalTimeoutMultiplier :=   0;
         WriteTotalTimeoutConstant :=    1;
         WriteTotalTimeoutMultiplier :=  1;
     end;
     if not SetCommTimeouts(ComFile, CommTimeouts) then
        Exit;
end;

procedure CloseCom();
begin
     if ComFile <> INVALID_HANDLE_VALUE then
     begin
       CloseHandle(ComFile);
       ComFile := INVALID_HANDLE_VALUE;
     end;
end;

procedure SendString(s: string);
var
  BytesWritten: DWORD = 0;
begin
     if ComFile <> INVALID_HANDLE_VALUE then
     begin
       s := s + #10;
       if not WriteFile(ComFile, s[1], Length(s), BytesWritten, nil) then
       begin
         ShowMessage('Timeout write');
       end;
     end;
end;

function ReceiveString: string;
var
  BytesRead: DWORD = 0;
  r: array[0..9] of Char = '';
begin
     Result := '';
     if ComFile <> INVALID_HANDLE_VALUE then
     begin
       if ReadFile(ComFile, r, 10, BytesRead, nil) then
       begin
            Result := LeftStr(r, Pos(#13, r) - 1);
       end
       else
       begin
            ShowMessage('Timeout read');
       end;
     end;
end;

procedure PowerON();
var
  s: string;
begin
     s:= 'OP' + Char($30 + PowPort) + ' 1';
     OpenCom();
     SendString(s);
     CloseCom();
end;

procedure PowerOFF();
var
  s: string;
begin
     s:= 'OP' + Chr($30 + PowPort) + ' 0';
     OpenCom();
     SendString(s);
     CloseCom();
end;

function GetPower(): Boolean;
var
  s, r: string;
begin
     s := 'OP' + Chr($30 + PowPort) + '?';
     OpenCom();
     SendString(s);
     Sleep(100);
     r := ReceiveString();
     if CompareStr(r, '1') = 0 then
     begin
       Result := True;
     end
     else
     begin
       Result := False;
     end;
     CloseCom();
end;

function GetVoltage(): String;
var s: string;
begin
     s := 'V' + Chr($30 + PowPort) + 'O?';
     OpenCom();
     SendString(s);
     Sleep(100);
     Result := ReceiveString();
     CloseCom();
end;

function GetCurrent(): String;
var s: string;
begin
     s := 'I' + Chr($30 + PowPort) + 'O?';
     OpenCom();
     SendString(s);
     Sleep(100);
     Result := ReceiveString();
     CloseCom();
end;

function GetTargetVoltage(): String;
var s, r: string;
begin
     s := 'V' + Chr($30 + PowPort) + '?';
     OpenCom();
     SendString(s);
     Sleep(100);
     r := ReceiveString();
     Result := MidStr(r, 4, Length(r)-3);
     CloseCom();
end;

function GetMaxCurrent(): String;
var s, r: string;
begin
     s := 'I' + Chr($30 + PowPort) + '?';
     OpenCom();
     SendString(s);
     Sleep(100);
     r := ReceiveString();
     Result := MidStr(r, 4, Length(r)-3);
     CloseCom();
end;

end.

