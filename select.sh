f="torrentIds.txt"
while getopts a:f: flag
do
    case "${flag}" in
        a) a=${OPTARG};;
        f) f=${OPTARG};;
    esac
done
headers="Authorization: Bearer $a"
baseurl="https://api.real-debrid.com/rest/1.0/torrents"

while read $f; do
        response=$(curl -s -X POST -H "$headers" -d '"files" = "*"' $baseurl/selectFiles/torrents/selectFiles/$torrentId)

        if [ -n $(echo $response | jq .error) ]
        then
                echo $torrentId
        else
                echo $response
                sleep 60
        fi
        sleep 0.25
done
