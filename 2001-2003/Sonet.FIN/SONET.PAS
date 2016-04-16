Program _Sonet;
Uses Graph,Kernel,Crt,Mouse;
Type

  TSonet=Object(TKernel)
    Rc:Word;
    Constructor Init;
    Procedure HandlEvent(Var Event:TEvent);Virtual;
  End;

  PIdle=^TIdle;
  TIdle=Object(Ttask)
    i,c:Integer;
    Constructor Init(aOwner:PView);
    Procedure Run;Virtual;
  End;

 Constructor TIdle.Init;
 Begin
   i:=0;
   c:=8;
 End;

 Procedure TIdle.Run;
 Begin
   SetColor(c);
   Line(i,0,i,30);
   Inc(i);
   If i>639 Then
    Begin
      i:=0;
      c:=8-c;
    End;
   Delay(10);
 End;

 Constructor TSonet.Init;
 Begin
   Inherited Init;
   ExecTask(New(PIdle,Init(KernelSelf)));
   Rc:=3;
 End;

 Procedure TSonet.Handlevent;
 Begin
   Inherited Handlevent(Event);
   If Event.What And evMouseLup<>0 Then
    Rc:=3;
   If Event.What And evMouseLdown<>0 Then
    Rc:=4;
   If Event.What=evKeyboard Then
    Case Event.CharCode of
      #27:ShutDown:=True;
      'a':Sound(20);
      's':NoSound;
    End;
   If Event.What And evMouse<>0 Then
    Begin
      HideMouse;
      Setcolor(0);
      Graph.Rectangle(OldMouseWhere.X,OldMouseWhere.Y,
                OldMouseWhere.X+100,OldMouseWhere.Y+100);
      Setcolor(Rc);
      Graph.Rectangle(Event.Global.X,Event.Global.Y,
                Event.Global.X+100,Event.Global.Y+100);
      ShowMouse;
    End;
 End;

Var
  Sonet:TSonet;

Begin
  Sonet.Init;
  Sonet.Run;
  sonet.Done;
End.