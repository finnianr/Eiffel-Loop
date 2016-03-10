pyxis-doc:
	version = 1.0; encoding = "ISO-8859-15"

music-collection:
	task = "export_playlists_to_device"; is_dry_run = False; test_checksum = 2738974618

	volume:
		name = "TABLET"; destination = "Card/Music"; id3_version = 2.3
	playlist:
		root = "/storage/extSdCard"; subdirectory_name = "playlists"
	

