# Description
float-alert.bash - A Simple Bash script to monitor CSFloat Market and detect new listings in real time.
<br>
<br>
# Dependencies
`git` - For cloning into the repository.

`curl` - For making HTTP requests to CSFloat API.

`jq` - For parsing JSON data.
<br>
<br>
# Usage
1. Clone the repository and `cd` into it.
```bash
git clone https://github.com/ahmedz4de/float-alert.git
cd float-alert/
```
2. Make `float-alert.bash` executable. 
```bash
chmod +x float-alert.bash
```
3. Edit `input.txt`:

`<link>` - Should be replaced with a link for a CSFloat Market search with applied filters. Make sure to select sort by newest.

`<key>` - Should be replaced with CSFloat API Key. You can get it in Profile -> Developers -> New key.

`<delay>` - Should be replaced with desired delay between API requests. For monitoring single item, recommended value is 15 (seconds).

3.1 If you want to get notifications via telegram, edit `telegram.txt`:

`<bot_token>` - Should be replaced with bot token. You will get one if you create a bot with @BotFather.

`<chat_id>` - Should be replaced with chat id. You can find how to get it online.

4. Execute the script (Normal mode, no telegram notifications, only terminal output).
```bash
./float-alert.bash n
```

4.1 Or (Telegram mode, no terminal output, only telegram notifications).
```bash
./float-alert.bash t
```
<br>

# Limitations
1. For obvious reasons the script will only work on Linux and MacOS. To use on Windows, you will need [Windows Sybsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install).
2. If you lauch multiple instances, according to this [source](https://github.com/GODrums/BetterFloat/wiki/CSFloat-API-Documentation), you should not exceed 5 requests a minute, otherwise you get a cooldown.
3. For a specified `<delay>` timeframe, if more than one item gets listed on the market, the script will only notify you of the most recent one. For this reason, avoid monitoring items that get listed in bulk or too often, for example, cases or very cheap skins.
4. For now, error handling and logging are not supported, ensure validity of you input.
