# Instructions
Run add.sh 
```
./add.sh -a APIKEY -dir /torrents/dir
```
don't add a trailing slash to dir.

Run select.sh (this starts the downloads)
```
select.sh -f /torrents/dir/torrentIds.txt
```

select is seperate as we'd hit the 10 active downloads limit otherwise and not be able to add more. This way we can bulk add then select and it'll auto download 10 at a time.
