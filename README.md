
# Instructions
Run add.sh (run it a few times as if there's errors other than '34' rate limit, it'll keep the torrent in the main dir and you can retry)
```
./add.sh -a APIKEY -d /torrents/dir
```
don't add a trailing slash to dir.

Run select.sh (this starts the downloads)
```
select.sh -a APIKEY -d /torrents/dir
```

select is seperate as we'd hit the 10 active downloads limit otherwise and not be able to add more. This way we can bulk add then select and it'll auto download 10 at a time.
Torrents not started due to limiting will be added to torrents/dir/activelim.txt. Rename this file to torrentIds.txt and rerun sel.sh later on when slots become available.

Alternatively, select these files on the real-debrid site and it bypasses the limit / queues extras.

# Ensure zurg isn't running - this will make you hit the API limit more often.

For every 2160p YTS movie as of end of 2024, use the backup file or hashlist here:
https://hashlists.debridmediamanager.com/3d047bc6-b235-4455-a41b-25708a8f9d45.html

For every YTS 1080p movie, there's a hashlist here:
https://hashlists.debridmediamanager.com/12728718-3066-4dd2-93dc-d1bced63896d.html

# Known Issues
Sometimes the file you want isn't file 1 - it's alphabetical, so this works well with YTS. Change it to 'files=all' for all files. Else you need extra API calls to determine the MKV/MP4/etc file.
