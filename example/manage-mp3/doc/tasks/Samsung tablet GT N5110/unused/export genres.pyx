pyxis-doc:
	version = 1.0; encoding = "UTF-8"

music-collection:
	task = export_music_to_device; is_dry_run = False

	volume:
		name = "GT N5110"; destination = "Card/Music"; id3_version = 2.3; type = "Samsung tablet"
	playlist:
		root = "/storage/extSdCard"; subdirectory_name = "playlists"

	selected-genres:
		"Dance"
		"Milonga"
		"Milonga (Electro)"
		"Tango"
		"Tango (Electro)"
		"Vals"

