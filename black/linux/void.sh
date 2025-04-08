sudo ln -s /etc/sv/sshd /var/service/
sudo sv start sshd

sudo useradd -m grayteam
sudo passwd grayteam #cdt-grayteamOnly!

sudo useradd -m scoring
sudo passwd scoring #scoring123

sudo useradd -m ian_malcolm
sudo passwd ian_malcolm #lifeUhFindsAWay94!

sudo useradd -m john_hammon
sudo passwd john_hammon #welcomeToJurrasicPark00!

sudo useradd -m mr_dna
sudo passwd mr_dna #blueprintOfLife54!

sudo useradd -m ellie_sattler
sudo passwd ellie_sattler #dinosaurDroppings72!

sudo useradd -m alan_grant
sudo passwd alan_grant #itsADinosaur68!

sudo usermod -aG wheel ian_malcolm
sudo usermod -aG wheel john_hammon
sudo usermod -aG wheel mr_dna
sudo usermod -aG wheel scoring



