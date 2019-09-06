pyxis-doc:
	version = 1.0; encoding = "ISO-8859-1"

publish_dj_events:
	is_dry_run = false; test_checksum = 2725155706
	music_dir = "workarea/rhythmdb/Music"

	publish:
		html_template = "playlist.html.evol"; html_index_template = "playlist-index.html.evol"
		www_dir = "workarea/rhythmdb/www"; upload = False

		ftp_url = "eiffel-loop.com"
		ftp_user_home = "/public/www"
		ftp_destination_dir = "compadrito-tango-playlists"

	

