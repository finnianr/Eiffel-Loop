pyxis-doc:
	version = 1.0; encoding = "UTF-8"

music-collection:
	task = export_music_to_device; is_dry_run = False

	volume:
		name = "E2105"; destination = "SD Card/Music"; id3_version = 2.3
	playlist:
		root = "/storage/sdcard1"; subdirectory_name = "playlists"
	
	selected-genres:
		"Blues"
		"Dance"
		"Classical (Bells)"
		"Classical (Choir)"
		"Foxtrot"
		"Polka"
		"Milonga"
		"Milonga (Electro)"
		"Tango"
		"Tango (Electro)"
		"Vals"

