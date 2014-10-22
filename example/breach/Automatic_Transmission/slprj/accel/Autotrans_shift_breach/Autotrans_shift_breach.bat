@echo off
call setup_msvc120.bat

cd .
nmake -f Autotrans_shift_breach.mk 
@if errorlevel 1 goto error_exit
exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
An_error_occurred_during_the_call_to_make
