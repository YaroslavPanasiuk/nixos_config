cd /home/yaroslaw/temp/result
for file in *; do
    if [ -f "$file" ]; then
        echo "Processing file: $file"
        set_as_wallpaper.sh "/home/yaroslaw/temp/result/$file"
        # Add your commands here
    fi
done