# WebmForNerds
a powershell script to mass convert mp4 (and other file types in the future) into webms within the 4chan size limit

# how to install?
go to the relases page and download the ps1 file

make sure to have ffmpeg installed and put it in your path

# how to use?
run it with powershell 

type the location of the folder with the mp4 files (eg. C:\videos\weirdshit\cartelbeheadings)

type the file size,
4chan's limit for \wsg\ and \gif\ is 4 mb, 3 mb for the rest of the boards that allow webms, because encoders arent perfect i would recomend you to put something like 3.9 or 3.8 if you want a 4 mb file

them it should start converting, it will close when it finishes

# TODO
1. add a gui
   - this should be done first, cli's are ass
2. add the option to choose other file formats
3. convert all files in subfolders (this one is hard)
4. auto-split
   - add the option to autosplit files if they are too big, so turn a 5 minute video into 5 1 minute videos
5. auto-name
   - make a better naming system, maybe names based on the original file name and metadata
6. filters
   - people seem to use those to make videos look good
7. other splitting tools
   - GUI to split videos
any ideas, make a issue with the enchancment tag
