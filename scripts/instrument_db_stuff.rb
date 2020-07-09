#!/usr/bin/env ruby

# require 'pty'
# require 'expect'
# require 'tty-command'
# require 'fileutils'
#
#
# cmd = TTY::Command.new
#
# results = cmd.run("echo "LIST DB_INSTRUMENTS RECURSIVE '/'" | netcat 127.0.0.1 8888 -q 1")
#
# puts "#{results}"


#puts "#{@x}"


# lscp=# ADD DB_INSTRUMENTS RECURSIVE FILE_AS_DIR '/brass' '/home/b08x/Studio/library/sounds/soundfonts/brass'
# OK
# lscp=# ADD DB_INSTRUMENTS RECURSIVE FILE_AS_DIR '/collections' '/home/b08x/Studio/library/sounds/soundfonts/collections'
# OK
# lscp=# ADD DB_INSTRUMENTS RECURSIVE FILE_AS_DIR '/keys' '/home/b08x/Studio/library/sounds/soundfonts/keys'
# OK
# lscp=# ADD DB_INSTRUMENTS RECURSIVE FILE_AS_DIR '/loops' '/home/b08x/Studio/library/sounds/soundfonts/loops'
# OK
# lscp=# ADD DB_INSTRUMENTS RECURSIVE FILE_AS_DIR '/percussions' '/home/b08x/Studio/library/sounds/soundfonts/percussions'
# OK
# lscp=# ADD DB_INSTRUMENTS RECURSIVE FILE_AS_DIR '/sfx' '/home/b08x/Studio/library/sounds/soundfonts/sfx'
# OK
# lscp=# ADD DB_INSTRUMENTS RECURSIVE FILE_AS_DIR '/strings' '/home/b08x/Studio/library/sounds/soundfonts/strings'
# OK
# lscp=# ADD DB_INSTRUMENTS RECURSIVE FILE_AS_DIR '/synths' '/home/b08x/Studio/library/sounds/soundfonts/synths'
# OK
# lscp=# ADD DB_INSTRUMENTS RECURSIVE FILE_AS_DIR '/woodwinds' '/home/b08x/Studio/library/sounds/soundfonts/winds'
# OK
# lscp=#
INSTRUMENT NON_MODAL '/home/b08x/Studio/library/sounds/sfx/Earthbound_NEW.sf2
ADD DB_INSTRUMENTS NON_MODAL '/collections' '/home/b08x/Studio/library/sounds/collections/oh_multi_preset.sf2'
