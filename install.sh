#!/bin/sh
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install libcurl4-openssl-dev libjansson-dev libomp-dev git screen nano jq wget
wget http://ports.ubuntu.com/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_arm64.deb
sudo dpkg -i libssl1.1_1.1.0g-2ubuntu4_arm64.deb
rm libssl1.1_1.1.0g-2ubuntu4_arm64.deb
mkdir ~/ccminer
cd ~/ccminer
GITHUB_RELEASE_JSON=$(curl --silent "https://api.github.com/repos/Oink70/Android-Mining/releases?per_page=1" | jq -c '[.[] | del (.body)]')
GITHUB_DOWNLOAD_URL=$(echo $GITHUB_RELEASE_JSON | jq -r ".[0].assets | .[] | .browser_download_url")
GITHUB_DOWNLOAD_NAME=$(echo $GITHUB_RELEASE_JSON | jq -r ".[0].assets | .[] | .name")

echo "Downloading latest release: $GITHUB_DOWNLOAD_NAME"

wget ${GITHUB_DOWNLOAD_URL} -O ~/ccminer/ccminer
wget https://raw.githubusercontent.com/makoshark2001/Verus/main/config.json -O ~/ccminer/config.json
wget https://raw.githubusercontent.com/makoshark2001/Verus/main/config_verushash.json -O ~/ccminer/config_verushash.json
wget https://raw.githubusercontent.com/makoshark2001/Verus/main/config_sha256d.json -O ~/ccminer/config_sha256d.json
wget https://raw.githubusercontent.com/makoshark2001/Verus/main/config_scrypt.json -O ~/ccminer/config_scrypt.json
chmod +x ~/ccminer/ccminer

cat << EOF > ~/ccminer/start.sh
#!/bin/sh
~/ccminer/ccminer -c ~/ccminer/config.json
EOF

cat << EOF > ~/ccminer/start_verushash.sh
#!/bin/sh
~/ccminer/ccminer -c ~/ccminer/config_verushash.json
EOF

cat << EOF > ~/ccminer/start_sha256d.sh
#!/bin/sh
~/ccminer/ccminer -c ~/ccminer/config_sha256d.json
EOF

cat << EOF > ~/ccminer/start_scrypt.sh
#!/bin/sh
~/ccminer/ccminer -c ~/ccminer/config_scrypt.json
EOF



cat << EOF > ~/ccminer/start-screen.sh
#!/bin/sh
screen -S Verus -d -m ./start.sh
EOF

cat << EOF > ~/ccminer/start-screen-verushash.sh
#!/bin/sh
screen -S Verus -d -m ./start_verushash.sh
EOF

cat << EOF > ~/ccminer/start-screen-sha256d.sh
#!/bin/sh
screen -S Bitcoin -d -m ./start_sha256d.sh
EOF

cat << EOF > ~/ccminer/start-screen-scrypt.sh
#!/bin/sh
screen -S Scrypt -d -m ./start_scrypt.sh
EOF


chmod +x *.sh


echo "setup nearly complete."
echo "Edit the config with \"nano ~/ccminer/config.json\""

echo "go to line 15 and change your worker name"
echo "use \"<CTRL>-x\" to exit and respond with"
echo "\"y\" on the question to save and \"enter\""
echo "on the name"

echo "start the miner with \"cd ~/ccminer; ./start.sh\"."
