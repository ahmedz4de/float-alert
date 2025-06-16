# Description
CSFloat Notifier - A lightweight Bash script to monitor the CSFloat market and detect new listings in real time.
<br>
<br>
# Dependencies
`curl` - For making HTTP requests to CSFloat API.

`jq` - For parsing JSON data.
<br>
<br>
# Usage
```bash
./csfn "<link>" "<token>" <sleeptime>
```
`<link>` - Should be replaced with a link for a CSFloat Market search with applied filters.

`<token>` - Should be replaced with CSFloat API Key. You can get it in Profile -> Developers -> New key.

`<sleeptime>` - Should be replaced with desired delay between API requests. For monitoring single item, recommended value is 15 (seconds).
<br>
<br>
### Example:
```bash
./csfn.sh "https://csfloat.com/search?sort_by=most_recent&def_index=500,503,505,506,507,508,509,512,514,515,516,517,518,519,520,521,522,523,525,526" "<token>" 15
```
This command monitors all knife listings and checks for updates every 15 seconds.
### Output:
```bash
Running...

★ Stiletto Knife
430$
https://csfloat.com/item/854678157721208729

★ Stiletto Knife | Crimson Web (Field-Tested)
432.33$
https://csfloat.com/item/854678416614624516

★ Shadow Daggers | Gamma Doppler (Factory New)
214.94$
https://csfloat.com/item/854678504455933411

★ Paracord Knife | Tiger Tooth (Factory New)
230$
https://csfloat.com/item/854678566447746739
...
```
<br>
<br>

# Limitations
1. For obvious reasons the program will only work on Linux and MacOS. To use on Windows, you will need [Windows Sybsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install).
2. If you lauch multiple instances, according to this [source](https://github.com/GODrums/BetterFloat/wiki/CSFloat-API-Documentation), you should not exceed 5 requests a minute, otherwise you get a cooldown.
3. For a specified `<sleeptime>` timeframe, if more than one item gets listed on the market, the program will only notify you of the most recent one. For this reason, avoid monitoring items that get listed in bulk or too often, for example, cases or cheap skins.
4. For now, error handling and logging are not supported, ensure validity of you input.
