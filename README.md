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

# Ensure zurg isn't running - this will make you hit the API limit more often.

For every 2160p YTS movie as of end of 2024, use the backup file or hashlist here:
https://hashlists.debridmediamanager.com/3d047bc6-b235-4455-a41b-25708a8f9d45.html
