echo "Fetching available French MagPi issues..."
for i in {1..3}
do
  wget -q https://www.raspberrypi.org/magpi-issues/MagPi_Mini_French_0$i.pdf -P French\_issues/
done
