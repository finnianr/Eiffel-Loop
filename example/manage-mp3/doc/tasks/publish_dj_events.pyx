pyxis-doc:
	version = 1.0; encoding = "UTF-8"

music-collection:
	task = publish_dj_events; is_dry_run = false
	DJ-events:
		publish:
			html_template = "playlist.html.evol"; html_index_template = "playlist-index.html.evol"
			www_dir = "$HOME/dev/web-sites/eiffel-loop.com/dancing-DJ"; upload = true 
			ftp:
				url = "eiffel-loop.com"; user_home = "/public/www"; destination_dir = "dancing-DJ"

	

