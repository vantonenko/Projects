program setup;
{�ணࠬ�� ��।������ ����� ०��� 640�400�256}
const Seg0040 = $40; {������� ������ BIOS}

Procedure SetVideoMode(Mode:byte); {��⠭�������� �����०��}
Begin
    asm
    mov al,Mode
    xor ah,ah
    int 10h
    end;
End;

Function GetVideoMode:byte;        {�⠥� �����०��}
Begin
    asm
    mov ah,$0f
    int 10h
    mov @Result,al
    end;
End;

type
  vidrec=record   {�������, �ࠪ�ਧ���� �����०��}
     mode:byte;                 {����� �����०���}
     wide:Word;     {�।���������� �ਭ� �࠭� � �窠�}
     Heig:Word;     {�।���������� ���� �࠭� � �窠�}
     pixel:boolean; {����� �� ������ ���ᮢ����� ���}
     Graph1,Graph2:boolean;    
{���� �� ०�� ����᪨� (2 ��ਠ��)}
     c256:boolean;         {���� �� ०�� 256-梥��}
  end;
var
   i,k:integer;
   vr:vidrec;         {��ࠬ���� ⥪�饣� ०���}
   q:array[0..$7f]of vidrec; {���ᨢ ��� ��࠭��� ०����}
   m:byte;        {��� ����� VESA-०���}

procedure GetConst; {�������� �������� �������ࠬ��஢}
var
   colpix:byte;
begin
   vr.mode := mem[Seg0040:$49];   {����� �����०���}
   vr.wide := memW[Seg0040:$4a] * 8;  
{��ਭ� �࠭�, �᫨ � ����� 8 �祪}
   vr.Heig := (mem[Seg0040:$84] + 1) * memW[Seg0040:$85];  {����� ����}
   asm
      mov ah,$0c  {�஢�ઠ ��⮤�� ����� � �⥭�� �窨}
      mov al,$aa  {����� 梥�}
      mov bh,0
      mov cx,639  {X-���न���}
      mov dx,399  {Y-���न���}
      int $10     {��襬 ���}
      mov ah,$0d
      mov bh,0
      mov cx,639  {X}
      mov dx,399  {Y}
      int $10     {�⠥� ���}
      mov colpix,al
   end;
   vr.pixel :=  (colpix = $aa);
   colpix := Port[$3da];         { �⥭�� ॣ���� MCR }
   Port[$3c0] := $10;   { ����஫��� }
   colpix := Port[$3c1];        { ��ਡ�⮢   }
   vr.Graph1 := (colpix and 1) = 1;     { ����᪨�?}
   Port[$3ce] := 6;     {            }
   vr.Graph2 := (Port[$3cf] and 1) = 1; { ����᪨�?}
   Port[$3ce] := 5;     {            }
   vr.c256 := (Port[$3cf] and $40) = $40;       { 256 梥⮢? }
end;

begin                    {�᭮���� �ணࠬ��}
   Port[$3c4] := 1;
   Port[$3c5] := Port[$3c5] or $20;  {�몫�砥� �࠭}
   k := 0;
   for i := $14 to $7f do begin {��ॡ�ࠥ� �� �ᥬ ����ࠬ}
      SetVideoMode(i);
      if i = GetVideoMode then begin 
{�⡨ࠥ� ⮫쪮 �������騥 ०���}
         GetConst;
         if (vr.Wide = 640) and (vr.Heig = 400) then begin 
{�⡨ࠥ� �� ࠧ��ࠬ}
            q[k] := vr;
            k := k + 1;
         end;
      end;
   end;
   SetVideoMode(3);
   asm                 {�஢�ઠ VESA}
      mov ax,$4f02
      mov bx,$100
      int $10
   end;
   m := GetVideoMode;
   Port[$3c4] := 1;
   Port[$3c5] := Port[$3c5] and $DF;  {����砥� �࠭}
   SetVideoMode(3);
   if k=0 then          {�᫨ �⮡࠭ ��� �� ���� ०��}
      for i := 0 to k-1 do 
{�뢮��� �� ����� ��� ��ࠬ����}
         writeln('Mode=',q[i].mode,' Wid=',q[i].Wide,'Hei=',q[i].Heig,
         ' Pixel:',q[i].pixel,'Graphic:',q[i].Graph1,'/',q[i].Graph2,
         ' 256colors:',q[i].c256)
   else writeln('Suitable mode not detected');
   if m=$13 then      writeln('VESA mode:',m)
   else                 writeln('VESA not supported');
end.
