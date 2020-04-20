note
	description: "Test set for class [$source DISPLAY_MUSIC_BRAINZ_INFO_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 14:22:44 GMT (Sunday 19th April 2020)"
	revision: "2"

class
	DISPLAY_MUSIC_BRAINZ_INFO_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [DISPLAY_MUSIC_BRAINZ_INFO_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 1744033158

	Task_config: STRING = "[
		display_music_brainz_info:
			is_dry_run = false; music_dir = "workarea/rhythmdb/Music"
	]"
end
