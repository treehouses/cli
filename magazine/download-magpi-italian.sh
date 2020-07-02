magcase="MagPi"
lang=${lang^}
echo "Fetching available $lang $magtype issues..."
for i in {1..3}
do
  wget -q https://www.raspberrypi.org/$magtype-issues/$magcase\_Mini_$lang\_0$i.pdf -P $lang\_issues/
done
