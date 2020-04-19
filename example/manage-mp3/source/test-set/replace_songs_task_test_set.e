note
	description: "Test set for class [$source REPLACE_SONGS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 9:24:18 GMT (Sunday 19th April 2020)"
	revision: "2"

class
	REPLACE_SONGS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [REPLACE_SONGS_TEST_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 3634151083

	Task_config: STRING = "[
		replace_songs:
			is_dry_run = false; music_dir = "workarea/rhythmdb/Music"
	]"
end
