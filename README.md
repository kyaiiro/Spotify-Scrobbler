# HOW TO USE

Put your spotify history into a folder named "history"

## First run
```sh run.sh setup```
<br>
This will then ask for api key and secret. Create one at [last.fm](https://www.last.fm/api/account/create)
<br>
The script will then split the history files into files with 2.5k songs in each. This is due to last.fm's api having a daily limit of around 2.8k songs a day. Just playing it safe with 2.5k.

## Then run
```sh run.sh scrobble```
<br>
This will scrobble the files, starting from 1 to the latest one. It scrobbles 50 songs at a time, so give it a minute to finish.