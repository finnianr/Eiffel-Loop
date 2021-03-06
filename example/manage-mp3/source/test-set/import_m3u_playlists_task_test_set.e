note
	description: "Test set for class [$source IMPORT_M3U_PLAYLISTS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-25 17:14:07 GMT (Monday 25th May 2020)"
	revision: "3"

class
	IMPORT_M3U_PLAYLISTS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [IMPORT_M3U_PLAYLISTS_TASK]

feature {NONE} -- Constants

	Checksum: NATURAL = 2381803920

	Task_config: STRING = "[
		import_m3u_playlists:
			music_dir = "workarea/rhythmdb/Music"
			m3u_dir = "test-data/rhythmdb/m3u"
	]"
end
