note
	description: "Update dj playlists test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:31:37 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	UPDATE_DJ_PLAYLISTS_TEST_TASK

inherit
	UPDATE_DJ_PLAYLISTS_TASK
		undefine
			root_node_name
		redefine
			apply
		end

	TEST_MANAGEMENT_TASK
		undefine
			make_default
		end

feature -- Basic operations

	apply
		do
			Precursor
			across Database.dj_playlists as playlist loop
				log.put_labeled_string ("Title", playlist.item.title)
				log.put_new_line
				across playlist.item as song loop
					log.put_path_field ("MP3", song.item.mp3_relative_path)
					log.put_new_line
				end
				log.put_new_line
			end
		end

end
