dir="/torrents"
while getopts a:dir: flag
do
    case "${flag}" in
        a) a=${OPTARG};;
        dir) dir=${OPTARG};;
    esac
done

headers="Authorization: Bearer $a"
baseurl="https://api.real-debrid.com/rest/1.0/torrents"

for file in $dir/*.torrent; do
        response=$(curl -s --request PUT -H "Content-Type: application/octet-stream" -H "$headers" --data-binary @"$file" "https://api.real-debrid.com/rest/1.0/torrents/addTorrent")
        torrentId=$(echo $response | jq .id)

        # If there was an error
        if [ $torrentId == "null" ]
        then
                echo $response
                mv "$file" $dir/failed
                if [ $(echo $response | jq .error_code) == 34 ]
                then
                        sleep 60
                fi
        else
                echo $torrentId >> torrentIds.txt
                echo $torrentId
                mv "$file" $dir/processed
        fi
        sleep 1
done
