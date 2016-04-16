unit fileman;
{-------}
interface
{-------}
uses taskman,dos;
type
  plist=^tlist;
  tlist=record
    s:searchrec;
    path:pathstr;
    next:plist;
  end;
  tfsearchtask=object(ttask)
   private
     name:string[12];
     slist:pslist;
   public
    constructor init(name:string[12]);
    procedure run;virtual;
    destructor done;virtual;
  end;
{------------}
implementation
{------------}
constructor tfsearchtask.init;
begin