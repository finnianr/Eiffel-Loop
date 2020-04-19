note
	description: "Test set for class [$source COLLATE_SONGS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-18 9:38:19 GMT (Saturday 18th April 2020)"
	revision: "3"

class
	COLLATE_SONGS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [COLLATE_SONGS_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 4013746582

	Task_config: STRING = "[
		collate_songs:
			is_dry_run = false; music_dir = "workarea/rhythmdb/Music"
	]"

end
