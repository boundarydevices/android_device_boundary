@echo off

IF "%PRODUCT%" == "" (
	SET PRODUCT=%1
)
IF "%OUT%" == "" (
	SET OUT=out\target\product\%PRODUCT%
)

SET VID=0x0525
fastboot.exe -i %VID% devices | FINDSTR fastboot
IF %ERRORLEVEL% NEQ 0 (
	SET VID=0x3016
)

fastboot.exe -i %VID% flash gpt %OUT%\gpt.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash gpt.img
	GOTO:eof
)
fastboot.exe -i %VID% flash boot %OUT%\boot.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash boot.img
	GOTO:eof
)
fastboot.exe -i %VID% flash recovery %OUT%\recovery.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash recovery.img
	GOTO:eof
)
fastboot.exe -i %VID% flash system %OUT%\system.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash system.img
	GOTO:eof
)
fastboot.exe -i %VID% flash cache %OUT%\cache.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash cache.img
	GOTO:eof
)
fastboot.exe -i %VID% flash vendor %OUT%\vendor.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash vendor.img
	GOTO:eof
)
fastboot.exe -i %VID% flash data %OUT%\userdata.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash userdata.img
	GOTO:eof
)
fastboot.exe -i %VID% continue
ECHO Flashing successful!
