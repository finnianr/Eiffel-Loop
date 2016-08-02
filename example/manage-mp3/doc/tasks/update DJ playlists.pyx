pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Update DJ playlists in $HOME/Music/Playlists with any new playlists created in Rhythmbox
# since the last update.

# These playlists can be published to a website using a Evolicity HTML template

music-collection:
	task = update_dj_playlists; is_dry_run = False

	# Set default DJ name and title for the event
	DJ-events:
		DJ_name = "Finnian Reilly"; default_title = "DATS Milonga Playlist"

