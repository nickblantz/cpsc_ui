@echo off
setlocal EnableDelayedExpansion
SET OUTPUT_FILE=main.js
SET FILES=

cd src
for /f "delims=" %%A in ('forfiles /s /m *.elm /c "cmd /c echo @relpath"') do (
  set "FILE=%%~A"
  set FILES=src\!FILE:~2! !FILES!
)
cd ..

call elm-app make !FILES! --output=!OUTPUT_FILE!
call elm-app start