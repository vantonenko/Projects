Unit Kernel;

Interface
Uses Dos;
Const
  {"Events"}
  evNothing=0;
  evMouse=$7f;
  evKeyboard=$80;
  evMessage=$300;
  {"evMouse"}
  evMouseLdown=$1;
  evMouseLup=$2;
  evMouseRdown=$4;
  evMouseRup=$8;
  evMouseMove=$10;
  evMouseAuto=$20;
  evMousePromt=$40;
  {"evKeyboard"}
  evKeydown=$80;
  {"evMessage"}
  evCommand=$100;
  evBroadCast=$200;
  {"Serve"}
  svRShift=$1;
  svLShift=$2;
  svCtrl=$4;
  svAlt=$8;
  svScrollLock=$10;
  svNumLock=$20;
  svCapsLock=$40;
  svInsert=$80;

  SettingsPath='Settings';
  IniPath='Sonet.ini';
  PalettePath:PathStr='';

Type

  TPoint=Record
    X,Y:Integer;
  End;

  TRect=Object
    A,B:TPoint;
    Procedure Assign(X1,Y1,X2,Y2:Integer);
    Procedure Copy(R:TRect);
    Procedure Move(dx,dy:Integer);
    Procedure Grow(dx,dy:Integer);
    Procedure Inter(R:TRect);
    Procedure Union(R:TRect);
    Function Contains(P:TPoint):Boolean;
    Function Equals(R:TRect):Boolean;
    Function Empty:Boolean;
  End;

  TEvent=Record
    What:Word;
    Case Word of
      evNothing:();
      evMouse:(
        Where,Global:TPoint;
        Double:Boolean;
        Buttons:Byte;
        Ctrl,Shift:Boolean);
      evKeyboard:(
        Serve:Byte;
        Case Byte of
          0:(KeyCode:Word);
          1:(CharCode:Char;
             ScanCode:Byte));
      evMessage:(
        Command:Word;
        Case Byte of
          0:(InfoPtr:Pointer);
          1:(InfoLong:LongInt);
          2:(InfoWord:Word));
  End;

  PVisibleRects=^TVisibleRects;
  TVisibleRects=Record
    R:TRect;
    Next:PVisibleRects;
  End;

  PGroup=^TGroup;
  PView=^TView;
  TView=Object
    Origin:TPoint;
    Size:TPoint;
    Global:TRect;
    Owner:PGroup;
    First:PView;
    Next:PView;
    VisibleRects:PVisibleRects;{"Local"}
    Constructor Init(R:TRect);
    Procedure HandlEvent(Var Event:TEvent);Virtual;
    Procedure Draw;Virtual;
    Destructor Done;Virtual;
    Procedure FindVisibleRects;Virtual;
    Procedure SetVisibleRects;
    Procedure Insert(View:PView);
    Procedure Delete(View:PView);
    {"R,X,Y-Local"}
    Procedure Rectangle(R:TRect;Color:Word);
    Procedure Bar(R:TRect;Color:Word);
    Procedure PutPixel(X,Y:Integer;Color:Word);
  End;

  TGroup=OBject(TView)
    Constructor Init(R:TRect);
  End;

  PTask=^TTask;
  TTask=Object
    Owner:PView;
    Constructor Init(aOwner:PView);
    Procedure Run;Virtual;
    Destructor Done;Virtual;
  End;

  PKeybTask=^TKeybTask;
  TKeybTask=Object(TTask)
    Procedure Run;Virtual;
  End;

  PEventTask=^TEventTask;
  TEventTask=Object(TTask)
    Procedure Run;Virtual;
  End;

  {PTimerTask=^TTimerTask;
  TTimerTask=Object(TTask)
    Constructor Init(aOwner:PView;Command:Word;aPeriod:Word;aOnce:Boolean);
    Procedure Run;Virtual;
  End;}

  PTaskList=^TTaskList;
  TTaskList=Record
    Task:PTask;
    Next:PTaskList;
  End;

  PEventList=^TEventList;
  TEventList=Record
    Event:Tevent;
    Next:PEventList;
  End;

  PKernel=^TKernel;
  TKernel=Object(TGroup)
    TaskList:PTaskList;
    CurTask:PTaskList;
    EventTask:PEventTask;
    KeybTask:PKeybTask;
    HeadEventList,EndEventList:PEventList;
    Constructor Init;
    Procedure Run;
    Destructor Done;Virtual;
    Procedure AddEvent(Event:TEvent);
    Procedure GetEvent(Var Event:TEvent);
    Procedure InitScreen;
    Procedure InitEvents;
    Procedure DoneScreen;
    Procedure DoneEvents;
    Procedure ExecTask(Task:PTask);
    Procedure FreeTask(Task:PTask);
    Procedure FreeAllTask;
    Procedure RunHaltError(Message:String);
  End;

  TVGAColor=Record
    Red,Green,Blue:Integer;
  End;

  TVGAPalette=Array [0..15] of TVGAColor;

 Procedure Delay(Ms:Word);

