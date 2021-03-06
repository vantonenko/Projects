uses Crt;
Const NumMax=10;
var Numbers: array[1..NumMax] of integer;     {ᮤ�ন� �᫠ ��ࠦ����}
    AmountNumbers: integer;                   {���-�� �ᥫ}
    AmountAnagrams: Longint;                  {���-�� ����ࠬ�}
    AmountRearrangements: Longint;            {���-�� ����⠭����}
    OriginalExpression,Expression: string;    {��室��� ��ࠦ����, ����᪠� ������}
    Original: integer;                        {�᫮-����ࠬ��}
    f: text;

  procedure ChooseNumbers(var st: string); {�롨ࠥ� �� ��ࠦ���� �᫠.}
  var i,s: byte;                           {��᫠ ࠧ������� ����⢨ﬨ}
      Code: integer;                 {�࠭�� � ࠧ��� �������� ���ᨢ�.}
      stv: string;                   {�����塞 �᫠ ��⨭᪨�� �㪢���.}
  begin
    i:=1;
    repeat

      if st[i] in ['0'..'9'] then    {�᫨ ��諨 �᫮: �������. ��� ��砫�}
        begin
          s:=i; Inc(AmountNumbers); stv:=''; {㢥�. ���稪; stv - ����� ���.}

          repeat
            stv:=stv+st[i];                     {���뢠�� �᫮ � stv}
            Inc(i)
          until (i>Length(st)) or not(st[i] in ['0'..'9']);

          val(stv,Numbers[AmountNumbers],Code); {��ॢ���� ��ப� � �᫮}
          Delete(st,s,i-s);                     {㤠�塞 �᫮ �� ��ப�}
          Insert(chr(96+AmountNumbers),st,s); {�����塞 ��� ��⨭᪮� �㪢��}

          i:=s+1;
        end;

      Inc(i)
    until i>Length(st)
  end; {ChooseNumbers}

  procedure SortNumbers;                 {�����㥬 ���ᨢ �ᥫ Numbers}
  var i,j,m,a,b: integer;                {� ���塞 ᮮ⢥��⢥��� �㪢� �}
      ch: char;                           {Expression}
  begin
    for i:=1 to AmountNumbers-1 do
      for j:=i+1 to AmountNumbers do     {������ ���஢�� �� �㦭�, �.�.}
        if Numbers[i]>Numbers[j] then    {���-�� �ᥫ ������讥}
          begin
            m:=Numbers[i];
            Numbers[i]:=Numbers[j];      {����� Numbers[i] � Numbers[j]}
            Numbers[j]:=m;

            a:=Pos(chr(96+i),Expression);   {��室�� ��뫪� �� Numbers[i]}
            b:=Pos(chr(96+j),Expression);   {��室�� ��뫪� �� Numbers[j]}

            ch:=Expression[a];
            Expression[a]:=Expression[b];   {���� �㪢 Expression[i] �}
            Expression[b]:=ch               {Expression[j] }
          end
  end; {SortNumbers}

  function Rearrangements: boolean;      {����砥� ᫥������ ����⠭����}
  Var i,k,m: Integer;                    {�����᪠� ����⠭����}
  Begin
    Rearrangements:=True;

    i:=AmountNumbers; k:=0;
    while (k=0) and (i>1) do                {�饬 a[i-1]<a[i]}
      begin
        if Numbers[i-1]<Numbers[i] then k:=i-1;
        i:=i-1
      end;

    if k=0 then begin Rearrangements:=False; Exit end;   {�᫨ �� ��諨}

    i:=AmountNumbers;
    m:=0;

    While m=0 do                        {�饬 ��������� �������,}
      begin                             {�� ����訩 a[k] }
        if Numbers[k]<Numbers[i] then m:=i;
        i:=i-1
      end;

    i:=Numbers[k];
    Numbers[k]:=Numbers[m];     {����� ���祭�ﬨ a[k] � a[m]}
    Numbers[m]:=i;

    m:=1;
    while m<(AmountNumbers-k+1)/2 do
      begin
        i:=Numbers[k+m];     {㯮�冷稢��� 墮�� �� �����⠭��}
        Numbers[k+m]:=Numbers[AmountNumbers+1-m];
        Numbers[AmountNumbers+1-m]:=i;
        m:=m+1
     end;

     Inc(AmountRearrangements)  {㢥��稢��� ���稪 ����⠭����}
  end; {Rearrangements}

  procedure Poliz(var a: string);  {��ॢ���� ��ࠦ���� � "�������" ������}
  type chars=string[1];            {����� ���ᯥ�� ����஥ �������⭮�}
  var b: string;                   {���᫥��� ��ࠦ����}
      c,d,e: array[0..20] of chars;   {20 - �� ����. �᫮ ��������� ᪮���}
      i,m: byte;
  begin
    b:=''; m:=0; c[m]:=''; d[m]:=''; e[m]:='';
    for i:=1 to length(a) do
      case a[i] of
        'a'..'z': b:=b+a[i];
        '+','-': begin b:=b+d[m]+c[m]+e[m]; c[m]:=''; d[m]:=''; e[m]:=a[i] end;
        '*','/': begin b:=b+d[m]+c[m]; c[m]:=a[i]; d[m]:='' end;
        '^': begin b:=b+d[m]; d[m]:=a[i] end;
        '(': begin m:=m+1; c[m]:=''; d[m]:=''; e[m]:='' end;
        ')': begin b:=b+d[m]+c[m]+e[m]; m:=m-1 end
      end;
    a:=b+d[m]+c[m]+e[m]
  end;

  function Calc: integer;     {������ Expression}
  var i,Top: integer;         {����� 'a'..'z' ����⠢��� �᫠ �� Numbers}
      steck: array[1..NumMax] of integer;
      Len: byte absolute Expression;
  begin
    Top:=0;
    for i:=1 to Len do
      case Expression[i] of
        'a'..'z': begin Inc(Top); Steck[Top]:=Numbers[Ord(Expression[i])-96] end;
        '+': begin Dec(Top); Steck[Top]:=Steck[Top]+Steck[Top+1] end;
        '-': begin Dec(Top); Steck[Top]:=Steck[Top]-Steck[Top+1] end;
        '*': begin Dec(Top); Steck[Top]:=Steck[Top]*Steck[Top+1] end;
        '/': begin Dec(Top); Steck[Top]:=Steck[Top] div Steck[Top+1] end
      end;
    Calc:=Steck[1]
  end; {Calc}

  procedure InputData;                        {������ ��室�� �����}
  begin
    ClrScr;
    Write('������ ��ࠦ����: ');
    ReadLn(Expression)
  end; {InputData}

  procedure OutAnagram;
  var i: integer;
  begin
    Inc(AmountAnagrams);         {㢥���. ���-�� ��������� ����ࠬ�}

    for i:=1 to Length(OriginalExpression) do
      if OriginalExpression[i] in ['a'..'z'] then
        begin
          Write(Numbers[Ord(OriginalExpression[i])-96]);    {�᫨ �㪢� - �뢮���}
          Write(f,Numbers[Ord(OriginalExpression[i])-96])   {�᫮ �� Numbers}
        end
      else
        begin
          Write(OriginalExpression[i]);
          Write(f,OriginalExpression[i])
        end;

    WriteLn(' = ',Original);    {����� १����, ���室 �� ����� ��ப�}
    WriteLn(f,' = ',Original)
  end; {OutAnagram}

