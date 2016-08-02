pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# relocate songs in "Archive" playlist
# This playlist should always contain the song "Silence 1 second" to prevent it being removed by Rhythmbox

music-collection:
	task = archive_songs; is_dry_run = False

	archive-dir:
		"$HOME/Music Extra"

