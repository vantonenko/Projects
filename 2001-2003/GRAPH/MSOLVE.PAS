{$r+}
program msolve;
uses mouse,views,graph,crt;
const
  maxn=100;
  maxm=1000;
  maxint2=maxint*maxint*2;
var
  n,ncont,m,i,j,k,imin,jmin:word;
  x,y:array[1..maxn]of integer;
  a:array[1..maxn,1..maxn]of longint;
  nnew:array[1..maxn]of boolean;
  st:array[1..maxn]of byte;
  colors:array[1..maxn]of byte;
  v:array[1..maxn]of byte;
  color:byte;
  pos,vl,l:byte;
  gd,gr:integer;
  xi,yi,xj,yj,s,min:longint;
  p,busy,ispath:boolean;
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
procedure renew;
var
  i,j:byte;
begin
  setfillstyle(1,0);
  hidemouse;
  bar(6,6,633,443);
  showmouse;
  setcolor(10);
  for i:=1 to n do
   for j:=1 to n do
    if a[i,j]>0 then
     begin
       hidemouse;
       line(x[i],y[i],x[j],y[j]);
       showmouse;
     end;
  for j:=1 to n do
   begin
     hidemouse;
     setcolor(15);
     circle(x[j],y[j],2);
     setcolor(9);
     circle(x[j],y[j],4);
     showmouse;
   end;
end;
procedure handler(event:tevent);far;
begin
  if busy then
   exit;
  if event.what and evmousemove<>0 then
   drawxy;
  if event.what and (evmouseldown+evmouserdown)<>0 then
   begin
     if ispath then
      begin
        renew;
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
            if (i=ncont)or(i=maxm) then
             exit;
            inc(m);
            xi:=longint(x[ncont]);
            yi:=longint(y[ncont]);
            xj:=longint(x[i]);
            yj:=longint(y[i]);
            a[i,ncont]:=round(sqrt(sqr(xi-xj)+sqr(yi-yj)));
            a[ncont,i]:=a[i,ncont];
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
     if (event.what and evmouserdown<>0)and(n<>0) then
      begin
        fillchar(nnew
        ispath:=true;
      end;
   end;
end;
begin
  initgraph(gd,gr,'c:\bp\bgi');
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
       fillchar(a,sizeof(a),0);
       busy:=false;
     end;
  until c=#27;
  closegraph;
end.