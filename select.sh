while getopts a:d: flag
do
    case "${flag}" in
        a) a=${OPTARG};;
        d) dir=${OPTARG};;
    esac
done
headers="Authorization: Bearer $a"
baseurl="https://api.real-debrid.com/rest/1.0"

task_in_total=$(cat "$dir/torrentIds.txt" | wc -l)
count=0

touch "$dir/activeLim.txt"
touch "$dir/failed.txt"

# Remove quotation marks
sed -i 's/\"//g' "$dir/torrentIds.txt"

while read -r torrentId
do
        echo $torrentId
        response=$(curl -s -X POST -H "$headers" -d "files=1" $baseurl/torrents/selectFiles/$torrentId)
        count=$(echo "$count+1" | bc)
        if [ -z $(echo $response | jq .error) ]
        then
                echo "$count/$task_in_total"
                sed -i '1d' "$dir/torrentIds.txt"
                echo $torrentId >> $dir/completed.txt
                echo $response
                sleep 1
        else
                if [ $(echo $response | jq .error_code) == "34" ]
                then
                        sleep 60
                        echo "Sleeping 60, API limit hit"
                fi
                if [ $(echo $response | jq .error_code) == "21" ]
                then
                        echo $torrentId >> $dir/activeLim.txt
                        sed -i '1d' "$dir/torrentIds.txt"
                        echo "Active limit hit, output to activeLim.txt"
                else
                        echo $response
                        echo $torrentId >> $dir/failed.txt
                        sed -i '1d' "$dir/torrentIds.txt"
                fi
        fi
done < "$dir/torrentIds.txt"
