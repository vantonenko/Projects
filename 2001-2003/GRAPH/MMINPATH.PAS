program mminpath;
uses mouse,views,graph,crt;
const
  maxn=100;
  maxm=1000;
  maxint2=maxint*maxint*2;
var
  n,n1,n2,m,ncont,pcont,i,j,k,imin,jmin:word;
  x,y:array[1..maxn]of integer;
  r:array[1..2,1..maxm]of word;
  d:array[1..maxm]of longint;
  l:array[1..maxn]of longint;
  s:array[1..maxn]of byte;
  gd,gr:integer;
  xi,yi,xj,yj,dl:longint;
  busy,f,ispath:boolean;
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
  if (mousewhere.x=639)and(mousewhere.y=0) then
   begin
     CloseGraph;
     halt;
   end;
  if busy then
   exit;
  if event.what and evmousemove<>0 then
   drawxy;
  if event.what and (evmouseldown+evmouserdown)<>0 then
   begin
     if ispath then
      begin
        for j:=1 to n do
         begin
           hidemouse;
           setcolor(15);
           circle(x[j],y[j],2);
           setcolor(9);
           circle(x[j],y[j],4);
           showmouse;
         end;
        setcolor(10);
        hidemouse;
        for j:=1 to m do
         line(x[r[1,j]],y[r[1,j]],x[r[2,j]],y[r[2,j]]);
        showmouse;
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
            if n=maxn then
             exit;
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
     if event.what and evmouserdown<>0 then
      if i<=n then
        if pcont<>0 then
          begin
            {searchpath}
            for j:=1 to n do
             l[j]:=maxint2;
            l[i]:=0;
            for j:=1 to n do
             s[j]:=0;
            f:=true;
            while f do
             begin
               f:=false;
               for j:=1 to m do
                begin
                  n1:=r[1,j];
                  n2:=r[2,j];
                  dl:=d[j];
                  if l[n2]>l[n1]+dl then
                    begin
                      l[n2]:=l[n1]+dl;
                      s[n2]:=n1;
                      f:=true;
                    end
                   else
                    if l[n1]>l[n2]+dl then
                     begin
                       l[n1]:=l[n2]+dl;
                       s[n1]:=n2;
                       f:=true;
                     end;
                end;
             end;
            if s[pcont]<>0 then
              begin
                j:=pcont;
                setcolor(12);
                hidemouse;
                repeat
                  line(x[j],y[j],x[s[j]],y[s[j]]);
                  j:=s[j];
                until j=i;
                showmouse;
                ispath:=true;
              end
             else
              begin
                hidemouse;
                setcolor(15);
                circle(x[pcont],y[pcont],2);
                setcolor(9);
                circle(x[pcont],y[pcont],4);
                showmouse;
              end;
            pcont:=0;
          end
         else
          begin
            pcont:=i;
            setcolor(12);
            hidemouse;
            circle(x[i],y[i],4);
            showmouse;
          end
       else
        if pcont<>0 then
         begin
           hidemouse;
           setcolor(15);
           circle(x[pcont],y[pcont],2);
           setcolor(9);
           circle(x[pcont],y[pcont],4);
           showmouse;
           pcont:=0;
         end;
   end;
end;
begin
  initgraph(gd,gr,'');
  setfillstyle(1,0);
  setcolor(15);
  rectangle(5,5,634,444);
  n:=0;
  ncont:=0;
  pcont:=0;
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