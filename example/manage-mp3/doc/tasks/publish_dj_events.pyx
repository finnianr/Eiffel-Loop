pyxis-doc:
	version = 1.0; encoding = "UTF-8"

publish_dj_events:
	is_dry_run = false
	publish:
		html_template = "playlist.html.evol"; html_index_template = "playlist-index.html.evol"
		www_dir = "$HOME/dev/web-sites/eiffel-loop.com/dancing-DJ"; upload = true

		ftp_url = "eiffel-loop.com"
		ftp_user_home = "/public/www"
		ftp_destination_dir = "dancing-DJ"

	

