@echo off
setlocal EnableDelayedExpansion
SET OUTPUT_FILE=main.js

SET FILES=
for /f "delims=" %%A in ('forfiles /s /m *.elm /c "cmd /c echo @relpath"') do (
  set "FILE=%%~A"
  set FILES=!FILE:~2! !FILES!
)
call elm make !FILES! --output=!OUTPUT_FILE!