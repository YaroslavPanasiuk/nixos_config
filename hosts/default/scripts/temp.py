with open("/home/yarko/Documents/list.txt", "r") as file:
    for line in file:
        print(f'"{line.strip()}" = [ "qimgv.desktop" ];')