@echo off

IF "%PRODUCT%" == "" (
	SET PRODUCT=%1
)
IF "%OUT%" == "" (
	SET OUT=out\target\product\%PRODUCT%
)

fastboot.exe -i 0x0525 flash gpt %OUT%\gpt.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash gpt.img
	GOTO:eof
)
fastboot.exe -i 0x0525 flash boot %OUT%\boot.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash boot.img
	GOTO:eof
)
fastboot.exe -i 0x0525 flash recovery %OUT%\recovery.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash recovery.img
	GOTO:eof
)
fastboot.exe -i 0x0525 flash system %OUT%\system.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash system.img
	GOTO:eof
)
fastboot.exe -i 0x0525 flash cache %OUT%\cache.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash cache.img
	GOTO:eof
)
fastboot.exe -i 0x0525 flash vendor %OUT%\vendor.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash vendor.img
	GOTO:eof
)
fastboot.exe -i 0x0525 flash data %OUT%\userdata.img
IF %ERRORLEVEL% NEQ 0 (
	ECHO Failed to flash userdata.img
	GOTO:eof
)
fastboot.exe -i 0x0525 continue
ECHO Flashing successful!
