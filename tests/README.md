# Testing

We use the [bats](https://github.com/sstephenson/bats) package.
Make sure to do testing on a Raspberry Pi. Support for other platforms
isn't guaranteed.

If the network mode is set to wifi and you're connected over wifi
this will skip a lot of the tests in order so you won't lose your 
SSH session.

Example:

```bash
sudo su
apt install bats
cd tests
bats ./services/moodle.bats # test a single file
nssidname='Wifiname' nwifipass='wifipass' ./wifi.bats
```

`test.sh` gives extra information ontop of running the tests using bats including
Image release, CLI version, and git branch name
```bash
./test.sh detect.bats detectrpi.bats # pick what you want
./test.sh all # test everything (variables inside test.sh as well)
yes | ./test.sh all # skip pressing any key to move forward for network tests
./test.sh services
./test.sh wifi
./test.sh ap
./test.sh nonet # all modules that don't require an internet connection
./test.sh nonetblue # no internet and no bluetooth
```

Note: Some tests are not included because they have restarts
(test manually w/out bats commands)

Example output:
```bash
root@treehouses:~/cli/tests# ./test.sh detect.bats detectrpi.bats

Branch  - tests-time
Image   - release-125
Version - 1.16.25

 ✓  detect
 ✓  detectrpi
 ✓  detectrpi model

3 tests, 0 failures

real    0m2.460s
user    0m1.617s
sys     0m1.048s

root@treehouses:~/cli/tests#
```