Const
  KernelSelf:PKernel=Nil;
  Shutdown:Boolean=False;
  RScreen:TRect=(A:(X:0;Y:0);B:(X:0;Y:0));
  OldMouseWhere:TPoint=(X:320;Y:240);
  MouseWhere:TPoint=(X:320;Y:240);
  MouseEventsHandlerType:Byte=0;

Var
  Clock_Val:Longint Absolute $0040:$006C;
  Serve_Val:Byte Absolute $0040:$0017;
  VGAPalette:TVGAPalette;

Implementation
Uses Graph,Mouse,Crt;

Const
  EGAColors:Array [0..15] of Byte=(0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);

 Procedure TRect.Assign;
 Begin
   A.X:=X1;
   A.Y:=Y1;
   B.X:=X2;
   B.Y:=Y2;
 End;

 Procedure TRect.Copy;
 Begin
   A:=R.A;
   B:=R.B;
 End;

 Procedure TRect.Move;
 Begin
   A.X:=A.X+dx;
   A.Y:=A.Y+dy;
   B.X:=B.X+dx;
   B.Y:=B.Y+dy;
 End;

 Procedure TRect.Grow;
 Begin
   B.X:=B.X+dx;
   B.Y:=B.Y+dy;
 End;

 Procedure TRect.Inter;
 Begin
   If R.A.X>A.X Then
    A.X:=R.A.X;
   If R.B.X<B.X Then
    B.X:=R.B.X;
   If R.A.Y>A.Y Then
    A.Y:=R.A.Y;
   If R.B.Y<B.Y Then
    B.Y:=R.B.Y;
 End;

 Procedure TRect.Union;
 Begin
   If R.A.X<A.X Then
    A.X:=R.A.X;
   If R.B.X>B.X Then
    B.X:=R.B.X;
   If R.A.Y<A.Y Then
    A.Y:=R.A.Y;
   If R.B.Y>B.Y Then
    B.Y:=R.B.Y;
 End;

 Function TRect.Contains;
 Begin
   Contains:=(P.X>=A.X) And (P.X<=B.X)and
             (P.Y>=A.Y) And (P.Y<=B.Y);
 End;

 Function TRect.Equals;
 Begin
   Equals:=(A.X=R.A.X) And (B.X=R.B.X) And
           (A.Y=R.A.Y) And (B.Y=R.B.Y);
 End;

 Function TRect.Empty;
 Begin
   Empty:=(B.X>=A.X) And (B.Y>=A.Y);
 End;

 Constructor TView.Init;
 Begin
   Origin:=R.A;
   Size.X:=R.B.X-R.A.X;
   Size.Y:=R.B.Y-R.A.Y;
   Owner:=Nil;
   First:=Nil;
   Next:=Nil;
   VisibleRects:=Nil;
 End;

 Procedure TView.HandlEvent;
 Begin
   If Event.What And evMouse<>0 Then
    Begin

    End;
 End;

 Procedure TView.Draw;
 Var
   T:PView;
 Begin
   T:=First;
   While T<>Nil Do
    Begin
      T^.Draw;
      T:=T^.Next;
    End;
 End;

 Destructor TView.Done;
 Begin
 End;

 Procedure TView.FindVisibleRects;
 Begin
 End;

 Procedure TView.SetVisibleRects;
 Begin
   KernelSelf^.FindVisibleRects;
 End;

 Procedure TView.Insert;
 Begin
 End;

 Procedure TView.Delete;
 Begin
 End;

 Procedure TView.Rectangle;
 Begin
 End;

 Procedure TView.Bar;
 Begin
 End;

 Procedure TView.PutPixel;
 Begin
 End;

 Constructor TGroup.Init;
 Begin
 End;

 Constructor TTask.Init;
 Begin
 End;

 Procedure TTask.Run;
 Begin
 End;

 Destructor TTask.Done;
 Begin
 End;

 Procedure TKeybTask.Run;
 Var
   Event:TEvent;
 Begin
   If KeyPressed Then
    With Event Do
     Begin
       What:=evKeyboard;
       CharCode:=ReadKey;
       If CharCode=#0 Then
        KeyCode:=Ord(ReadKey);
       KernelSelf^.HandlEvent(Event);
     End;
 End;

 Procedure TEventTask.Run;
 Var
   Event:TEvent;
 Begin
   DisableMouse:=True;
   With KernelSelf^ Do
    While EndEventList<>Nil Do
     Begin
       GetEvent(Event);
       OldMouseWhere:=MouseWhere;
       MouseWhere:=Event.Global;
       DisableMouse:=False;
       HandlEvent(Event);
       DisableMouse:=True;
       If MouseEventsHandlerType=1 Then
        Break;
     End;
   DisableMouse:=False;
 End;

 Constructor TKernel.Init;
 Begin
   TaskList:=Nil;
   KernelSelf:=@Self;
   CurTask:=Nil;
   InitScreen;
   InitEvents;
 End;

 Procedure TKernel.Run;
 Var
   T:PTaskList;
 Begin
   Repeat
     T:=TaskList;
     While T<>Nil Do
      Begin
        CurTask:=T;
        T^.Task^.Run;
        T:=T^.Next;
        EventTask^.Run;
        KeybTask^.Run;
      End;
   Until Shutdown;
 End;

 Destructor TKernel.Done;
 Begin
   DoneEvents;
   DoneScreen;
   FreeAllTask;
   KernelSelf:=Nil;
 End;

 Procedure TKernel.AddEvent;
 Var
   T:PEventList;
 Begin
   New(T);
   T^.Event:=Event;
   T^.Next:=Nil;
   If HeadEventList=Nil Then
     EndEventList:=T
    Else
     HeadEventList^.Next:=T;
   HeadEventList:=T;
 End;

 Procedure TKernel.GetEvent;
 Var
   T:PEventList;
 Begin
   T:=EndEventList;
   Event:=T^.Event;
   EndEventList:=EndEventList^.Next;
   If EndEventList=Nil Then
    HeadEventList:=Nil;
   Dispose(T);
 End;

 Procedure TKernel.InitScreen;
 Var
   Gd,Gm,i:Integer;
   Fpal,Fini:Text;
 Begin
   Gd:=Vga;
   Gm:=VgaHi;
   InitGraph(Gd,Gm,'Bgi');
   RScreen.Assign(0,0,GetMaxX,GetMaxY);
   Assign(Fini,IniPath);
   {$I-}
   Reset(Fini);
   If IOResult<>0 Then
    RunHaltError('Не найден "ini"-файл!');
   Readln(Fini);
   Readln(Fini,PalettePath);
   Readln(Fini);
   Readln(Fini,MouseEventsHandlerType);
   Close(Fini);
   Assign(Fpal,PalettePath);
   Reset(Fpal);
   {$I+}
   If IOResult<>0 Then
    Exit;
   For i:=0 to 15 do
    With VGAPalette[i] Do
     Begin
       Readln(Fpal,Red,Green,Blue);
       SetRGBPalette(EGAColors[i],Red,Green,Blue);
     End;
 End;

 Procedure TKernel.InitEvents;
 Begin
   InitMouse;
   KeybTask:=New(PKeybTask,Init(KernelSelf));
   EventTask:=New(PEventTask,Init(KernelSelf));
 End;

 Procedure TKernel.DoneScreen;
 Begin
   CloseGraph;
 End;

 Procedure TKernel.DoneEvents;
 Var
   Event:TEvent;
 Begin
   DoneMouse;
   While EndEventList<>Nil Do
    GetEvent(Event);
 End;

 Procedure TKernel.ExecTask;
 Var
   T:PTaskList;
 Begin
   New(T);
   T^.Task:=Task;
   If (CurTask=Nil)or(TaskList=Nil) Then
     Begin
       T^.Next:=Nil;
       CurTask:=T;
       TaskList:=T;
     End
    Else
     Begin
       T^.Next:=CurTask^.Next;
       CurTask^.Next:=T;
     End;
 End;

 Procedure TKernel.FreeTask;
 Var
   T:PTaskList;
 Begin
   T:=TaskList;
   If (T=Nil)or(Task=Nil) Then
    Exit;
   While T^.Next^.Task<>Task Do
    T:=T^.Next;
   If T^.Next^.Task=Task Then
    Begin
      T^.Next:=T^.Next^.Next;
      If CurTask^.Task=Task Then
       CurTask:=Nil;
      Dispose(Task);
    End;
 End;

 Procedure TKernel.FreeAllTask;
 Var
   T:PTaskList;
 Begin
   While TaskList<>Nil Do
    Begin
      T:=TaskList;
      TaskList:=TaskList^.Next;
      Dispose(T);
    End;
 End;

 Procedure TKernel.RunHaltError;
 Begin
   CloseGraph;
   Writeln(Message);
   Writeln('Нажмите любую клавишу для выхода...');
   ReadKey;
   Halt;
 End;

 Procedure Delay;Assembler;
 Asm
   Mov Ax, 1000;
   Mul Ms;
   Mov Cx, Dx;
   Mov Dx, Ax;
   Mov Ah, $86;
   Int $15;
 End;

End.