#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function sox_pwm () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  # local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  # cd -- "$SELFPATH" || return $?

  local -A CFG=(
    [pwm_cycle_msec]=20
    [dc_offset_pct]=50
    [phase_shift_pct]=50
    [n_cycles]=10
    [duty_pct]="${1:-7.5}"
    [save_wave]=
    [pa_dev]='alsa_output.usb-GeneralPlus_USB_Audio_Device-00-Device_1.analog-stereo'
    )
  # CFG[save_wave]='pwm.wav'

  local DEST_TYPE='pulseaudio'
  local DEST_NAME="${CFG[pa_dev]}"
  if [ -n "${CFG[save_wave]}" ]; then
    DEST_TYPE='wav'
    DEST_NAME="${CFG[save_wave]}"
  fi

  local SYNTH_FREQ=$(( 1000 / ${CFG[pwm_cycle_msec]} ))
  local DURA_MSEC=$(( ${CFG[n_cycles]} * ${CFG[pwm_cycle_msec]} ))
  [ "$DURA_MSEC" -lt 60000 ] || return 4$(
    echo "E: This script is meant to produce very short audio," \
      "a few seconds at most." >&2)
  local DURA_HMS="$DURA_MSEC"
  while [ "${#DURA_HMS}" -lt 5 ]; do DURA_HMS="0$DURA_HMS"; done
  DURA_HMS="00:00:${DURA_HMS:0:2}.${DURA_HMS:2}"
  # local -p | sort -V

  local SOX_CMD=(
    sox
    -q  # quiet
    -n  # no input file
    -t "$DEST_TYPE" "$DEST_NAME"
    synth
    -n  # ignore input channel
    "$DURA_HMS"
    square
    create
    "$SYNTH_FREQ"
    "${CFG[dc_offset_pct]}"
    "${CFG[phase_shift_pct]}"
    "${CFG[duty_pct]}"
    )
  echo "D: run: ${SOX_CMD[*]}" >&2
  "${SOX_CMD[@]}" || return $?$(echo "E: failed to play: rv=$?" >&2)
}










sox_pwm "$@"; exit $?
