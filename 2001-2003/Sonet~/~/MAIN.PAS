unit main;

interface

uses sources;
type
  {ptextmenuitem=^ttextmenuitem;
  ttextmenuitem=object(tmenuitem)
    font:tfont;
    name:string50;
    constructor init(x,y:integer;asubmenu:pmenu;acommand:word;name:string50;font:tfont);
    procedure drawligthon;virtual;
    procedure drawligthoff;virtual;
  end;
  ptextmenu=^ttextmenu;
  ttextmenu=object(tmenu)}
