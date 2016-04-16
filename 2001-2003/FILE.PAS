program files;
uses dos,crt,f_mouse,graph;
const
  metri=100;
  size=2048*metri;
  k=64;{col-vo sectorov za 1 raz}
  cl=512*k;
  path='f:\segate\1f2.sol';
  sf=0;
  x100=32;
  y100=32;
type
  plist=^tlist;
  tlist=record
    a:pointer;
    next:plist;
  end;
var
  f1,f2,f3,f11,f22,f33:file;
  timer:longint absolute $0:$046c;
  m:array[1..512]of byte;
  t,t1:longint;
  i,j:longint;
  list:plist;
  image,ground:pointer;
  oldx,oldy:integer;
procedure gen;
var
  i:word;
begin
  for i:=1 to 512 do
   m[i]:=random(256);
end;
procedure handler(mask,butt,x,y,dx,dy:integer);far;
var
  t:plist;
begin
  if (x<>oldx)or(y<>oldy)then
   begin
     {putimage(oldx,oldy,ground^,0);}
     setfillstyle(1,0);
     bar(oldx,oldy,oldx+x100,oldy+y100);
     oldx:=x;
     oldy:=y;
     setfillstyle(1,9);
     bar(oldx,oldy,oldx+x100,oldy+y100);
     {putimage(oldx,oldy,image^,0);}
   end;
  {list:=nil;
  for j:=1 to 1000 do
   begin
     new(t);
     t^.a:=pointer(i);
     t^.next:=list;
     list:=t;
   end;
  while list<>nil do
   begin
     t:=list;
     list:=list^.next;
     dispose(t);
   end;}
end;
var
  gd,gm:integer;
  sizeim:word;
begin
  clrscr;
  {assign(f1,'c:\bp\avp\k1\f1.dat');
  rewrite(f1,cl);}
  assign(f2,path);
  rewrite(f2,cl);
  assign(f3,'f:\segate\f3.sol');
  rewrite(f3,cl);
  {assign(f3,path);
  reset(f3,cl);}
  initgraph(gd,gm,'f:\segate\programs\bp\bgi');
  {sizeim:=imagesize(1,1,x100,x100);
  getmem(ground,sizeim);
  getimage(1,1,x100,x100,ground^);
  for i:=1 to x100 do
   for j:=1 to x100 do
    putpixel(i,j,random(15)+1);
  getmem(image,sizeim);
  getimage(1,1,x100,x100,image^);
  putimage(1,1,ground^,0);}
  initmouse;
  oldx:=wherex;
  oldy:=wherey;
  {putimage(oldx,oldy,image^,0);}
  setlinestyle(2,0,1);
  setfillstyle(1,1);
  setmousehandler(255,handler);
  {assign(f11,'c:\bp\avp\k1\f1.sol');
  rewrite(f11,cl);
  assign(f22,'c:\bp\avp\k2\f2.sol');
  rewrite(f22,cl);
  assign(f33,'c:\bp\avp\k2\k3\f3.sol');
  rewrite(f33,cl);}
  gotoxy(6,6);
  t:=timer;
  line(501,100,501,130);
  setcolor(9);
  for i:=1 to size{*2} div k do
   begin
     {gen;
     blockwrite(f1,m,1);
     gen;
     blockwrite(f2,m,1);
     gen;}
     {blockread(f3,m,1);}
     line(200+round(i*300/(size{*2} div k)),100,200+round(i*300/(size{*2} div k)),130);
     if i mod 2<>3 then
       blockwrite(f2,m,1)
      else
       blockwrite(f3,m,1);
     if keypressed then
      break;
   end;
  t1:=timer;
  {close(f1);}
  close(f2);
  close(f3);
  {readln;
  erase(f3);
  writeln('hj');}
  readln;
  {freemem(ground,sizeim);
  freemem(image,sizeim);}
  closegraph;
  writeln;
  writeln((t1-t)/18.2:0:2,' sec');
  writeln(i/((t1-t)/18.2):0:2,' per/sec');
  readln;
  {close(f11);
  close(f22);
  close(f33);}
  textcolor(7);
end.