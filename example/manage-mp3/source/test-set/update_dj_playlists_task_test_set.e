note
	description: "Test set for class [$source UPDATE_DJ_PLAYLISTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-19 10:08:31 GMT (Tuesday 19th May 2020)"
	revision: "2"

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
					log.put_path_field ("MP3", song.item.mp3_relative_path)
					log.put_new_line
				end
				log.put_new_line
			end
			across OS.file_list (Playlists_dir, "*.pyx") as path loop
				log.put_labeled_string (path.item.to_string, file_digest (path.item).to_base_64_string)
				log.put_new_line
			end
			print_rhythmdb_xml
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 2083116530

	Task_config: STRING = "[
		update_dj_playlists:
			music_dir = "workarea/rhythmdb/Music"
			dj_events:
				dj_name = "Finnian Reilly"; default_title = "DATS Milonga Playlist"
	]"

end
