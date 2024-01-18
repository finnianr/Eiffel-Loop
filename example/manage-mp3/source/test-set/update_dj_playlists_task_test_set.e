note
	description: "Test set for class ${UPDATE_DJ_PLAYLISTS_TASK}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-18 14:58:54 GMT (Friday 18th August 2023)"
	revision: "9"

class
	UPDATE_DJ_PLAYLISTS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [UPDATE_DJ_PLAYLISTS_TASK]
		redefine
			do_task
		end

feature {NONE} -- Implementation

	do_task
		do
			task.apply
			across database.dj_playlists as playlist loop
				log.put_labeled_string ("Title", playlist.item.title)
				log.put_new_line
				across playlist.item as song loop
					log.put_path_field ("MP3 %S", song.item.mp3_relative_path)
					log.put_new_line
				end
				log.put_new_line
			end
			across OS.file_list (Playlists_dir, "*.pyx") as path loop
				log.put_labeled_string (path.item.to_string, raw_file_digest (path.item).to_base_64_string)
				log.put_new_line
			end
			print_rhythmdb_xml
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 2524514439

	Task_config: STRING = "[
		update_dj_playlists:
			music_dir = "workarea/rhythmdb/Music"
			dj_events:
				dj_name = "Finnian Reilly"; default_title = "DATS Milonga Playlist"
	]"

end