begin
  AmountNumbers:=0;
  AmountAnagrams:=-1;        {��室��� ��ࠦ���� �� ����� ����ࠬ���}
  AmountRearrangements:=1;   {��室��� ��ࠦ���� ����� �� ����⠭����}

  InputData;                 {������ �����}
  ChooseNumbers(Expression); {�롨ࠥ� �᫠ �� ��ࠦ����, �����塞 �� �㪢���}
  SortNumbers;               {�����㥬 �᫠, � �㪢�}

  OriginalExpression:=Expression;
  Poliz(Expression);         {��ॢ���� � "�������" ������}
  Original:=Calc;            {����塞 ��ࠦ����}

  Assign(f,'anagram.out');
  ReWrite(f);

  Write('> ');   {�뢮��� � 䠩� ��室��� ��ࠦ����}
  Write(f,'> ');
  OutAnagram;

  While Rearrangements do              {�᫨ �஢�७� �� �� ����⠭����}
    if Calc=Original then OutAnagram;  {����⠭��������, �஢��塞, �뢮���}

  WriteLn('�ᥣ� ����⠭���� - ',AmountRearrangements,', �� ��� ����ࠬ� - ',
                                                          AmountAnagrams);
  WriteLn(f,'�ᥣ� ����⠭���� - ',AmountRearrangements,', �� ��� ����ࠬ� - ',
                                                          AmountAnagrams);
  Close(f)
end.