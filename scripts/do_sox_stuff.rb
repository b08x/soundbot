#!/usr/bin/env ruby

# take a folder of audio files and use sox to mixdown to mono
# then.....

require 'tty-prompt'
require 'tty-command'
require 'fileutils'

# for the most part, will be using this within the samples directory
# within the library folder. will adjust later if need be
HOME = ENV['HOME']
LIBRARY = File.join(HOME, "studio", "library")

prompt = TTY::Prompt.new

folder = prompt.ask("Folder name? Assuming folder is in #{LIBRARY}/") do |q|
  q.required(true)
  q.validate ->(v) {return Dir.exist?(File.join(LIBRARY, v)) }
  q.messages[:valid?] = 'Folder does not exist'
  q.messages[:required?] = 'Folder name must not be empty'
end

#
# # prompt whether or not to keep the original file
keep_original = prompt.yes?('keep original file?')

SRC_DIR = File.join(LIBRARY, folder)

def run_sox_rate(tmpinputfile,outputfullpath)  # instantiate a new sox command obj"t

  cmd = TTY::Command.new

  #cmd.run("sox -V --temp /tmp --single-threaded '#{tmpinputfile}' -b 24 '#{outputfullpath}' channels 1 rate -v -I -b 90 48k")
  cmd.run("sox -V --temp /tmp --single-threaded '#{tmpinputfile}' -b 24 '#{outputfullpath}' rate -v -I -b 90 48k")
end

def run_sox_compand(in,out)
  sox -V '#{tmpinputfile}' '#{outputfullpath}' compand 2,2 -60,-60,-50,-20,0,-20 -20 -60 1
end

def run_sox_spectrogram(in)
  # for file in *.flac;do
  #     outfile="${file%.*}.png"
  #     sox "$file" -n spectrogram -o "$outfile"
  # done


  sox '#{in}' -n spectrogram -o "OUTPUTFILEPATH/OUTPUTFILENAME.png"
end

#use metaflac to alter flac tag info
def embed_spectrogram_into_flac
  `metaflac --import-picture-from`
end


def add_replay_gain_tags
  # Since this operation requires two passes, it is always executed last,
  # after all other operations have been completed and written to disk.
  `metaflac --add-replay-gain`
end

def remove_unwanted_characters(filename)
  # take the original file name, and standardize
  # format by removing whitespaces, multiple underscores
  # dashes, digits at the start of line and ensuring file name is all lowercaseinfile

  #filename.gsub!(/-|\s|\)|\(|__|\.|\+/,"_")
  #...this one doesn't replace dashes
  filename.gsub!(/\s|\)|\(|\+/,"_")
  filename.gsub!(/__/,"_")
  filename.gsub!(/_$/,"")

  #filename.gsub!(/^\d+_/,"")

  filename.downcase!

  p filename
  #return a_cleaner_filename
end

#def flip_and_reverse
def trim_silence_from_end(infile)
  #work in a tmp directory...
  #run reverse effect and create a new reversedoutfile
  #silence the begining of that newly created reveresed audio sample
  #then reverse that one, using "a_cleaner_filename" as the outfile
  #http://forums.justlinux.com/showthread.php?136678-using-sox-to-trim-silence-from-the-end-of-wav-files
  #https://digitalcardboard.com/blog/2009/08/25/the-sox-of-silence/

  set_effects(:reverse=>true, :silence=>"1 0.1 0.1% reverse")


end

def do_file_stuff_in_tmpfs
  #TODO: this will require a sudo method


  #check available system memorty
  free_memory = `free -m | awk '/Mem/ {print $4}'`

  # by default, try to mount 1GB worth of tmpfs
  # the difference between backticks and system
  # is shown here, as the we only care about whether
  # or not this happen. Whereas using backticks will
  # return a result.
  unless free_memory < 1024sox --plot
    system("mount -o remount,size=4G,noatime ~/tmpsox")
  end

end

def process(files)
  inputfiles = files.select { |x| x.extname =~ /flac|aiff|wav|mp3/}

  inputfiles.each do |inputfile|
    puts "inputfile: #{inputfile}"
  end


end

def backup(files)
  #TODO: use hash key for "src_drc"
  #create a "temp" backup folder

  bak = Dir.mktmpdir('backup', SRC_DIR)

  files.each do |file|
    #a = Pathname.new(File.join(SRC_DIR, file))
    # create a hard link to file in the backup folder
    FileUtils.cp_lr(file.cleanpath, bak)
    puts "#{a}"
  end

