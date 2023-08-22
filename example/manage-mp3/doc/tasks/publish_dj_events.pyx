pyxis-doc:
	version = 1.0; encoding = "UTF-8"

publish_dj_events:
	publish:
		html_template = "playlist.html.evol"; html_index_template = "playlist-index.html.evol"
		www_dir = "$HOME/dev/web-sites/eiffel-loop.com/dancing-DJ"; upload = true

		ftp_site:
			encrypted_url:
				"HVQPk8fnB04fXvnHdSsvfGjfu0FMt2N1QWbjiSDK+a4QI2aB4XY3QEUC3tfn6wMhiVZrUz4rP59JmXjfdIbktQ=="
			credential:
				salt:
					"QmOh7tMBAGEyOrOBgMU9BJoJJ1R/dr67"
				digest:
					"66i62a1zmjfTUvaSSFUFSL7teSuOejiJlAa+4lEmIj0="

		ftp_destination_dir = "dancing-DJ"

	

