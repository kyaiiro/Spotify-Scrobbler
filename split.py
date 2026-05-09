import json, math, os
from pathlib import Path

if not Path('splitSongs').is_dir():
     os.mkdir('splitSongs')

with open("formatted-songs.json", "r") as f:
    allSongs = json.load(f)

for j in range(0, math.ceil(len(allSongs)/2500)):
    songs = []
    for i in range(0+(2500*j), 0+(2500*j) + 2500):
        if i == len(allSongs):
            break
        songs.append(allSongs[i])

    json.dump(songs, open(f"splitSongs/Songs_{j}.json", "w"), indent=2)
print("Split all songs into daily files")