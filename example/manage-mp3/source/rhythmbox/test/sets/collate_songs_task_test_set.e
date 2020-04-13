note
	description: "Test set for class [$source COLLATE_SONGS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-13 16:56:44 GMT (Monday 13th April 2020)"
	revision: "1"

class
	COLLATE_SONGS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [COLLATE_SONGS_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 3506817341

	Task_code: STRING = "[
		pyxis-doc:
			version = 1.0; encoding = "ISO-8859-1"
		
		collate_songs:
			is_dry_run = false; music_dir = "workarea/rhythmdb/Music"
	]"

end
