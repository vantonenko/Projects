@echo off

SET /P AREYOUSURE=Are you sure you want to DELETE ALL the added (non-tracked) files in a repository(Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

@echo on

git -C ProjectFolder clean -d  -fx -- ""

pause
:END
