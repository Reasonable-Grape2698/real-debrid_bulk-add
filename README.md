# Instructions
Run add.sh 
```
./add.sh -a APIKEY -d /torrents/dir
```
don't add a trailing slash to dir.

Run select.sh (this starts the downloads)
```
select.sh -a APIKEY -d /torrents/dir
```

select is seperate as we'd hit the 10 active downloads limit otherwise and not be able to add more. This way we can bulk add then select and it'll auto download 10 at a time.

# Ensure zurg isn't running - this will make you hit the API limit more often.

For every 2160p YTS movie as of end of 2024, use the backup file or hashlist here:
https://hashlists.debridmediamanager.com/3d047bc6-b235-4455-a41b-25708a8f9d45.html
