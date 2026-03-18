import time
import requests
from django.core.cache import cache
from django.http import JsonResponse
from django.http import HttpResponse

def fetch_posts(request):
    return HttpResponse("Hello from fetch_posts! Cache is working if you see this twice quickly.")

"""
def fetch_posts(request):
    cache_key = "posts_data"
    ttl = 120 # cache duration in second

    start_time = time.time()
    data = cache.get(cache_key)

    if data:
        source = "redis"
    else:
        response = requests.get("https://jsonplaceholder.typicode.com/posts")
        data = response.json()
        cache.set(cache_key, data, timeout=ttl)
        source = "api"
    
    end_time = time.time()
    time_taken_ms = round((end_time - start_time) * 1000, 2)

    return JsonResponse({
        "source" : source,
        "count" : len(data),
        "time_taken" : f"{time_taken_ms} ms",
        "data" : data
    })
"""