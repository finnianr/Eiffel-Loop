note
	description: "Test set for class [$source REPLACE_CORTINA_SET_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-18 14:46:26 GMT (Friday 18th August 2023)"
	revision: "8"

class
	REPLACE_CORTINA_SET_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [REPLACE_CORTINA_SET_TEST_TASK]
		redefine
			do_task
		end

feature {NONE} -- Implementation

	do_task
		do
			task.apply
			log.put_labeled_string (Belvedere_playlist.to_string, raw_file_digest (Belvedere_playlist).to_base_64_string)
			log.put_new_line
			across database.songs.query (song_is_genre ("Cortina")) as cortina loop
				assert ("cortina exists", cortina.item.mp3_path.exists)
			end
			print_rhythmdb_xml; print_playlist_xml
		end

feature {NONE} -- Constants

	Belvedere_playlist: FILE_PATH
		once
			Result := Playlists_dir + "2014-10-01 Belvedere.pyx"
		end

	Checksum: NATURAL = 3859059489

	Task_config: STRING = "[
		replace_cortina_set:
			music_dir = "workarea/rhythmdb/Music"
		
			cortina_set:
				fade_in = 1.0; fade_out = 1.0; clip_duration = 5
				# Tanda spec
				tango_count = 8; tangos_per_vals = 4
	]"

end