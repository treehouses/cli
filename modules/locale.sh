#!/bin/bash

function locale {
  locale="$1"
  if [ -z "$locale" ];
  then
    echo "Error: the locale is missing"
    exit 1
  fi

  if ! locale_line="$(grep "^$locale " /usr/share/i18n/SUPPORTED)";
  then
    echo "Error: the specified locale is not supported"
    exit 1
  fi

  encoding="$(echo "$locale_line" | cut -f2 -d " ")"
  echo "$locale $encoding" > /etc/locale.gen
  sed -i "s/^\\s*LANG=\\S*/LANG=$locale/" /etc/default/locale
  dpkg-reconfigure -f noninteractive locales -q 2>"$LOGFILE"
  echo "Success: the locale has been changed"
}

function locale_help {
  echo
  echo "Usage: $BASENAME locale <locale>"
  echo
  echo "Sets the system locale"
  echo
  echo "Example:"
  echo "  $BASENAME locale en_US"
  echo "      This will set the raspberry pi locale to en_US."
  echo "      The supported languages are in /usr/share/i18n/SUPPORTED"
  echo
}