end

def get_folder_list(folder_contents)
  @folders = folder_contents.select { |x| File.stat(x.cleanpath.to_s).directory? && x.basename.to_s !~ /^\./ }
end

def get_file_list(folder_contents)
  @files = folder_contents.reject { |x| File.stat(x.cleanpath.to_s).directory? && x.basename.to_s =~ /^\./ }
end

def get_folder_contents(folder)
  #TODO: convert to hash folder => folder_contents
  @folder_contents = Dir.entries(folder)
  @folder_contents.map! { |x| Pathname.new(File.join(folder, x))}

  return

end
#-------------------------------------------
#need to glob folders first, then for each folder, glob audio files
#create new folder, process. once complete, remove old folder
@folder_contents = []
get_folder_contents(SRC_DIR)

get_file_list(@folder_contents)

get_folder_list(@folder_contents)


if @files.any?
  backup(@files)
  process(@files)
end

if @folders.any?
  @folders.each do |folder|
    get_folder_contents(folder)
    get_file_list(@folder_contents)
    unless @files.empty?
      backup(@files)
      process(@files)
    end
  end
end



##------

# folder_contents.each do |folder|
#   next if folder == '.' or folder == '..'
#
#   puts "folder: #{folder}"
#   puts "-" * 36
#
#   inputfolder = Pathname.new(folder)
#   inputpath = File.join(SRC_DIR, inputfolder.basename)
#
#
#   puts "inputfolder: #{inputfolder}\n"
#   puts "inputpath: #{inputpath}"
#
#   outputfolder = remove_unwanted_characters(folder)
#   outputpath = File.join(SRC_DIR, outputfolder)
#
#   puts "outputfolder: #{outputfolder}\n"
#   puts "outputpath: #{outputpath}\n"
#
#   #ensure the output directory exists if it does not
#   unless Dir.exists?(outputpath)
#     puts "creating new folder..."
#     FileUtils.mkpath(outputpath)
#   end
#
#   #grab the audio files from the current working dir
#   puts "globbing!"
#
#   inputfiles = Dir.glob(inputpath + "/**/*.{flac,wav,mp3,aiff}")
#
#   inputfiles.each do |inputfile|
#     next if File.directory?(inputfile)
#
#     # get some basic info via soxi
#     puts "#{inputfile}:\n\n"
#     puts "*****"
#
#     ch = `soxi -c "#{inputfile}"`.strip.to_i
#     sr = `soxi -r "#{inputfile}"`.strip.to_i
#     bd = `soxi -p "#{inputfsox --plotile}"`.strip.to_i
#     en = `soxi -t "#{inputfile}"`.strip
#
#     puts "chan: #{ch}\n samplerate: #{sr}\n bitdepth: #{bd}\n encoding: #{en}"
#
#  	  infilefullpath = Pathname.new(inputfile)
#
#     inputpath, inputfile = File.split(infilefullpath.cleanpath)
#
#     inputfilename,ext = inputfile.split(/\./)
#
#     puts "send just the file name and the directroy path to a regex method to standardize filenames\n"
#     puts "before: #{inputfilename}"
#
#     outputfile = remove_unwanted_characters(inputfilename)
#
#     puts "after: #{outputfile}"
#
#     tmpinputfile = "infile_" + inputfile
#     tmpinputfile = File.join(inputpath, tmpinputfile)
#
#     puts "temp input file name = #{tmpinputfile}"
#
#     puts "renaming the input file"
#     FileUtils.cp(infilefullpath,tmpinputfile)
#
#     outputfile = Pathname.new(outputfile)
#     outputfile = outputfile.sub_ext(".wav")
#
#     puts "the new output file name with an extension: #{outputfile}"
#
#     outputfullpath = File.join(outputpath, outputfile.basename.to_s)
#
#     puts "the full output path: #{outputfullpath}\n"
#
#     if ch == 1 && sr == 48000 && bd == 24
#       puts "already mono 24bit/48k"
#       next
#     end
#
#     run_sox_mono_rate(tmpinputfile, outputfullpath)
#
#     unless keep_original == true
#       FileUtils.remove_file(tmpinputfile)
#     end
#   end
#
#   #todo: remove original folder
#   #ensure any atrifacts are copied to the new folder (e.g. sfz, h2, xml, etc)
# end
