Unit Mouse;

Interface
Uses Kernel,F_Mouse;

Procedure InitMouse;
Procedure DoneMouse;
Procedure HideMouse;
Procedure ShowMouse;

Const
  InitMouseFlag:Boolean=False;
  DisableMouse:Boolean=False;
Implementation
Const
  Count:Byte=0;
  DoubTime:Longint=0;
  Lup:Integer=4;
  Ldown:Integer=2;
  Rdown:Integer=8;
  Rup:Integer=16;
  DoubleTime:Longint=9;
  OldButt:Integer=0;

 Procedure MouseHandler(Mask,Butt,X,Y,dX,dY:Integer);Far;
 Var
   T:Longint;
   Event:TEvent;
 Begin
   If DisableMouse Then
    Exit;
   T:=Clock_Val;
   Event.What:=0;
   Event.Double:=False;
   Event.Global.X:=X;
   Event.Global.Y:=Y;
   Event.Where:=Event.Global;
   Event.Buttons:=Butt;
   Event.Ctrl:=Serve_Val And svCtrl<>0;
   Event.Shift:=Serve_Val And (svLShift+svRShift)<>0;
   If Mask And 1=1 Then
    Event.What:=Event.What or evMouseMove;
   If (Mask And Lup<>0)or((OldButt And 1<>0)And(Butt And 1=0))Then
    Event.What:=Event.What or evMouseLup;
   If (Mask And Rup<>0)or((OldButt And 2<>0)And(Butt And 2=0))Then
    Event.What:=Event.What or evMouseRup;
   If (Mask And Ldown<>0)or((OldButt And 1=0)And(Butt And 1<>0))Then
    Event.What:=Event.What or evMouseLdown;
   If (Mask And Rdown<>0)or((OldButt And 2=0)And(Butt and 2<>0))Then
    Event.What:=Event.What or evMouseRdown;
   OldButt:=Butt;
   If (Mask And Ldown<>0)And(Count Mod 2=0) Then
    Begin
      If Count=0 Then
       DoubTime:=T;
      If T-DoubTime>=DoubleTime Then
        Begin
          Count:=1;
          DoubTime:=T;
        End
       Else
        Inc(Count);
    End;
   If (Mask And Lup<>0)And(Count Mod 2<>0) Then
    Begin
      If T-DoubTime>=DoubleTime Then
        Count:=0
       Else
        Inc(Count);
      If Count=4 Then
       Begin
         Event.Double:=True;
         Count:=0;
       End;
    End;
   If Butt And 1=1 Then
    Event.What:=Event.What or evMouseAuto;
   KernelSelf^.AddEvent(Event);
 End;

 Procedure InitMouse;
 Begin
   If InitMouseFlag Then
    Exit;
   InitMouseFlag:=True;
   F_Mouse.InitMouse;
   F_Mouse.ShowMouse;
   With RScreen Do
    F_mouse.MouseWindow(A.X,A.Y,B.X,B.Y);
   SetMouseHandler(1+ldown+rdown+lup+rup,MouseHandler);
 End;

 Procedure DoneMouse;
 Begin
   If Not InitMouseFlag Then
    Exit;
   InitMouseFlag:=False;
   ClearMouseHandler;
 End;

 Procedure HideMouse;
 Begin
   F_Mouse.HideMouse;
 End;

 Procedure ShowMouse;
 Begin
   F_Mouse.ShowMouse;
 End;

End.