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


Used with https://github.com/ozencb/yts-scraper
If you plan to use with this, I've included DMM backup of every 2160p YTS movie so you can use that instead if that's what you plan to scrape.
