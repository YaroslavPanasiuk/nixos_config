import time
import subprocess
from datetime import datetime, timedelta


today = datetime.now()

print(today.isocalendar()[-1])
days_to_wednesday = (10 - today.isocalendar()[-1]) % 7
print(days_to_wednesday)
for i in range(45):
    print(f'- {(datetime.now() + timedelta(days_to_wednesday + i * 7)).strftime("%d.%m.%Y")}')