@echo off

echo.
echo *** Assembling base2num
nasm -fwin32 base2num.asm

echo.
echo *** Assembling beep
nasm -fwin32 beep.asm

echo.
echo *** Linking
golink beep.obj base2num.obj kernel32.dll user32.dll

echo.
pause
