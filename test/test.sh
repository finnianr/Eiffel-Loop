
mkdir workarea

# Generate a wav file
swgen -s 22000 -t 20 -w workarea/La\ Copla\ Porteña.wav 1 1000 10000

# Compress to mp3 with ID3 ver 2 tags
lame --id3v2-only --tl "Poema" --ta "Franciso Canaro" --tt "La Copla Porteña" \
	--silent -h -b 128 -m s workarea/La\ Copla\ Porteña.wav workarea/La\ Copla\ Porteña.mp3

# View mp3 file info
extract workarea/La\ Copla\ Porteña.mp3



