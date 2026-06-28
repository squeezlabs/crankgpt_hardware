#!/bin/bash
# DietPi-AutoStart custom script
# create with dietpi-autostart
# or copy to: /var/lib/dietpi/dietpi-autostart/custom.sh 

echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null

cd /root/dev/edge_voice_agent || exit 1
source venv_rpi/bin/activate || exit 1

# Mode: 1 = Voice Agent, 2 = Translation
MODE=1

# Platform: rpi5 or opi5
PLATFORM=rpi5

case $MODE in
    1)
        echo "Starting llama-server (agent)..."
        sh start_llama_server_agent.sh

        echo "Starting Voice Agent..."
        python voice_agent_cli.py --platform $PLATFORM --log-conversation --audio-device-input 1 --audio-device-output 0 --speaking_rate 1. --prompt_file prompts.json
        ;;
    2)
        echo "Starting llama-server (translation)..."
        sh start_llama_server_translation.sh

        echo "Starting Voice Translate..."
        python voice_translate_cli.py --preload-tts --platform $PLATFORM --audio-device-input 1 --audio-device-output 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

exit 0
