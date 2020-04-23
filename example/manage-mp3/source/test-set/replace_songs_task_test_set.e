note
	description: "Test set for class [$source REPLACE_SONGS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-23 14:45:00 GMT (Thursday 23rd April 2020)"
	revision: "3"

class
	REPLACE_SONGS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [REPLACE_SONGS_TEST_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 3405796200

	Task_config: STRING = "[
		replace_songs:
			is_dry_run = false; music_dir = "workarea/rhythmdb/Music"
	]"
end
