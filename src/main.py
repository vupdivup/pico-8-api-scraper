import requests
import parse
from argparse import ArgumentParser

def parse_http():
    url = 'https://www.lexaloffle.com/' + \
          'dl/docs/pico-8_manual.html#PICO_8_User_Manual'
    
    r = requests.get(url)
    r.encoding = 'utf-8'

    parse.main(r.text)

def parse_fallback():
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
