#!/usr/bin/env ruby

require 'pty'
require 'expect'
require 'tty-command'
require 'fileutils'


cmd = TTY::Command.new

results = cmd.run("cat <(echo "LIST DB_INSTRUMENTS RECURSIVE '/'") | netcat 127.0.0.1 8888 -q 1")

puts "#{results}"


#puts "#{@x}"
