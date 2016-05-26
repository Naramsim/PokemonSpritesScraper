#! /bin/sh
dirs[0]="conquest"
dirs[1]="cries"
dirs[2]="cropped"
dirs[3]="dream-world"
dirs[4]="footprints"
dirs[5]="global-link"
dirs[6]="icons"
dirs[7]="main-sprites/yellow"
dirs[8]="mystery-dungeon"
dirs[9]="overworld"
dirs[10]="sugimori"
dirs[11]="trozei"
dirs[12]="main-sprites/black-white"
dirs[13]="main-sprites/crystal"
dirs[14]="main-sprites/diamond-pearl"
dirs[15]="main-sprites/emerald"
dirs[16]="main-sprites/firered-leafgreen"
dirs[17]="main-sprites/gold"
dirs[18]="main-sprites/heartgold-soulsilver"
dirs[19]="main-sprites/omegaruby-alphasapphire"
dirs[20]="main-sprites/platinum"
dirs[21]="main-sprites/red-blue"
dirs[22]="main-sprites/red-green"
dirs[23]="main-sprites/ruby-sapphire"
dirs[24]="main-sprites/silver"
dirs[25]="main-sprites/x-y"
FAIL=0

for i in {0..25} ;
do
	echo "GET http://veekun.com/dex/media/pokemon/${dirs[$i]}/" &
    wget --no-host-directories --no-cache -nc -c -U "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2600.0 Iron Safari/537.36" -r -l6 -A png,gif,svg -R html --no-parent --exclude-directories=../ http://veekun.com/dex/media/pokemon/${dirs[$i]}/ 1> NULL 2> NULL &
done
for job in `jobs -p`
do
echo $job
    wait $job || let "FAIL+=1"
done

echo $FAIL

if [ "$FAIL" == "0" ];
then
echo "YAY!"
else
echo "FAIL! ($FAIL)"
fi

echo "finish1"