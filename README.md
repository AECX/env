# Hyprland Dotfiles

Personal [Hyprland](https://hyprland.org/) dotfiles with modern terminal and productivity tools.

This repository contains my Hyprland configuration together with configuration for the applications and utilities I use around it.

> **Note:** This is **not a full desktop environment** and does **not** set up a complete system from scratch. It also does **not** set up SM/login management. A working Linux/Wayland/Hyprland environment is expected.

## Features

- **Modern Terminal**: Primary terminal is `foot`, with `ghostty` available as alternative
- **Advanced Productivity**: Stopwatch and timer with real-time display
- **Weather Integration**: Live weather data with detailed forecasts
- **System Monitoring**: Real-time CPU, memory, network, and audio status
- **Smart Desktop**: Full integration with Waybar, Rofi, and Hyprland

## Key Components

### 🖥️ Desktop Environment

- **Hyprland**: Wayland compositor with smooth animations and window management
- **Waybar**: Status bar with custom modules for time, memory, network, and more
- **Rofi**: Application launcher with custom themes and menus
- **Dunst**: Notification daemon with custom styling

### 🔧 Productivity

- **⏱️ Stopwatch**: Real-time elapsed time tracking with start/stop/reset functionality. Click to toggle.
- **⏰ Timer**: Set custom durations (1–120 minutes). Click to set, scroll to adjust, right-click to cancel.
- **📊 Weather**: Live weather data with detailed 3-day forecast and tooltip.

## Installation

Clone the repository:

```bash
git clone https://github.com/AECX/env
cd env
```

Install the required packages:

```bash
./setup.sh install
```

Install the configurations:

```bash
./setup.sh activate
```

The setup script creates symlinks from `~/.config/` to the corresponding directories in `config/`.

Existing configurations are moved into `backup/` before being replaced.

To remove the dotfiles and restore the backed-up configurations:

```bash
./setup.sh remove
```

## Configuration

The repository is organized into a few main parts:

```text
config/
├── dunst/       # Notification daemon
├── ghostty/     # Ghostty terminal
├── hypr/        # Hyprland configuration
├── kitty/       # Kitty terminal configuration
├── nvim/        # Neovim / LazyVim configuration
├── rofi/        # Rofi themes and menus
└── waybar/      # Waybar configuration and styling

scripts/
├── cycle-kb.sh          # Cycle keyboard layouts
├── env.sh               # Environment setup
├── hyprpaper-shuffle.sh # Rotate wallpapers
├── launcher.sh          # Application launcher
├── mic-status.sh        # Microphone status
├── nightlight.sh        # Night light toggle
├── power-menu.sh        # Power menu
├── toggle-audio.sh      # Audio device switch
├── vpn-toggle.sh        # VPN status toggle
├── weather.sh           # Weather information
├── stopwatch.sh         # Stopwatch
└── timer.sh             # Timer

wallpapers/  # Wallpapers used by the configuration
```

## Usage Notes

- The primary terminal is `foot`, with `ghostty` available as alternative
- Neovim uses LazyVim with personal preferences that may change over time
- The `vpn-toggle.sh` script must be configured manually with your specific host
- The `weather.sh` script uses `wttr.in` and caches data every 30 minutes
- Stopwatch and timer scripts provide JSON output for Waybar integration

## 📝 Template Code Snippets

<details>
<summary><strong>vpn-toggle.sh</strong></summary>

```bash
#!/usr/bin/env bash

CHECK_HOST="replace-with-hostname-pingable-when-connected"

is_connected() {
    ping -c1 -W1 "$CHECK_HOST" &>/dev/null
}

if [[ "$1" == "toggle" ]]; then
    if is_connected; then
        # TOGGLE OFF COMMAND
    else
        # TOGGLE ON COMMAND
    fi
    exit 0
fi

if is_connected; then
    printf '{"text":"<span foreground=\"#8bd49c\">\xe2\x97\x8f</span> VPN","tooltip":"VPN connected (click to disconnect)"}\n'
else
    printf '{"text":"<span foreground=\"#ff6c6c\">\xe2\x97\x8f</span> VPN","tooltip":"VPN disconnected (click to connect)"}\n'
fi
```
</details>

<details>
<summary><strong>weather.sh</strong></summary>

```bash
#!/usr/bin/env bash
# Waybar weather widget backed by wttr.in. Prints waybar JSON.

LOCATION="Osaka"
CACHE="$HOME/.cache/waybar-weather.json"
MAX_AGE=1800

fetch() {
    curl -s -m 25 --connect-timeout 10 --retry 2 --retry-delay 2 \
        "https://wttr.in/${LOCATION}?format=j1"
}

icon_for() {
    case "$1" in
        113) echo "󰖙" ;;                                   # clear/sunny
        116) echo "󰖕" ;;                                   # partly cloudy
        119|122) echo "󰖐" ;;                                # cloudy/overcast
        143|248|260) echo "󰖑" ;;                            # fog/mist
        176|263|266|281|284|293|296|299|302|305|308|311|314|353|356|359) echo "󰖗" ;;  # rain
        179|182|317|320|362|365) echo "󰙿" ;;                # sleet
        185|227|230|323|326|329|332|335|338|350|368|371|374|377) echo "󰼶" ;;          # snow
        200|386|389|392|395) echo "󰖓" ;;                    # thunder
        *) echo "󰖐" ;;
    esac
}

age_ok() {
    [[ -f "$CACHE" ]] || return 1
    local mtime now
    mtime=$(stat -c %Y "$CACHE" 2>/dev/null) || return 1
    now=$(date +%s)
    (( now - mtime < MAX_AGE ))
}

if ! age_ok; then
    tmp="$(fetch)"
    if [[ -n "$tmp" ]] && jq -e '.current_condition' >/dev/null 2>&1 <<< "$tmp"; then
        echo "$tmp" > "$CACHE"
    fi
fi

if [[ ! -s "$CACHE" ]]; then
    printf '{"text":"󰼶 --°C","tooltip":"Weather unavailable"}\n'
    exit 0
fi

jq -r --arg icon_fallback "󰖐" '
    .current_condition[0] as $c |
    .weather as $days |
    {
        temp: $c.temp_C,
        feels: $c.FeelsLikeC,
        desc: $c.weatherDesc[0].value,
        code: $c.weatherCode,
        humidity: $c.humidity,
        wind: $c.windspeedKmph,
        d0: $days[0],
        d1: $days[1],
        d2: $days[2]
    } | @json
' "$CACHE" | {
    read -r payload
    temp=$(jq -r '.temp' <<< "$payload")
    feels=$(jq -r '.feels' <<< "$payload")
    desc=$(jq -r '.desc' <<< "$payload")
    code=$(jq -r '.code' <<< "$payload")
    humidity=$(jq -r '.humidity' <<< "$payload")
    wind=$(jq -r '.wind' <<< "$payload")

    icon=$(icon_for "$code")
    nl=$'\n'

    forecast=""
    for i in 0 1 2; do
        day=$(jq -r ".d${i}" <<< "$payload")
        [[ "$day" == "null" ]] && continue
        date=$(jq -r '.date' <<< "$day")
        max=$(jq -r '.maxtempC' <<< "$day")
        min=$(jq -r '.mintempC' <<< "$day")
        hourly_code=$(jq -r '.hourly[4].weatherCode' <<< "$day")
        dicon=$(icon_for "$hourly_code")
        forecast+="$date: $dicon $min°-$max°C$nl"
    done
    forecast="${forecast%$nl}"

    tooltip="$desc$nlFeels like $feels°C$nlHumidity: $humidity%$nlWind: $wind km/h$nl$nl$forecast"

    jq -nc --arg text "$icon $temp°C" --arg tooltip "$tooltip" \
        '{text: $text, tooltip: $tooltip}'
}
```
</details>