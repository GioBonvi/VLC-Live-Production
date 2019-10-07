@ECHO Off
SETLOCAL EnableDelayedExpansion

rem Drag and drop files as parameters.
IF "%~1" == "" (
  rem No files dragged and dropped.
  SET media_files=
) else (
  rem One or more files dragged and dropped.
  SET media_files="%~1"
)

rem Locate the VLC executable.
SET VLC_32="C:\Program Files\VideoLAN\VLC\vlc.exe"
SET VLC_64="C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
SET VLC_CUSTOM="C:\CUSTOM\PATH"
FOR %%p IN (%VLC_64% %VLC_32% %VLC_CUSTOM%) DO (
  IF EXIST %%p (
    SET VLC=%%p
    GOTO :read_monitor_info
  )
)

ECHO Error: could not locate the VLC executable.
PAUSE
EXIT /B 0

:read_monitor_info
rem Read multi-monitor info from external program.
.\MultiMonitorTool.exe /scomma .\monitor_report.csv
SET /A monitor_index=0
FOR /F "tokens=1,8,14 delims=,? skip=1" %%a IN (monitor_report.csv) DO (
  SET resolution=%%a
  SET primary=%%b
  SET name=%%c
  IF "!primary!" == "Yes" (
    SET primary_descr=!name! ^(!resolution!^)
  ) ELSE (
    SET secondary_descr[!monitor_index!]=!name! ^(!resolution!^)
    SET /A monitor_index=!monitor_index!+1
  )
)

:choose_monitor
IF !monitor_index!==0 (
  ECHO Error: no secondary monitor detected!
  PAUSE
  EXIT /B 0
) ELSE (
  rem Only one secondary monitor: obligated choice.
  SET /A monitor_index=!monitor_index!-1
  IF NOT !monitor_index!==0 (
    rem More than a secondary monitor: menu choice.
    ECHO More than one secondary monitor detected: please choose one.
    CALL :menu_choose_monitor monitor_index
  )
)

GOTO :calc_resolution

:menu_choose_monitor
rem Present the user with a menu choice of the secondary monitor.

ECHO -------
ECHO PRIMARY:
ECHO %primary_descr%
ECHO SECONDARY:
FOR /L %%n IN (0,1,%monitor_index%) DO (
  ECHO %%n^) !secondary_descr[%%n]!
)
SET /P choice=Choose a secondary monitor: 
IF %choice% GTR %monitor_index% GOTO :menu_choose_monitor
IF %choice% LSS 0 GOTO :menu_choose_monitor
SET /A %~1=%choice%

EXIT /B 0

:calc_resolution
rem Get the resolution for the chosen secondary monitor, calculate the
rem video position and launch VLC.
SET /A i=-1
FOR /F "tokens=2,3,8* delims=,? skip=1" %%a in (monitor_report.csv) do (
  SET left=%%a
  SET top=%%b
  SET primary=%%c
  IF "!primary!"=="No" (
    SET /a i=!i!+1
    IF !i!==!monitor_index! (
      rem Calculate video position.
      SET /a VIDEO_X=!left:~1!+1
      SET /a VIDEO_Y=!top:~1,-1!+1
      rem Break out of the loop as we have reached the desired monitor.
      GOTO :launch_vlc
    )
  )
)

:launch_vlc
rem Hide the console if possible.
rem SETCONSOLE.EXE is a 3rd party program, available here:
rem http://prozandcoms.stefanoz.com/setconsole-exe-console-window-control/
IF EXIST SETCONSOLE.EXE (
  SETCONSOLE /hide
) ELSE (
  ECHO You can close this window whenever you want.
)

rem Launch VLC with the right arguments.
%VLC% --quiet --disable-screensaver --no-random --no-loop --no-repeat --no-playlist-autostart --play-and-stop --no-video-title-show --no-embedded-video --fullscreen --no-qt-fs-controller --video-x=%VIDEO_X% --video-y=%VIDEO_Y% %media_files%
GOTO :EOF