while getopts a:d: flag
do
    case "${flag}" in
        a) a=${OPTARG};;
        d) dir=${OPTARG};;
    esac
done
headers="Authorization: Bearer $a"
baseurl="https://api.real-debrid.com/rest/1.0"

task_in_total=$(cat $f | wc -l)
count=0
f = "$dir/torrentIds.txt"
while read -r torrentId
do
        echo $torrentId
        response=$(curl -s -X POST -H "$headers" -d "files=1" $baseurl/torrents/selectFiles/$torrentId)
        count=$(echo "$count+1" | bc)
        if [ -z $(echo $response | jq .error) ]
        then
                echo "$count/$task_in_total"
                sed -i '1d' $f
                echo $torrentId >> completed.txt
                echo $response
                sleep 1
        else
                echo $response
                echo $torrentId >> failed.txt
                if [ $(echo $response | jq .error_code) == "34" ]
                then
                        sleep 60
                fi
        fi
done < "$f"
