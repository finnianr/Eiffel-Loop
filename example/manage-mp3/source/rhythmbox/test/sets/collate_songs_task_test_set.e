note
	description: "Test set for class [$source COLLATE_SONGS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-16 17:57:50 GMT (Thursday 16th April 2020)"
	revision: "2"

class
	COLLATE_SONGS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [COLLATE_SONGS_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 3520081511

	Task_config: STRING = "[
		collate_songs:
			is_dry_run = false; music_dir = "workarea/rhythmdb/Music"
	]"

end