note
	description: "Test set for class [$source COLLATE_SONGS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-25 16:47:45 GMT (Monday 25th May 2020)"
	revision: "6"

class
	COLLATE_SONGS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [COLLATE_SONGS_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 4000379559

	Task_config: STRING = "[
		collate_songs:
			music_dir = "workarea/rhythmdb/Music"
	]"

end
