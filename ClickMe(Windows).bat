@echo off
echo Have you installed Node.js and npm?
pause
@echo off
set /p "port=Enter Port Number (Leave It Blank For Using Default Port 5000): "
if not defined port set "port=5000"
echo Use Port %port%
SET current_path=%~dp0
echo %current_path%
cd %current_path%
npm run use_click_me %port%