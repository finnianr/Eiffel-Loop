note
	description: "Test set for class ${REPLACE_SONGS_TASK}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	REPLACE_SONGS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [REPLACE_SONGS_TEST_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 1433485148

	Task_config: STRING = "[
		replace_songs:
			music_dir = "workarea/rhythmdb/Music"
	]"
end