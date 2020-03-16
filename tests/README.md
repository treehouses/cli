# Testing

We use the [bats](https://github.com/sstephenson/bats) package.
Make sure to do testing on a Raspberry Pi. Support for other platforms
isn't guaranteed.

If the network mode is set to wifi and you're connected over wifi
this will skip a lot of the tests in order so you won't lose your 
SSH session.

Example:

```
sudo apt install bats
sudo bats ./tests/blocker.bats # test a single file
nssidname='Wifiname' nwifipass='wifipass' sudo ./tests/wifi.bats
sudo ./tests/test-cli.sh # test everything (variables inside test-cli.sh as well)

```

Note: Some tests are not included because they have restarts
(test manually w/out bats commands)
