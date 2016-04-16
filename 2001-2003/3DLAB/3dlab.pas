Program _3dlab;
Uses F_mouse,Graph,Crt,Dos;
Const
  Pathini:String='3dlab.ini';
  PathMap:String='';

  ScreenSizeX:Word=0;
  ScreenSizeY:Word=0;
  ScreenOpt:Word=0;
  SquareSize:Word=0;
  SquareHeight:Word=0;
  Speed:Word=0;
  GroundColor:Word=0;
  SkyColor:Word=0;

  ScreenAX:Word=0;
  ScreenAY:Word=0;
  Maxnm=100;
  MaxX:Word=0;
  MaxY:Word=0;
  MaxCurX:Longint=0;
  MaxCurY:Longint=0;
  Dangle=pi/500;
  Mode:(Night,Day)=Day;

  Col:array[0..15]of Byte=
      (0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
  CornerWidth:Word=5;
Var
  Map:Array[0..Maxnm-1,0..Maxnm-1] of Byte;
  Fini,Fmap:Text;
  i,j:Word;
  CurX,CurY,NCurX,NCurY:Extended;
  CurSquareX,CurSquareY,NCurSX,NCurSY:Integer;
  Gd,Gm:Integer;
  CurAngle:Extended;
  Angles:Array[0..639] of Extended;
  Page:Byte;

  Cx,Cy,SinA,CosA,Hx,Hy,L,Lh,CornerX,CornerY:Extended;
  CSx,CSy:Integer;
 Procedure DigitHeight(Angle:Extended;Var Height:LongInt;Var Color:Word);
 Begin
   Cx:=CurX;
   Cy:=CurY;
   CSx:=CurSquareX;
   CSy:=CurSquareY;
   Color:=0;
   CosA:=Cos(Angle);
   SinA:=Sin(Angle);
   L:=0;
   While (Color=0) And (CSx>=0) And (CSy>=0)
      And (CSx<=MaxX) And (CSy<=MaxY) do
    Begin
      If SinA=0 Then
        Hx:=1e17
       Else
        If SinA>0 Then
          Hx:=((CSy+1)*SquareSize-Cy)/SinA
         Else
          Hx:=-(Cy-CSy*SquareSize)/SinA;
      If CosA=0 Then
        Hy:=1e17
       Else
        If CosA>0 Then
          Hy:=((CSx+1)*SquareSize-Cx)/CosA
         Else
          Hy:=-(Cx-CSx*SquareSize)/CosA;
      If Hx<=Hy Then
        Begin
          L:=L+Hx;
          Cx:=Cx+Hx*CosA;
          Cy:=Cy+Hx*SinA;
          If SinA>0 Then
            Inc(CSy)
           Else
            Dec(CSy);
        End
       Else
        Begin
          L:=L+Hy;
          Cx:=Cx+Hy*CosA;
          Cy:=Cy+Hy*SinA;
          If CosA>0 Then
            Inc(CSx)
           Else
            Dec(CSx);
        End;
      If (CSx in [0..MaxX-1]) And (CSy in [0..MaxY-1]) Then
       Case Map[CSx,CSy] of
         15:Color:=12*Random(2);
         Else
            Color:=Map[CSx,CSy];
       End;
      CornerX:=Round(Cx) Mod SquareSize;
      CornerY:=Round(Cy) Mod SquareSize;
      If ((CornerX < CornerWidth) Or (CornerX > SquareSize - CornerWidth)) And
         ((CornerY < CornerWidth) Or (CornerY < SquareSize - CornerWidth)) And (Color > 0) Then
        Color:=1;
    End;
   Lh:=L*Cos(Angle-CurAngle);
   If Color=0 Then
     {Color:=random(2) Mod 2+Color;}
     Height:=0
   Else Begin
     Height:=Round((LongInt(SquareHeight)+Round(Sin((Cx)/20)*20))*ScreenOpt/Lh);
     {If Height>ScreenSizeY Then
      Height:=ScreenSizeY;}
   End;
 End;
 Procedure Draw;
 Var
   i:integer;
   Height:LongInt;
   Color:Word;
 Begin
   SetFillStyle(1,SkyColor);
   Bar(ScreenAX,ScreenAY-ScreenSizeY Div 2,ScreenAX+ScreenSizeX,ScreenAY);
   SetFillStyle(1,GroundColor);
   Bar(ScreenAX,ScreenAY,ScreenAX+ScreenSizeX,ScreenAY+ScreenSizeY Div 2);
   For i:=0 To ScreenSizeX-1 Do
    Begin
      DigitHeight(CurAngle+Angles[i],Height,Color);
      If Height>0 Then
       Begin
         SetColor(Color);
         Line(ScreenAX+i,ScreenAY-Height Div 2,ScreenAX+i,ScreenAY+Height Div 2);
         PutPixel(ScreenAX+i,ScreenAY-Height Div 2,1);
         PutPixel(ScreenAX+i,ScreenAY+Height Div 2,1);
         PutPixel(ScreenAX+i,ScreenAY-Height Div 4,1);
         PutPixel(ScreenAX+i,ScreenAY+Height Div 4,1);
       End;
    End;
   Setcolor(11);
   Rectangle(ScreenAX,ScreenAY-ScreenSizeY Div 2,
             ScreenAX+ScreenSizeX,ScreenAY+ScreenSizeY Div 2);
 End;
 Procedure FinishMessage(Message:String);
 Begin
   Sound(100);
   Delay(100);
   Sound(1000);
   Delay(100);
   NoSound;
   SetActivePage(1-Page);
   SetColor(12);
   OutTextXY(ScreenAX,ScreenAY+ScreenSizeY,Message);
   ReadKey;
   CurX:=SquareSize Div 2;
   CurY:=SquareSize Div 2;
   CurAngle:=pi/4;
 End;
 Procedure WaitRetrace; Assembler;
 Label
   L1, L2;
 Asm
   Mov DX, 3DAH
L1:In AL,DX
   And AL,08H
   JNZ L1
L2:In AL,DX
   And AL,08H
   JZ  L2
 End;
 Procedure CreateSound(Fr,t:Word);
 Begin
   Sound(Fr);
   Delay(t);
   NoSound;
 End;
Var
  Butt,Mx,My,Oldx:integer;
  R:Registers;
Begin
  Assign(Fini,Pathini);
  Reset(Fini);
  ReadLn(Fini);
  ReadLn(Fini,ScreenSizeX);
  ReadLn(Fini);
  ReadLn(Fini,ScreenSizeY);
  ReadLn(Fini);
  ScreenOpt:=ScreenSizeY;
  ReadLn(Fini,PathMap);
  ReadLn(Fini);
  ReadLn(Fini,SquareSize);
  ReadLn(Fini);
  ReadLn(Fini,SquareHeight);
  ReadLn(Fini);
  ReadLn(Fini,Speed);
  ReadLn(Fini);
  ReadLn(Fini,GroundColor);
  ReadLn(Fini);
  ReadLn(Fini,SkyColor);
  ReadLn(Fini);
  ReadLn(Fini,i);
  If i=0 Then
    Mode:=Day
   Else
    Mode:=Night;
  Close(Fini);
  Assign(Fmap,'Maps\'+PathMap+'.map');
  Reset(Fmap);
  Read(Fmap,MaxX,MaxY);
  MaxCurX:=MaxX*Longint(SquareSize);
  MaxCurY:=MaxY*Longint(SquareSize);
  For j:=0 To MaxY-1 Do
   For i:=0 To MaxX-1 Do
    Read(Fmap,Map[i,j]);
  Close(Fmap);
  Gd:=Vga;
  Gm:=VgaMed;
  InitGraph(Gd,Gm,'Bgi');
  If Mode=Night Then
   For i:=1 To 15 Do
    SetRGBPalette(Col[i],i+i,i+i,30+i+i);
  InitMouse;
  ScreenAX:=GetMaxX Div 2-ScreenSizeX Div 2;
  ScreenAY:=GetMaxY Div 2;
  CurX:=SquareSize Div 2;
  CurY:=SquareSize Div 2;
  CurSquareX:=0;
  CurSquareY:=0;
  CurAngle:=pi/4;
  For i:=0 To ScreenSizeX-1 Do
   Angles[i]:=ArcTan((ScreenSizeX/2-i)/ScreenOpt);
  Oldx:=320;
  ClearDevice;
  Repeat
    SetActivePage(Page);
    WaitRetrace;
    SetVisualPage(1-Page);
    GetMouseState(Butt,Mx,My);
    If Butt=1 Then
     Begin
       Cx:=CurX+Speed*Cos(CurAngle);
       Cy:=CurY+Speed*Sin(CurAngle);
     End;
    If Butt=2 Then
     Begin
       Cx:=CurX-Speed*Cos(CurAngle);
       Cy:=CurY-Speed*Sin(CurAngle);
     End;
    If ((Butt=1)or(Butt=2)) Then
     If (Cx>=0) And (Cy>=0) And (Cx<=MaxCurX-1) And (Cy<=MaxCurX-1) And
        (Map[Trunc(Cx/SquareSize),Trunc(Cy/SquareSize)]=0) Then
       Begin
         CurX:=Cx;
         CurY:=Cy;
       End
      Else
       Begin
         CreateSound(100,2000);
         CreateSound(200,2000);
         CreateSound(100,2000);
       End;
    If Mem[0:$417] And 2<>0 Then
     Begin
       CurX:=SquareSize Div 2;
       CurY:=SquareSize Div 2;
       CurAngle:=pi/4;
     End;
    CurSquareX:=Trunc(CurX/SquareSize);
    CurSquareY:=Trunc(CurY/SquareSize);
    if Oldx<>Mx then
     begin
       CurAngle:=CurAngle-(Mx-Oldx)*Dangle;
       Oldx:=Mx;
       if (Mx=0)or(Mx=639) then
        begin
          R.ax:=4;
          R.cx:=320;
          R.dx:=My;
          Oldx:=320;
          Intr($33,R);
        end;
     end;
    If ((Butt=1)or(Butt=2)) And
        (Map[Trunc(Cx/SquareSize),Trunc(Cy/SquareSize)]=15) Then
     FinishMessage('You`ve found it!...');
    Page:=1-Page;
    ClearDevice;
    Draw;
  Until KeyPressed;
  If ReadKey=#0 Then
   ReadKey;
  CloseGraph;
End.