#! /bin/sh
onlyAudio=false
onlyMain=false
onlyOther=false
onlyGif=false
only60Fps=false
while getopts "zamogf" flag
do
  case $flag in
    z) zipSprites=true;;
    a) onlyAudio=true;;
    m) onlyMain=true;;
	o) onlyOther=true;;
	g) onlyGif=true;;
	f) only60Fps=true;;
  esac
done

if [[ "$onlyOther" = "false" && "$onlyAudio" = "false" && "$onlyMain" = "false" && "$onlyGif" = "false" && "$only60Fps" = "false" ]] ; then
	echo "Use some options"
	exit
fi
if [[ "$onlyOther" = "true" ]] ; then
	veekun+=('conquest')
	veekun+=('cropped')
	veekun+=('dream-world')
	veekun+=('footprints')
	veekun+=('global-link')
	veekun+=('icons')
	veekun+=('mystery-dungeon')
	veekun+=('overworld')
	veekun+=('sugimori')
	veekun+=('trozei')
fi
if [[ "$onlyMain" = "true" ]] ; then
	veekun+=('main-sprites/yellow')
	veekun+=('main-sprites/black-white')
	veekun+=('main-sprites/crystal')
	veekun+=('main-sprites/diamond-pearl')
	veekun+=('main-sprites/emerald')
	veekun+=('main-sprites/firered-leafgreen')
	veekun+=('main-sprites/gold')
	veekun+=('main-sprites/heartgold-soulsilver')
	veekun+=('main-sprites/omegaruby-alphasapphire')
	veekun+=('main-sprites/platinum')
	veekun+=('main-sprites/red-blue')
	veekun+=('main-sprites/red-green')
	veekun+=('main-sprites/ruby-sapphire')
	veekun+=('main-sprites/silver')
	veekun+=('main-sprites/x-y')
fi
if [[ "$onlyAudio" = "true" ]] ; then
	veekun+=('cries')
fi
if [[ "$onlyGif" = "true" ]] ; then
	dirs+=('http://sprites.pokecheck.org/i/')
	dirs+=('http://sprites.pokecheck.org/b/')
	dirs+=('http://sprites.pokecheck.org/s/')
	dirs+=('http://sprites.pokecheck.org/bs/')
fi
if [[ "$only60Fps" = "true" ]] ; then
	dirs+=('http://play.pokemonshowdown.com/sprites/xyani/')
	dirs+=('http://play.pokemonshowdown.com/sprites/xyani-back/')
	dirs+=('http://play.pokemonshowdown.com/sprites/xyani-shiny/')
	dirs+=('http://play.pokemonshowdown.com/sprites/xyani-back-shiny/')
fi

FAIL=0
for veek in "${veekun[@]}" ;
do
	echo "GET http://veekun.com/dex/media/pokemon/$veek/" &
    wget --no-host-directories --no-cache -nc -c -U "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2600.0 Iron Safari/537.36" -e robots=off -r -l6 -A png,gif,svg,ogg -R html,txt --no-parent http://veekun.com/dex/media/pokemon/$veek/ 1> NULL 2> NULL &
done

for dir in "${dirs[@]}" ;
do
	echo "GET $dir" &
    wget -P gifs --no-host-directories --no-cache -nc -c -U "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2600.0 Iron Safari/537.36" -e robots=off -r -l1 -A gif -R html,txt --no-parent --exclude-directories=/themes/ $dir 1> NULL 2> NULL &
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