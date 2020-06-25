echo "Fetching available Hebrew MagPi issues..."
for i in {1..3}
do
  wget -q https://www.raspberrypi.org/magpi-issues/MagPi_Mini_Hebrew_0$i.pdf -P Hebrew\_issues/
done
