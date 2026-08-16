#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Error: Execute this script as root."
  exit 1
fi

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <github_repo_url> <entry_point>"
  echo "Example: $0 https://github.com/user/repo.git 'python3 -m bot.main'"
  exit 1
fi

REPO_URL=$1
APP_NAME=$(basename "$REPO_URL" .git)
ENTRY_POINT=$2
INSTALL_DIR="/home/yaros/Projects/$APP_NAME"
SERVICE_FILE="/etc/systemd/system/${APP_NAME}.service"
ENV_FILE="$INSTALL_DIR/.env"
WEBHOOK_CONF="/etc/webhook.json"
REDEPLOY_SCRIPT="/home/yaros/Projects/redeploy_python_app.sh"
HOOK_ID="${APP_NAME}-update"

echo "Cloning repository..."
git clone "$REPO_URL" "$INSTALL_DIR"
sudo git config --global --add safe.directory $INSTALL_DIR

echo "Setting up virtual environment..."
cd "$INSTALL_DIR"
python3 -m venv venv

if [ -f "requirements.txt" ]; then
  echo "Installing dependencies..."
  ./venv/bin/pip install -r requirements.txt
fi

echo "Configuring environment file..."
if [ ! -f "$ENV_FILE" ]; then
  cp "$INSTALL_DIR/.env.example" "$ENV_FILE"
  chmod 600 "$ENV_FILE"
fi

echo "Updating webhook JSON configuration..."
if [ ! -f "$WEBHOOK_CONF" ]; then
  echo "[]" > "$WEBHOOK_CONF"
fi

jq --arg id "$HOOK_ID" \
   --arg cmd "$REDEPLOY_SCRIPT" \
   --arg app "$APP_NAME" \
   --arg wd "$INSTALL_DIR" \
   'map(select(.id != $id)) + [{
     "id": $id, 
     "execute-command": $cmd, 
     "command-working-directory": $wd,
     "pass-arguments-to-command": [
       {
         "source": "string",
         "name": $app
       }
     ]
   }]' \
   "$WEBHOOK_CONF" > "${WEBHOOK_CONF}.tmp" && mv "${WEBHOOK_CONF}.tmp" "$WEBHOOK_CONF"

echo "Creating systemd service..."
cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=$APP_NAME Python Application
After=network.target

[Service]
Type=simple
Environment="PYTHONUNBUFFERED=1"
User=root
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/venv/bin/$ENTRY_POINT
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "Starting service..."
systemctl daemon-reload
systemctl enable --now "$APP_NAME"

echo "Deployment complete."
echo "Please add your environment variables to $ENV_FILE, then start the service:"
echo "sudo systemctl enable --now $APP_NAME"
