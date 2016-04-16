program mminder;
uses mouse,views,graph,crt;
const
  maxn=100;
  maxm=1000;
  maxint2=maxint*maxint*2;
var
  n,ncont,m,i,j,k,imin,jmin:word;
  x,y:array[1..maxn]of integer;
  v:array[1..maxn]of byte;
  r:array[1..2,1..maxm]of word;
  d:array[1..maxm]of longint;
  gd,gr:integer;
  min,xi,yi,xj,yj:longint;
  busy,ispath:boolean;
  c:char;
  sx,sy,oldsx,oldsy:string;
procedure drawxy;
begin
  str(mousewhere.x,sx);
  str(mousewhere.y,sy);
  setcolor(0);
  hidemouse;
  outtextxy(10,447,oldsx+' '+oldsy);
  setcolor(15);
  outtextxy(10,447,sx+' '+sy);
  showmouse;
  oldsx:=sx;
  oldsy:=sy;
end;
procedure handler(event:tevent);far;
begin
  if (mousewhere.x=639)and(mousewhere.y=0) then halt;
  if busy then
   exit;
  if event.what and evmousemove<>0 then
   drawxy;
  if event.what and (evmouseldown+evmouserdown)<>0 then
   begin
     if ispath then
      begin
        setcolor(10);
        hidemouse;
        for j:=1 to m do
         line(x[r[1,j]],y[r[1,j]],x[r[2,j]],y[r[2,j]]);
        showmouse;
        for j:=1 to n do
         begin
           hidemouse;
           setcolor(15);
           circle(x[j],y[j],2);
           setcolor(9);
           circle(x[j],y[j],4);
           showmouse;
         end;
        ispath:=false;
      end;
     if (mousewhere.y>=440)or
        (mousewhere.y<=9)or(mousewhere.x<=9)or
        (mousewhere.x>=630) then exit;
     i:=1;
     while (i<=n)and((abs(x[i]-mousewhere.x)>6)or
           (abs(y[i]-mousewhere.y)>6))do
      inc(i);
     if event.what and evmouseldown<>0 then
      if i>n then
        if ncont<>0 then
          begin
            hidemouse;
            setcolor(15);
            circle(x[ncont],y[ncont],2);
            setcolor(9);
            circle(x[ncont],y[ncont],4);
            showmouse;
            ncont:=0;
          end
         else
          begin
            inc(n);
            x[n]:=mousewhere.x;
            y[n]:=mousewhere.y;
            hidemouse;
            setcolor(15);
            circle(x[n],y[n],2);
            setcolor(9);
            circle(x[n],y[n],4);
            showmouse;
          end
       else
        if ncont<>0 then
          begin
            if (m=maxm)or(i=ncont) then
             exit;
            inc(m);
            r[1,m]:=ncont;
            r[2,m]:=i;
            xi:=longint(x[ncont]);
            yi:=longint(y[ncont]);
            xj:=longint(x[i]);
            yj:=longint(y[i]);
            d[m]:=round(sqrt(sqr(xi-xj)+sqr(yi-yj)));
            hidemouse;
            setcolor(15);
            circle(x[ncont],y[ncont],2);
            setcolor(9);
            circle(x[ncont],y[ncont],4);
            setcolor(10);
            line(x[ncont],y[ncont],x[i],y[i]);
            showmouse;
            ncont:=0;
          end
         else
          begin
            ncont:=i;
            hidemouse;
            setcolor(10);
            circle(x[i],y[i],4);
            showmouse;
          end;
     if (event.what and evmouserdown<>0)and(m<>0) then
      begin
        for i:=1 to n do
         v[i]:=0;
        v[r[1,1]]:=1;
        setcolor(12);
        for k:=1 to n-1 do
         begin
           min:=maxint2;
           for i:=1 to m do
            if (v[r[1,i]]+v[r[2,i]]=1)and(d[i]<min)then
             begin
               imin:=r[1,i];
               jmin:=r[2,i];
               min:=d[i];
             end;
           v[imin]:=1;
           v[jmin]:=1;
           hidemouse;
           line(x[imin],y[imin],x[jmin],y[jmin]);
           showmouse;
         end;
        ispath:=true;
      end;
   end;
end;
begin
  initgraph(gd,gr,'c:\programs\bp\bgi');
  setfillstyle(1,0);
  setcolor(15);
  rectangle(5,5,634,444);
  n:=0;
  ncont:=0;
  busy:=false;
  ispath:=false;
  oldsx:='';
  oldsy:='';
  mousehandleron(handler);
  setmousespeed(4,4);
  drawxy;
  showmouse;
  repeat
    c:=readkey;
    if (c=#13)and(n<>0) then
     begin
       busy:=true;
       n:=0;
       m:=0;
       hidemouse;
       bar(6,6,633,443);
       drawxy;
       showmouse;
       busy:=false;
     end;
  until c=#27;
end.