import json, hashlib, time, sys, requests, dotenv, os
from datetime import datetime, timezone
dotenv.load_dotenv()

API_KEY = os.getenv("API_KEY")
API_SECRET = os.getenv("API_SECRET")
USERNAME = os.getenv("USERNAME")
PASSWORD = os.getenv("PASSWORD")
API_URL = os.getenv("API_URL")

def md5(s):
    return hashlib.md5(s.encode()).hexdigest()

def sign(params):
    sig = "".join(f"{k}{params[k]}" for k in sorted(params) if k != "format")
    return md5(sig + API_SECRET)

def api_call(params):
    params["api_key"] = API_KEY
    params["format"]  = "json"
    params["api_sig"] = sign(params)
    r = requests.post(API_URL, data=params, timeout=30)
    return r.json()

def get_session_key():
    resp = api_call({"method": "auth.getMobileSession",
                     "username": USERNAME,
                     "authToken": md5(USERNAME.lower() + md5(PASSWORD))})
    return resp["session"]["key"]

def scrobble_file(path, sk):
    tracks = json.load(open(path, encoding="utf-8"))
    batches = [tracks[i:i+50] for i in range(0, len(tracks), 50)]

    for batch in batches:
        params = {"method": "track.scrobble", "sk": sk}
        for i, t in enumerate(batch):
            ts = int(time.time())
            params[f"track[{i}]"]     = t["track"]
            params[f"artist[{i}]"]    = t["artist"]
            params[f"album[{i}]"]     = t["album"]
            params[f"timestamp[{i}]"] = ts
        resp = api_call(params)
        attr = resp.get("scrobbles", {}).get("@attr", {})
        print(f"  accepted: {attr.get('accepted', 0)}  ignored: {attr.get('ignored', 0)}")
        time.sleep(0.25)

sk = get_session_key()
scrobble_file(sys.argv[1], sk)
print("Done!")