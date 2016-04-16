program maldebort;
uses crt,graph;
type
  complex=record
    real:extended;
    imag:extended;
  end;
const
  maxiter=30;
  bailout=16;
var
  working,working2,backup:complex;
  x,y,count:integer;
  cancel:boolean;
procedure complexsquare(a:complex;var result:complex);
begin
  result.real:=(sqr(a.real)-sqr(a.imag));
  result.imag:=2*a.real*a.imag;
end;
procedure complexadd(a,b:complex;var result:complex);
begin
  result.real:=a.real+b.real;
  result.imag:=a.imag+b.imag;
end;
procedure tocomplex(a,b:extended;var result:complex);
begin
  result.real:=a;
  result.imag:=b;
end;
begin
  cancel:=false;
  randomize;
  initgraph(x,y,'..\..\bp\bgi');
  for y:=-getmaxy div 2 to 0 do
   for x:=-getmaxx div 2 to getmaxx div 2 do
    begin
      count:=0;
      tocomplex(x/200,y/200,backup);
      tocomplex(0,0,working);
      while ((sqr(working.real)+sqr(working.imag))<bailout)and(count<maxiter) do
       begin
         working2:=working;
         complexsquare(working2,working);
         complexadd(working,backup,working2);
         working:=working2;
         inc(count);
         if keypressed then
          begin
            readkey;
            count:=maxiter;
            x:=161;
            y:=101;
            cancel:=true;
          end;
       end;
      if count<>maxiter then
        begin
          putpixel(getmaxx div 2+x,getmaxy div 2+y,255-((count mod 254)+2));
          putpixel(getmaxx div 2+x,getmaxy div 2+abs(y),255-((count mod 254)+2));
        end
       else
        begin
          putpixel(getmaxx div 2+x,getmaxy div 2+y,0);
          putpixel(getmaxy div 2+x,getmaxy div 2+abs(y),0);
        end;
      if cancel then
       exit;
    end;
  while not keypressed do
   begin
     setpalette(random(16),random(16));
     delay(50);
   end;
  readkey;
  closegraph;
end.