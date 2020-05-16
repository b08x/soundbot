# #!/usr/bin/env ruby
#
# # edit sound file(s) using sox and bs1770gain
# # standardize file/folder names
# # convert wavs to flac
# # convert to 24bit/48khz
# # use highpass filter to exclude any frequencies below 15hz
# # "normalize" to ~-23dbFS
#
# require 'commander/import'
#
# program :name, 'Do Sox Stuff'
# program :version, '1.0.0'
# program :description, 'manipulate sound files with sox'
#
# def fileinfo(file)
# #pp File.basename(args[0],".*")
#   file = Pathname.new(file)
#   file_info = {}
#   file_info[:fullpath] = file
#   file_info[:dir] = file.dirname
#   file_info[:name] = file.basename(".*")
#   return file_info
# end
#
#
# class SoxCommand
#
#   def resample(file_info)
#
#     p file_info
#   end
#
# end
#
# command :resample do |c|
#   c.syntax = 'do_sox_stuff resample [files]'
#   c.description = 'resample file to 24bit/48khz'
#   c.action do |args|
#     args.each do |a|
#       file_info = fileinfo(a)
#       resample(file_info)
#     end
#   end
# end
