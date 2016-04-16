program sonet_;
uses crt,graph,mouse,kernel,sources,dos;
const
  settingspath='Settings';
  inifile='sonet.ini';
  palettefile:pathstr='';
  shutdown:boolean=false;
  smallfont:tfont=(font:2;charsize:4);
type
  tsonet=object(tgroup)
    constructor init;
    procedure run;
    procedure handlevent(var event:tevent);virtual;
    procedure draw;virtual;
    destructor done;virtual;
    procedure clean(r:trect);virtual;
    procedure newtask(task:ptask);
    procedure deltask(task:ptask);
  end;
  pmywindow=^tmywindow;
  tmywindow=object(twindow)
    constructor init(r:trect);
  end;
var
  sonet:tsonet;
  tasklist:array[0..1]of ptask;
  task_point:byte;
procedure mousehandler(event:tevent);far;
begin
  sonet.handlevent(event);
end;
constructor tsonet.init;
var
  gd,gm,i:integer;
  font:tfont;
  fini,fpal:text;
begin
  assign(fini,inifile);
  reset(fini);
  readln(fini);
  readln(fini,palettefile);
  close(fini);
  assign(fpal,settingspath+'\'+palettefile+'.pal');
  reset(fpal);
  for i:=0 to 15 do
   with syspalette[i] do
    read(fpal,r,g,b);
  close(fpal);
  tasklist[0]:=nil;
  tasklist[1]:=nil;
  task_point:=0;
  inherited init(rscreen);
  gd:=vga;
  gm:=vgahi;
  initgraph(gd,gm,'');
  randomize;
  for i:=0 to 15 do
   with syspalette[i] do
    setrgbpalette(egacolors[i],r,g,b);
  mousehandleron(mousehandler);
  showmouse;
  setstate(true,sflife+sfselected+sffocused);
  draw;
  font.charsize:=4;
  font.font:=2;
  insert(new(pclosebutton,init(617,6,16,14)));
  insert(new(pdialogbutton,init(30,430,cmrefresh,false,'Refresh',font)));
  insert(new(pdialogbutton,init(90,430,cmtime,false,'New-',font)));
  insert(new(pdialogbutton,init(140,430,cmtime,true,'New_',font)));
  newtask(new(pkeybtask,init(@self,0)));
end;
procedure tsonet.run;
var
  t:ptask;
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
       t^.run;
       if t^.kill then
        t^.done;
       t:=t^.next;
       if shutdown then
        break;
     end;
    {коррекция списка задач}
    {disableview:=@self;
    disableview:=nil;}
  until shutdown;
end;
procedure tsonet.handlevent;
var
  r:trect;
  ev:tevent;
begin
  if (disableview=@self)and(event.what and evmouse<>0) then
   exit;
  if event.what and evmouseldown<>0 then
   setstate(true,sfauto);
  ev:=event;
  inherited handlevent(event);
  if ev.what and evmouselup<>0 then
   setstate(false,sfauto);
  if event.what and evcommand<>0 then
   case event.command of
       cmclose:shutdown:=true;
     cmrefresh:draw;
     cmtime:begin
              r.a.x:=random(150)+50;
              r.a.y:=random(150)+50;
              r.b.x:=r.a.x+random(409-r.a.x)+200;
              r.b.y:=r.a.y+random(329-r.a.y)+100;
              insert(new(pmywindow,init(r)));
            end;
     cmzoom:begin
              sound(1000);
              delay(10);
              nosound;
            end;
     cmdown:begin
              sound(5000);
              delay(10);
              nosound;
            end;
   end;
  if event.what and evkeyboard<>0 then
   case event.charcode of
    #27:shutdown:=true;
    #32:draw;
    #13:newtask(new(ptimertask,init(@self,cmtime,9,true)));
    else
     newtask(new(ptimertask,init(@self,cmtime,18,true)));
   end;
end;
procedure tsonet.draw;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(1,3);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  iorun;
  inherited draw;
end;
destructor tsonet.done;
begin
  inherited done;
  mousehandleroff;
  hidemouse;
  closegraph;
end;
procedure tsonet.clean;
begin
  setfillstyle(1,3);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
end;
procedure tsonet.newtask;
var
  t:ptask;
begin
  if tasklist[task_point]=nil then
    tasklist[task_point]:=task
   else
    begin
      t:=tasklist[task_point];
      while t^.next<>nil do
       t:=t^.next;
      t^.next:=task;
    end;
end;
procedure tsonet.deltask;
begin

end;
constructor tmywindow.init;
var
  i,j:integer;
begin
  inherited init(r);
  insert(new(pdialogbutton,init(10,30,cmnothing,false,'TButton',smallfont)));
end;

begin
  sonet.init;
  sonet.run;
  sonet.done;
end.