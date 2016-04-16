{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 32767,0,200000}
program sonet_;
uses crt,graph,mouse,kernel,sources,dos,spaint{,timerman};
const
  settingspath='Settings';
  inifile='sonet.ini';
  palettefile:pathstr='';
  screensavertime:longint=0;
  scrsaverpath:pathstr='';

  shutdown:boolean=false;
  shutdowninit:boolean=false;
  shutdownview:boolean=false;
  shutdowntemp=10;
  shutdowncount=63;
  shutdowntype:0..1=0;
  pointscolor=0;
type
  tsonet=object(tgroup)
    constructor init;
    procedure run;
    procedure handlevent(var event:tevent);virtual;
    destructor done;virtual;
    procedure draw;virtual;
    procedure clean(r:trect);virtual;
    procedure execwindow(window:pwindow);
    procedure execshutdown;
    procedure initscreen;
    procedure initevents;
    procedure donescreen;
    procedure doneevents;
  end;
  pmywindow=^tmywindow;
  tmywindow=object(twindow)
    constructor init(r:trect;name:twindowname);
    procedure handlevent(var event:tevent);virtual;
  end;
  pshutdownwindow=^tshutdownwindow;
  tshutdownwindow=object(twindow)
    buff:pointer;
    sizebuff:word;
    constructor init;
    procedure handlevent(var event:tevent);virtual;
    procedure draw;virtual;
    destructor done;virtual;
  end;
  pshutdownview=^tshutdownview;
  tshutdownview=object(tgroup)
    constructor init;
    procedure handlevent(var event:tevent);virtual;
    procedure draw;virtual;
    procedure free;virtual;
  end;
var
  sonet:tsonet;
  winname:word;
  pchr:pointer;
  chrsize:word;

procedure tsonet.initscreen;
var
  gd,gm,i,j,c:integer;
  fpal:text;
  fchr:file;
