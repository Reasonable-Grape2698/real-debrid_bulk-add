dir="/torrents"
while getopts a:d: flag
do
    case "${flag}" in
        a) a=${OPTARG};;
        d) dir=${OPTARG};;
    esac
done

headers="Authorization: Bearer $a"
baseurl="https://api.real-debrid.com/rest/1.0/torrents"

mkdir $dir/failed
mkdir $dir/processed

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

task_in_total=$(ls -l $dir/*.torrent | wc -l)

for file in $dir/*.torrent; do
        response=$(curl -s --request PUT -H "Content-Type: application/octet-stream" -H "$headers" --data-binary @"$file" "https://api.real-debrid.com/rest/1.0/torrents/addTorrent")
        torrentId=$(echo $response | jq .id)
        count=$(echo "$count+1" | bc)
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
                echo $torrentId >> $dir/torrentIds.txt
                echo $torrentId
                mv "$file" $dir/processed
        fi
        show_progress $count $task_in_total
        sleep 1
done < for file in $dir/*.torrent; do echo $file; done
