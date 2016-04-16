{$r+}
program mgamil;
uses mouse,views,graph,crt;
const
  maxn=100;
  maxm=1000;
  maxint2=maxint*maxint*2;
type
  tset=set of byte;
var
  n,ncont,m,i,j,k,imin,jmin:word;
  x,y:array[1..maxn]of integer;
  a:array[1..maxn,1..maxn]of longint;
  gset:array[1..maxn]of tset;
  nnew:array[1..maxn]of boolean;
  st:array[1..maxn]of byte;
  pos,v,l:byte;
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
  setcolor(10);
  for i:=1 to n do
   for j:=1 to n do
    if a[i,j]<>0 then
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
  if (mousewhere.x=639)and(mousewhere.y=0) then halt;
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
            if (i=ncont)or(i=maxn) then
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
     if event.what and evmouserdown<>0 then
      begin
        for i:=1 to n do
         gset[i]:=[];
        fillchar(nnew,n,true);
        pos:=1;
        st[pos]:=1;
        nnew[pos]:=false;
        k:=0;
        min:=maxint2;
        setcolor(15);
        outtextxy(100,447,'Digit...');
        while pos<>0 do
         begin
           v:=st[pos];
           l:=0;
           repeat
             if (a[v,l+1]<>0)and(l=0)and(k=n-1) then
              begin
                inc(pos);
                st[pos]:=1;
                setcolor(12);
                for j:=2 to pos do
                 begin
                   xi:=x[st[j]];
                   yi:=y[st[j]];
                   xj:=x[st[j-1]];
                   yj:=y[st[j-1]];
                   hidemouse;
                   line(xi,yi,xj,yj);
                   showmouse;
                 end;
                dec(pos);
                setcolor(0);
                outtextxy(100,447,'Digit...');
                ispath:=true;
                exit;
              end;
             p:=(a[v,l+1]<>0)and nnew[l+1] and not((l+1) in gset[v]);
             inc(l);
             if keypressed then
              begin
                setcolor(0);
                outtextxy(100,447,'Digit...');
                exit;
              end;
           until p or (l+1>n);
           if p then
             begin
               inc(k);
               nnew[l]:=false;
               inc(pos);
               st[pos]:=l;
             end
            else
             begin
               nnew[v]:=true;
               gset[v]:=[];
               dec(pos);
               dec(k);
               if pos<>0 then
                begin
                  j:=st[pos];
                  gset[j]:=gset[j]+[v];
                end;
             end;
         end;
        ispath:=true;
        setcolor(0);
        outtextxy(100,447,'Digit...');
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
       fillchar(a,sizeof(a),0);
       busy:=false;
     end;
  until c=#27;
end.