read -p "Have you installed Node.js and npm? (Hit enter to continue)"
read -p "Enter Port Number (Leave it blank for using default port 5000): " port
port=${port:-5000}
echo $name
echo It will use Port $port
echo "$PWD"
cd We are in $PWD
echo npm run use_click_me $port
npm run use_click_me $port
