processing organic drum sample

sox --combine merge *.wav kick-loud-trap-beats.wav remix 1v0.8,2,3,4,5v0.8

sox --combine merge 01-BD-11CR-BRS-BELL-L-OGDL.wav 02-SD-11CR-BRS-BELL-L-OGDL.wav 03-RM-11CR-BRS-BELL-L-OGDL.wav 11CR-BRS-BELL-L-OGDL.wav remix -
sox --combine merge 04-OHL-11CR-BRS-BELL-L-OGDL.wav 05-OHR-11CR-BRS-BELL-L-OGDL.wav 11CR-BRS-BELL-L-OGDL.wav remix 1 2

sox --combine merge *.wav KICK-LOUD-JUNGLERY.wav remix 1v0.8,3v0.2,4v0.2 1v0.8,2,3v0.2,4v0.2,5



#---------------
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

def remove_unwanted_characters(string)
  # take the original file name, and standardize
  # format by removing whitespaces, multiple underscores
  # dashes, digits at the start of line and ensuring file name is all lowercaseinfile

  #filename.gsub!(/-|\s|\)|\(|__|\.|\+/,"_")
  #...this one doesn't replace dashes
  string = string.gsub(/\s|\)|\(|\+/,"_")
  string = string.gsub(/__/,"_")
  string = string.gsub(/_$/,"")

  #filename.gsub!(/^\d+_/,"")

  string = string.downcase

  return string
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
  backup(@files)extname
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


sox -V JoMoX_111bpm_Triangle.wav -b 24 JoMoX_111bpm_Triangle.flac rate -v -I -b 90 48k highpass 15
sox -V -G david-lizmi_bass-loop-20_bass_loop_152.wav -b 24 david-lizmi_bass-loop-20_bass_loop_152.flac rate -v -I -b 90 48k highpass 15

bs1770gain --codec=flac --suffix=flac --track-tags --atsc ~/Studio/library/sounds/loops/111bpm_Waveform_loops/JoMoX_111bpm_Triangle.flac --overwrite -a -u shortterm-mean
bs1770gain --codec=flac --suffix=flac --track-tags --atsc ~/Studio/library/sounds/loops/bass_loops/david-lizmi_bass-loop-20_bass_loop_152.flac --overwrite -a -u momentary-maximum --shortterm-length=3000 --momentary-length=3000

bs1770gain --codec=flac --suffix=flac --track-tags \
"/home/b08x/Studio/library/sounds/keys/SalamanderGrandPianoV3_48khz24bit/48khz24bit/A0v16.flac" \
--overwrite -a -u momentary-mean  --shortterm-length=20000 --momentary-length=2400 \
--momentary-mean-gate=-20

# grab the length from the output of the sox stat command and convert to ms
# new_hash = {}
#
# results = cmd.run("sox '#{f}' -n stat")
# results.err.each_line do |x|
#   if x =~ /Length/
#     k,v = x.gsub(/\s/,'').split(":")
#     new_hash = {:length => v.to_f * 1000}
#     p new_hash
#   end
# end

#----------------------or

# f = Pathname.new("/home/b08x/Studio/library/sounds/loops/111bpm_Waveform_loops/JoMoX_111bpm_Triangle.wav")
# file_name,file_ext = f.basename.to_s.split(".")
# file_dir_name = f.dirname
#
# output = Hash.new { |hash, key| hash[key] = [] }
#
# results = cmd.run("sox '#{f}' -n stat")
# results.err.each_line do |x|
#   if x =~ /Length/
#     k,v = x.gsub(/\s/,'').split(":")
#     output[file_name.to_sym] = {
#       :type => file_ext.to_s,
#       :length => v.to_f * 1000,
#       :dir => file_dir_name.to_s
#     }
#     p output
#   end
# end
##------------------------or

file = Pathname.new("/home/b08x/Studio/library/sounds/loops/111bpm_Waveform_loops/JoMoX_111bpm_Triangle.wav")
file_name,file_ext = f.basename.to_s.split(".")
file_dir_name = f.dirname

file_info = {}
file_info[:fullpath] = file
file_info[:dir] = file_dir_name
file_info[:name] = file_name
file_info[:type] = file_ext

results = cmd.run("sox '#{file}' -n stats")
# 2>&1|awk '/^RMS\ lev\ dB/ {print ($4)}'
# 2>&1|awk '/^Length\ s/ {print ($3)}'
# results.err.each_line do |x|
#   if x =~ /Length/
#     k,v = x.gsub(/\s/,'').split(":")
#     file_info[:length] = v.to_f * 1000
#   end
# end
#
# p file_info

