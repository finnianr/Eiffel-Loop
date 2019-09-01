pyxis-doc:
	version = 1.0; encoding = "UTF-8"

export_playlists_to_device:
	is_dry_run = False

	volume:
		name = "GT N5110"; destination_dir = "Card/Music"; id3_version = 2.3; type = "Galaxy tablet"
	playlist_export:
		root = "/storage/extSdCard"; subdirectory_name = "playlists"
	

