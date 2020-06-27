availablelang=0
for file in $MAGAZINE/*; do
  if [ "$magtype" = "$(echo "${file##*/}" | sed -e 's/^download-//' -e 's/.sh$//')" ]; then 
    case $magtype in
      "hackspace")       
        magcase="HackSpace"
        ;;
      "helloworld")       
        magcase="HelloWorld"
        ;;
      "magpi")       
        magcase="MagPi"
	if [ $lang = "french" ] || [ $lang = "hebrew" ] || [ $lang = "italian" ] || [ $lang = "spanish" ]; then
          availablelang=1
        fi
        ;;
      "wireframe")       
        magcase="Wireframe"
        ;;
    esac 
  fi
done
lang=${lang^}
if [ $availablelang = 0 ]; then 
  echo "Please enter a valid language for $magtype" 
  exit 1 
fi
echo "Fetching available $lang $magtype issues..."
for i in {1..3}
do
  wget -q https://www.raspberrypi.org/$magtype-issues/$magcase\_Mini_$lang\_0$i.pdf -P $lang\_issues/
done
