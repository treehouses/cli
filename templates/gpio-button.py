#!/usr/bin/env python
# -*- coding: utf-8 -*-

import RPi.GPIO as GPIO
import time
import subprocess

ESTIMATED_STATE_DIFF_DURATION = 1
ESTIMATED_PIN_CALLBACK_DURATION = 15

GPIO.cleanup()
GPIO.setmode(GPIO.BOARD)
GPIO.setup(18, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

prevState = None
while True:
  state = GPIO.input(18)
  # sleep in the loop is related to how fast the command in the block run
  if prevState == state:
    time.sleep(ESTIMATED_STATE_DIFF_DURATION)
    continue
  elif state == 1:
    print "Pin is on"
    try:
      subprocess.check_output(['bash', '/etc/gpio-button-action-on.sh'])
    except:
      pass
    time.sleep(ESTIMATED_PIN_CALLBACK_DURATION)
  else:
    print "Pin is off"
    try:
      subprocess.check_output(['bash', '/etc/gpio-button-action-off.sh'])
    except:
      pass
    time.sleep(ESTIMATED_PIN_CALLBACK_DURATION)

  prevState = state
