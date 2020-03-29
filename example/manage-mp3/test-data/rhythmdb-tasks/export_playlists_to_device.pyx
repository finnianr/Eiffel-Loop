pyxis-doc:
	version = 1.0; encoding = "ISO-8859-15"

export_playlists_to_device:
	# Needs fixing
	is_dry_run = false; test_checksum = 1014829034
	music_dir = "workarea/rhythmdb/Music"

	volume:
		name = "TABLET"; destination_dir = "Card/Music"; id3_version = 2.3

	playlist_export:
		root = "/storage/extSdCard"; subdirectory_name = "playlists"
	

