{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 32767,0,5000}
program load;
uses dos,crt;
begin
  clrscr;
  writeln('Starting Sonet.10...');
  swapvectors;
  exec('sonet.exe','');
  swapvectors;
  clrscr;
end.