pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Synchronize selected genres of music with connected device.

export_music_to_device:
	is_dry_run = false

	volume:
		name = "SD-CARD-1"; destination_dir = "Music"; id3_version = 2.4
	playlist_export:
		root = "/"; subdirectory_name = "playlists"
	

