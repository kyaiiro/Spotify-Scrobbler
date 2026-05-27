const fs = require("fs");
const path = require('path');

const files = fs.readdirSync('./history');
const combined = files
  .filter(file => file.endsWith('.json'))
  .flatMap(file => {
    const rawData = fs.readFileSync(path.join('./history', file), 'utf8');
    return JSON.parse(rawData);
  });

const songs = combined
  .filter(item => item.master_metadata_track_name !== null)
  .map(item => ({
    track: item.master_metadata_track_name,
    artist: item.master_metadata_album_artist_name,
    album: item.master_metadata_album_album_name,
  }));

if (!fs.existsSync('splitSongs')) {
  fs.mkdirSync('splitSongs');
}

for (let j = 0; j < Math.ceil(songs.length / 2500); j++) {
  const chunk = songs.slice(j * 2500, (j + 1) * 2500);
  fs.writeFileSync(`splitSongs/Songs_${j + 1}.json`, JSON.stringify(chunk, null, 2));
}

console.log("Split all songs into daily files");