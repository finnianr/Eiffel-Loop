note
	description: "Test set for class [$source REPLACE_CORTINA_SET_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-25 17:24:12 GMT (Monday 25th May 2020)"
	revision: "4"

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
			log.put_labeled_string (Belvedere_playlist.to_string, file_digest (Belvedere_playlist).to_base_64_string)
			log.put_new_line
			across database.songs.query (song_is_genre ("Cortina")) as cortina loop
				assert ("cortina exists", cortina.item.mp3_path.exists)
			end
			print_rhythmdb_xml; print_playlist_xml
		end

feature {NONE} -- Constants

	Belvedere_playlist: EL_FILE_PATH
		once
			Result := Playlists_dir + "2014-10-01 Belvedere.pyx"
		end

	Checksum: NATURAL = 2262026292

	Task_config: STRING = "[
		replace_cortina_set:
			music_dir = "workarea/rhythmdb/Music"
		
			cortina_set:
				fade_in = 1.0; fade_out = 1.0; clip_duration = 5
				# Tanda spec
				tango_count = 8; tangos_per_vals = 4
	]"

end
