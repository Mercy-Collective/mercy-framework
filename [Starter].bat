@ECHO OFF
color 09
ECHO Thanks for using Mercy Framework, we hope you enjoy it!
timeout /t 2 /nobreak >nul
ECHO Starting Mercy Framework...
timeout /t 3 /nobreak >nul
color 07
cls

YOUR_URL_TO_FXSERVER_FOLDER_HERE\FXServer.exe +exec cfg/server.cfg
