note
	description: "Test set for class [$source IMPORT_M3U_PLAYLISTS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	IMPORT_M3U_PLAYLISTS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [IMPORT_M3U_PLAYLISTS_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 54524071

	Task_config: STRING = "[
		import_m3u_playlists:
			music_dir = "workarea/rhythmdb/Music"
			m3u_dir = "test-data/rhythmdb/m3u"
	]"
end