echo "Fetching available Spanish MagPi issues..."
for i in {1..3}
do
  wget -q https://www.raspberrypi.org/magpi-issues/MagPi_Mini_Spanish_0$i.pdf -P Spanish\_issues/
done
