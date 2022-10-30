echo Have you installed Node.js and npm?
pause
read -e -p " Enter Port Number (Leave It Blank For Using Default Port 5000):" -i "5000" port
echo Use Port $port
echo "$PWD"
cd $PWD
npm $port run use_click_me %port%