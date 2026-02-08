#!/bin/bash
#
# configure.sh - Interactive setup for flomo-send skill
#
# This script runs during skill installation to configure user preferences.
#

set -e

echo "📝 flomo-send Configuration"
echo "============================"
echo ""

# Check if running in interactive mode
if [ ! -t 0 ]; then
    echo "Note: Non-interactive mode detected. Skipping configuration."
    echo "To configure later, run: ./scripts/configure.sh"
    exit 0
fi

# Ask if user has flomo PRO account
echo "Do you have a flomo PRO account? (y/n)"
read -r HAS_PRO

case "$HAS_PRO" in
    [Yy]*)
        echo ""
        echo "✅ PRO account selected"
        echo ""
        echo "Please enter your flomo webhook URL (or just the token; we'll convert it to a URL)."
        echo "You can find it at: https://flomoapp.com/mine?source=incoming_webhook"
        echo ""
        read -rp "Webhook token (or full URL): " WEBHOOK_INPUT
        
        if [ -z "$WEBHOOK_INPUT" ]; then
            echo "⚠️  No webhook provided. You can configure it later by running this script again."
            exit 0
        fi
        
        # Detect if user pasted full URL or just token
        if echo "$WEBHOOK_INPUT" | grep -q "^https://flomoapp.com/iwh/"; then
            # Full URL provided
            WEBHOOK_URL="$WEBHOOK_INPUT"
            echo ""
            echo "✅ Webhook URL configured"
        else
            # Assume token provided; construct full URL
            WEBHOOK_URL="https://flomoapp.com/iwh/$WEBHOOK_INPUT"
            echo ""
            echo "✅ Webhook URL created from token"
        fi
        
        # Save configuration to local .env file only (avoid writing shell configs)
        ENV_FILE="$(dirname "$0")/../.env"
        echo "# flomo-send Configuration" > "$ENV_FILE"
        echo "FLOMO_WEBHOOK_URL=$WEBHOOK_URL" >> "$ENV_FILE"
        chmod 600 "$ENV_FILE"
        echo ""
        echo "✅ Configuration saved to: $ENV_FILE"
        echo "   The .env file has been created with restricted permissions (600)"
        echo "   This skill no longer writes to shell config files for security."
        
        echo ""
        echo "🎉 Configuration complete!"
        echo "   You can now use the flomo_send.sh script with webhook fallback."
        ;;
    
    [Nn]*)
        echo ""
        echo "✅ Free account selected"
        echo "   The skill will use URL Scheme only (requires flomo app on macOS)."
        echo "   If you upgrade to PRO later, run: ./scripts/configure.sh"
        ;;
    
    *)
        echo ""
        echo "⚠️  Invalid input. Skipping configuration."
        echo "   You can run this script later to configure: ./scripts/configure.sh"
        exit 0
        ;;
esac

echo ""
echo "📖 Quick start:"
echo "   ./scripts/flomo_send.sh \"Your note\" \"#tag1 #tag2\""
