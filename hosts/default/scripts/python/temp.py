import argparse
import json
import os
import sys
import time
import urllib.parse
import urllib.request

parser = argparse.ArgumentParser()
parser.add_argument('--hours', type=int, default=12)
parser.add_argument('--height', type=int, default=6)
parser.add_argument('--city', type=str, default="")
parser.add_argument('--lat', type=str, default="")
parser.add_argument('--lon', type=str, default="")
parser.add_argument('--refresh', type=int, default=1200)
args = parser.parse_args()

accent_color = "#FFFFFF"
wal_path = os.path.expanduser("~/.cache/wal/colors")
if os.path.exists(wal_path):
    with open(wal_path, 'r') as f:
        lines = f.readlines()
        if len(lines) >= 3:
            accent_color = lines[2].strip()

L = f"<span color='{accent_color}'>║</span>"


def get_temp_color(temp_val):
    temp = temp_val / 10.0
    colors = [
        "#FF0000", "#FF0A00", "#FF1400", "#FF1E00", "#FF2800", "#FF3200",
        "#FF3C00", "#FF4600", "#FF5000", "#FF5A00", "#FF6400", "#FF6E00",
        "#FF7800", "#FF8200", "#FF8C00", "#FF9600", "#FFA000", "#FFAA00",
        "#FFB400", "#FFBE00", "#FFC800", "#FFD200", "#FFDC00", "#FFE600",
        "#FFF000", "#FFFA00", "#FFFF00", "#FFFF1A", "#FFFF33", "#FFFF4D",
        "#FFFF66", "#FFFF80", "#FFFF99", "#FFFFB3", "#FFFFCC", "#FFFFE6",
        "#FFFFFF", "#F0F7FF", "#E0EFFF", "#D1E7FF", "#C2DFFF", "#B3D7FF",
        "#A4CFFF", "#95C7FF", "#86BFFF", "#77B7FF", "#68AFFF", "#59A7FF",
        "#4A9FFF", "#3B97FF", "#2C8FFF", "#1D87FF", "#0E7FFF", "#0077FF"
    ]
    idx = 0
    for i in range(29, -21, -1):
        if temp > i:
            return colors[idx]
        idx += 1
    return colors[-1]


def interpolate(values, target_len):
    if len(values) == target_len:
        return values
    result = []
    for i in range(target_len):
        idx = i * (len(values) - 1) / (target_len - 1)
        lower = int(idx)
        upper = min(lower + 1, len(values) - 1)
        weight = idx - lower
        val = values[lower] * (1 - weight) + values[upper] * weight
        result.append(val)
    return result


def fetch_json(url):
    print(url)
    req = urllib.request.Request(
        url, headers={'User-Agent': 'WaybarWeatherScript/1.0'}
    )
    with urllib.request.urlopen(req) as response:
        result = json.loads(response.read().decode())
        print('fetched')
        return result


def get_location():
    if args.lat and args.lon:
        lat, lon = args.lat, args.lon
        url = (f"https://nominatim.openstreetmap.org/reverse"
               f"?format=json&lat={lat}&lon={lon}")
        city_data = fetch_json(url)
    elif args.city:
        query = urllib.parse.quote(args.city)
        search = fetch_json(
            f"https://nominatim.openstreetmap.org/search"
            f"?q={query}&format=json"
        )
        lat, lon = search[0]['lat'], search[0]['lon']
        url = (f"https://nominatim.openstreetmap.org/reverse"
               f"?format=json&lat={lat}&lon={lon}")
        city_data = fetch_json(url)
    else:
        ip_data = fetch_json("https://ipinfo.io/json")
        lat, lon = ip_data['loc'].split(',')
        url = (f"https://nominatim.openstreetmap.org/reverse"
               f"?format=json&lat={lat}&lon={lon}")
        city_data = fetch_json(url)
        
    addr = city_data.get('address', {})
    city = (addr.get('city') or addr.get('town') or
            addr.get('village') or addr.get('municipality') or "Unknown")
    return lat, lon, city


WEATHER_DESC = {
    0: "☀️ Clear sky", 1: "🌤️ Mainly clear", 2: "🌤️ Partly cloudy",
    3: "☁️ Overcast", 45: "🌫️ Fog", 48: "🌫️ Depositing rime fog",
    51: "🌧️ Light drizzle", 53: "🌧️ Moderate drizzle",
    55: "🌧️ Dense drizzle", 56: "🌧️❄️ Light freezing drizzle",
    57: "🌧️❄️ Dense freezing drizzle", 61: "🌦️ Slight rain",
    63: "🌧️ Moderate rain", 65: "🌧️ Heavy rain",
    66: "🌧️❄️ Light freezing rain", 67: "🌧️❄️ Heavy freezing rain",
    71: "🌨️ Slight snow fall", 73: "🌨️ Moderate snow fall",
    75: "❄️ Heavy snow fall", 77: "🌨️ Snow grains",
    80: "🌦️ Slight rain showers", 81: "🌧️ Moderate rain showers",
    82: "⛈️ Violent rain showers", 85: "🌨️ Slight snow showers",
    86: "❄️ Heavy snow showers", 95: "⛈️ Thunderstorm",
    96: "⛈️ Thunderstorm slight hail", 99: "⛈️ Thunderstorm heavy hail"
}


def get_wind_dir(deg):
    if 338 <= deg or deg < 23:
        return "󰁆"
    elif 23 <= deg < 68:
        return "󰦸"
    elif 68 <= deg < 113:
        return "󰁎"
    elif 113 <= deg < 158:
        return "󰧄"
    elif 158 <= deg < 203:
        return "󰁞"
    elif 203 <= deg < 248:
        return "󰧆"
    elif 248 <= deg < 293:
        return "󰁕"
    else:
        return "󰦺"


def main():
    try:
        lat, lon, city = get_location()
    except Exception:
        lat, lon, city = "49.8350", "23.9970", "Дрогобич"

    hours = max(1, min(100, args.hours))

    url = (
        f"https://api.open-meteo.com/v1/forecast"
        f"?latitude={lat}&longitude={lon}"
        f"&hourly=weather_code,temperature_2m"
        f"&daily=precipitation_sum,precipitation_hours,"
        f"precipitation_probability_max,sunrise,sunset"
        f"&current_weather=true&forecast_hours={hours}"
        f"&forecast_days=7&timezone=auto"
    )

    try:
        data = fetch_json(url)
    except Exception:
        err = {"text": "󰔪", "tooltip": "Error: Failed to fetch data"}
        print(json.dumps(err), flush=True)
        sys.exit(1)

    current = data['current_weather']
    wcode = current['weathercode']
    temp = current['temperature']

    text_out = f"{WEATHER_DESC.get(wcode, '❓')[:2]} {temp}°"

    step = 30
    elapsed = 0

    while True:
        wind_spd = current['windspeed']
        wind_dir = get_wind_dir(current['winddirection'])
        tooltip_str = (
            f"Location: {city}\n"
            f"Temperature: {temp}°C\n"
            f"Wind: {wind_spd}km/h {wind_dir}"
        )

        output = {
            "text": text_out,
            "tooltip": tooltip_str,
            "class": "weather"
        }

        print(json.dumps(output), flush=True)
        time.sleep(step)
        elapsed += step
        if elapsed >= args.refresh:
            break


if __name__ == "__main__":
    while True:
        main()