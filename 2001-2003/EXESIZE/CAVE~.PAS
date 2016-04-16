{$b-}
program cave;
uses crt;
const
  max=75;
  pathinp='cave.dat';
  pathout='cave.sol';
type
  plist=^tlist;{список эл-тов одного блока}
  tlist=record
    i,j:byte;
    next:plist;
  end;
  pblocks=^tblocks;{список блоков}
  tblocks=record
    list:plist;
    n,dir:byte;{номер блока,текущее направление блока}
    next:pblocks;
  end;
  tpoint=record
    i,j:byte;
    time:byte;
  end;
var
  map:array[1..max,1..max]of integer;{карта}
  nnew:array[1..max,1..max]of word;
  path:array[1..max,1..max,1..2]of byte;{путь}
  st:array[1..max*max]of tpoint;{очередь}
  posr,posw,oldposr,oldposw,l,curtime,alltime,time:word;
  sizem,ci,i,exiti:byte;{sizem-число строк}
  sizen,cj,j,exitj,dir:byte;{sizen-число столбцов}
  blocks,t,bls:pblocks;{список блоков}
  bl,tt:plist;
  fdat,fsol:text;
  enable,rflag,move:boolean;
  n:word;
procedure addelem(n:word;i,j:byte);{добавляет эл-т к блоку с номером n}
var
  bl:pblocks;
  t:plist;
begin
  bl:=blocks;
  while bl^.n<>n do
   bl:=bl^.next;
  new(t);
  t^.next:=bl^.list;
  t^.i:=i;
  t^.j:=j;
  bl^.list:=t;
end;
procedure addst(i,j,ni,nj:byte;time:word);
begin
  st[posw].i:=i;
  st[posw].j:=j;
  st[posw].time:=time;
  inc(posw);
  if (i=1)or(i=sizem)or(j=1)or(j=sizen) then
   begin
     enable:=false;
     exiti:=i;
     exitj:=j;
   end;
  path[i,j,1]:=ni;
  path[i,j,2]:=nj;
  nnew[i,j]:=1;
end;
begin
  clrscr;
  {-----"init"-----}
  assign(fdat,pathinp);
  reset(fdat);
  read(fdat,sizem,sizen,l);
  for i:=1 to sizem do
   for j:=1 to sizen do
    read(fdat,map[i,j]);
  blocks:=nil;
  for i:=1 to l do
   begin
     new(t);
     t^.list:=nil;
     t^.n:=i;
     read(fdat,dir);
     dir:=dir+2;
     if dir>4 then
      dir:=dir-4;
     t^.dir:=dir;
     t^.next:=blocks;
     blocks:=t;
   end;
  close(fdat);
  for i:=1 to sizem do
   for j:=1 to sizen do
    if map[i,j]>0 then
      addelem(map[i,j],i,j)
     else
      if map[i,j]=-2 then
       begin
         ci:=i;
         cj:=j;
       end;
  {-------"run"-----------}
  exiti:=0;
  exitj:=0;
  posr:=1;
  posw:=2;
  st[posr].i:=ci;
  st[posr].j:=cj;
  st[posr].time:=0;
  enable:=true;
  curtime:=0;
  fillchar(nnew,sizeof(nnew),0);
  nnew[ci,cj]:=1;
  rflag:=false;
  alltime:=0;
  while enable do
   begin
     {<двигаем блоки>}
     bls:=blocks;
     while bls<>nil do
      begin
        bl:=bls^.list;
        dir:=bls^.dir;
        move:=true;
        while (bl<>nil)and move do
         begin
           i:=bl^.i;
           j:=bl^.j;
           bl:=bl^.next;
           case dir of
            1:move:=(i=1)or(map[i-1,j]=0);
            2:move:=(j=sizen)or(map[i,j+1]=0);
            3:move:=(i=sizem)or(map[i+1,j]=0);
            4:move:=(j=1)or(map[i,j-1]=0);
           end;
         end;
        if move then
          begin
            {<двигаем блок>}
            bl:=bls^.list;
            n:=bls^.n;
            while bl<>nil do
             begin
               i:=bl^.i;
               j:=bl^.j;
               map[i,j]:=0;
               case dir of
                1:begin
                    map[i-1,j]:=n;
                    i:=i-1;
                  end;
                2:begin
                    map[i,j+1]:=n;
                    j:=j+1;
                  end;
                3:begin
                    map[i+1,j]:=n;
                    i:=i+1;
                  end;
                4:begin
                    map[i,j-1]:=n;
                    j:=j-1;
                  end;
               end;
               bl^.i:=i;
               bl^.j:=j;
               bl:=bl^.next;
             end;
          end
         else
          begin
            {<меняем направление>}
            bls^.dir:=bls^.dir+2;
            if bls^.dir>4 then
             bls^.dir:=bls^.dir-4;
          end;
        bls:=bls^.next;
      end;
     oldposr:=posr;
     oldposw:=posw;
     while (posw>posr)and(st[posr].time=curtime)and enable do
      begin
        i:=st[posr].i;
        j:=st[posr].j;
        time:=st[posr].time;
        inc(posr);
        if map[i,j]>0 then
         continue;
        if rflag then
         inc(nnew[i,j]);
        if (i>1)and(map[i-1,j]=0)and(nnew[i-1,j]=0)then
         addst(i-1,j,i,j,time+1);
        if (j<sizen)and(map[i,j+1]=0)and(nnew[i,j+1]=0)then
         addst(i,j+1,i,j,time+1);
        if (i<sizem)and(map[i+1,j]=0)and(nnew[i+1,j]=0)then
         addst(i+1,j,i,j,time+1);
        if (j>1)and(map[i,j-1]=0)and(nnew[i,j-1]=0)then
         addst(i,j-1,i,j,time+1);
      end;
     if posw=oldposw then
       begin
         posr:=oldposr;
         rflag:=true;
       end
      else
       begin
         inc(curtime);
         rflag:=false;
       end;
     inc(alltime);
   end;
  {--------"done"--------}
  assign(fsol,pathout);
  rewrite(fsol);
  writeln(fsol,alltime);
  bls:=blocks;
  for i:=1 to l do
   begin
     bl:=bls^.list;
     while bl<>nil do
      begin
        tt:=bl;
        bl:=bl^.next;
        dispose(tt);
      end;
     t:=bls;
     bls:=bls^.next;
     dispose(t);
   end;
  for l:=1 to alltime do
   begin
     writeln(fsol,exiti,' ',exitj);
     dec(nnew[exiti,exitj]);
     if nnew[exiti,exitj]=0 then
      begin
        i:=path[exiti,exitj,1];
        j:=path[exiti,exitj,2];
        exiti:=i;
        exitj:=j;
      end;
   end;
  close(fsol);
end.