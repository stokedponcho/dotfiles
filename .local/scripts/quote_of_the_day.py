#!/bin/python
""" Retrieves and display the.. quote of the day
    from https://en.wikiquote.org/wiki/
"""

from datetime import date
from io import open
from os import environ, getenv, path

from wikiquote import quote_of_the_day

QUOTE_PROVIDER = lambda: quote_of_the_day() #pylint: disable=unnecessary-lambda
CACHE_ROOT = getenv("XDG_CACHE_HOME", environ["HOME"] + "/.cache")
CACHE_FILE = path.join(CACHE_ROOT, "quote_of_the_day")

def _main():
    quote, author = _get_or_update()
    print(f'{quote}\n- {author}\n')

def _get_or_update():
    sep = '|'
    full_quote = _read_cache(CACHE_FILE)
    full_quote = full_quote.split(sep) if full_quote else None

    if not full_quote or int(full_quote[0]) != date.today().day:
        full_quote = QUOTE_PROVIDER()
        full_quote = (str(date.today().day),) + full_quote
        _write_cache(CACHE_FILE, sep.join(full_quote))

    return (full_quote[1], full_quote[2])

def _read_cache(cache):
    if not path.exists(cache):
        return None
    with open(cache,  "r") as file:
        return file.read()

def _write_cache(cache, value):
    with open(cache, "w", encoding="utf-8") as file:
        file.write(value)


if __name__ == "__main__":
    _main()
