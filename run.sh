read -p "1) Setup
2) Continue Scrobbling
> " todo

if [[ "$todo" == 1 ]]; then
    echo 'API_URL="https://ws.audioscrobbler.com/2.0/"' > .env

    read -p "last.fm API key
> " key
    echo "API_KEY='$key'" >> .env

    read -p "last.fm API secret
> " secret
    echo "API_SECRET='$secret'" >> .env

    read -p "last.fm username
> " username
    echo "USERNAME='$username'" >> .env

    read -p "last.fm password
> " password
    echo "PASSWORD='$password'" >> .env

    node combine.js
    env/bin/python split.py
    rm formatted-songs.json
elif [[ "$todo" == 2 ]]; then
    read -p "What day are we on?
> " day
    env/bin/python scrobble.py "splitSongs/Songs_$day.json"
else
    echo "What? That's not an option bro..."
fi