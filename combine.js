const fs = require("fs");
const path = require('path');

const files = fs.readdirSync('./history');
const formatted = "./formatted-songs.json";

const combined = files
  .filter(file => file.endsWith('.json')) // only grab JSON files
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

try {
  fs.writeFileSync(`./${formatted}`, JSON.stringify(songs, null, 2));
  console.log(`Wrote to ${formatted}`);
} catch (err) {
  console.log(`Error: ${err}`);
}