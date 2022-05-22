#installer Git, postgresql, vs code
sudo apt install git
sudo apt install postgresql
sudo apt install code

#se connecter a git
git config --global user.name amina
git config --global user.email amina.bouchekhchoukh@gmail.com

#colne my repository from my Git account 
git clone https://github.com/AminaBouchek/MyRepository.git


#save my user name and password
git config --global credential.helper store

#create a new branch "lab"
git branch lab

#switch to the new branch lab
git checkout lab

#add my files my MyRepository
cp /home/amina/Documents/myDb.sql myDb.sql
cp /home/amina/Documents/myCommandes.sh myCommades.sh
git add .

#check repository status
git status

#commit
git commit -m "my first commit"








