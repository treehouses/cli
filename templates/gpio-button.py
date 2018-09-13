#!/usr/bin/env python
# -*- coding: utf-8 -*-

import RPi.GPIO as GPIO
import time
import subprocess

GPIO.cleanup()
GPIO.setmode(GPIO.BOARD)
GPIO.setup(18, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

prevState = None
while True:
  state = GPIO.input(18)
  if prevState == state:
    continue
  elif state == 1:
    print "Pin is on"
    try:
      subprocess.check_output(['bash', '/etc/gpio-button-action-on.sh'])
    except:
      pass
    time.sleep(15)
  else:
    print "Pin is off"
    try:
      subprocess.check_output(['bash', '/etc/gpio-button-action-off.sh'])
    except:
      pass
    time.sleep(15)

  prevState = state
