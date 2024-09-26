#!/bin/bash

# Install jq first

url="YOUR-TIANJI-SERVER-URL"
workspace="YOUR-WORKSPACE-ID"
name="YOUR-MACHINE-NAME"

start_reporter() {
    pkill -f "tianji-reporter-linux-amd64"
    ./tianji-reporter-linux-amd64 --url $url --workspace $workspace --name $name
}

latest=$(curl -s "https://api.github.com/repos/msgbyte/tianji/releases/latest")
latest_tag=$(echo "$latest" | jq -r .tag_name)

if [ -f "latest" ]; then
    local=$(cat "latest")
    if [ "$local" = "$latest_tag" ]; then
        echo "No new version available"
        start_reporter
        exit 0
    fi
fi

echo "New version available: $latest_tag"
echo "Downloading new version"
curl -L "https://github.com/msgbyte/tianji/releases/download/$latest_tag/tianji-reporter-linux-amd64" -o "tianji-reporter-linux-amd64"
chmod +x "tianji-reporter-linux-amd64"

echo "$latest_tag" > "latest"
start_reporter
exit 0
