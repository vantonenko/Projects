{$r+}
program mnet;
uses mouse,views,graph,crt;
const
  maxn=100;
  maxm=1000;
  maxint2=maxint*maxint*2;
var
  n,ncont,m,i,j,k:word;
  x,y:array[1..maxn]of integer;
  a:array[1..maxn,1..maxn]of byte;
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
var
  num,lowpg:array[1..maxn]of word;
  col,pos:word;
  st:array[1..2,1..maxm]of byte;
  ncomp,startv:word;
function fmin(a,b:word):word;
begin
  if a<b then
    fmin:=a
   else
    fmin:=b;
end;
procedure search(v,p:byte);
var
  u:byte;
begin
  inc(col);
  num[v]:=col;
  lowpg[v]:=col;
  for u:=1 to n do
   if a[v,u]<>0 then
    if num[u]=0 then
      begin
        inc(pos);
        st[1,pos]:=v;
        st[2,pos]:=u;
        search(u,v);
        lowpg[v]:=fmin(lowpg[v],lowpg[u]);
        if lowpg[u]>=num[v] then
         begin
           inc(ncomp);
           if ncomp=10 then
            inc(ncomp);
           if ncomp=16 then
            ncomp:=9;
           setcolor(ncomp);
           repeat
             line(x[st[1,pos]],y[st[1,pos]],x[st[2,pos]],y[st[2,pos]]);
             dec(pos);
           until st[1,pos+1]=v;
           if v<>startv then
            begin
              setcolor(12);
              setfillstyle(1,15);
              bar(x[v]-2,y[v]-2,x[v]+2,y[v]+2);
            end;
         end;
      end
     else
      if (u<>p)and(num[v]>num[u]) then
       begin
         inc(pos);
         st[1,pos]:=v;
         st[2,pos]:=u;
         lowpg[v]:=fmin(lowpg[v],num[u]);
       end;
end;
procedure handler(event:tevent);far;
begin
  if (mousewhere.x>=635)and(mousewhere.y<=5)
   then halt;
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
            a[i,ncont]:=1;
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
        fillchar(num,sizeof(num),0);
        col:=0;
        pos:=0;
        fillchar(lowpg,sizeof(lowpg),0);
        for i:=1 to n do
         if num[i]=0 then
          begin
            ncomp:=9;
            startv:=i;
            search(i,0);
          end;
        ispath:=true;
      end;
   end;
end;
begin
  initgraph(gd,gr,'d:\projects\segate\programs\bp\bgi');
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
  setmousespeed(8,8);
  drawxy;
  showmouse;
  repeat
    c:=readkey;
    if (c=#13)and(n<>0) then
     begin
       busy:=true;
       n:=0;
       m:=0;
       setfillstyle(1,0);
       hidemouse;
       bar(6,6,633,443);
       drawxy;
       showmouse;
       fillchar(a,sizeof(a),0);
       busy:=false;
     end;
  until c=#27;
end.