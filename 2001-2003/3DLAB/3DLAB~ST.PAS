Program _3dlab;
Uses F_mouse,Graph,Crt,Dos;
Const
  ScreenSize=30;
  ScreenSizeX=4*ScreenSize;
  ScreenSizeY=2*ScreenSize;
  ScreenOpt=ScreenSizeX div 2;
  StereoDist=5;
  ScreenAX:Word=0;
  ScreenAY:Word=0;

  Maxnm=100;
  MaxX:Word=0;
  MaxY:Word=0;
  MaxCurX:Longint=0;
  MaxCurY:Longint=0;
  SquareSize=300;
  SquareHeight=200;
  Speed=4;
  GroundColor=2;
  SkyColor=9;
  PathMap:String='3dlab3.map';
Var
  Map:Array[0..Maxnm-1,0..Maxnm-1] of Byte;
  Fini:Text;
  i,j:Word;
  CurX,CurY,NCurX,NCurY:Extended;
  CurSquareX,CurSquareY,NCurSX,NCurSY:Integer;
  Gd,Gm:Integer;
  CurAngle:Extended;
  Angles:Array[0..ScreenSizeX-1] of Extended;
  Page:Byte;

  Cx,Cy,SinA,CosA,Hx,Hy,L,Lh:Extended;
  CSx,CSy:Integer;
 Procedure DigitHeight(I:Byte;Angle:Extended;Var Height,Color:Word);
 Begin
   CosA:=Cos(Angle);
   SinA:=Sin(Angle);
   If I=1 Then
     Begin
       Cx:=CurX-StereoDist*SinA;
       Cy:=CurY+StereoDist*CosA;
     End
    Else
     Begin
       Cx:=CurX+StereoDist*SinA;
       Cy:=CurY-StereoDist*CosA;
     End;
   CSx:=Trunc(Cx/SquareSize);
   CSy:=Trunc(Cy/SquareSize);
   Color:=0;
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
       Begin
         Color:=Map[CSx,CSy];
         If Color=15 Then
          Color:=12*Random(2);
       End;
    End;
   Lh:=L*Cos(Angle-CurAngle);
   If Color=0 Then
     Height:=0
    Else
     Height:=Round(SquareHeight*ScreenOpt/Lh);
   If Height>ScreenSizeY Then
    Height:=ScreenSizeY;
 End;
 Procedure Draw;
 Var
   i:integer;
   Height,Color:Word;
 Begin
   {SetFillStyle(1,SkyColor);
   Bar(ScreenAX,ScreenAY-ScreenSizeY Div 2,ScreenAX+ScreenSizeX,ScreenAY);
   SetFillStyle(1,GroundColor);
   Bar(ScreenAX,ScreenAY,ScreenAX+ScreenSizeX,ScreenAY+ScreenSizeY Div 2);}
   For i:=0 To ScreenSizeX-1 Do
    Begin
      DigitHeight(i Mod 2,CurAngle+Angles[i],Height,Color);
      SetColor(Color);
      If Height>0 Then
       Begin
         Line(ScreenAX+i+(i Mod 2)*ScreenSizeX,ScreenAY-Height Div 2,
              ScreenAX+i+(i Mod 2)*ScreenSizeX,ScreenAY+Height Div 2);
         PutPixel(ScreenAX+i+(i Mod 2)*ScreenSizeX,ScreenAY-Height Div 2,1);
         PutPixel(ScreenAX+i+(i Mod 2)*ScreenSizeX,ScreenAY+Height Div 2,1);
       End;
    End;
   {Setcolor(11);
   Rectangle(ScreenAX,ScreenAY-ScreenSizeY Div 2,ScreenAX+ScreenSizeX,ScreenAY+ScreenSizeY Div 2);}
 End;
Var
  Butt,Mx,My,Oldx:integer;
  R:Registers;
Begin
  Assign(Fini,'Maps\'+PathMap);
  Reset(Fini);
  Read(Fini,MaxX,MaxY);
  MaxCurX:=MaxX*Longint(SquareSize);
  MaxCurY:=MaxY*Longint(SquareSize);
  For j:=0 To MaxY-1 Do
   For i:=0 To MaxX-1 Do
    Read(Fini,Map[i,j]);
  Close(Fini);
  Gd:=Vga;
  Gm:=VgaMed;
  InitGraph(Gd,Gm,'Bgi');
  InitMouse;
  ScreenAX:=GetMaxX Div 2-ScreenSizeX{ Div 2};
  ScreenAY:=GetMaxY Div 2;
  CurX:=SquareSize Div 2;
  CurY:=SquareSize Div 2;
  CurSquareX:=0;
  CurSquareY:=0;
  CurAngle:=pi/4;
  For i:=0 To ScreenSizeX-1 Do
   Angles[i]:=ArcTan((ScreenSizeX/2-i)/ScreenOpt);
  Oldx:=320;
  Repeat
    SetActivePage(Page);
    SetVisualPage(1-Page);
    GetMouseState(Butt,Mx,My);
    if Butt=1 Then
     Begin
       Cx:=CurX+Speed*Cos(CurAngle);
       Cy:=CurY+Speed*Sin(CurAngle);
     End;
    if Butt=2 Then
     Begin
       Cx:=CurX-Speed*Cos(CurAngle);
       Cy:=CurY-Speed*Sin(CurAngle);
     End;
    If ((Butt=1)or(Butt=2)) And
        (Map[Trunc(Cx/SquareSize),Trunc(Cy/SquareSize)]=0) Then
     Begin
       CurX:=Cx;
       CurY:=Cy;
     End;
    If Butt=3 Then
     Begin
       CurX:=SquareSize Div 2;
       CurY:=SquareSize Div 2;
       CurAngle:=pi/4;
     End;
    CurSquareX:=Trunc(CurX/SquareSize);
    CurSquareY:=Trunc(CurY/SquareSize);
    if Oldx<>Mx then
     begin
       CurAngle:=CurAngle-(Mx-Oldx)*pi/1000;
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
    Page:=1-Page;
    ClearDevice;
    Draw;
  Until KeyPressed;
  If ReadKey=#0 Then
   ReadKey;
  CloseGraph;
End.