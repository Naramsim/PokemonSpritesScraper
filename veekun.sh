#! /bin/sh
onlyAudio=false
onlyMain=false
onlyOther=false
while getopts "zamo" flag
do
  case $flag in
    z) zipSprites=true;;
    a) onlyAudio=true;;
    m) onlyMain=true;;
	o) onlyOther=true;;
  esac
done

if [[ "$onlyOther" = "false" && "$onlyAudio" = "false" && "$onlyMain" = "false" ]] ; then
	echo "Use some options"
	exit
fi
if [[ "$onlyOther" = "true" ]] ; then
	dirs+=('conquest')
	dirs+=('cropped')
	dirs+=('dream-world')
	dirs+=('footprints')
	dirs+=('global-link')
	dirs+=('icons')
	dirs+=('mystery-dungeon')
	dirs+=('overworld')
	dirs+=('sugimori')
	dirs+=('trozei')
fi
if [[ "$onlyMain" = "true" ]] ; then
	dirs+=('main-sprites/yellow')
	dirs+=('main-sprites/black-white')
	dirs+=('main-sprites/crystal')
	dirs+=('main-sprites/diamond-pearl')
	dirs+=('main-sprites/emerald')
	dirs+=('main-sprites/firered-leafgreen')
	dirs+=('main-sprites/gold')
	dirs+=('main-sprites/heartgold-soulsilver')
	dirs+=('main-sprites/omegaruby-alphasapphire')
	dirs+=('main-sprites/platinum')
	dirs+=('main-sprites/red-blue')
	dirs+=('main-sprites/red-green')
	dirs+=('main-sprites/ruby-sapphire')
	dirs+=('main-sprites/silver')
	dirs+=('main-sprites/x-y')
fi
if [[ "$onlyAudio" = "true" ]] ; then
	dirs+=('cries')
fi

FAIL=0
for dir in "${dirs[@]}" ;
do
	echo "GET http://veekun.com/dex/media/pokemon/$dir/" &
    wget --no-host-directories --no-cache -nc -c -U "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2600.0 Iron Safari/537.36" -r -l6 -A png,gif,svg,ogg -R html --no-parent --exclude-directories=../ http://veekun.com/dex/media/pokemon/$dir/ 1> NULL 2> NULL &
done
for job in `jobs -p`
do
echo $job
    wait $job || let "FAIL+=1"
done
if [ "$FAIL" == "0" ];
then
echo 'Done'
else
echo "Failed ($FAIL) times"
fi

if [[ "$zipSprites" = "true" ]]; then
	echo 'Zipping'
	zip -r -q sprites.zip dex/
	echo 'Done'
fi