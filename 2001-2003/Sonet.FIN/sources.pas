Unit Sources;

Interface
Uses Kernel;

Type

  PButton=^TButton;
  TButton=Object(TView)

    Constructor Init(R:TRect);
    Procedure Draw;Virtual;
    Procedure HandlEvent(Var Event:TEvent);Virtual;
  End;

Implementation

 Constructor TButton.Init;
 Begin
 End;

 Procedure TButton.Draw;
 Begin

 End;

 Procedure TButton.HandlEvent;
 Begin
 End;

End.