# get duration through soxi
soxi -D '#{file}'

results.err.each_line do |x|
  if x =~ /Length/
    length = x.gsub(/Length s\s+/,'')
    file_info[:length] = length.to_f * 1000
  end
  if x =~ /RMS lev dB/
    level = x.gsub(/RMS lev dB\s+/,'').split(" ").first
    file_info[:rms] = level.to_f
  end
  if x =~ /Pk lev dB/
    level = x.gsub(/Pk lev dB\s+/,'').split(" ").first
    file_info[:peak] = level.to_f
  end
end

if file_info[:rms] >= -23
  then calcuate length in terms of --shortterm-length and momentary-length
  e.g. Length s       0.456 then --shortterm-length <= 450

# adjust folder name (remove spaces, etc) and create a new folder with this
# new name, followed by the suffix "converted"
new_file_dir_name = remove_unwanted_characters(file_info[:dir].basename.to_s)
new_file_dir_name = new_file_dir_name + "_new"

file_info[:newdir] = file_info[:dir].parent + new_file_dir_name

# same with file name
new_file_name = remove_unwanted_characters(file_name)
file_info[:newname] = new_file_name

newfullpath = file_info[:newdir] + file_info[:newname]

file_info[:newfullpath] = newfullpath.sub_ext(".flac")

FileUtils.mkpath(file_info[:newdir])





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

#!/usr/bin/env ruby


#load sample names from the base directory...
#later to be used in autocompletion and what not
require 'pathname'
require 'fileutils'

# drumkits = "/home/b08x/studio/resources/samples/drums/drumkits/**"
#
# Dir.glob(drumkits + "/*.{flac,wav}").each do |x|
#   perc = Pathname.new(x)
#
#   name = perc.basename
#
#
#   puts name.to_s.gsub(/#{perc.extname}/,'')
#
# end


#############################################
drum_kits = Pathname.new("/home/b08x/studio/library/sfz/drums/")

drum_kits = drum_kits.children

drum_kits.map { |x| x.to_s  }.each do |y|

  folder_path = y
  p folder_path

  sample_files = Dir.entries(y)
  sample_files.sort!  {|x,y| x <=> y}

  puts File.basename(y)
  new_prefix = File.basename(y)
  new_prefix = new_prefix.downcase + "_"
  new_prefix = new_prefix.gsub(/-|\s/,"_")
  puts new_prefix
  puts "-" * 20


  sample_files.each do |file|
    next if File.directory?(file)
    next unless File.extname(file) =~ /wav|flac|aiff/


    #file = file.gsub(/^\d+/,"")
    #file = file.gsub(/-|\s|__|\+/,"_")
    # file_ext = File.extname(file)
    new_file_name = new_prefix + file
    new_file_name = new_file_name.gsub(/-|\s|__|\+/,"_")
    new_file_name = new_file_name.downcase

    old_name = folder_path + "/" + file
    new_name = folder_path + "/" + new_file_name


    File.rename(old_name,new_name)
    # sample_file = file.gsub(/#{file_ext}/,'')
    #
    # puts sample_file
  end
  3.times do
    puts "\n"
  end

end
#################################################

# def print_sample_files(dir)
#   sample_files = Dir.entries(dir)
#   sample_files.sort!  {|x,y| x <=> y}
#   puts File.basename(dir)
#   puts "-" * 20
#
#
#   sample_files.each do |file|
#     next if File.directory?(file)
#     next unless File.extname(file) =~ /wav|flac|aiff/
#
#     #file_ext = File.extname(file)
#     #sample_file = file.gsub(/#{file_ext}/,'')
#
#     puts File.(file)
#   end
#   3.times do
#     puts "\n"
#   end
#
# end
#
#
# forzee_kit = "/home/b08x/studio/library/sfz/drums/YamahaVintageKit/"
#
#
# print_sample_files(forzee_kit)

# conver to lower case
# replace spaces with underscore


#

# sample_dir = Pathname.new("/home/b08x/studio/resources/samples")
#
# samples = Dir.glob(sample_dir + "**/*.{flac,wav,aiff}")
#
# puts samples

for flac in *.flac; do bs1770gain --codec=flac --suffix=flac /home/b08x/.hydrogen/data/drumkits/tea_flow_kit/$flac --overwrite -a; done
