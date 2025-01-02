while getopts a:f: flag
do
    case "${flag}" in
        a) a=${OPTARG};;
        f) f=${OPTARG};;
    esac
done
headers="Authorization: Bearer $a"
baseurl="https://api.real-debrid.com/rest/1.0/torrents"

function show_progress {
    current="$1"
    total="$2"

    # calculate the progress in percentage
    percent=$(bc <<< "scale=$bar_percentage_scale; 100 * $current / $total" )
    # The number of done and todo characters
    done=$(bc <<< "scale=0; $bar_size * $percent / 100" )
    todo=$(bc <<< "scale=0; $bar_size - $done" )

    # build the done and todo sub-bars
    done_sub_bar=$(printf "%${done}s" | tr " " "${bar_char_done}")
    todo_sub_bar=$(printf "%${todo}s" | tr " " "${bar_char_todo}")

    # output the bar
    echo -ne "\rProgress : [${done_sub_bar}${todo_sub_bar}] ${percent}%"

    if [ $total -eq $current ]; then
        echo -e "\nDONE"
    fi
}
task_in_total=$(cat $f | wc -l)

while read $torrentId; do
        response=$(curl -s -X POST -H "$headers" -d "files='1'" $baseurl/selectFiles/torrents/selectFiles/$torrentId)
        count=$(echo "$count+1" | bc)
        if [ -n $(echo $response | jq .error) ]
        then
                echo $torrentId
        else
                echo $response
                sleep 60
        fi
        show_progress $count $task_in_total
        sleep 0.25
done < "$f"
