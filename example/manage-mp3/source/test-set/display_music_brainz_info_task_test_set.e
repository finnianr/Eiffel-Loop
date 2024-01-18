note
	description: "Test set for class ${DISPLAY_MUSIC_BRAINZ_INFO_TASK}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	DISPLAY_MUSIC_BRAINZ_INFO_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [DISPLAY_MUSIC_BRAINZ_INFO_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 1744033158

	Task_config: STRING = "[
		display_music_brainz_info:
			music_dir = "workarea/rhythmdb/Music"
	]"
end