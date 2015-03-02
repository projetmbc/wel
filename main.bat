@echo off

REM : Let's show only what we want to be seen.


REM : Sources used :
REM :   * http://www.batcher.fr
REM :   * http://stackoverflow.com/a/17606350
REM :   * http://stackoverflow.com/a/11237450
REM :   * http://stackoverflow.com/a/16116676
REM :   * http://stackoverflow.com/a/6963210/4589608


setlocal EnableDelayedExpansion


REM : The aliases - User's point of view

for /f "tokens=* eol=# delims=" %%x in (config\aliases.txt) do (
     set aliases=!aliases! "%%x"
)


REM : The aliases - Batch's point of view

set i=0

for %%d in (%aliases%) do (
    if not exist "%%d" (
        echo An illegal alias has been found: the following directory or file doesn't exist.
        echo.
        echo    * %%d
		
	    goto CLOSING
    )

    set /A i+=1
    set alias[!i!]=%%d
)


REM : The user must have the possibility to launch ``atom`` several times.

: RESTART


REM : Clear the screen

cls


REM : No shortcut has been found.

if %i%=="0" (
    echo --------------------------
    echo No shortcut has been found.
    echo ---------------------------
	
	goto CLOSING
)


REM : Asking for the shortcut wanted.

echo ------------------------------------
echo Choose the number of your directory.
echo ------------------------------------
echo.

for /L %%k in (1,1,%i%) do (
   echo     * %%k: !alias[%%k]!
)

echo.
set /p choice="Your choice [type (q)uit if you want to stop now] ? "

if "%choice%"=="q" goto END
if "%choice%"=="quit" goto END


REM : We must have an integer greater than one (zero is not allowed).

set test=0

for /L %%k in (1,1,%i%) do (
   if %%k == %choice% (set test=1)
)

if "%test%"=="0" (
    echo.
	echo Unvalid choice. The script will restart next you type a key.
    echo.
    pause

    goto RESTART
)


REM : We use a BATCH file just to launch ``atom`` without opening a new console.

call tools\_silent_launch !alias[%choice%]!

echo.
echo.
echo atom has been launched in the following directory, or with the following file.
echo.
echo     * !alias[%choice%]!


REM : Restart or not restart, that is the question.

echo.
echo.
echo ----------------
echo Restart or not ?
echo ----------------
echo.

set /p choice="Do you want to open another directory [(y)es/no]? "

if "%choice%"=="yes" goto RESTART
if "%choice%"=="y" goto RESTART

goto END


REM : Befor closing the script.

: CLOSING

echo.
echo The script will be closed next you type a key.
echo.
pause
 

REM : This is the end, my only friend, the end.

: END
