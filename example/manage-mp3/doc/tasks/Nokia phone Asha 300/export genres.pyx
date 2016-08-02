pyxis-doc:
	version = 1.0; encoding = "UTF-8"

music-collection:
	task = export_music_to_device; is_dry_run = False

	volume:
		name = "NOKIA-300"; destination = "Music"; id3_version = 2.3; type = "Nokia phone"
	playlist:
		root = "E:"; subdirectory_name = "playlists"

	selected-genres:
		"Cortina"
		"Classical"
		"Classical (Bells)"
		"Classical (Choir)"
		"Classical (Harpsichord)"
		"Classical (Organ)"
		"Classical (Piano)"
		"Foxtrot"
		"Mantra"
		"Milonga"
		"Tango"
		"Vals"
		"World (Sacred)"

