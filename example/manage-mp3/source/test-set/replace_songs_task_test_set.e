note
	description: "Test set for class [$source REPLACE_SONGS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-25 17:30:52 GMT (Monday 25th May 2020)"
	revision: "5"

class
	REPLACE_SONGS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [REPLACE_SONGS_TEST_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 2948467619

	Task_config: STRING = "[
		replace_songs:
			music_dir = "workarea/rhythmdb/Music"
	]"
end
