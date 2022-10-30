read -p "Have you installed Node.js and npm? (Hit Enter to continue)"
read -p "Enter Port Number (Leave It Blank For Using Default Port 5000): " port
port=${port:-5000}
echo $name
echo It will use Port $port
echo "$PWD"
cd We are in $PWD
echo npm run use_click_me $port
npm run use_click_me $port
