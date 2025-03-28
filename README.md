# PICO-8 API Reference Scraper

This Python program scrapes the API reference found within the [PICO-8 Manual](https://www.lexaloffle.com/dl/docs/pico-8_manual.html) and stores it in JSON format. With it, you can also create a definition file for the [Lua Language Server](https://luals.github.io/).

### Files

Download output files of past script runs here:

- [API Reference JSON](https://raw.githubusercontent.com/vupdivup/pico-8-api-scraper/refs/heads/main/data/api_reference.json)
- [Lua Language Server definitions](https://raw.githubusercontent.com/vupdivup/pico-8-api-scraper/refs/heads/main/lua/definitions.lua)

## Results

Results are exported to a JSON file under the `data` folder of the working directory. Each function signature is stored in the following format:

```json
{
    "name": "stop",
    "category": "System",
    "params": [
      {
        "name": "message",
        "optional": true
      }
    ],
    "desc": "Stop the cart and optionally print a message."
  }
```

Note that the `desc` field is structured for markdown display.

## Instructions
Install requirements and run `src/main.py` to extract data.

```shell
pip install -r requirements.txt
```

```shell
python src/main.py
```

### Configuration

#### Nonstandard Signatures

Function signatures are identified by testing for the pattern `NAME(PARAM, [OPTIONAL_PARAM])`. If a function doesn't conform to this pattern, but is still a part of the PICO-8 library, add the function name to the `nonstandard_signatures` list within `src/config.py`. Make sure that the list item matches the HTML string content exactly, including whitespace.

```python
nonstandard_signatures = [
    ' SSPR(SX, SY, SW, SH, DX, DY, [DW, DH], [FLIP_X], [FLIP_Y]]',
    ' FOLDER',
    ' RESUME',
    ' REBOOT',
    ' YIELD'
]
```

### Fallback
If the script encounters an error while scraping, it will scrape the HTML document within the `fallback` folder instead. 

Fallback scraping can be forced by adding the `-fb` argument when running the script.

```shell
python src/main.py -fb
```

## Lua Language Server Definitions

Execute `src/lua.py` to generate a [definition file](https://luals.github.io/wiki/definition-files/) for the Lua Language Server based on the scraped PICO-8 API JSON. The resulting `.lua` file will be placed under the `lua` folder. A snapshot of the definitions:

```lua
---Stop the cart and optionally print a message.
---@param message any?
function stop(message) end
```
