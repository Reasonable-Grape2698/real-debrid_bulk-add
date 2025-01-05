while getopts a:d: flag
do
    case "${flag}" in
        a) a=${OPTARG};;
        d) dir=${OPTARG};;
    esac
done

echo $a
echo $dir

headers="Authorization: Bearer $a"
baseurl="https://api.real-debrid.com/rest/1.0/torrents"

mkdir "$dir/failed"
mkdir "$dir/processed"
count=0
total=$(ls $dir/*.torrent | wc -l)
for file in $dir/*.torrent
do
        response=$(curl -s --request PUT -H "Content-Type: application/octet-stream" -H "$headers" --data-binary @"$file" "https://api.real-debrid.com/rest/1.0/torrents/addTorrent")
        torrentId=$(echo $response | jq .id)

        # If there was an error
        if [ $torrentId == "null" ]
        then
                echo $response
                if [ $(echo $response | jq .error_code) == 34 ]
                then
                    sleep 60
                else
                    mv "$file" $dir/failed
                fi
        else
                echo $torrentId >> $dir/torrentIds.txt
                echo $torrentId
                mv "$file" $dir/processed
        fi
        sleep 1
        count=$(echo "$count+1" | bc)
        echo $count / $total
done
