note
	description: "Test set for class [$source COLLATE_SONGS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "7"

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