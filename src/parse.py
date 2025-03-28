import re
import json
from bs4 import BeautifulSoup
from bs4.element import Tag
from constants import OUTPUT_PATH

def main(html):
    """Scrape function signatures from the PICO-8 manual .html document.
    Signatures are exported in JSON format."""
    
    soup = BeautifulSoup(html, 'lxml')

    # find API reference boundaries
    start = soup.find('h1', id='API_Reference').parent
    end = soup.find('h1', id='Appendix').parent

    # pattern for matching function signatures
    # but doesn't match nested function calls within headings
    # note that params can have digits within them
    signature_pat = re.compile(r'^\s*[A-Z]+\([A-Z0-9, _\[\]]*\)\s*$')

    # TODO: import this from external file
    # signatures that don't match pattern but should be included
    exceptions = [
        ' SSPR(SX, SY, SW, SH, DX, DY, [DW, DH], [FLIP_X], [FLIP_Y]]',
        ' FOLDER',
        ' RESUME',
        ' REBOOT',
        ' YIELD'
        ]

    api = []
    categ = None
    signature = None
    desc_flag = False

    # collect tags of API Reference section
    for tag in start.next_siblings:
        # end of section
        if tag == end:
            break
        
        # exclude whitespace and high-level string elements
        if type(tag) is not Tag:
            continue
        
        # check for category heading
        h2 = tag.find('h2')
        if h2:
            # remove category indices
            categ = h2.string.split(' ', maxsplit=1)[1]
            desc_flag = False

        # stop extracting description after subcategory heading
        if tag.find('h3') or tag.find('h4'):
            desc_flag = False

        # check for function signature
        h5 = tag.find('h5')
        if h5 and (signature_pat.match(h5.string) or h5.string in exceptions):
            # mark body text after heading for extraction
            desc_flag = True

            # function name
            name = h5.string.split('(')[0]

            # extract params
            params = h5.string.removeprefix(name) \
                            .strip('(') \
                            .split(')')[0] \
                            .split(', ')
            
            signature = {
                'name': name.lower().strip(),
                'category': categ,
                'params': [],
                'desc': [] # list of paragraphs
            }

            # extract parameters
            for p in params:
                # don't record params for functions without any
                if p == '':
                    continue

                # note the or comparison instead of and
                # it's because optional params may be written like so: [x, y]
                is_optional = p[0] == '[' or p[-1] == ']'

                signature['params'].append({
                    'name': p.strip('[]').replace(' ', '_').lower(),
                    'optional': is_optional
                })

            api.append(signature)

        # description content
        if tag.name == 'p' and desc_flag:
            # check for code box
            code_flag = 'class' in tag.attrs and tag['class'][0] == 'codebox'

            content = tag.get_text().strip()
            
            # replace non-breaking spaces with normal ones
            content = content.replace('\u00a0', ' ')

            if code_flag:
                signature['desc'].append(f'```\n{content}\n```')
            else:
                signature['desc'].append(content)

    # join description paragraphs into single string
    for sign in api:
        sign['desc'] = '\n\n'.join(sign['desc'])

    # fill descriptions upwards for functions with blank desc
    for i, sign in enumerate(reversed(api)):
        if sign['desc'] == '' and i > 0:
            sign['desc'] = api[-i]['desc']

    # export
    with open(OUTPUT_PATH, 'w') as f:
        json.dump(api, f, indent=2)
