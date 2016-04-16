program sonet_;
uses graph,mouse,kernel,sources,crt;
const
  settingspath='settings\';
  inipath='sonet.ini';
  palettepath:string[8]='';
  mousecursorpath:string[8]='';
type
  tsonet=object(tkernel)
    constructor init;
    procedure handlevent(var event:tevent);virtual;
    destructor done;virtual;
  end;
  pmywindow=^tmywindow;
  tmywindow=object(twindow)
    constructor init(r:trect);
  end;
  pmyfolderman=^tmyfolderman;
  tmyfolderman=object(tfolderman)
    timer:ptask;
    p:tpoint;
    color:byte;
    constructor init(r:trect);
    procedure handlevent(var event:tevent);virtual;
    procedure draw;virtual;
    destructor done;virtual;
  end;
var
  sonet:tsonet;
  font:tfont;
  b:byte;
constructor tsonet.init;
var
  fini,fpal:text;
  i,j:integer;
  r:trect;
begin
  shutdown:=false;
  assign(fini,inipath);
  reset(fini);
  readln(fini);
  readln(fini,palettepath);
  close(fini);
  assign(fpal,settingspath+palettepath+'.pal');
  reset(fpal);
  for i:=0 to 15 do
   with palette[i] do
    read(fpal,r,g,b);
  close(fpal);
  inherited init;
  r.a.x:=50;
  r.a.y:=50;
  r.b.x:=300;
  r.b.y:=200;
  r.move(50,50);
  insert(new(pmywindow,init(r)));
  font.font:=2;
  font.charsize:=5;
  insert(new(pdialogbutton,init(10,440,cmrefresh,false,'Refresh',font)));
end;
procedure tsonet.handlevent;
var
  r:trect;
begin
  inherited handlevent(event);
  if event.what=evkeyboard then
   begin
     case event.charcode of
       #27:begin
             event.what:=evcommand;
             event.command:=cmshutdown;
             putevent(event);
           end;
       #13:sonet.newtask(new(ptimertask,init(@self,cmtime,36,false)),0);
       '%':tasks:=nil;
        #9:begin
             event.what:=evcommand;
             event.command:=cmrefresh;
             putevent(event);
           end;
      else
       sonet.newtask(new(ptimertask,init(@self,cmtime,50,true)),0);
     end;
     if not event.putflag then
      clearevent(event);
   end;
  if (event.double and(event.what and evmouse<>0))or
     ((event.what and evcommand<>0)and(event.command=cmnothing)) then
   begin
     sonet.newtask(new(ptimertask,init(@self,cmtime,6,true)),0);
     clearevent(event);
   end;
  if (event.what and evcommand<>0)and((event.command=cmtime){or(event.command=cmnothing)}) then
   begin
     sound(50);
     delay(1);
     nosound;
     clearevent(event);
     r.a.x:=0;r.a.y:=0;
     r.b.x:=300;r.b.y:=200;
     r.move(random(400),random(200));
     insert(new(pmywindow,init(r)));
   end;
end;

destructor tsonet.done;
begin
  inherited done;
end;

constructor tmywindow.init;
begin
  font.font:=2;
  font.charsize:=5;
  b:=btclose;
  inherited init('Window for Example #1.',font,r,b);
  if random(2)=0 then
    begin
      font.font:=2;
      font.charsize:=8;
      insert(new(pdialogbutton,init(r.a.x+20,r.a.y+50,cmshutdown,false,'Shutdown',font)));
      font.charsize:=5;
      insert(new(pdialogbutton,init(r.a.x+20,r.b.y-50,cmclose,false,'OK',font)));
      insert(new(pdialogbutton,init(r.a.x+100,r.b.y-50,cmclose,false,'Cencel',font)));
      insert(new(pdialogbutton,init(r.a.x+200,r.b.y-50,0,false,'New',font)));
      insert(new(pdialogbutton,init(r.a.x+170,r.a.y+50,cmokay,false,'Nosing',font)));
    end
   else
    begin
      r.a.x:=r.a.x+3;
      r.a.y:=r.a.y+titleheight+6;
      r.b.x:=r.b.x-3;
      r.b.y:=r.b.y-3;
      insert(new(pmyfolderman,init(r)));
    end;
end;

constructor tmyfolderman.init;
begin
  inherited init(r);
  timer:=new(ptask,init(@self,cmtime));
  sonet.newtask(timer,0);
  p.x:=0;
  color:=0;
end;

procedure tmyfolderman.handlevent;
var
  j,i:integer;
begin
  inherited handlevent(event);
  if (event.what and evcommand<>0)and(event.command=cmtime) then
   for i:=1 to 10 do
    begin
      asm
        sti
      end;
      for j:=global.y+20 to global.y+40 do
       putpixel(global.x+20+p.x,j,color);
      asm
        cli
      end;
      p.x:=p.x+1;
      if p.x>size.x-40 then
       begin
         p.x:=0;
         if color=12 then
           color:=0
          else
           color:=12;
       end;
   end;
end;

procedure tmyfolderman.draw;
var
  i,j:integer;
  adr:word;
begin
  inherited draw;
  hidemouse;
  for j:=global.y+20 to global.y+40 do
   begin
     for i:=global.x+20 to global.x+20+p.x do
      begin
        if not((i>=0)and(i<=639)and(j>=0)and(j<=479)) then
         continue;
        port[$3ce]:=5;
        port[$3cf]:=2;
        adr:=j shl 6+j shl 4+i div 8;
        port[$3ce]:=8;
        port[$3cf]:=128 shr (i mod 8);
        b:=mem[sega000:adr];
        mem[sega000:adr]:=0;
      end;
     for i:=global.x+20+p.x+1 to global.x+size.x-20 do
      begin
        if not((i>=0)and(i<=639)and(j>=0)and(j<=479)) then
         continue;
        port[$3ce]:=5;
        port[$3cf]:=2;
        adr:=j shl 6+j shl 4+i div 8;
        port[$3ce]:=8;
        port[$3cf]:=128 shr (i mod 8);
        b:=mem[sega000:adr];
        mem[sega000:adr]:=12;
      end;
   end;
  showmouse;
end;


destructor tmyfolderman.done;
begin
  sonet.killtask(timer);
  inherited done;
end;

begin
  sonet.init;
  sonet.run;
  sonet.done;
end.