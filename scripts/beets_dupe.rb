https://github.com/beetbox/beets/issues/2873


run checksum on file;

  ffmpeg -i {file} -f crc -

take resulting checksum and add to database field