begin
  gd:=vga;
  gm:=vgahi;
  initgraph(gd,gm,'bgi');
  rscreen.assign(0,0,getmaxx,getmaxy);
  setviewport(rscreen.a.x,rscreen.a.y,rscreen.b.x,rscreen.b.y,true);
  assign(fpal,settingspath+'\'+palettefile+'.pal');
  reset(fpal);
  for i:=0 to 15 do
   with syspalette[i] do
    readln(fpal,r,g,b);
  close(fpal);
  for i:=0 to 15 do
   with syspalette[i] do
    setrgbpalette(egacolors[i],r,g,b);
  assign(fchr,'bgi\russian.chr');
  reset(fchr,1);
  chrsize:=filesize(fchr);
  getmem(pchr,chrsize);
  blockread(fchr,pchr^,chrsize);
  registerbgifont(pchr);
  close(fchr);
end;
procedure tsonet.initevents;
begin
  mousehandleron;
  showmouse;
end;
procedure tsonet.donescreen;
begin
  closegraph;
end;
procedure tsonet.doneevents;
begin
  mousehandleroff;
  hidemouse;
end;
constructor tsonet.init;
var
  fini:text;
begin
  winname:=0;
  scrtime:=clock_val;
  assign(fini,inifile);
  reset(fini);
  readln(fini);
  readln(fini,palettefile);
  readln(fini);
  readln(fini,scrsaverpath);
  readln(fini);
  readln(fini,screensavertime);
  readln(fini);
  readln(fini,shutdowntype);
  close(fini);
  initscreen;
  tasklist[0]:=nil;
  tasklist[1]:=nil;
  task_point:=0;
  inherited init(rscreen);
  randomize;
  initevents;
  sonetself:=@self;
  setstate(true,sflife+sfselected+sffocused);
  newtask(new(pkeybtask,init(@self,0)));
  newtask(new(peventtask,init(@self,0)));
  draw;
  controlpanel:=new(pcontrolpanel,init);
  insert(controlpanel);
end;
procedure tsonet.run;
var
  t:ptask;
  i:integer;
begin
  repeat
    {выполнение задач}
    t:=tasklist[task_point];
    while t<>nil do
     begin
       if t^.kill then
        begin
          t:=t^.next;
          continue;
        end;
       if blocktask or t^.block  then
         t^.run
        else
         if keypressed then
          readkey;
       if t^.kill then
        t^.done;
       t:=t^.next;
       if shutdown then
        break;
     end;
    {коррекция списка задач}
    if (clock_val>scrtime+screensavertime)and
       (scrsaverpath<>'')and blocktask then
     begin
       doneevents;
       donescreen;
       swapvectors;
       exec('scrsaver\he-he.exe','');
       swapvectors;
       initscreen;
       initevents;
       for i:=0 to 15 do
        with syspalette[i] do
         setrgbpalette(egacolors[i],0,0,0);
       draw;
       for i:=0 to 15 do
        with syspalette[i] do
         setrgbpalette(egacolors[i],r,g,b);
       scrtime:=clock_val;
     end;
    if shutdowninit then
     execshutdown;
  until shutdown;
end;
procedure tsonet.handlevent;
var
  r:trect;
  ev:tevent;
  sn:string;
  shortcut:pwinshortcut;
  t:pview;
  i:integer;
  yy,x,y:word;
begin
  if event.what and evmouseldown<>0 then
   setstate(true,sfauto);
  ev:=event;
  inherited handlevent(event);
  if ev.what and evmouselup<>0 then
   setstate(false,sfauto);

  if (event.what and evmouse<>0)and event.double then
   newtask(new(ptimertask,init(@self,cmtime,0,true)));

  if event.what and evcommand<>0 then
   case event.command of
    cmshutdown:shutdowninit:=true;
     cmrefresh:draw;
        cmtime:begin
                 if random(2)=0 then
                   begin
                     r.a.x:=random(150)+50;
                     r.a.y:=random(150)+50;
                     r.b.x:=r.a.x+random(409-r.a.x)+200;
                     r.b.y:=r.a.y+random(229-r.a.y)+120;
                     inc(winname);
                     str(winname,sn);
                     execwindow(new(pmywindow,init(r,sn+':Окно для примера.')));
                   end
                  else
                   execwindow(new(ppaintapp,init(random(100),random(100))));
               end;
        cmhalt:halt(1);
   end;
  if event.what and evkeyboard<>0 then
   case event.charcode of
     #0:if event.scancode=107 then
         shutdown:=true;
  #9,#8:begin
          event.what:=evbroadcast+evcommand;
          if event.charcode=#8 then
            event.command:=cmclose
           else
            event.command:=cmdown;
          handlevent(event);
        end;
    #27:execshutdown;
    '%':halt(0);
    #32:draw;
    #13:newtask(new(ptimertask,init(@self,cmtime,9,true)));
    'Z':begin
          port[$3ce]:=5;
          port[$3cf]:=1;
          yy:=480*80;
          for y:=479 downto 0 do
           begin
             yy:=yy-80;
             for x:=79 downto 0 do
             mem[sega000:yy+8*80+x]:=
             mem[sega000:yy+x];
           end;
        end;
    else
     newtask(new(ptimertask,init(@self,cmtime,18,true)));
   end;
end;
destructor tsonet.done;
begin
  inherited done;
  freemem(pchr,chrsize);
  doneevents;
  donescreen;
end;
procedure tsonet.draw;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  if filltype<>1 then
   setfillpattern(fillpattern,backgroundcolor);
  setfillstyle(filltype,backgroundcolor);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  iorun;
  inherited draw;
end;
procedure tsonet.clean;
var
  i,j:integer;
begin
  if filltype<>1 then
   setfillpattern(fillpattern,backgroundcolor);
  setfillstyle(filltype,backgroundcolor);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
end;

procedure tsonet.execwindow;
var
  t:pview;
  i:word;
begin
  if (countwindow+1)*(winshortcutsize+3)+controlpanel^.first^.size.x+5<rscreen.b.x-2-clock^.size.x then
    begin
      inc(countwindow);
      window^.shortcut:=new(pwinshortcut,
       init(window^.title^.name,(countwindow-1)*(winshortcutsize+3),winshortcutsize,window));
      insert(window);
      controlpanel^.shortcutgroup^.insert(window^.shortcut);
    end
   else
    if countwindow>maxcolwindow-1 then
      begin
        sound(1000);
        delay(10);
        nosound;
        dec(winname);
        dispose(window,done);
      end
     else
      begin
        inc(countwindow);
        winshortcutsize:=controlpanel^.shortcutgroup^.size.x div countwindow-3;
        t:=controlpanel^.shortcutgroup^.first;
        for i:=1 to countwindow-1 do
         begin
           t^.owner^.clear(t);
           t^.origin.x:=(i-1)*(winshortcutsize+3);
           t^.size.x:=winshortcutsize;
           t^.draw;
           t:=t^.next;
         end;
        window^.shortcut:=new(pwinshortcut,
         init(window^.title^.name,(countwindow-1)*(winshortcutsize+3),winshortcutsize,window));
        insert(window);
        controlpanel^.shortcutgroup^.insert(window^.shortcut);
      end;
end;
procedure tsonet.execshutdown;
begin
  shutdowninit:=false;
  if shutdownview then
   exit;
  shutdownview:=true;
  blocktask:=false;
  insert(new(pshutdownview,init));
end;
constructor tmywindow.init;
var
  t:integer;
  i,j:integer;
begin
  inherited init(r,false,name);
  insert(new(pdialogbutton,init(30,50,cmclose,false,'Закрыть',smallfont)));
  insert(new(pdialogbutton,init(130,50,cmshutdown,false,'Выход',smallfont)));
  insert(new(pdialogbutton,init(30,75,cmzoom,false,'Развернуть',smallfont)));
  insert(new(pdialogbutton,init(130,75,cmtime,false,'Новый',smallfont)));
  insert(new(pdialogbutton,init(30,100,cmrefresh,false,'Обновить',smallfont)));
  insert(new(pdialogbutton,init(130,100,cmdown,false,'Свернуть',smallfont)));
end;
procedure tmywindow.handlevent;
begin
  inherited handlevent(event);
  if event.double and (event.what and evmouse<>0) then
   begin
     sound(1000);
     delay(10);
     nosound;
     event.what:=evnothing;
   end;
end;
constructor tshutdownwindow.init;
var
  r:trect;
begin
  r.assign(0,0,250,100);
  inherited init(r,false,'Завершение работы...');
  setstate(false,sfmove+sfgrowx+sfgrowy+sfzoom);
  options:=options or (ofcenterx+ofcentery);
  options:=options and not ofcleared;
  insert(new(pdialogbutton,init(45,70,cmok,false,'Да',smallfont)));
  insert(new(pdialogbutton,init(93,70,cmok+random(2),false,'Не знаю...',smallfont)));
  insert(new(pdialogbutton,init(180,70,cmcencel,false,'Нет',smallfont)));
end;
procedure tshutdownwindow.handlevent;
begin
  inherited handlevent(event);
  if event.what and evcommand<>0 then
    case event.command of
          cmok:shutdown:=true;
      cmcencel:owner^.free;
    end
   else
    event.what:=evnothing;
end;
procedure tshutdownwindow.draw;
var
  r:trect;
begin
  getextend(r);
  if shutdowntype=1 then
   begin
     iostop(r);
     sizebuff:=imagesize(r.a.x,r.a.y,r.b.x,r.b.y);
     getmem(buff,sizebuff);
     getimage(r.a.x,r.a.y,r.b.x,r.b.y,buff^);
     iorun;
   end;
  inherited draw;
  iostop(r);
  setcolor(0);
  settextstyle(smallfont.font,0,smallfont.charsize);
  outtextxy(r.a.x+33,r.a.y+30,' Вы действительно хотите выйти? ');
  iorun;
end;
destructor tshutdownwindow.done;
begin
  if shutdowntype=1 then
   begin
     hidemouse;
     putimage(origin.x,origin.y,buff^,0);
     showmouse;
     freemem(buff,sizebuff);
   end;
  inherited done;
  shutdownview:=false;
  blocktask:=true;
end;
constructor tshutdownview.init;
begin
  inherited init(rscreen);
  options:=options or oftopview;
  if shutdowntype=1 then
   options:=options and not ofcleared;
  insert(new(pshutdownwindow,init));
end;
procedure tshutdownview.handlevent;
begin
  inherited handlevent(event);
  if (event.what and evcommand<>0)and(event.command=cmclose) then
   free;
  event.what:=evnothing;
end;
procedure tshutdownview.free;
var
  i:integer;
begin
  if shutdowntype=1 then
   for i:=0 to 15 do
    with syspalette[i] do
     setrgbpalette(egacolors[i],r,g,b);
  inherited free;
  if (sonetself^.current<>nil)and(shutdowntype=1) then
   sonetself^.current^.draw;
end;
procedure tshutdownview.draw;
const
  mask:array[0..1]of byte=(85,170);
var
  i,j,c:word;
  adr:word;
  b:byte;
begin
  if shutdowntype=0 then
    begin
      port[$3ce]:=5;
      port[$3cf]:=2;
      port[$3ce]:=8;
      for j:=0 to 479 do
       for i:=0 to 79 do
        begin
          adr:=j shl 6+j shl 4+i;
          port[$3cf]:=mask[j mod 2];
          b:=mem[sega000:adr];
          mem[sega000:adr]:=pointscolor;
        end;
    end
   else
    begin
      for j:=0 to shutdowncount do
       begin
         for i:=0 to 15 do
          with syspalette[i] do
           begin
             c:=(r+g+b)div 3;
             setrgbpalette(egacolors[i],r+round((c-r)*j/shutdowncount),
              g+round((c-g)*j/shutdowncount),b+round((c-b)*j/shutdowncount));
           end;
         delay(shutdowntemp);
       end;
    end;
  inherited draw;
end;

begin
  sonet.init;
  sonet.run;
  sonet.done;
end.
{2852}