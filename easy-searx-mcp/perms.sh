
sudo usermod -aG docker $USER
newgrp docker
groups | grep docker
docker ps

