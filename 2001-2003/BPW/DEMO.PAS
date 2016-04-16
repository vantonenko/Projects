program demo;
uses wincrt;
var
  k:integer;
const
  nx=50;
  dx=2*pi/nx;
  ny=10;
begin
  screensize.x:=80;
  screensize.y:=60;
  autotracking:=false;
  for k:=0 to nx do
   begin
     gotoxy(k+1,ny);
     write('-');
     gotoxy(k+1,round(ny*(1+sin(dx*k))));
     write('*');
     gotoxy(nx+5,k+1);
     write(dx*k:4:2,sin(dx*k):8:2);
   end;
end.