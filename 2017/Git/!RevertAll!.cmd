@echo off

SET /P AREYOUSURE=Are you sure you want to REVERT ALL the changed files in a repository(Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

@echo on

git -C ProjectFolder checkout .

pause
:END
