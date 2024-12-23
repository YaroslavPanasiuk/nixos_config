{ pkgs }:

pkgs.writeShellScriptBin "mp4_to_wallp.sh" '' 
count=$(ls -1 /home/yaros/shared/Wallpapers/*.gif 2>/dev/null | wc -l)
echo $1
ffmpeg -i $1 -vf "fps=15,scale=1920:-1:flags=lanczos" -c:v gif "/home/yaros/shared/Wallpapers/''${count}[GIF].gif"
ffmpeg -i $1 -vf "select=eq(n\,0)" -q:v 2 -frames:v 1 "/home/yaros/shared/Wallpapers/''${count}[GIF].jpg"
''
