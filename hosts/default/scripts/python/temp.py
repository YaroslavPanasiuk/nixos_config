import requests
from bs4 import BeautifulSoup
import pandas as pd
import time

base_url = "https://lpnu.ua/dissertations-directory"
headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'}
all_theses = []
page = 0

while True:
    print(f"Fetching page {page + 1}...")
    # Drupal standard pagination
    response = requests.get(base_url, params={'page': page}, headers=headers)
    print(f"Fetching page {page + 1}...")
    if response.status_code != 200:
        break
        
    soup = BeautifulSoup(response.text, 'html.parser')
    print(f"Scraping page {page + 1}...")
    
    # Inspect DOM to update these specific CSS selectors
    rows = soup.select('.views-row') 
    if not rows:
        break
        
    for row in rows:
        thesis = {
            'title': row.select_one('.title-selector').get_text(strip=True) if row.select_one('.title-selector') else None,
            'author': row.select_one('.author-selector').get_text(strip=True) if row.select_one('.author-selector') else None,
            'link': row.select_one('a')['href'] if row.select_one('a') else None
        }
        all_theses.append(thesis)
        print(f"Scraped: {thesis['title']} by {thesis['author']}")
        
    page += 1
    time.sleep(1) # Prevent rate limiting

df = pd.DataFrame(all_theses)