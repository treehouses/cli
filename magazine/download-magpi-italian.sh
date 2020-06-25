echo "Fetching available Italian MagPi issues..."
for i in {1..3}
do
  wget -q https://www.raspberrypi.org/magpi-issues/MagPi_Mini_Italian_0$i.pdf -P Italian\_issues/
done
