note
	description: "Test set for class ${IMPORT_M3U_PLAYLISTS_TASK}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	IMPORT_M3U_PLAYLISTS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [IMPORT_M3U_PLAYLISTS_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 659126876

	Task_config: STRING = "[
		import_m3u_playlists:
			music_dir = "workarea/rhythmdb/Music"
			m3u_dir = "test-data/rhythmdb/m3u"
	]"
end