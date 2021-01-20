@echo off

IF "%PRODUCT%" == "" (
	SET PRODUCT=%1
)
IF "%OUT%" == "" (
	SET OUT=out\target\product\%PRODUCT%
)

IF "%GPT%" == "" (
	SET GPT=partition-table-default.img
)

fastboot.exe flash gpt %OUT%\%GPT%
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash gpt.img
	GOTO:eof
)
fastboot.exe flash preboot %OUT%\preboot.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash preboot.img
	GOTO:eof
)
fastboot.exe flash dtbo %OUT%\dtbo.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash dtbo.img
	GOTO:eof
)
fastboot.exe flash boot %OUT%\boot.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash boot.img
	GOTO:eof
)
fastboot.exe flash recovery %OUT%\recovery.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash recovery.img
	GOTO:eof
)
fastboot.exe flash system %OUT%\system.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash system.img
	GOTO:eof
)
fastboot.exe flash vendor %OUT%\vendor.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash vendor.img
	GOTO:eof
)
fastboot.exe flash vbmeta %OUT%\vbmeta.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash vbmeta.img
	GOTO:eof
)
fastboot.exe flash cache %OUT%\cache.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash cache.img
	GOTO:eof
)
fastboot.exe erase userdata
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to erase userdata
	GOTO:eof
)
fastboot.exe reboot
ECHO Flashing successful!
