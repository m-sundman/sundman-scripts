# sundman-scripts
Various scripts to make things easier.
 * reduce-size    - A script to reduce the resolution and size of photos.
                    This script will process photos in a smart way, reducing
                    resolution (in megapixels) and/or recompressing them, but
                    only if the resulting file is smaller by a given margin.
 * fix-new-photos - A script to fix newly imported photos.
                    When photos are imported from a digital camera they have
                    weird names, contain useless thumbnails and are not
                    rotated correctly. This script fixes all of those (the
                    rotation is automatically corrected only if the camera
                    has a rotation sensor).
 * rotate-jpeg    - Rotates JPEG pictures losslessly.
 * fix-file-ext   - Corrects the file extension of files.
 * flac2mp3       - Convert FLAC to MP3, using lame.
 * md5chk         - Check md5sums, hiding normal output but showing errors.
 * mkvextractsubs - Extract subtitles (and lyrics) from an MKV file.
 * mkvdts2ac3     - Convert DTS audio in an MKV file to AC3.
 * midentify      - Display video file info, using mplayer.
 * midentify-dvd  - Display DVD info, using mplayer.
 * rip-dvd-title  - Ripping DVD titles, using mplayer.
 * unrar-rm       - Uncompress RAR archives, removing the archive on success.
 * unzip-rm       - Uncompress a ZIP archive, removing the archive on success.
 * zerofill       - Fill a file with sparse zeros, taking up no disk space.
