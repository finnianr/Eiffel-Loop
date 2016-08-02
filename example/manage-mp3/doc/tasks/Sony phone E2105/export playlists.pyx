pyxis-doc:
	version = 1.0; encoding = "UTF-8"

music-collection:
	task = export_playlists_to_device; is_dry_run = False

	volume:
		name = "E2105"; destination = "SD Card/Music"; id3_version = 2.3
	playlist:
		root = "/storage/sdcard1"; subdirectory_name = "playlists"
	

