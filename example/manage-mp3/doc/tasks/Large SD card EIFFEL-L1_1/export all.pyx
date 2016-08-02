pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# Synchronize selected genres of music with connected device.

music-collection:
	task = export_music_to_device; is_dry_run = False

	volume:
		name = "EIFFEL-L1_1"; destination = "Music"; id3_version = 2.4
	playlist:
		root = "/"; subdirectory_name = "playlists"
	

