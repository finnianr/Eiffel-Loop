pyxis-doc:
	version = 1.0; encoding = "UTF-8"

music-collection:
	task = export_playlists_to_device; is_dry_run = False

	volume:
		name = "SGP311"; destination = "SD Card/Music"; id3_version = 2.3
	playlist:
		root = "/storage/extSdCard"; subdirectory_name = "playlists"
	

