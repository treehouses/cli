function wificountry {
  local country
  checkrpi
  checkroot
  checkargn $# 1
  country=$1
  country=${country^^}
  country_codes=(US CA JP DE NL IT PT LU NO FI DK CH CZ ES GB KR CN FR HK SG TW BR
                 IL SA LB AE ZA AR AU AT BO CL GR IS IN IE KW LI LT MX MA NZ PL PR
                 SK SI TH UY PA RU KW LI LT MX MA NZ PL PR SK SI TH UY PA RU EG TT
                 TR CR EC HN KE UA VN BG CY EE MU RO CS ID PE VE JM BH OM JO BM CO
                 DO GT PH LK SV TN PK QA DZ)

  case "$1" in
    "")
      if [ -e /etc/wpa_supplicant/wpa_supplicant.conf ]; then
        result=$(grep "country=" /etc/wpa_supplicant/wpa_supplicant.conf)
        if [ -n "$result" ]; then
          echo "$result"
        else
          echo "Wifi country not set"
        fi
      fi
      ;;

    *)
      for country_code in "${country_codes[@]}"
      do
        if [ "$country" = "$country_code" ]; then
          if [ -e /etc/wpa_supplicant/wpa_supplicant.conf ]; then
            if grep -q "^country=" /etc/wpa_supplicant/wpa_supplicant.conf ; then
              sed -i --follow-symlinks "s/^country=.*/country=$country/g" /etc/wpa_supplicant/wpa_supplicant.conf
            else
              sed -i --follow-symlinks "1i country=$country" /etc/wpa_supplicant/wpa_supplicant.conf
            fi
          else
            echo "country=$country" > /etc/wpa_supplicant/wpa_supplicant.conf
          fi
          iw reg set "$country" 2> "$LOGFILE";

          if [ -f /run/wifi-country-unset ] && hash rfkill 2> "$LOGFILE"; then
            rfkill unblock wifi
          fi

          conf_var_update "WIFICOUNTRY" "$country"
          echo "Success: the wifi country has been set to $country"
          exit 0
        fi
      done

      echo "error: invalid country code"
      exit 1
      ;;
  esac

}

function wificountry_help {
  echo
  echo "Usage: $BASENAME wificountry <country>"
  echo
  echo "Sets the wireless interface country. Required on rpi 3b+ in order to get wifi working."
  echo
  echo "Example:"
  echo
  echo "  $BASENAME wificountry"
  echo "      This will display the current wifi country setting."
  echo
  echo "  $BASENAME wificountry US"
  echo "      This will set the wifi country to 'US'."
  echo "      This configuration is used in all commands (wifi, bridge, hotspot)."
  echo
}
