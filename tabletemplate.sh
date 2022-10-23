#!/bin/bash
echo "title composer price avail sold total"
function output(){
while read line
do
    title="$(cut -d ":"  -f 1 <<<"$line")"
    composer="$(cut -d ":" -f 2 <<<"$line")"
    price="$(cut -d ":" -f 3 <<<"$line")"
    avail="$(cut -d ":" -f 4 <<<"$line")"
    sold="$(cut -d ":" -f 5 <<<"$line")"
    #debug:
    #echo "title:$title, composer:$composer, price=$price, avail=$avail, sold=$sold" 
    total="$(echo "$price * $sold" | bc -l)"
    echo "$title $composer $price $avail $sold $total" 
done < file.txt
}
output | column -t
