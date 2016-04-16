Program MC_Jordan;
Uses Crt;
Const
  DatFile='Matrix.Dat';
  NMul=15;{кол-во елементарных преобразований данной матрицы}
  MaxNN=50;
  MaxSquare=10;{(1+sqrt(1+8*MaxNN))/2}
  MaxN:Byte=0;
Type
  TMatrix=Array[1..MaxNN,1..MaxNN]of LongInt;
  TVlasn=Record
    L,St:LongInt;
  End;
  TMode=(Left,Right);
Var
  ERROR:TEXT;
  Fdat:Text;
  Matr,E,C,Cc,Jordan:TMatrix;
  VlasniZnach:Array[1..MaxNN]of TVlasn;
  SetVlasn:Set of Byte;
  NVlasn,i,j,k,ei,ej:Byte;
  R:Array[0..MaxNN+1]of Byte;{ранги матриц A,A*A,...}
  ColSquare:Array[1..MaxSquare]of Byte;
  S:Word;
  JordanCount:Byte;

 Procedure MulMatr(Var Matr:TMatrix;E:TMatrix;Mode:TMode);
 var
   i,j,k:byte;
   S:Longint;
   C:TMatrix;
 Begin
   For i:=1 To MaxN Do
    For j:=1 To MaxN Do
     Begin
       S:=0;
       If Mode=Right Then
         For k:=1 To MaxN Do
          S:=S+Matr[i,k]*E[k,j]
        Else
         For k:=1 To MaxN Do
          S:=S+E[i,k]*Matr[k,j];
       C[i,j]:=S;
     End;
   Matr:=C;
 End;

 Procedure GetE(Var E:TMatrix;Var i,j:Byte);
 Begin
   i:=Random(MaxN)+1;
   j:=Random(MaxN)+1;
   If i=j Then
    i:=(j+1) Mod MaxN;
   E[i,j]:=1;
 End;

 Procedure OutPut(Matr:TMatrix);
 Var
   i,j:Byte;
 Begin
   ClrScr;
   For i:=1 To MaxN Do
   Begin
     For j:=1 To MaxN Do
      Write(Matr[i,j]:5);
     Writeln;
   End;
 End;

 Function NSDxy(X,Y:LongInt):LongInt;
 Begin
   While (X<>Y)And(X<>0)And(Y<>0) Do
    If X>Y Then
      X:=X Mod Y
     Else
      Y:=Y Mod X;
   If X=0 Then
     NSDxy:=Y
    Else
     NSDxy:=X;
 End;

 Function GetRang(M:TMatrix):Byte;
 Var
   i,j,k,R:Word;
   B1,B2,NSD,i0:LongInt;
 Begin
   R:=0;
   For i:=1 To MaxN Do
    Begin
      i0:=0;
      j:=0;
      While (j<MaxN)And(i0=0) Do
       Begin
         Inc(j);
         If M[i,j]<>0 Then
          i0:=j;
       End;
      If i0=0 Then
       Begin
         Inc(R);
         Continue;
       End;
      For k:=i+1 To MaxN Do
       If M[k,i0]<>0 Then
        Begin
          NSD:=NSDxy(Abs(M[i,i0]),Abs(M[k,i0]));
          B1:=M[i,i0] Div NSD;
          B2:=M[k,i0] Div NSD;
          WRITELN(ERROR,'i,k,i0,NSD,B1,B2:',
                   i:6,k:6,i0:6,NSD:6,B1:6,B2:6);
          FLUSH(ERROR);
          For j:=1 To MaxN Do
           Begin
             WRITELN(ERROR,'j:',j);
             FLUSH(ERROR);
             M[k,j]:=M[k,j]*B1-M[i,j]*B2;
           End;
        End;
    End;
   GetRang:=MaxN-R;
 End;

Begin
  ASSIGN(ERROR,'ERROR.TXT');
  REWRITE(ERROR);
  ClrScr;
  Assign(Fdat,DatFile);
  Reset(Fdat);
  Read(Fdat,MaxN);
  {Randomize;}
  For i:=1 To MaxN Do
   For j:=1 To MaxN do
    Read(Fdat,Matr[i,j]);
  OutPut(Matr);
  Close(Fdat);
  NVlasn:=0;
  SetVlasn:=[];
  For i:=1 To MaxN Do
   If Matr[i,i] In SetVlasn Then
     Inc(VlasniZnach[NVlasn].St)
    Else
     Begin
       Inc(NVlasn);
       VlasniZnach[NVlasn].L:=Matr[i,i];
       VlasniZnach[NVlasn].St:=1;
       SetVlasn:=SetVlasn+[Matr[i,i]];
     End;
  FillChar(E,Sizeof(E),0);
  For K:=1 To MaxN Do
   E[k,k]:=1;
  For k:=1 To NMul Do
   Begin
     GetE(E,ei,ej);
     MulMatr(Matr,E,Right);
     E[ei,ej]:=-E[ei,ej];
     MulMatr(Matr,E,Left);
     E[ei,ej]:=0;
   End;
  OutPut(Matr);
  FillChar(Jordan,Sizeof(Jordan),0);
  JordanCount:=0;
  For k:=1 To NVlasn Do
   With VlasniZnach[k] Do
    Begin
      C:=Matr;
      For i:=1 To MaxN Do
       C[i,i]:=C[i,i]-L;
      Cc:=C;
      S:=0;
      i:=0;
      FillChar(R,Sizeof(R),0);
      FillChar(ColSquare,Sizeof(ColSquare),0);
      R[0]:=MaxN;
      If St=1 Then
        ColSquare[1]:=1
       Else
        While (S<St) And (i<St) Do
         Begin
           Inc(i);
           WRITELN(ERROR,'i,k:',i,' ',k,' ');
           FLUSH(ERROR);
           R[i]:=GetRang(C);
           If i>=2 Then
            Begin
              ColSquare[i-1]:=R[i-2]-2*R[i-1]+R[i];
              S:=S+(i-1)*ColSquare[i-1];
            End;
           MulMatr(C,Cc,Right);
         End;
        If ColSquare[i]=0 Then
         ColSquare[i]:=R[i-1]-R[i];
      i:=i;
    End;
  ReadKey;
End.