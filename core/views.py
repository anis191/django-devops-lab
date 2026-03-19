import time
from django.utils import timezone
from django.core.cache import cache
from django.shortcuts import render
import requests
'''
def cache_test(request):
    key = "test_key"
    value = cache.get(key)
    if value is None:
        value = "This was just computed at " + str(timezone.now())
        cache.set(key, value, 60)  # 60 seconds
        return render(request, 'cache_test.html', {'message': f"Cache MISS → {value}"})
    return render(request, 'cache_test.html', {'message': f"Cache HIT → {value}"})
'''
def cache_test(request):
    key = "test_key"
    value = cache.get(key)

    if value is None:
        computed_at = timezone.now()
        value = str(computed_at)
        cache.set(key, value, 60)  # 60 seconds
        context = {
            'status':      'miss',
            'computed_at':  computed_at,
            'ttl':          60,
        }
    else:
        context = {
            'status':      'hit',
            'computed_at':  value,   # already a string from when it was cached
            'ttl':          60,
        }

    return render(request, 'cache_test.html', context)


def fetch_posts(request):
    cache_key = "posts_data"
    ttl = 120  # 2 minutes

    start_time = time.time()

    data = cache.get(cache_key)
    if data:
        source = "From Redis"
    else:
        response = requests.get("https://jsonplaceholder.typicode.com/posts")
        response.raise_for_status()          # raise error if request failed
        data = response.json()
        cache.set(cache_key, data, timeout=ttl)
        source = "From API"

    end_time = time.time()
    time_taken_ms = round((end_time - start_time) * 1000, 2)

    context = {
        'posts': data,
        'source': source,
        'time_taken': time_taken_ms,
        'count': len(data),
    }

    return render(request, 'posts.html', context)

