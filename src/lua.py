import json
import os
from constants import OUTPUT_PATH, LUA_DEFINITIONS_PATH

def main():
    if not os.path.exists(OUTPUT_PATH):
        print(
            'API extract missing at {}.\n'.format(OUTPUT_PATH) + \
            'Run main.py first to scrape the API Reference.'
        )
        return

    with open(OUTPUT_PATH, 'r') as f:
        ref = json.load(f)

    os.makedirs(os.path.dirname(LUA_DEFINITIONS_PATH), exist_ok=True)

    with open(LUA_DEFINITIONS_PATH, 'w') as f:
        f.write('---@meta\n')
        
        for func in ref:
            # description
            f.write('\n---')
            f.write(func['desc'].replace('\n', '\n---'))

            # parameters
            for p in func['params']:
                suffix = '?' if p['optional'] else ''
                f.write('\n---@param {} any{}'.format(p['name'], suffix))

            # function signature
            f.write('\nfunction {}({}) end\n'.format(
                func['name'],
                ', '.join(p['name'] for p in func['params'])
            ))

if __name__ == '__main__':
    main()
