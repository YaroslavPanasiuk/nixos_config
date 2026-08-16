import time
import subprocess
import datetime

# Set target time
target = datetime.datetime.now().replace(hour=19, minute=0, second=0, microsecond=0)

# Sleep until 1 second before target to save CPU
while datetime.datetime.now() < target - datetime.timedelta(seconds=2):
	time.sleep(1)
	print(f"Time till target: {(target - datetime.datetime.now()).total_seconds()} seconds")
	if int(datetime.datetime.now().timestamp()) % 100 == 0:
		subprocess.run(["adb", "shell", "input", "tap", "532", "2173"])
# Busy-wait for the exact microsecond
while datetime.datetime.now() < target:
    pass

# Execute tap
for _ in range(10):
	subprocess.run(["adb", "shell", "input", "tap", "532", "2173"])
	time.sleep(1)