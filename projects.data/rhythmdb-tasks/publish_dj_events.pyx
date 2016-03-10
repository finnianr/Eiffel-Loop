pyxis-doc:
	version = 1.0; encoding = "ISO-8859-1"

music-collection:
	task = "publish_dj_events"; is_dry_run = False; test_checksum = 3895769834
	DJ-events:
		playlist_dir = "workarea/rhythmdb/Documents/DJ-events"
		publish:
			html_template = "playlist.html.evol"; html_index_template = "playlist-index.html.evol"
			www_dir = "workarea/rhythmdb/www"; upload = False 
			ftp:
				url = "eiffel-loop.com"; user_home = "/public/www"; destination_dir = "compadrito-tango-playlists"

	

