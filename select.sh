while getopts a:f: flag
do
    case "${flag}" in
        a) a=${OPTARG};;
        f) f=${OPTARG};;
    esac
done
headers="Authorization: Bearer $a"
baseurl="https://api.real-debrid.com/rest/1.0/"

task_in_total=$(cat $f | wc -l)
count=0

while read $torrentId; do
        response=$(curl -s -X POST -H "$headers" -d "files=1" $baseurl/selectFiles/$torrentId)
        count=$(echo "$count+1" | bc)
        if [ -n $(echo $response | jq .error) ]
        then
                echo "$count/$task_in_total"
                sed -i '1d' $f
                $torrentId > completed.txt
                sleep 0.25
        else
                echo $response
                $torrentId > failed.txt
                sleep 60
        fi
done < $f
