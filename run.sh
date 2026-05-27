echo "
 ▗▄▄▖▄▄▄▄   ▄▄▄     ■  ▄ ▗▞▀▀▘▄   ▄      ▗▄▄▖▗▞▀▘ ▄▄▄ ▄▄▄  ▗▖   ▗▖   █ ▗▞▀▚▖ ▄▄▄ 
▐▌   █   █ █   █ ▗▄▟▙▄▖▄ ▐▌   █   █     ▐▌   ▝▚▄▖█   █   █ ▐▌   ▐▌   █ ▐▛▀▀▘█    
 ▝▀▚▖█▄▄▄▀ ▀▄▄▄▀   ▐▌  █ ▐▛▀▘  ▀▀▀█      ▝▀▚▖    █   ▀▄▄▄▀ ▐▛▀▚▖▐▛▀▚▖█ ▝▚▄▄▖█    
▗▄▄▞▘█             ▐▌  █ ▐▌   ▄   █     ▗▄▄▞▘              ▐▙▄▞▘▐▙▄▞▘█           
     ▀             ▐▌          ▀▀▀                                               
"

if [[ $1 == "setup" ]]; then
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
elif [[ $1 == "scrobble" ]]; then
    set -a
    . ./.env
    set +a
    if [[ "$API_KEY" == "" || "$API_SECRET" == "" || "$USERNAME" == "" || "$PASSWORD" == "" ]]; then
        echo "Something is wrong with your setup, did you run 'sh run.sh setup'?"
        exit
    fi
    next=$(ls splitSongs/Songs_* | sort -t'_' -k2 -n | head -1)
    echo "Scrobbling $next"
    env/bin/python scrobble.py "$next"
    if not [ -d "finished" ]; then mkdir finished; fi
    mv "$next" finished
    echo "If scrobbling didn't work, double check your setup and move the file out of finished back into splitSongs"
else
    echo "What? That's not an option bro..."
fi