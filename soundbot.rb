#!/usr/bin/env ruby

$LOAD_PATH.push File.expand_path(File.dirname(__FILE__) + '/lib')

APP_ROOT = File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'commander'
require 'extract_audio_segment'


class Soundbot
  include Commander::Methods
  # include whatever modules you need

  def run
    program :name, 'Soundbot'
    program :version, '0.0.1'
    program :description, 'manage sounds'

    command :normalize do |c|
      c.syntax = 'Soundbot normalize [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Soundbot::Commands::Normalize
      end
    end

    command :convert do |c|
      c.syntax = 'Soundbot convert [options]'
      c.summary = 'convert sf2 to sfz'
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Soundbot::Commands::Convert
      end
    end

    command :extract do |c|
      c.syntax = 'Soundbot extract [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Soundbot::Commands::Extract
      end
    end

    command :info do |c|
      c.syntax = 'Soundbot info [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--file FILE', 'Some switch that does something'
      c.action do |args, options|
        p args
      end
    end

    run!
  end

end

Soundbot.new.run if $0 == __FILE__
