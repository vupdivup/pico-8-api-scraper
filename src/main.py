import requests
import parse
from argparse import ArgumentParser
from constants import API_REFERENCE_URL

def parse_http():
    print('Parsing {}...'.format(API_REFERENCE_URL))
    
    r = requests.get(API_REFERENCE_URL)
    r.encoding = 'utf-8'

    parse.main(r.text)

def parse_fallback():
    print('Parsing fallback .html file...')
    with open('fallback/PICO-8 Manual.htm', 'r', encoding='utf-8') as f:
        parse.main(f.read())

def main():
    parser = ArgumentParser()
    parser.add_argument('-fb', '--fallback', action='store_true')
    args = parser.parse_args()

    if args.fallback:
        parse_fallback()
    else:
        try:
            parse_http()
        except:
            parse_fallback()

if __name__ == '__main__':
    main()
