pyxis-doc:
	version = 1.0; encoding = "ISO-8859-1"

task_config:
	task = "publish_dj_events"; is_dry_run = False; test_checksum = 3895769834
	music_dir = "workarea/rhythmdb/Music"

	dj_events:
		publisher:
			html_template = "playlist.html.evol"; html_index_template = "playlist-index.html.evol"
			www_dir = "workarea/rhythmdb/www"; upload = False

			ftp_url = "eiffel-loop.com"
			ftp_user_home = "/public/www"
			ftp_destination_dir = "compadrito-tango-playlists"

	

