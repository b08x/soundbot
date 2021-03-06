#!/usr/bin/env ruby

require 'tty-command'
require 'tty-prompt'


# start jack and/or pulse audio

def start_jack

  cmd = TTY::Command.new(printer: :pretty)
  cmd.run("jack_control start \
  dps device 'hw:0' \
  dps rate 96000 \
  dps period 1024 \
  dps nperiods 3 \
  dps midi-driver seq \
  eps driver alsa \
  eps realtime True \
  eps realtime-priority 80 \
  eps verbose True \
  eps client-timeout 1000")

  sleep 1

  cmd.run("a2j_control start")

end

def set_alsa
  cmd = TTY::Command.new(printer: :pretty)
  # set master, headphone and PCM, make sure they're not muted and
  # mute the speaker
  cmd.run("amixer -D hw:0 sset PCM,0 58 unmute")
  cmd.run("amixer -D hw:0 sset Front,0 58 unmute")
  cmd.run("amixer -D hw:0 sset Surround,0 58 unmute")
  cmd.run("amixer -D hw:0 sset Center,0 58 mute")
  cmd.run("amixer -D hw:0 sset LFE,0 58 mute")
  cmd.run("amixer -D hw:0 sset Side,0 58 unmute")
  cmd.run("amixer -D hw:0 set PCM 90%")

end

set_alsa
start_jack

# prompt = TTY::Prompt.new
#
# engine = prompt.select("select audio engine to start") do |menu|
#   menu.default 1
#
#   menu.choice 'jack', 1
#   menu.choice 'pulse', 2
#   menu.choice 'jack and pulse', 3
#
# end
#
# cmd = TTY::Command.new(printer: :pretty)
#
# case engine
#   when 1
#     start_jack
#   when 2
#     cmd.run("pulseaudio --start")
#   when 3
#     start_jack
#     sleep 1
#     cmd.run("pulseaudio --start")
# end
