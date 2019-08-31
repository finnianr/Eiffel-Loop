pyxis-doc:
	version = 1.0; encoding = "ISO-8859-15"

task_config:
	task = "export_music_to_device"; is_dry_run = False; test_checksum = 2583245024
	music_dir = "workarea/rhythmdb/Music"
	
	volume:
		name = "TABLET"; destination_dir = "Card/Music"; id3_version = 2.3
	
	selected_genres:
		item:
			"Classical"
			"Irish Traditional"

